//
//  TestMQTTViewController.m
//  NDL_Category
//
//  Created by dzcx on 2019/8/27.
//  Copyright © 2019 ndl. All rights reserved.
//

/*
 MARK:MQTT 传输层协议
 MQTT服务器称为“消息代理”（Broker）
 服务质量（QoS）和主题（Topic）
 遗嘱标志 Will Flag
 字节中的位从0到7。第7位是最高有效位，第0位是最低有效位
 
 -----MQTT控制报文的结构
 Fixed header    固定报头，所有控制报文都包含
 Variable header    可变报头，部分控制报文包含
 Payload    有效载荷，部分控制报文包含
 
 固定报头的格式:
 Bit    7    6    5    4    3    2    1    0
 byte 1    MQTT控制报文的类型    用于指定控制报文类型的标志位
 byte 2...    剩余长度
 
 MQTT控制报文类型特定的标志:
 第1个字节的剩0-3
 如果收到非法的标志，接收者必须关闭网络连接
 
 MQTT控制报文的类型:
 位置：第1个字节，二进制位7-4.表示为4位无符号值
 名字    值    报文流动方向    描述
 Reserved    0    禁止    保留
 CONNECT    1    客户端到服务端    客户端请求连接服务端
 CONNACK    2    服务端到客户端    连接报文确认
 PUBLISH    3    两个方向都允许    发布消息
 PUBACK    4    两个方向都允许    QoS 1消息发布收到确认
 PUBREC    5    两个方向都允许    发布收到（保证交付第一步）
 PUBREL    6    两个方向都允许    发布释放（保证交付第二步）
 PUBCOMP    7    两个方向都允许    QoS 2消息发布完成（保证交互第三步）
 SUBSCRIBE    8    客户端到服务端    客户端订阅请求
 SUBACK    9    服务端到客户端    订阅请求报文确认
 UNSUBSCRIBE    10    客户端到服务端    客户端取消订阅请求
 UNSUBACK    11    服务端到客户端    取消订阅报文确认
 PINGREQ    12    客户端到服务端    心跳请求
 PINGRESP    13    服务端到客户端    心跳响应
 DISCONNECT    14    客户端到服务端    客户端断开连接
 Reserved    15    禁止    保留
 
 剩余长度 Remaining Length:
 位置：从第2个字节开始
 表示当前报文剩余部分的字节数，包括可变报头和负载的数据
 
 -----可变报头 Variable header
 可变报头的报文标识符（Packet Identifier）字段存在于在多个类型的报文里
 可变报头的内容根据报文类型的不同而不同
 报文标识符 Packet Identifier:
 Bit    7 - 0
 byte 1    报文标识符 MSB
 byte 2    报文标识符 LSB
 客户端每次发送一个新的这些类型的报文时都必须分配一个当前未使用的报文标识符
 如果一个客户端要重发这个特殊的控制报文，在随后重发那个报文时，它必须使用相同的标识符
 当客户端处理完这个报文对应的确认后，这个报文标识符就释放可重用
 很多控制报文的可变报头部分包含一个两字节的报文标识符字段。这些报文是PUBLISH（QoS > 0时）， PUBACK，PUBREC，PUBREL，PUBCOMP，SUBSCRIBE, SUBACK，UNSUBSCRIBE，UNSUBACK。

 有效载荷 Payload:
 对于PUBLISH来说有效载荷就是应用消息
 
 ---------CONNECT – 连接服务端
 剩余长度等于可变报头的长度（10字节）加上有效载荷的长度
 CONNECT报文的可变报头按下列次序包含四个字段：协议名（Protocol Name），协议级别（Protocol Level），连接标志（Connect Flags）和保持连接（Keep Alive）
 ======连接标志 Connect Flags
 清理会话 Clean Session:
 如果清理会话（CleanSession）标志被设置为0，服务端必须基于当前会话（使用客户端标识符识别）的状态恢复与客户端的通信
 如果清理会话（CleanSession）标志被设置为1，客户端和服务端必须丢弃之前的任何会话并开始一个新的会话
 ======遗嘱标志 Will Flag
 遗嘱标志（Will Flag）被设置为1，表示如果连接请求被接受了，遗嘱（Will Message）消息必须被存储在服务端并且与这个网络连接关联。之后网络连接关闭时，服务端必须发布这个遗嘱消息，除非服务端收到DISCONNECT报文时删除了这个遗嘱消息
 如果遗嘱标志被设置为1，连接标志中的Will QoS和Will Retain字段会被服务端用到，同时有效载荷中必须包含Will Topic和Will Message字段
 如果遗嘱标志被设置为0，连接标志中的Will QoS和Will Retain字段必须设置为0，并且有效载荷中不能包含Will Topic和Will Message字段
 ======遗嘱QoS Will QoS
 位置：连接标志的第4和第3位。
 这两位用于指定发布遗嘱消息时使用的服务质量等级
 ======遗嘱保留 Will Retain
 如果遗嘱消息被发布时需要保留
 ======保持连接 Keep Alive
 保持连接（Keep Alive）是一个以秒为单位的时间间隔，表示为一个16位的字，它是指在客户端传输完成一个控制报文的时刻到发送下一个报文的时刻，两者之间允许空闲的最大时间间隔。客户端负责保证控制报文发送的时间间隔不超过保持连接的值。如果没有任何其它的控制报文可以发送，客户端必须发送一个PINGREQ报文
 不管保持连接的值是多少，客户端任何时候都可以发送PINGREQ报文，并且使用PINGRESP报文判断网络和服务端的活动状态
 保持连接的值为零表示关闭保持连接功能
 
 CONNECT报文的有效载荷（payload）包含一个或多个以长度为前缀的字段，可变报头中的标志决定是否包含这些字段。如果包含的话，必须按这个顺序出现：客户端标识符，遗嘱主题，遗嘱消息，用户名，密码
 ======客户端标识符 Client Identifier
 服务端使用客户端标识符 (ClientId) 识别客户端。连接服务端的每个客户端都有唯一的客户端标识符（ClientId)
 
 ###-----PUBLISH – 发布消息###
 PUBLISH报文固定报头:
 Bit    7    6    5    4    3    2    1    0
 byte 1    MQTT控制报文类型 (3)    DUP    QoS-H    QoS-    RETAIN
 0    0    1    1    X    X    X    X
 
 重发标志 DUP:
 如果DUP标志被设置为0，表示这是客户端或服务端第一次请求发送这个PUBLISH报文。如果DUP标志被设置为1，表示这可能是一个早前报文请求的重发
 对于QoS 0的消息，DUP标志必须设置为0
 
 服务质量等级 QoS:
 这个字段表示应用消息分发的服务质量等级保证
 位置：第1个字节，第2-1位
 QoS值    Bit 2    Bit 1    描述
 0    0    0    最多分发一次
 1    0    1    至少分发一次
 2    1    0    只分发一次
 -    1    1    保留位
 如果服务端或客户端收到QoS所有位都为1的PUBLISH报文，它必须关闭网络连接
 
 保留标志 RETAIN:
 如果客户端发给服务端的PUBLISH报文的保留（RETAIN）标志被设置为1，服务端必须存储这个应用消息和它的服务质量等级（QoS），以便它可以被分发给未来的主题名匹配的订阅者
 一个新的订阅建立时，对每个匹配的主题名，如果存在最近保留的消息，它必须被发送给这个订阅者
 
 // https://www.jianshu.com/u/3f246c8f1c8f
 
 1、使用发布/订阅消息模式，提供一对多的消息发布，解除应用程序耦合；
 2、对负载内容屏蔽的消息传输；
 3、使用 TCP/IP 提供网络连接；
 4、有三种消息发布服务质量：
 MQTTQosLevelAtMostOnce = 0, 最多一次
 MQTTQosLevelAtLeastOnce = 1,最少一次
 MQTTQosLevelExactlyOnce = 2 只有一次
 “至多一次”，消息发布完全依赖底层 TCP/IP 网络。会发生消息丢失或重复。这一级别可用于如下情况，环境传感器数据，丢失一次读记录无所谓，因为不久后还会有第二次发送。
 “至少一次”，确保消息到达，但消息重复可能会发生。
 “只有一次”，确保消息到达一次。这一级别可用于如下情况，在计费系统中，消息重复或丢失会导致不正确的结果。
 
 5、小型传输，开销很小（固定长度的头部是 2 字节），协议交换最小化，以降低网络流量；
 6、使用 Last Will 和 Testament 特性通知有关各方客户端异常中断的机制
 
 
 */

#import "TestMQTTViewController.h"
#import <AFNetworking.h>

@interface TestMQTTViewController ()

@end

@implementation TestMQTTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // MARK:AF处理302
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    [sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [sessionManager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest * _Nullable(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLResponse * _Nonnull response, NSURLRequest * _Nonnull request) {
        NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
        if (resp.statusCode == 302) {
            // 通过重定向url去获取数据
            //return NSMutableURLRequest
            
            // 忽略重定向
            return nil;
        } else {
            return request;
        }
    }];

    // 处理304
    // AFNetworking默认是把304的Code变成200了，然后去拿缓存数据
    // [sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
}

@end
