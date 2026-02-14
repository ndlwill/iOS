//
//  PacketParser.h
//  PacketTunnelProvider
//
//  Created by youdun on 2025/12/2.
//  Copyright © 2025 AiJiaSu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 NS_ASSUME_NONNULL_BEGIN & NS_ASSUME_NONNULL_END
 是在 Objective-C 头文件里使用的 “默认非空（nonnull）注解区块”

 在这两个宏之间声明的所有指针类型，都默认是 nonnull，除非显式写了 nullable。

 为什么要用它？
 因为 Apple 希望 Objective-C 头文件能与 Swift 更好地桥接。

 Swift 对可空性要求严格：
 NSString * _Nonnull → Swift 中是 String
 NSString * _Nullable → Swift 中是 String?
 如果你不写可空注解，Swift 端会变成 隐式可选，不安全。

 可以减少你重复写大量的 nonnull
 */
NS_ASSUME_NONNULL_BEGIN

/**
 NEPacketTunnelProvider → readPacketsWithCompletionHandler
  // The NSData and NSNumber in corresponding indicies in the array represent one packet.
 [self.packetFlow readPacketsWithCompletionHandler:^(NSArray<NSData *> * __nonnull packets, NSArray<NSNumber *> * __nonnull protocols) {
 NSUInteger count = [packets count];
 for (NSUInteger i = 0; i < count; i++) {
     NSData *packet = [packets objectAtIndex:i];
     NSNumber *protocol = [protocols objectAtIndex:i];

     if([protocol intValue] == AF_INET && state == FVClient::State_Connected && !self.isReconnecting) {
         NSLog(@"==========fiveTupleFromIPv4Packet = %@ packetLength = %lu", [PacketParser fiveTupleFromIPv4Packet:packet], packet.length);
     }
 }
 }]

 在 Packet Tunnel 模式中，系统把所有经过 TUN 的数据，按 完整 IP 包（IP packet） 的形式交给你的 VPN 进程。
 packets 数组中的每一个 NSData 就是一个完整的 IP 数据包 // 是 整个 IP 层的数据包（包括 IP 头部 + L4 头部 + 负载）

 ##########
 注意: 通过实际测试，得到多个packet（长度不同）但 five-tuple 完全相同
 ==========fiveTupleFromIPv4Packet = { dstIP = "218.91.197.68"; dstPort = 443; protocol = 6; srcIP = "10.253.252.182"; srcPort = 54376; } packetLength = 40
 ==========fiveTupleFromIPv4Packet = { dstIP = "218.91.197.68"; dstPort = 443; protocol = 6; srcIP = "10.253.252.182"; srcPort = 54376; } packetLength = 125
 。。。
 。。。
 这是完全正常的。
 原因是：NEPacketTunnelProvider 给你的每一条 packet 都是真实网络栈里“一个 IP 包（IP packet）”，而不是“一个 TCP 连接”。
 也就是说：
 一个 TCP 连接，会被拆成无数个 IP 包，每个包就是一个 packet。

 抓到的都是来自同一个 TCP 连接：
 srcIP: 10.253.252.182  srcPort: 54376
 dstIP: 218.91.197.68  dstPort: 443
 protocol: TCP(6)
 TCP 连接里：
 SYN 包
 ACK 包
 TLS ClientHello
 应用层数据包（HTTP2、HTTP3 等）
 KeepAlive
 FIN、RST
 都会被分成一个个 单独的 IP 包。

 Packet #1（length 40）
 长度 40 的 packet 一般是：
 纯 ACK
 空载荷（payload = 0）
 TCP header 20 + IP header 20 = 40

 Packet #2（length 125）
 这个 packet 带 payload（例如 TLS ClientHello 分片，或应用层数据片段）

 结论：
 一个 packet 表示一个 IP 包，不代表整个 TCP 数据。

 同一个五元组 ⇒ 同一个 TCP 连接

 如果你需要“组装完整 TCP 流”：
 你需要自己在用户态做：
 TCP 重组（如果你做透明代理）
 或者将 packet 原样转发给你的代理服务器（SOCKS/HTTP CONNECT）
 或交给 libuv / lwip / tun2socks 之类的 TCP 栈实现

 TCP 重组输出一条“完整、有序、连续的字节流”。
 TCP 重组（TCP Reassembly） = 把多个分散的 TCP 数据包（segments）按序号重新拼成原始连续数据流的过程。
 或者说是
 把属于同一个 TCP 连接、但被拆成多个独立 IP 包发送的 TCP segment，再重新拼成最初应用层发送的数据流的过程。
 这是 TCP 的基本能力，因为：
 应用层发送的是 字节流（stream）
 但网络传输是 分段的 segment，每段都有 序号 SEQ
 到达顺序可能乱序、丢包、重复
 TCP 必须按 SEQ 顺序重排，并把完整数据交给上层（如 HTTP 解析器）

 为什么需要 TCP 重组？
 因为网络传输不是一次性把应用发的数据送过去
 底层会拆成多个 TCP 段：
 | Segment | SEQ  | 内容长度 | 内容                     |
 | ------- | ---- | ---- | ---------------------- |
 | #1      | 1000 | 20   | `GET /index.html HT`   |
 | #2      | 1020 | 20   | `TP/1.1\r\nHost: exam` |
 | #3      | 1040 | 20   | `ple.com\r\n\r\n`      |
 可能乱序到达：
 #2 -> #1 -> #3
 你必须按 SEQ 顺序重组成正确的字节流。

 重组解决的问题
 ① 乱序 Packet 排列
 网络可能让包 2 比包 1 先到，你需要按 seq 号排。
 ② 重传导致重复包
 TCP 重传的包可能重复，你必须去重。
 ③ 分片 / 多包合并
 应用层的数据可能被拆到多个包中，需要拼起来。
 ④ 一次包中可能含多个应用层消息
 例如多个 HTTP 请求连续黏在一起（TCP 粘包），更需要重组成连续的“字节流”。

 你在 Packet Tunnel（NEPacketTunnelProvider）中为什么要考虑 TCP 重组？
 因为：
 Packet Tunnel 直接给你原始 IP 包，不做 TCP 连接管理，也不帮你重组数据流。

 当你实现透明代理 / NAT / SOCKS / HTTP Proxy 时：
 你通常不自己做 TCP 重组，
 而是：
 要么把 packet 交给一个 TCP stack（如 lwIP / libuinet）
 要么交给远端代理
 要么自己维护一个五元组对应的 TCP State Machine（极难）
 否则，你只能看到零散的 TCP segment，无法解析完整数据。
 ##########

 在 Packet Tunnel 模式中，系统给你的不是 socket 数据，而是 TUN 设备流量。
 TUN = 只处理 IP 层（第三层）
 → 所以你收到的是 raw IP packets

 Apple 官方对 TUN（Packet Tunnel）的定义就是：
 不包含以太网头（L2 header）
 从 L3（IP）开始
 完整 IP header + transport header + payload

 IPv4 示例：
 [IPv4 Header][TCP/UDP Header][Payload]

 你收到的数据已经完成了系统网络栈的层级封装，只是没有送到物理网卡，而是送到你的 app。你在用户态模拟成了一个网卡（TUN 设备）。
 */
@interface PacketParser : NSObject

/// 从 IPv4 原始包中解析 5 元组
/// @param packet NSData 类型的 IPv4 原始包
/// @return NSDictionary 包含 srcIP, dstIP, srcPort, dstPort, protocol
+ (nullable NSDictionary<NSString *, id> *)fiveTupleFromIPv4Packet:(NSData *)packet;

@end

NS_ASSUME_NONNULL_END
