#include "faketcp.h"
#include <fcntl.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <arpa/inet.h>
#include <string.h>
#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <netdb.h>
#include <fcntl.h>
#include <errno.h>

/*@null@*/
queue* conn_q = NULL;

int ftcp_socket() {
  return socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP);
}

int ftcp_bind(int socket, sockaddr* addr, socklen_t addrlen) {
  int v = 1;
  v = setsockopt(socket, SOL_SOCKET, SO_REUSEADDR, &v, (socklen_t) sizeof(int));
  if (v < 0)
    return v;
  return bind(socket, addr, addrlen);
}

int ftcp_listen(int socket) {
  queue* q = __ftcp_conn_queue();
  
  /* listening must be non-blocking */
  int ret = fcntl(socket, F_SETFL, O_NONBLOCK);
  ftcp_sck_ctl* conn = malloc(sizeof(ftcp_sck_ctl));
  if (conn) {
    conn->socket = socket;
    conn->type = FTCP_SCK_LISTEN;
    conn->inc_q = queue_create();

    /* push connection to connection queue */
    queue_push(q, conn);
  } else {
    return EXIT_FAILURE;
  }

#ifdef FTCP_DEBUG
  printf("[LISTEN] Started listening on socket %d\n", socket);
#endif
  
  pthread_create(&conn->tid, NULL, (void*(*)(void*)) __ftcp_listen, conn);

  return ret;
}

/*@null@*/
void* __ftcp_listen(ftcp_sck_ctl* sck_ctl) {
  int ret = 0;
  int err = EAGAIN;
  ftcp_conn_ctl* ctl = malloc(sizeof(ftcp_conn_ctl));
  
  while (ret > 0 || err == EAGAIN || err == EWOULDBLOCK) {
    ctl->addrlen = sizeof(ctl->addr);
    
    ret = recvfrom(sck_ctl->socket, &ctl->data, sizeof(ftcp_conn_ctl_data), 0, (sockaddr*) &ctl->addr, &ctl->addrlen);
    err = errno;

    if (ret > 0 && (ctl->data.flags & (FTCP_SYN | FTCP_ACK)) == FTCP_SYN) {
      queue_push(sck_ctl->inc_q, ctl);

#ifdef FTCP_DEBUG
      printf("<--[LISTEN]-- %s:%d connected to server\n", inet_ntoa(ctl->addr.sin_addr), ntohs(ctl->addr.sin_port));
#endif
      
      ctl = malloc(sizeof(ftcp_conn_ctl));
      memset(ctl, 0, sizeof(ftcp_conn_ctl));
    }

    (void) usleep(10000);
  }
  free(ctl);
  perror("__ftcp_listen");
  return NULL;
}

int ftcp_accept(int socket, sockaddr* addr, socklen_t* addrlen) {
#ifdef FTCP_DEBUG
  printf("[ACCEPT] Awaiting connection, socket %d\n", socket);
#endif
  queue* sck_q = __ftcp_sck_queue(socket);
  if (!sck_q)
    return -0xb4d;
  
  /* Receive SYN from queue */
  ftcp_conn_ctl* ctl = queue_pop(sck_q);
  while (!ctl) {
    ctl = queue_pop(sck_q);
    sleep(1);
  }

  /* swap sequences */
  ftcp_seq seq = ctl->data.my_seq;
  ctl->data.my_seq = ctl->data.other_seq;
  ctl->data.other_seq = seq;

  int ret = ftcp_socket();

  int conn_sck = ret;

  if (ret < 0)
    goto done;
  
  sockets[conn_sck] = FTCP_SCK_LISTEN;
  
  if (ctl->data.flags & FTCP_SYN && !(ctl->data.flags & FTCP_ACK)) {
    /* Save host sequence */
    host_seq[conn_sck] = rand();
    /* Save client sequence */
    client_seq[conn_sck] = ctl->data.other_seq;
    
#ifdef FTCP_DEBUG
    printf("<--[ACCEPT]-- %s:%d SYN token [%d; %d]\n", inet_ntoa(((sockaddr_in*) &ctl->addr)->sin_addr), ntohs(((sockaddr_in*) &ctl->addr)->sin_port), ctl->data.my_seq, ctl->data.other_seq);
#endif
    
    /* Send SYN-ACK */
    
    ctl->data.flags |= FTCP_ACK;
    /* Put host sequence */
    ctl->data.my_seq = host_seq[conn_sck];
    ctl->data.other_seq = ++client_seq[conn_sck];

    /* get server address */
    sockaddr_in addr_in;
    getsockname(socket, (sockaddr*) &addr_in, &ctl->addrlen);
    inet_aton("127.0.0.1", &addr_in.sin_addr);
    
    ret = ftcp_bind(conn_sck, (sockaddr*) &addr_in, ctl->addrlen);

    if (ret < 0)
      goto done;

    ret = connect(conn_sck, (sockaddr*) &ctl->addr, ctl->addrlen);

    if (ret < 0)
      goto done;

    ret = send(conn_sck, &ctl->data, sizeof(ftcp_conn_ctl_data), 0);

    if (ret < 0)
      goto done;
    
#ifdef FTCP_DEBUG
    printf("--[ACCEPT]--> %s:%d SYN-ACK token [%d; %d]\n", inet_ntoa(((sockaddr_in*) &ctl->addr)->sin_addr), ntohs(((sockaddr_in*) &ctl->addr)->sin_port), ctl->data.my_seq, ctl->data.other_seq);
#endif
    memset(&ctl->data.flags, 0, sizeof(ctl->data.flags));

    /* Receive ACK */
    ret = recv(conn_sck, &ctl->data, sizeof(ftcp_conn_ctl_data), 0);

    /* swap sequences */
    seq = ctl->data.my_seq;
    ctl->data.my_seq = ctl->data.other_seq;
    ctl->data.other_seq = seq;
    
    if (ret < 0)
      goto done;
    if ((ctl->data.flags & (FTCP_ACK | FTCP_SYN)) == FTCP_ACK) {
      if (ctl->data.my_seq == host_seq[conn_sck] + 1) {
#ifdef FTCP_DEBUG
	printf("<--[ACCEPT]-- %s:%d ACK token [%d; %d]\n", inet_ntoa(((sockaddr_in*) &ctl->addr)->sin_addr), ntohs(((sockaddr_in*) &ctl->addr)->sin_port), ctl->data.my_seq, ctl->data.other_seq);
#endif
	++host_seq[conn_sck];
      }
    }
  }
 done:
  if (ret < 0) {
    perror("accept_ret");
    return ret;
  }
  return conn_sck;
}

int ftcp_connect(int socket, sockaddr* addr, socklen_t addrlen) {
  int ret = connect(socket, addr, addrlen);
  if (ret < 0)
    return ret;
  
  ftcp_conn_ctl ctl;
  memset(&ctl, 0, sizeof(ftcp_conn_ctl));

  host_seq[socket] = rand();
  
  ctl.data.flags |= FTCP_SYN;
  ctl.data.my_seq = host_seq[socket];
  
  ret = write(socket, &ctl.data, sizeof(ftcp_conn_ctl_data));

#ifdef FTCP_DEBUG
  printf("-->%s:%d SYN token [%d; %d]\n", inet_ntoa(((sockaddr_in*) addr)->sin_addr), ntohs(((sockaddr_in*) addr)->sin_port), ctl.data.my_seq, ctl.data.other_seq);
#endif
  
  if (ret < 0)
    return ret;

  ret = recv(socket, &ctl.data, sizeof(ftcp_conn_ctl_data), 0);

  /* swap sequences */
  ftcp_seq seq = ctl.data.my_seq;
  ctl.data.my_seq = ctl.data.other_seq;
  ctl.data.other_seq = seq;
  
  if (ret < 0)
    return ret;

#ifdef FTCP_DEBUG
  printf("<--%s:%d SYN-ACK token [%d; %d]\n", inet_ntoa(((sockaddr_in*) addr)->sin_addr), ntohs(((sockaddr_in*) addr)->sin_port), ctl.data.my_seq, ctl.data.other_seq);
#endif
  
  ctl.data.flags = FTCP_ACK;
  client_seq[socket] = ++ctl.data.other_seq;
  ret = write(socket, &ctl.data, sizeof(ftcp_conn_ctl_data));  

#ifdef FTCP_DEBUG
  printf("--[CONNECT]--> ACK %d [%d; %d]\n", ctl.data.flags & FTCP_ACK, ctl.data.my_seq, ctl.data.other_seq);
#endif

  sockets[socket] = FTCP_SCK_NONE;
  
  return ret;
}

int ftcp_write(int socket, void* data, size_t len) {
  ftcp_conn_ctl ctl;
  
  memset(&ctl, 0, sizeof(ftcp_conn_ctl));
  ctl.data.my_seq = host_seq[socket];
  ctl.data.other_seq = ++client_seq[socket];

  int bytesread, ret;

  do {
    ret = __ftcp_write_ctl(socket, &ctl);
    if (ret < 0)
      continue;
    
    bytesread = write(socket, data, len);
    if (bytesread < 0)
      return bytesread;

#ifdef FTCP_DEBUG
    if (ctl.data.my_seq != host_seq[socket]) {
      printf("Other host_seq %d vs mine %d\n", ctl.data.my_seq, host_seq[socket]);
    }
    if (ctl.data.other_seq != client_seq[socket]) {
      printf("Other client_seq %d vs mine %d\n", ctl.data.other_seq, client_seq[socket]);
    }
#endif
    
    memset(&ctl, 0, sizeof(ftcp_conn_ctl));
      
    ret = __ftcp_read_ctl(socket, &ctl);
    if (ret < 0)
      continue;
      
  } while (ctl.data.other_seq != client_seq[socket]);
  return ret;
}

int ftcp_read(int socket, void* data, size_t len) {
  ftcp_conn_ctl ctl;
  
  memset(&ctl, 0, sizeof(ftcp_conn_ctl));

  int ret, bytesread = 0;

  do {
    while (ctl.data.my_seq != host_seq[socket] + 1) {
      ret = __ftcp_read_ctl(socket, &ctl);

#ifdef FTCP_DEBUG
      if (ctl.data.my_seq != host_seq[socket] + 1) {
	printf("Other host_seq %d vs mine %d\n", ctl.data.my_seq, host_seq[socket]);
      }
      if (ctl.data.other_seq != client_seq[socket]) {
	printf("Other client_seq %d vs mine %d\n", ctl.data.other_seq, client_seq[socket]);
      }
#endif

      bytesread = read(socket, data, len);
    }
    
    ret = __ftcp_write_ctl(socket, &ctl);
  } while (ret < 0);

  host_seq[socket] = ctl.data.my_seq;
  client_seq[socket] = ctl.data.other_seq;
  ctl.data.flags = FTCP_ACK;
  
  return bytesread;
}

int __ftcp_write_ctl(int socket, ftcp_conn_ctl* ctl) {
#ifdef FTCP_DEBUG
  printf("--[WRITE]--> ACK %d [%d; %d]\n", ctl->data.flags & FTCP_ACK, ctl->data.my_seq, ctl->data.other_seq);
#endif
  return write(socket, &ctl->data, sizeof(ctl->data));
}

int __ftcp_read_ctl(int socket, ftcp_conn_ctl* ctl) {
  int ret = read(socket, &ctl->data, sizeof(ctl->data));

  /* swap sequences */
  ftcp_seq seq = ctl->data.my_seq;
  ctl->data.my_seq = ctl->data.other_seq;
  ctl->data.other_seq = seq;
  
#ifdef FTCP_DEBUG
  printf("--[READ]--> ACK %d ret %d [%d; %d]\n", ctl->data.flags & FTCP_ACK, ret, ctl->data.my_seq, ctl->data.other_seq);
#endif

  return ret;
}

queue* __ftcp_conn_queue()  {
  if (!conn_q)
    conn_q = queue_create();
  return conn_q;
}

queue* __ftcp_sck_queue(int socket)  {
  node_t* node = __ftcp_conn_queue()->head;
  if (node) {
    while (node != NULL && ((ftcp_sck_ctl*) node->value)->socket != socket) {
      node = node->next;
    }
    if (node)
      return ((ftcp_sck_ctl*) node->value)->inc_q;
  }
  return NULL;
}

int isClient(int socket) {
  return sockets[socket] == FTCP_SCK_NONE;
}
