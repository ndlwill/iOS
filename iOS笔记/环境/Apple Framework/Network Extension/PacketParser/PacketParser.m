//
//  PacketParser.m
//  PacketTunnelProvider
//
//  Created by youdun on 2025/12/2.
//  Copyright © 2025 AiJiaSu Inc. All rights reserved.
//

#import "PacketParser.h"
#import <netinet/in.h>
#import <arpa/inet.h>

// IPv4 Header
struct IPv4Header {
    uint8_t  version_ihl;
    uint8_t  tos;
    uint16_t totalLength;
    uint16_t identification;
    uint16_t flags_fragmentOffset;
    uint8_t  ttl;
    uint8_t  protocol;
    uint16_t headerChecksum;
    uint32_t sourceAddress;
    uint32_t destinationAddress; // 把这个作为第二个结构体成员，加不加__attribute__((packed))，通过sizeof得到的大小不一样（由于字节对齐）
} __attribute__((packed));
/**
 __attribute__((packed)) 的意思是：
 让结构体按最紧凑方式对齐，不做任何填充（padding）。
 
 也就是说：
 ➡️ 每个字段紧挨着前一个字段存储
 ➡️ 字节布局与网络数据流完全一致
 
 为什么需要 packed？
 正常情况下，C 结构体会按照 CPU 的对齐规则（alignment）自动插入 padding，例如 2 字节、4 字节、8 字节对齐。
 struct Example {
     uint8_t  a;   // 1 byte
     uint32_t b;   // 4 bytes
 };
 正常情况下会变成：
 | a (1 byte) | padding (3 bytes) | b (4 bytes) |
 
 为什么解析 IP 包必须 packed？
 IP 包头结构是严格定义的，没有任何 padding。
 */


@implementation PacketParser

+ (nullable NSDictionary<NSString *,id> *)fiveTupleFromIPv4Packet:(NSData *)packet {
    // sizeof(struct IPv4Header): 20字节
    if (packet.length < sizeof(struct IPv4Header)) return nil;

    const uint8_t *bytes = packet.bytes;
    struct IPv4Header *ip = (struct IPv4Header *)bytes;

    /**
     高 4 位（bits 4~7）是 Version
     低 4 位（bits 0~3）是 IHL（header length）
     */
    uint8_t version = ip->version_ihl >> 4;
    // 因为 IHL 给你的不是“字节数”，而是“4 字节块的个数”。（IHL（单位：4 字节））所以必须转成实际字节
    uint8_t ihl = (ip->version_ihl & 0x0F) * 4; //

    if (version != 4) return nil;

    /**
     | 值       | 协议             |
     | ------- | -------------- |
     | **1**   | ICMP           |
     | **6**   | TCP            |
     | **17**  | UDP            |
     | **47**  | GRE            |
     | **50**  | ESP (IPSec 加密) |
     | **51**  | AH (IPSec 认证头) |
     | **58**  | ICMPv6         |
     | **115** | L2TP           |
     */
    uint8_t protocol = ip->protocol;

    // 解析源/目的 IP
    // 你平时看到的 "192.168.1.20" 只是字符串形式；真正存储在数据包或 socket 中，就是 in_addr（存储顺序：network byte order（大端））.
    struct in_addr srcAddr = { ip->sourceAddress };
    struct in_addr dstAddr = { ip->destinationAddress };
    // inet_ntoa: 把 IPv4 地址（二进制）转换成点分十进制字符串
    /**
     struct in_addr addr;
     addr.s_addr = htonl(0xC0A80101); // 192.168.1.1

     char *str = inet_ntoa(addr);
     printf("%s\n", str);   // 输出: "192.168.1.1"
     */
    NSString *srcIP = [NSString stringWithUTF8String:inet_ntoa(srcAddr)];
    NSString *dstIP = [NSString stringWithUTF8String:inet_ntoa(dstAddr)];

    // 检查包长度是否足够 L4 header （只加 4 判断长度，就是为了确保至少能读取 TCP/UDP 的前 4 个字节（源端口 + 目的端口））
    if (packet.length < ihl + 4) return nil;

    const uint8_t *l4 = bytes + ihl;
    uint16_t srcPort = 0;
    uint16_t dstPort = 0;

    if (protocol == IPPROTO_TCP || protocol == IPPROTO_UDP) {
        srcPort = [self readU16:l4];
        dstPort = [self readU16:l4 + 2];
    }

    return @{
        @"srcIP": srcIP,
        @"dstIP": dstIP,
        @"srcPort": @(srcPort),
        @"dstPort": @(dstPort),
        @"protocol": @(protocol)
    };
}

// 因为这是 IP 包的数据，所有多字节字段（端口、长度、标识、序号…）都使用网络字节序（大端）。网络协议规定所有多字节字段都是 网络字节序（大端）。
+ (uint16_t)readU16:(const uint8_t *)data {
    // 因为网络字节序（network byte order）是大端（big-endian），所以 (data[0] << 8) | data[1]
    /**
     TCP/UDP 头部中的端口号是 16 位（2 字节）的大端：
     byte0（高位）   byte1（低位）
     例如端口号 0x1F90（十进制 8080）在网络包里放成：
     1F 90
     */
    return (data[0] << 8) | data[1];
}

@end
