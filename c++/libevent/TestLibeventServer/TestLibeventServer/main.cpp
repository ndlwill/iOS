//
//  main.cpp
//  TestLibeventServer
//
//  Created by youdone-ndl on 2021/9/8.
//

// MARK: - socket: event
/*
#include<stdio.h>
#include<string.h>
#include<errno.h>
#include<iostream>
#include<unistd.h>
#include<event.h>

#include<arpa/inet.h>
 
using namespace std;

void socket_read_cb(int fd, short events, void *arg);

void accept_cb(int fd, short events, void* arg)
{
    evutil_socket_t sockfd;
 
    struct sockaddr_in cli;
    socklen_t len = sizeof(cli);
 
    sockfd = accept(fd, (struct sockaddr *)&cli, &len);
    evutil_make_socket_nonblocking(sockfd);
 
    printf("accept a cli %d\n", sockfd);
 
    struct event_base* base = (event_base *)arg;
 
    //仅仅是为了动态创建一个event结构体
    struct event *ev = event_new(NULL, -1, 0, NULL, NULL);
    //将动态创建的结构体作为event的回调参数
    event_assign(ev,
                 base,
                 sockfd,
                 EV_READ | EV_PERSIST,
                 socket_read_cb,
                 (void *)ev);
 
    event_add(ev, NULL);
}
 
 
void socket_read_cb(int fd, short events, void *arg)
{
    char msg[4096];
    struct event *ev = (struct event *)arg;
    
    ssize_t len = read(fd, msg, sizeof(msg) - 1);
 
    if (len <= 0)
    {
        printf("some error happen when read\n");
        event_free(ev);
        close(fd);
        return ;
    }
 
    msg[len] = '\0';
    printf("recv the cli msg: %s", msg);
 
    char reply_msg[4096] = "I have recvieced the msg: ";
    strcat(reply_msg + strlen(reply_msg), msg);
 
    write(fd, reply_msg, strlen(reply_msg));
}
 
typedef struct sockaddr SA;
int tcp_server_init(int port, int listen_num)
{
    int errno_save;
    evutil_socket_t listener;
 
    listener = socket(AF_INET, SOCK_STREAM, 0);
    if (listener == -1) return -1;
 
    //允许多次绑定同一个地址。要用在socket和bind之间
    evutil_make_listen_socket_reuseable(listener);
 
    struct sockaddr_in sin;
    sin.sin_family = AF_INET;
    sin.sin_addr.s_addr = 0;
    //sin.sin_addr.s_addr = inet_addr("0.0.0.0");
    //sin.sin_addr.s_addr = inet_addr("192.168.100.82");
    
    //sin.sin_addr.s_addr = inet_addr("127.0.0.1");// client Connection refused
    sin.sin_port = htons(port);
 
    if (::bind(listener, (SA*)&sin, sizeof(sin)) < 0)
        goto error;
 
    if (::listen(listener, listen_num) < 0)
        goto error;
 
    //跨平台统一接口，将套接字设置为非阻塞状态
    evutil_make_socket_nonblocking(listener);
 
    return listener;
 
    error:
        errno_save = errno;
        evutil_closesocket(listener);
        errno = errno_save;
        return -1;
}

int main(int argc, char** argv)
{
    int listener = tcp_server_init(5288, 10);
    if (listener == -1)
    {
        perror("tcp_server_init perror");
        return -1;
    }
 
    struct event_base* base = event_base_new();
 
    //添加监听客户端请求连接事件
    struct event* ev_listen = event_new(base,
                                        listener,
                                        EV_READ | EV_PERSIST,
                                        accept_cb,
                                        base);
    event_add(ev_listen, NULL);
 
    printf("start event_base_dispatch\n");
    event_base_dispatch(base);
 
    return 0;
}
 */


/**
 // 互联网地址（基于历史原因的结构）
 struct in_addr {
     in_addr_t s_addr;
 };
 */
// MARK: - socket: bufferevent start==========
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <unistd.h>

#include<event.h>
#include<event2/bufferevent.h>



void accept_cb(int fd, short events, void* arg);
void socket_read_cb(bufferevent* bev, void* arg);
void event_cb(struct bufferevent *bev, short event, void *arg);
int tcp_server_init(int port, int listen_num);

// MARK: - bufferevent main
int main(int argc, char** argv)
{
    // for: 0.0.0.0
    //int listener = tcp_server_init(5288, 10);
    // for: 127.0.0.1
    int listener = tcp_server_init(1080, 10);
    if (listener == -1)
    {
        perror(" tcp_server_init perror");
        return -1;
    } else {
        printf("==========\n");
    }

    struct event_base* base = event_base_new();

    //添加监听客户端请求连接事件
    struct event* ev_listen = event_new(base,
                                        listener,
                                        EV_READ | EV_PERSIST,
                                        accept_cb,
                                        base);
    event_add(ev_listen, NULL);

    event_base_dispatch(base);
    printf("after event_base_dispatch\n");

    event_base_free(base);

    return 0;
}

void accept_cb(int fd, short events, void* arg)
{
    evutil_socket_t sockfd;

    struct sockaddr_in client;
    socklen_t len = sizeof(client);

    uint32_t clientAddr = 0;
    uint16_t clientPort = 0;

    sockfd = ::accept(fd, (struct sockaddr *)&client, &len);
    // 查看某个端口的占用情况: lsof -i tcp:1080
    struct sockaddr_in *pClient = (sockaddr_in *)&client;
    clientAddr = pClient->sin_addr.s_addr;
    clientPort = ntohs(pClient->sin_port);
    // inet_ntoa
    //char *clientAddrStr = inet_ntoa(pClient->sin_addr);
    //printf("clientAddrStr = %s\n", clientAddrStr);
    // inet_ntop
    //char clientIpAddr[INET_ADDRSTRLEN];//保存点分十进制的地址
    //const char *ntopRet = inet_ntop(AF_INET, &client.sin_addr, clientIpAddr, sizeof(clientIpAddr));
    //printf("ntopRet = %s clientIpAddr = %s\n", ntopRet, clientIpAddr);

    printf("clientAddr = %u clientPort = %u\n", clientAddr, clientPort);
    evutil_make_socket_nonblocking(sockfd);
    printf("accept a clientFD %d\n", sockfd);

    /*
    struct sockaddr_in peer;
    socklen_t peerlen = sizeof(peer);
    uint32_t peerAddr = 0;
    uint16_t peerPort = 0;
    // getpeername函数用于获取与某个套接字关联的外地协议地址
    int peernameRet = getpeername(sockfd, (sockaddr *)&peer, &peerlen);
    struct sockaddr_in *pPeer = (sockaddr_in *)&peer;
    peerAddr = pPeer->sin_addr.s_addr;
    peerPort = ntohs(pPeer->sin_port);
    printf("peernameRet = %d\n", peernameRet);
    printf("peerAddr = %u peerPort = %u\n", peerAddr, peerPort);
     */

    struct event_base* base = (event_base *)arg;

    bufferevent* bev = bufferevent_socket_new(base, sockfd, BEV_OPT_CLOSE_ON_FREE);
    bufferevent_setcb(bev, socket_read_cb, NULL, event_cb, arg);
    bufferevent_enable(bev, EV_READ | EV_PERSIST);
}

// client键盘输入123
void socket_read_cb(bufferevent* bev, void* arg)
{
    struct evbuffer *inputEB = bufferevent_get_input(bev);
    struct evbuffer *outputEB = bufferevent_get_output(bev);
    // MARK: - evbuffer_get_length
    printf("input evbuffer_get_length: %ld\n", evbuffer_get_length(inputEB));
    printf("output evbuffer_get_length: %ld\n", evbuffer_get_length(outputEB));

    // MARK: - evbuffer_get_contiguous_space
    printf("input evbuffer_get_contiguous_space: %ld\n", evbuffer_get_contiguous_space(inputEB));
    printf("output evbuffer_get_contiguous_space: %ld\n", evbuffer_get_contiguous_space(outputEB));

    // MARK: - evbuffer_add to input evbuffer
    /*
    char inputData[] = "inputdata";
    int addRet = evbuffer_add(inputEB, inputData, strlen(inputData));
    printf("addRet = %d\n", addRet);// -1
    printf("errno = %d\n", EVUTIL_SOCKET_ERROR());// 1
    evutil_socket_t clientFD = bufferevent_getfd(bev);
    printf("clientFD = %d\n", clientFD);// 5
    printf("errno = %d\n", evutil_socket_geterror(clientFD));// 1
    printf("error_to_string = %s\n", evutil_socket_error_to_string(evutil_socket_geterror(clientFD)));// Operation not permitted
     */

    // MARK: - evbuffer_drain 用于inputEB，将数据从缓冲区前面移除
    /*
    int drainRet = evbuffer_drain(inputEB, 3);
    printf("drainRet = %d\n", drainRet);
     */

    // MARK: - evbuffer_search client: 123123
    /*
    const char *searchData = "23";
    struct evbuffer_ptr evb_ptr;
    int ptrSetRet = evbuffer_ptr_set(inputEB, &evb_ptr, 0, EVBUFFER_PTR_SET);
    printf("evbuffer_ptr init set pos = %ld\n", evb_ptr.pos);// 0
    printf("ptrSetRet = %d\n", ptrSetRet);// 0 成功
    while (1) {
        evb_ptr = evbuffer_search(inputEB, searchData, strlen(searchData), &evb_ptr);
        if (evb_ptr.pos < 0) {
            printf("evb_ptr < 0\n");// 没找到
            break;
        }
        printf("evbuffer_ptr.pos = %ld\n", evb_ptr.pos);// 找到字节下标的位置为 1, 4

        int ptrWhileSetRet = evbuffer_ptr_set(inputEB, &evb_ptr, strlen(searchData), EVBUFFER_PTR_ADD);
        printf("ptrWhileSetRet = %d\n", ptrWhileSetRet);// 0 成功
        printf("evbuffer_ptr while set pos = %ld\n", evb_ptr.pos);// 移动字节下标的位置到 3, 6
    }
     */

    // MARK: - evbuffer_peek client: 123456 查看
    /*
    struct evbuffer_iovec iovec[1];
    struct evbuffer_iovec iovec_two[2];
    struct evbuffer_ptr evb_ptr;
    printf("evbuffer_ptr.pos = %ld\n", evb_ptr.pos);
    const char *searchData = "123";
    evb_ptr = evbuffer_search(inputEB, searchData, strlen(searchData), NULL);

    // Advance the pointer past the searchData string.
    evbuffer_ptr_set(inputEB, &evb_ptr, strlen(searchData), EVBUFFER_PTR_ADD);

    int peekRet = evbuffer_peek(inputEB, -1, &evb_ptr, iovec, 1);
    printf("peekRet = %d\n", peekRet);
    printf("iov_base = %s iov_len = %ld\n", (char *)iovec[0].iov_base, iovec[0].iov_len);

    int peekTwoRet = evbuffer_peek(inputEB, -1, NULL, iovec_two, 2);
    printf("peekTwoRet = %d\n", peekTwoRet);
    for (int i = 0; i < peekTwoRet; i++) {
        printf("for: iov_base = %s iov_len = %ld\n", (char *)iovec_two[i].iov_base, iovec_two[i].iov_len);
    }
     */


    char msg[1024 * 4];
    size_t len = bufferevent_read(bev, msg, sizeof(msg));
    printf("bufferevent_read len = %ld\n", len);

    msg[len] = '\0';
    printf("recv the client msg: %s\n", msg);

    char reply_msg[4096] = "I have recvieced the msg is ";
    strcat(reply_msg + strlen(reply_msg), msg);
    bufferevent_write(bev, reply_msg, strlen(reply_msg));
}

void event_cb(struct bufferevent *bev, short event, void *arg)
{
    if (event & BEV_EVENT_EOF)
        printf("connection closed\n");
    else if (event & BEV_EVENT_ERROR)
        printf("some other error\n");

    //这将自动close套接字和free读写缓冲区
    bufferevent_free(bev);
}

typedef struct sockaddr SA;
int tcp_server_init(int port, int listen_num)
{
    int errno_save;
    evutil_socket_t listener;

    listener = ::socket(AF_INET, SOCK_STREAM, 0);
    if (listener == -1) return -1;

    //允许多次绑定同一个地址。要用在socket和bind之间
    evutil_make_listen_socket_reuseable(listener);

    struct sockaddr_in sin;
    sin.sin_family = AF_INET;
    // in_addr_t类型
    // for: 0
    //sin.sin_addr.s_addr = 0;
    // for: 127.0.0.1 inet_addr: 将字符串转换为32位二进制网络字节序的IPV4地址
    sin.sin_addr.s_addr = inet_addr("127.0.0.1");
    sin.sin_port = htons(port);

    if (::bind(listener, (SA*)&sin, sizeof(sin)) < 0)
        printf("bind error\n");
        //goto error;

    if (::listen(listener, listen_num) < 0)
        printf("listen error\n");
        //goto error;

    struct sockaddr_storage sa = {0};
    socklen_t salen = sizeof(sa);
    // getsockname函数用于获取与某个套接字关联的本地协议地址,获取监听的地址和端口
    int socknameRet = getsockname(listener, (struct sockaddr *)&sa, &salen);
    printf("socknameRet = %d\n", socknameRet);// 0
    if (sa.ss_family == AF_INET) {
        in_port_t port = ((sockaddr_in *)&sa)->sin_port;
        printf("port = %u\n", port);// 14340
        printf("ntohs port = %u\n", ntohs(port));// 1080
    }

    //跨平台统一接口，将套接字设置为非阻塞状态
    evutil_make_socket_nonblocking(listener);

    return listener;

    error:
        errno_save = errno;
        evutil_closesocket(listener);
        errno = errno_save;
        return -1;
}
// MARK: - socket: bufferevent end==========

// MARK: - test timer
/*
static int n_calls = 0;

void cb_func(evutil_socket_t fd, short what, void *arg)
{
    struct event *me = (struct event *)arg;

    printf("cb_func called %d times so far.\n", ++n_calls);

    if (n_calls > 10) event_del(me);
}

void run(struct event_base * base)
{
    struct timeval one_sec = {1, 0};
    struct event *ev;
    
    ev = event_new(base, -1, EV_PERSIST, cb_func, event_self_cbarg());
    event_add(ev, &one_sec);
    event_base_dispatch(base);
}

int main(int argc, const char * argv[]) {
    run(event_base_new());
    printf("=====finish=====\n");
    return 0;
}
*/

// MARK: - Valgrind 内存泄漏检测
/*
#include <stdio.h>
#include <string>
#include <errno.h>

#include <time.h>

#include <event.h>
#include <event2/bufferevent.h>

struct event_base *evBase = event_base_new();

static void evcb_timer_timeout(evutil_socket_t, short, void *evarg) {
    //获取系统时间
    time_t now_time = time(NULL);
    //获取本地时间
    tm *t_tm = localtime(&now_time);
    //转换为年月日星期时分秒结果
    printf("2.local time is: %s\n", asctime(t_tm));
    
    printf("=====evcb_timer_timeout=====\n");
    // breakRet: 0 if successful, or -1 if an error occurred
    int breakRet = event_base_loopbreak(evBase);
    printf("breakRet = %d\n", breakRet);
}

int main(int argc, const char * argv[]) {
    struct timeval tv;
    tv.tv_sec = 1;
    tv.tv_usec = 0;

    struct event *evTimeout = evtimer_new(evBase, evcb_timer_timeout, NULL);
    for (int i = 0; i < ((5 + tv.tv_sec - 1) / tv.tv_sec); i++) {
        printf("==for==\n");
        
        //获取系统时间
        time_t now_time = time(NULL);
        //获取本地时间
        tm *t_tm = localtime(&now_time);
        //转换为年月日星期时分秒结果
        printf("1.local time is: %s\n", asctime(t_tm));
        
        event_add(evTimeout, &tv);
        
        // 0 if successful, -1 if an error occurred, or 1 if we exited because no events were pending or active.
        int ret = event_base_dispatch(evBase);
        if (ret < 0) {
            std::string msg = std::string("event failed") + evutil_socket_error_to_string(EVUTIL_SOCKET_ERROR());
            printf("error msg = %s", msg.c_str());
            break;
        } else if (ret == 0) {
            printf("successful\n");
            break;
        } else if (ret == 1) {
            printf("no events were pending or active\n");
            break;
        }
    }
    
    event_free(evTimeout);
    
    printf("=====finish=====\n");
    return 0;
}
*/



// MARK: - getsockname && getpeername
/*
#define MAXLINE 4096
#define PORT 5288
#define LISTENQ 1024
#include<stdio.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<unistd.h>
#include<string.h>
#include<arpa/inet.h>


int main(int argc, const char * argv[]) {
    int listenfd, connfd;
    struct sockaddr_in servaddr;//服务器绑定的地址
    struct sockaddr_in listendAddr, connectedAddr, peerAddr;//分别表示监听的地址，连接的本地地址，连接的对端地址
    socklen_t listendAddrLen, connectedAddrLen, peerLen;
    char ipAddr[INET_ADDRSTRLEN];//保存点分十进制的地址
    listenfd = socket(AF_INET, SOCK_STREAM, 0);
    printf("listenfd = %d\n", listenfd);
    memset(&servaddr, 0, sizeof(servaddr));
 
    servaddr.sin_family = AF_INET;
    // 如果一个主机有两个IP地址，192.168.1.1 和 10.1.2.1，并且该主机上的一个服务监听的地址是0.0.0.0,那么通过两个ip地址都能够访问该服务。
    // 比如我有一台服务器，一个外放地址A,一个内网地址B，如果我绑定的端口指定了0.0.0.0，那么通过内网地址或外网地址都可以访问我的应用。
    servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
    servaddr.sin_port = htons(PORT);
    
    bind(listenfd, (struct sockaddr*)&servaddr, sizeof(servaddr));//服务器端绑定地址
 
    listen(listenfd, LISTENQ);
    listendAddrLen = sizeof(listendAddr);
    
    getsockname(listenfd, (struct sockaddr *)&listendAddr, &listendAddrLen);//获取监听的地址和端口
    // 0.0.0.0:5288
    printf("getsockname: listen address = %s:%d\n", inet_ntoa(listendAddr.sin_addr), ntohs(listendAddr.sin_port));
 
    while(1) {
        connfd = accept(listenfd, (struct sockaddr *)NULL, NULL);
        printf("connfd = %d\n", connfd);// 4
        connectedAddrLen = sizeof(connectedAddr);
        getsockname(connfd, (struct sockaddr *)&connectedAddr, &connectedAddrLen);//获取connfd表示的连接上的本地地址
        //192.168.100.82:5288
        //127.0.0.1:5288
        printf("getsockname: connected server address = %s:%d\n", inet_ntoa(connectedAddr.sin_addr), ntohs(connectedAddr.sin_port));
        
        getpeername(connfd, (struct sockaddr *)&peerAddr, &peerLen); //获取connfd表示的连接上的对端地址
        // inet_ntoa(peerAddr.sin_addr)
        // 0.0.0.0:0
        printf("getpeername: connected peer address = %s:%d\n", inet_ntop(AF_INET, &peerAddr.sin_addr, ipAddr, sizeof(ipAddr)), ntohs(peerAddr.sin_port));
    }
    return 0;
}
*/
