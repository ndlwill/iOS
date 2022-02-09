#include "faketcp.h"
#include <arpa/inet.h>
#include <string.h>
#include <stdio.h>
#include <pthread.h>

void* rdloop(int socket) {
  char buffer[16];
  buffer[15] = 0;
  int ret = 1;
  while (ret > 0) {
    ret = ftcp_read(socket, buffer, sizeof(buffer) - 1);
    if (ret > 0) {
      write(1, buffer, ret);
      printf("\nwriting to %d\n", socket);
      ftcp_write(socket, buffer, ret);
    }
  }
  return NULL;
}

int main(int argc, char** argv) {
  short port = atoi(argv[1]);
  
  int socket = ftcp_socket(PF_INET);
  sockaddr_in addr, cl_addr;

  memset((void*) &addr, 0, sizeof(sockaddr_in));
  addr.sin_family = AF_INET;
  addr.sin_addr.s_addr = INADDR_ANY;
  addr.sin_port = htons(port);
  
  socklen_t addrlen = sizeof(sockaddr_in);

  if (ftcp_bind(socket, (sockaddr*) &addr, addrlen) < 0)
    perror("bind");

  if (ftcp_listen(socket) < 0)
    perror("listen");

  int sck;
  while ((sck = ftcp_accept(socket, (sockaddr*) &cl_addr, &addrlen)) > 0) {
    pthread_t id;
    pthread_create(&id, NULL, (void* (*)(void*)) rdloop, (void*) (size_t) sck);
  }
  if (sck < 0)
    perror("accept");
  
  return 0;
}
