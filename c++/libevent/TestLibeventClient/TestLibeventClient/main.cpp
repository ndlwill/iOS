//
//  main.cpp
//  TestLibeventClient
//
//  Created by youdone-ndl on 2021/9/9.
//
#include <event2/event.h>
int main(int argc, char** argv)
{
    return 0;
}

// MARK: - socket: event
/*
#include<iostream>
#include<stdio.h>

#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<arpa/inet.h>
#include<errno.h>
#include<unistd.h>

#include<string.h>
#include<stdlib.h>
#include<event.h>
#include<event2/util.h>
 
using namespace std;
 
typedef struct sockaddr cli;
 
void send_msg_cb(int fd, short events, void *arg)
{
    char msg[1024] = {};

    ssize_t ret = read(fd, msg, sizeof(msg));
    if (ret <= 0) {
        perror("send_msg_cb: read perror");
        exit(1);
    }

    int sockfd = *((int *)arg);
 
    write(sockfd, msg, ret);
    cout << "write: " << msg << endl;
}
 
 
void read_msg_cb(int fd, short events, void *arg)
{
    char msg1[1024] = {};
 
    ssize_t len = read(fd, msg1, sizeof(msg1) - 1);
    if (len <= 0)
    {
        perror("read_msg_cb: read perror");
        exit(1);
    }
    
    msg1[len] = '\0';
    cout << "read is ok,msg: " << msg1 << endl;
}
 

int connect_ser(const char* server_ip, const int port)
{
    int sockfd, status;
    struct sockaddr_in sock;
 
    memset(&sock, 0, sizeof(sock));
 
    sock.sin_family = AF_INET;
    sock.sin_port = htons(port);
    // 将一个字符串IP地址转换为一个32位的网络序列IP地址. 如果这个函数成功，函数的返回值非零
    status = inet_aton(server_ip, &sock.sin_addr);
 
    if (status == 0) {
        errno = EINVAL;
        return -1;
    }
    //创建套接字
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (-1 == sockfd) {
        perror("socket perror");
        exit(-1);
    }
 
    status = connect(sockfd, (cli *)&sock, sizeof(sock));
 
    if (status == -1) {
        perror("connect perror");
        close(sockfd);
        return -1;
    }
 
    evutil_make_socket_nonblocking(sockfd);
 
    return sockfd;
}
 
int main(int argc, char** argv)
{
    
    if (argc < 3) {
        cout << "please input two param:" << endl;
        return -1;
    }

    int sockfd = connect_ser(argv[1], atoi(argv[2]));
    if (sockfd == -1) {
        cout << "connect error" << endl;
        return -1;
    }
    
    //初始化 base
    struct event_base* base = event_base_new();
    //read
    struct event *ev1 = event_new(base,
                                  sockfd,
                                  EV_READ | EV_PERSIST,
                                  read_msg_cb,
                                  NULL);
    event_add(ev1, NULL);
    //键盘输入
    struct event* ev2 = event_new(base,
                                  STDIN_FILENO,
                                  EV_READ | EV_PERSIST,
                                  send_msg_cb,
                                  (void *)&sockfd);
    event_add(ev2, NULL);
 
    event_base_dispatch(base);
 
    cout << "===ending===" << endl;
    
    return 0;
}
*/

// MARK: - socket: bufferevent
/*
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<arpa/inet.h>
#include<errno.h>
#include<unistd.h>

#include<stdio.h>
#include<string.h>
#include<stdlib.h>

#include<event.h>
#include<event2/bufferevent.h>
#include<event2/buffer.h>
#include<event2/util.h>

int tcp_connect_server(const char* server_ip, int port);

void cmd_msg_cb(int fd, short events, void* arg);
void server_msg_cb(struct bufferevent* bev, void* arg);
void event_cb(struct bufferevent *bev, short event, void *arg);

int main(int argc, char** argv)
{
    if (argc < 3) {
        printf("please input 2 parameter\n");
        return -1;
    }


    //两个参数依次是服务器端的IP地址、端口号
    int sockfd = tcp_connect_server(argv[1], atoi(argv[2]));
    if (sockfd == -1) {
        perror("tcp_connect perror");
        return -1;
    }

    printf("connect to server successful\n");

    struct event_base* base = event_base_new();

    struct bufferevent* bev = bufferevent_socket_new(base,
                                                     sockfd,
                                                     BEV_OPT_CLOSE_ON_FREE);

    //监听终端输入事件
    struct event* ev_cmd = event_new(base,
                                     STDIN_FILENO,
                                     EV_READ | EV_PERSIST,
                                     cmd_msg_cb,
                                     (void *)bev);
    event_add(ev_cmd, NULL);

    //当socket关闭时会用到回调参数
    bufferevent_setcb(bev, server_msg_cb, NULL, event_cb, (void*)ev_cmd);
    bufferevent_enable(bev, EV_READ | EV_PERSIST);

    event_base_dispatch(base);

    printf("finished \n");
    return 0;
}

void cmd_msg_cb(int fd, short events, void* arg)
{
    char msg[1024];

    ssize_t ret = read(fd, msg, sizeof(msg));
    if (ret < 0)
    {
        perror("read perror");
        exit(1);
    }

    struct bufferevent* bev = (struct bufferevent *)arg;

    //把终端的消息发送给服务器端
    bufferevent_write(bev, msg, ret);
    printf("cmd_msg_cb write: %s", msg);
}


void server_msg_cb(struct bufferevent* bev, void* arg)
{
    char msg[1024];

    size_t len = bufferevent_read(bev, msg, sizeof(msg));
    printf("server_msg_cb: len = %ld\n", len);
    msg[len] = '\0';

    printf("recv from server: %s\n", msg);
}


void event_cb(struct bufferevent *bev, short event, void *arg)
{

    if (event & BEV_EVENT_EOF)
        printf("connection closed\n");
    else if (event & BEV_EVENT_ERROR)
        printf("some other error\n");

    //这将自动close套接字和free读写缓冲区
    bufferevent_free(bev);

    struct event *ev = (struct event*)arg;
    //因为socket已经没有，所以这个event也没有存在的必要了
    event_free(ev);
}


typedef struct sockaddr SA;
int tcp_connect_server(const char* server_ip, int port)
{
    int sockfd, status, save_errno;
    struct sockaddr_in server_addr;

    memset(&server_addr, 0, sizeof(server_addr));

    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(port);
    status = inet_aton(server_ip, &server_addr.sin_addr);

    if (status == 0) //the server_ip is not valid value
    {
        errno = EINVAL;
        return -1;
    }

    sockfd = ::socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd == -1) return sockfd;


    status = ::connect(sockfd, (SA*)&server_addr, sizeof(server_addr));

    if (status == -1) {
        save_errno = errno;
        ::close(sockfd);
        errno = save_errno; //the close may be error
        return -1;
    }

    evutil_make_socket_nonblocking(sockfd);

    return sockfd;
}
*/
