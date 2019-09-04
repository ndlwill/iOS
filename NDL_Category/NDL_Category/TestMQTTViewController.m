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
 
 LSB最低有效位和MSB最高有效位
 
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
 如果遗嘱消息被发布时需要保留，需要指定这一位的值
 如果遗嘱标志被设置为0，遗嘱保留（Will Retain）标志也必须设置为0 [MQTT-3.1.2-15]。
 如果遗嘱标志被设置为1：
 如果遗嘱保留被设置为0，服务端必须将遗嘱消息当作非保留消息发布 [MQTT-3.1.2-16]。
 如果遗嘱保留被设置为1，服务端必须将遗嘱消息当作保留消息发布
 ======保持连接 Keep Alive
 保持连接（Keep Alive）是一个以秒为单位的时间间隔，表示为一个16位的字，它是指在客户端传输完成一个控制报文的时刻到发送下一个报文的时刻，两者之间允许空闲的最大时间间隔。客户端负责保证控制报文发送的时间间隔不超过保持连接的值。如果没有任何其它的控制报文可以发送，客户端必须发送一个PINGREQ报文
 不管保持连接的值是多少，客户端任何时候都可以发送PINGREQ报文，并且使用PINGRESP报文判断网络和服务端的活动状态
 保持连接的值为零表示关闭保持连接功能
 
 CONNECT报文的有效载荷（payload）包含一个或多个以长度为前缀的字段，可变报头中的标志决定是否包含这些字段。如果包含的话，必须按这个顺序出现：客户端标识符，遗嘱主题，遗嘱消息，用户名，密码
 ======客户端标识符 Client Identifier
 服务端使用客户端标识符 (ClientId) 识别客户端。连接服务端的每个客户端都有唯一的客户端标识符（ClientId)
 
 ======CONNACK – 确认连接请求:
 服务端发送CONNACK报文响应从客户端收到的CONNECT报文。服务端发送给客户端的第一个报文必须是CONNACK
 如果客户端在合理的时间内没有收到服务端的CONNACK报文，客户端应该关闭网络连接。合理 的时间取决于应用的类型和通信基础设施
 
 可变报头的长度。这个值等于2
 连接确认标志 Connect Acknowledge Flags
 第1个字节是 连接确认标志，位7-1是保留位且必须设置为0。 第0 (SP)位 是当前会话（Session Present）标志
 
 当前会话 Session Present
 位置：连接确认标志的第0位。
 如果服务端收到清理会话（CleanSession）标志为1的连接，除了将CONNACK报文中的返回码设置为0之外，还必须将CONNACK报文中的当前会话设置（Session Present）标志为0
 如果服务端收到一个CleanSession为0的连接，当前会话标志的值取决于服务端是否已经保存了ClientId对应客户端的会话状态。如果服务端已经保存了会话状态，它必须将CONNACK报文中的当前会话标志设置为1 [MQTT-3.2.2-2]。如果服务端没有已保存的会话状态，它必须将CONNACK报文中的当前会话设置为0。还需要将CONNACK报文中的返回码设置为0
 
 连接返回码 Connect Return code
 位置：可变报头的第2个字节
 0    0x00连接已接受    连接已被服务端接受
 1    0x01连接已拒绝，不支持的协议版本    服务端不支持客户端请求的MQTT协议级别
 2    0x02连接已拒绝，不合格的客户端标识符    客户端标识符是正确的UTF-8编码，但服务端不允许使用
 3    0x03连接已拒绝，服务端不可用    网络连接已建立，但MQTT服务不可用
 4    0x04连接已拒绝，无效的用户名或密码    用户名或密码的数据格式无效
 5    0x05连接已拒绝，未授权    客户端未被授权连接到此服务器
 6-255        保留
 
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
 
 可变报头按顺序包含主题名和报文标识符
 报文标识符 Packet Identifier
 只有当QoS等级是1或2时，报文标识符（Packet Identifier）字段才能出现在PUBLISH报文中
 
 PUBLISH报文的预期响应:
 服务质量等级    预期响应
 QoS 0    无响应
 QoS 1    PUBACK报文
 QoS 2    PUBREC报文
 
 // https://www.jianshu.com/u/3f246c8f1c8f
 
 ======PUBACK –发布确认:
 PUBACK报文是对QoS 1等级的PUBLISH报文的响应
 
 ======PUBREC – 发布收到（QoS 2，第一步）:
 PUBREC报文是对QoS等级2的PUBLISH报文的响应。它是QoS 2等级协议交换的第二个报文
 
 ======PUBREL – 发布释放（QoS 2，第二步）:
 固定报头的第3,2,1,0位是保留位，必须被设置为0,0,1,0
 PUBREL报文是对PUBREC报文的响应。它是QoS 2等级协议交换的第三个报文
 
 ======PUBCOMP – 发布完成（QoS 2，第三步）:
 PUBCOMP报文是对PUBREL报文的响应。它是QoS 2等级协议交换的第四个也是最后一个报文
 
 ======SUBSCRIBE - 订阅主题:
 固定报头的第3,2,1,0位是保留位且必须分别设置为0,0,1,0
 客户端向服务端发送SUBSCRIBE报文用于创建一个或多个订阅。每个订阅注册客户端关心的一个或多个主题。为了将应用消息转发给与那些订阅匹配的主题，服务端发送PUBLISH报文给客户端。SUBSCRIBE报文也（为每个订阅）指定了最大的QoS等级，服务端根据这个发送应用消息给客户端
 
 可变报头的长度（2字节）加上有效载荷的长度
 
 SUBSCRIBE报文的有效载荷包含了一个主题过滤器列表，它们表示客户端想要订阅的主题
 每一个过滤器后面跟着一个字节，这个字节被叫做 服务质量要求（Requested QoS）
 
 ======SUBACK – 订阅确认:
 服务端发送SUBACK报文给客户端，用于确认它已收到并且正在处理SUBSCRIBE报文。
 SUBACK报文包含一个返回码清单，它们指定了SUBSCRIBE请求的每个订阅被授予的最大QoS等级
 
 允许的返回码值：
 0x00 - 最大QoS 0
 0x01 - 成功 – 最大QoS 1
 0x02 - 成功 – 最大 QoS 2
 0x80 - Failure 失败
 
 ======UNSUBSCRIBE –取消订阅:
 固定报头的第3,2,1,0位是保留位且必须分别设置为0,0,1,0
 客户端发送UNSUBSCRIBE报文给服务端，用于取消订阅主题
 
 ======UNSUBACK – 取消订阅确认:
 服务端发送UNSUBACK报文给客户端用于确认收到UNSUBSCRIBE报文
 
 可变报头的长度为2
 UNSUBACK报文没有有效载荷
 
 ======PINGREQ – 心跳请求:
 客户端发送PINGREQ报文给服务端的。用于：
 1.在没有任何其它控制报文从客户端发给服务的时，告知服务端客户端还活着。
 2.请求服务端发送 响应确认它还活着。
 3.使用网络以确认网络连接没有断开
 
 PINGREQ报文没有可变报头。
 PINGREQ报文没有有效载荷。
 服务端必须发送 PINGRESP报文响应客户端的PINGREQ报文
 
 ======PINGRESP – 心跳响应:
 服务端发送PINGRESP报文响应客户端的PINGREQ报文。表示服务端还活着
 
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
