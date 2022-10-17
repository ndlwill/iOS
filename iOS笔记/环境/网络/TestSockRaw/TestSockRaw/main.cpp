//
//  main.cpp
//  TestSockRaw
//
//  Created by youdone-ndl on 2022/7/25.
//

#ifndef SUCCESS
#define SUCCESS 0
#endif

#ifndef FAILURE
#define FAILURE -1
#endif

//
//#include <stdlib.h>

// printf
#include <stdio.h>

// memset
#include <string.h>

// ioctl
#include <sys/ioctl.h>

// socket
#include <sys/socket.h>

// sockaddr_in
// #include <netinet/in.h>
#include <arpa/inet.h>

// ifreq
#include <net/if.h>

// MARK: - ioctl
/**
 ioctl(input/output control)是一个专用于设备输入输出操作的系统调用,
 该调用传入一个跟设备有关的请求码，系统调用的功能完全取决于请求码
 */
int getAddressInfo(const char* ifName, char *ip, char *netMask) {
    if (NULL == ifName) {
        printf("ifName = NULL\n");
        return FAILURE;
    }
    
    if (strlen(ifName) > IFNAMSIZ) {
        return FAILURE;
    }
    
    int fd = SUCCESS, ret = FAILURE;
    
    struct sockaddr_in *addr;
    
    /**
     Interface request structure used for socket ioctl's.
     All interface ioctl's must have parameter definitions which begin with ifr_name.
     The remainder may be interface specific.
     */
    struct ifreq ifr;
    memset(&ifr, 0, sizeof(ifr));
    strcpy(ifr.ifr_name, ifName);
    
    fd = socket(AF_INET, SOCK_DGRAM, 0);
    if (fd < 0) {
        return FAILURE;
    }
    
    // get addr
    ret = ioctl(fd, SIOCGIFADDR, &ifr);
    if (ret < 0) {
        return FAILURE;
    }
    struct sockaddr ipAddr = ifr.ifr_addr;
    if (ipAddr.sa_family == AF_INET) {
        addr = (struct sockaddr_in *)&ipAddr;
        /**
         strcpy只用于字符串复制，并且它不仅复制字符串内容之外，还会复制字符串的结束符。 memcpy可以复制任意内容，例如字符数组、整型、结构体、类等。
         */
        //memcpy(ip, inet_ntoa(addr->sin_addr), INET_ADDRSTRLEN);
        strncpy(ip, inet_ntoa(addr->sin_addr), INET_ADDRSTRLEN);
    } else {
        printf("address.sa_family != AF_INET\n");
    }

    // get netMask
    ret = ioctl(fd, SIOCGIFNETMASK, &ifr);
    if (ret < 0) {
        return FAILURE;
    }
    struct sockaddr netMaskAddr = ifr.ifr_addr;
    if (netMaskAddr.sa_family == AF_INET) {
        addr = (struct sockaddr_in *)&netMaskAddr;
        memcpy(netMask, inet_ntoa(addr->sin_addr), INET_ADDRSTRLEN);
    } else {
        printf("address.sa_family != AF_INET\n");
    }
    
    return SUCCESS;
}

// MARK: - main
int main(int argc, const char * argv[]) {
    char ip[INET_ADDRSTRLEN] = {0};
    char netMask[INET_ADDRSTRLEN] = {0};
    getAddressInfo("en1", ip, netMask);
    printf("ip = %s, netMask = %s\n", ip, netMask);
    
    return 0;
}




// MARK: - getifaddrs用于获取本机接口信息
/**
 ifa_flags是接口的标识位（当IFF_BROADCAST或IFF_POINTOPOINT设置到此标识位时，影响广播地址或点对点地址）
 */

