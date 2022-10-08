//
//  main.cpp
//  Test_IOCTL
//
//  Created by youdone-ndl on 2021/10/15.
//

#include <iostream>
#include <net/if.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/ioctl.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define MAX_INTERFACE (16)

// MARK: - 获取网卡的IP地址
void getIFADDR() {
    int sock = socket(AF_INET, SOCK_DGRAM, 0);
    struct ifreq ifr;
    strcpy(ifr.ifr_name, "en1");
    // SIOCGIFADDR标志代表获取接口地址
    // ioctl(input/output control) 是设备驱动程序中设备控制接口函数
    if (ioctl(sock, SIOCGIFADDR, &ifr) < 0) perror("ioctl error");
    printf("%s\n", inet_ntoa(((struct sockaddr_in *)&(ifr.ifr_addr))->sin_addr));
}

// MARK: - ifconfig
void port_status(unsigned int flags)
{
    if (flags & IFF_UP)
    {
        printf("is up\n");
    }
    if (flags & IFF_BROADCAST)
    {
        printf("is broadcast\n");
    }
    if (flags & IFF_LOOPBACK)
    {
        printf("is loop back\n");
    }
    if (flags & IFF_POINTOPOINT)
    {
        printf("is point to point\n");
    }
    if (flags & IFF_RUNNING)
    {
        printf("is running\n");
    }
    if (flags & IFF_PROMISC)
    {
        printf("is promisc\n");
    }
}


int get_if_info(int fd) {
    struct ifreq buf[MAX_INTERFACE];
    struct ifconf ifc;
    
    int ret = 0;
    int if_num = 0;
    
    ifc.ifc_len = sizeof(buf);
    printf("ifc.ifc_len = %d\n", ifc.ifc_len);// 512
    printf("sizeof(struct ifreq) = %lu\n", sizeof(struct ifreq));// 32
    ifc.ifc_buf = (caddr_t)buf;
    // 获取所有接口的清单
    ret = ioctl(fd, SIOCGIFCONF, (char *)&ifc);
    printf("ret = %d\n", ret);
    
    // 492 / 32
    if_num = ifc.ifc_len / sizeof(struct ifreq);
    printf("interface num is interface = %d\n", if_num);// 15
    
    while (if_num-- > 0) {
        printf("net device name: %s\n", buf[if_num].ifr_name);
            // 获取接口标志
            ret = ioctl(fd, SIOCGIFFLAGS, (char *)&buf[if_num]);
            /* 获取网口状态 */
            port_status(buf[if_num].ifr_flags);

            /* 获取当前网卡的ip地址 */
            ret = ioctl(fd, SIOCGIFADDR, (char *)&buf[if_num]);
            printf("IP address is: \n%s\n\n", inet_ntoa(((struct sockaddr_in *)(&buf[if_num].ifr_addr))->sin_addr));
    }
    
    return ret;
}

void ifconfig() {
    int fd = socket(AF_INET, SOCK_DGRAM, 0);
    if (fd > 0) {
        get_if_info(fd);
    }
}



// MARK: - main
/**
 ifconfig命令是通过ioctl接口与内核通信
 ifconfig命令首先打开一个socket，然后通过系统管理员输入的参数初始化一个数据结构，并通过ioctl调用将数据传送到内核
 */
int main(int argc, const char * argv[]) {
    //getIFADDR();
    
    ifconfig();
    
    return 0;
}


