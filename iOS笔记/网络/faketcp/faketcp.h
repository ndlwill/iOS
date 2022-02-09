#pragma once

#include <unistd.h>
#include <stdlib.h>
#include <stdint.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include "queue.h"
#include <pthread.h>

#define FTCP_SYN 0x1
#define FTCP_ACK 0x2

#define FTCP_SCK_NONE 0x0
#define FTCP_SCK_LISTEN 0x1

typedef struct sockaddr sockaddr;
typedef struct sockaddr_in sockaddr_in;
typedef struct in_addr in_addr;

typedef uint16_t ftcp_seq;

ftcp_seq host_seq[1024];
ftcp_seq client_seq[1024];
int sockets[1024];

typedef struct ftcp_conn_ctl_data {
  uint8_t flags;
  ftcp_seq my_seq;
  ftcp_seq other_seq;
} ftcp_conn_ctl_data;

typedef struct ftcp_conn_ctl {
  sockaddr_in addr;
  socklen_t addrlen;
  ftcp_conn_ctl_data data;
} ftcp_conn_ctl;

typedef struct ftcp_sck_ctl {
  int socket;
  char type;
  pthread_t tid;
  queue* inc_q;
} ftcp_sck_ctl;

int ftcp_socket();

int ftcp_bind(int socket, sockaddr* addr, socklen_t addrlen);

int ftcp_listen(int socket);

void* __ftcp_listen(ftcp_sck_ctl* sck_ctl);

int ftcp_accept(int socket, sockaddr* addr, socklen_t* addrlen);

int ftcp_connect(int socket, sockaddr* addr, socklen_t addrlen);

int ftcp_write(int socket, void* data, size_t len);

int __ftcp_write_ctl(int socket, ftcp_conn_ctl* ctl);

int ftcp_read(int socket, void* data, size_t len);

int __ftcp_read_ctl(int socket, ftcp_conn_ctl* ctl);

queue* __ftcp_conn_queue();

queue* __ftcp_sck_queue(int socket);

int isClient(int socket);
