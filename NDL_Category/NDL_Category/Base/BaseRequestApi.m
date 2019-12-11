//
//  BaseRequestApi.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/22.
//  Copyright © 2018年 ndl. All rights reserved.
//

// ###Tencent腾讯###
// https://github.com/Tencent/mars

// 中间人攻击(Man-in-the-Middle attack，MITM)

// cipher  密码

// [密码学] && 网络
// https://github.com/halfrost/Halfrost-Field/tree/master/contents/Protocol

/*
 ##HTTP##
 无状态: 这一次请求和上一次请求是没有任何关系的
 
 客户端打开与服务器的连接发出请求到服务器响应客户端请求的全过程称之为会话
 会话跟踪指的是对同一个用户对服务器的连续的请求和接受响应的监视
 浏览器与服务器之间的通信是通过HTTP协议进行通信的，而HTTP协议是”无状态”的协议，它不能保存客户的信息，即一次响应完成之后连接就断开了，下一次的请求需要重新连接，这样就需要判断是否是同一个用户，所以才有会话跟踪技术来实现这种要求
 
 把www.zhihu.com/login.html和www.zhihu.com/index.html关联起来
 为了使某个域名下的所有网页能够共享某些数据，session和cookie出现了:
 cookie: http://bubkoo.com/2014/04/21/http-cookies-explained/
 
 首先，客户端会发送一个http请求到服务器端。
 服务器端接受客户端请求后，建立一个session，并发送一个http响应到客户端，这个响应头，其中就包含Set-Cookie头部。该头部包含了sessionId。
 Set-Cookie: value[; expires=date][; domain=domain][; path=path][; secure]
 在客户端发起的第二次请求，假如服务器给了set-Cookie，浏览器会自动在请求头中添加cookie
 服务器接收请求，分解cookie，验证信息，核对成功后返回response给客户端
 
 ##session 有如用户信息档案表, 里面包含了用户的认证信息和登录状态等信息. 而 cookie 就是用户通行证##
 session存储于服务器，可以理解为一个状态列表，拥有一个唯一识别符号sessionId，通常存放于cookie中。服务器收到cookie后解析出sessionId，再去session列表中查找，才能找到相应session。依赖cookie
 cookie类似一个令牌，装有sessionId，存储在客户端，浏览器通常会自动添加
 
 form 发起的 POST 请求并不受到浏览器同源策略的限制，因此可以任意地使用其他域的 Cookie 向其他域发送 POST 请求，形成 CSRF 攻击
 
 Cookie:
 Cookie 是Web 服务器发送给客户端的一小段信息，客户端请求时可以读取该信息发送到服务器端，进而进行用户的识别。对于客户端的每次请求，服务器都会将 Cookie 发送到客户端,在客户端可以进行保存,以便下次使用。
 
 客户端可以采用两种方式来保存这个 Cookie 对象，一种方式是保存在客户端内存中，称为临时 Cookie，浏览器关闭后这个 Cookie 对象将消失。另外一种方式是保存在客户机的磁盘上，称为永久 Cookie。以后客户端只要访问该网站，就会将这个 Cookie 再次发送到服务器上，前提是这个 Cookie 在有效期内，这样就实现了对客户的跟踪。
 
 Cookie 是可以被客户端禁用的
 
 Session:
 每一个用户都有一个不同的 session，各个用户之间是不能共享的，是每个用户所独享的，在 session 中可以存放信息。
 
 在服务器端会创建一个 session 对象，产生一个 sessionID 来标识这个 session 对象，然后将这个 sessionID 放入到 Cookie 中发送到客户端，下一次访问时，sessionID 会发送到服务器，在服务器端进行识别不同的用户。
 
 Session 的实现依赖于 Cookie，如果 Cookie 被禁用，那么 session 也将失效
 */

/*
 MARK:###token###
 token 的认证方式类似于临时的证书签名, 并且是一种服务端无状态的认证方式, 非常适合于 REST API 的场景. 所谓无状态就是服务端并不会保存身份认证相关的数据
 
 token 也称作令牌，由uid+time+sign[+固定参数]
 uid: 用户唯一身份标识
 time: 当前时间的时间戳
 sign: 签名, 使用 hash/encrypt 压缩成定长的十六进制字符串，以防止第三方恶意拼接
 固定参数(可选): 将一些常用的固定参数加入到 token 中是为了避免重复查库
 
 token在客户端一般存放于localStorage，cookie，或sessionStorage中。在服务器一般存于数据库中
 
 token 的认证流程与cookie很相似:
 用户登录，成功后服务器返回Token给客户端。
 客户端收到数据后保存在客户端
 客户端再次访问服务器，将token放入headers中
 服务器端采用filter过滤器校验。校验成功则返回请求数据，校验失败则返回错误码
 
 token是开发者为了防范csrf(CSRF（Cross-site request forgery）跨站请求伪造)而特别设计的令牌
 */

// MARK: iOS Https 证书验证
/**
 证书分为两种，一种是花钱向认证的机构购买的证书，服务端如果使用的是这类证书的话，那一般客户端不需要做什么，用HTTPS进行请求就行了，苹果内置了那些受信任的根证书的。另一种是自己制作的证书，使用这类证书的话是不受信任的（当然也不用花钱买），因此需要我们在代码中将该证书设置为信任证书
 
 自签名证书：
 把生成的.cer文件添加到项目中
 AFNetworking首先需要配置AFSecurityPolicy类，AFSecurityPolicy类封装了证书校验的过程
 
 AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
 securityPolicy.allowInvalidCertificates = YES;//是否允许使用自签名证书
 securityPolicy.validatesDomainName = NO;//是否需要验证域名，默认YES
 */

/*
 MARK:HTTPS
 
 单向认证: 认证服务器-服务器给客户端公钥，私钥只有服务器有。只有服务器可以解密
 双向认证: 除了客户端需要认证服务端以外，增加了服务端对客户端的认证
 
 Http + 加密 + 认证 + 完整性保护 = Https
 
 TLS 的基本过程:
 客户端发送一个 ClientHello 消息到服务器端，消息中同时包含了它的 Transport Layer Security (TLS) 版本，可用的加密算法和压缩算法。
 服务器端向客户端返回一个 ServerHello 消息，消息中包含了服务器端的 TLS 版本，服务器所选择的加密和压缩算法，以及数字证书认证机构（Certificate Authority，缩写 CA）签发的服务器公开证书，证书中包含了公钥。客户端会使用这个公钥加密接下来的握手过程，直到协商生成一个新的对称密钥。证书中还包含了该证书所应用的域名范围（Common Name，简称 CN），用于客户端验证身份。
 客户端根据自己的信任 CA 列表，验证服务器端的证书是否可信。如果认为可信（具体的验证过程在下一节讲解），客户端会生成一串伪随机数，使用服务器的公钥加密它。这串随机数会被用于生成新的对称密钥
 服务器端使用自己的私钥解密上面提到的随机数，然后使用这串随机数生成自己的对称主密钥
 客户端发送一个 Finished 消息给服务器端，使用对称密钥加密这次通讯的一个散列值
 服务器端生成自己的 hash 值，然后解密客户端发送来的信息，检查这两个值是否对应。如果对应，就向客户端发送一个 Finished 消息，也使用协商好的对称密钥加密
 从现在开始，接下来整个 TLS 会话都使用对称秘钥进行加密，传输应用层（HTTP）内容
 
 消息认证算法（TLS 的传输会使用 MAC(message authentication code) 进行完整性检查）
 
 HTTP缺点:
 Http协议使用明文传输，容易遭到窃听；
 Http对于通信双方都没有进行身份验证，通信的双方无法确认对方是否是伪装的客户端或者服务端；
 Http对于传输内容的完整性没有确认的办法，往往容易在传输过程中被劫持篡改
 要解决 HTTP 上面 3 个大的安全问题，第一步就是要先进行加密通信。于是在传输层增加了一层 SSL（Secure Sockets Layer 安全套接层）/ TLS (Transport Layer Security 安全层传输协议) 来加密 HTTP 的通信内容。
 HTTPS (HTTP Secure) 并不是新协议，而是 HTTP 先和 SSL（Secure Sockets Layer 安全套接层）/ TLS (Transport Layer Security 安全层传输协议) 通信，再由 SSL/TLS 和 TCP 通信。也就是说 HTTPS 使用了隧道进行通信
 
 Https则可以通过增加的SSL\TLS，支持对于通信内容的加密，以及对通信双方的身份进行验证
 
 Https的加密原理:
 近代密码学中加密的方式主要有两类:
 1）对称秘钥加密；
 2）非对称秘钥加密。
 
 对称秘钥加密是指加密与解密过程使用同一把秘钥。这种方式的优点是处理速度快，但是如何安全的从一方将秘钥传递到通信的另一方是一个问题。

 非对称秘钥加密是指加密与解密使用两把不同的秘钥。这两把秘钥，一把叫公开秘钥，可以随意对外公开。一把叫私有秘钥，只用于本身持有。得到公开秘钥的客户端可以使用公开秘钥对传输内容进行加密，而只有私有秘钥持有者本身可以对公开秘钥加密的内容进行解密。这种方式克服了秘钥交换的问题，但是相对于对称秘钥加密的方式，处理速度较慢。
 
 HTTPS 采用混合的加密机制，使用公开密钥加密用于传输对称密钥，之后使用对称密钥加密进行通信
 SSL\TLS的加密方式则是结合了两种加密方式的优点。首先采用非对称秘钥加密，将一个对称秘钥使用公开秘钥加密后传输到对方。对方使用私有秘钥解密，得到传输的对称秘钥。之后双方再使用对称秘钥进行通信。这样即解决了对称秘钥加密的秘钥传输问题，又利用了对称秘钥的高效率来进行通信内容的加密与解密
 
 Https的认证:
 SSL\TLS采用的混合加密的方式还是存在一个问题，即怎么样确保用于加密的公开秘钥确实是所期望的服务器所分发的呢？也许在收到公开秘钥时，这个公开秘钥已经被别人篡改了。因此，我们还需要对这个秘钥进行认证的能力，以确保我们通信的对方是我们所期望的对象。
 
 目前的做法是使用由数字证书认证机构颁发的公开秘钥证书。服务器的运营人员可以向认证机构提出公开秘钥申请。认证机构在审核之后，会将公开秘钥与共钥证书绑定。服务器就可以将这个共钥证书下发给客户端，客户端在收到证书后，使用认证机构的公开秘钥进行验证。一旦验证成功，即可知道这个秘钥是可以信任的秘钥
 
 Https的通信流程:
 1）Client发起请求；
 2）Server端响应请求，并在之后将证书发送至Client；
 3）Client使用认证机构的共钥认证证书，并从证书中取出Server端共钥；
 4）Client使用共钥加密一个随机秘钥，并传到Server；
 5）Server使用私钥解密出随机秘钥；
 6）通信双方使用随机秘钥最为对称秘钥进行加密解密
 
 MARK:###HTTPS 通过使用 证书 来对通信方进行认证###
 数字证书认证机构（CA，Certificate Authority）是客户端与服务器双方都可信赖的第三方机构。服务器的运营人员向 CA 提出公开密钥的申请，CA 在判明提出申请者的身份之后，会对已申请的公开密钥做数字签名，然后分配这个已签名的公开密钥，并将该公开密钥放入公开密钥证书后绑定在一起
 进行 HTTPS 通信时，服务器会把证书发送给客户端，客户端取得其中的公开密钥之后，先进行验证，如果验证通过，就可以开始通信
 
 使用 OpenSSL 这套开源程序，每个人都可以构建一套属于自己的认证机构，从而自己给自己颁发服务器证书。浏览器在访问该服务器时，会显示“无法确认连接安全性”或“该网站的安全证书存在问题”等警告消息
 
 TLS / SSL 提供报文摘要功能来验证完整性
 
 到 20 世纪 90 年代末，Netscape 将 SSL 移交给了 IETF，IETF 将其重命名为 TLS，并从此成为该协议的管理者。许多人仍将 Web 加密称作 SSL，即使绝大多数服务已切换到仅支持 TLS
 在 IETF 中，协议被称为 RFC。TLS 1.0 是 RFC 2246，TLS 1.1 是 RFC 4346，TLS 1.2 是 RFC 5246。现在，TLS 1.3 为 RFC 8446
 (Request For Comments（RFC），是一系列以编号排定的文件)
 
 TLS/SSL 协议位于应用层和传输层 TCP 协议之间。TLS 粗略的划分又可以分为 2 层:
 靠近应用层的握手协议 TLS Handshaking Protocols
 靠近 TCP 的记录层协议 TLS Record Protocol
 
 TLS 握手协议还能细分为 5 个子协议:
 change_cipher_spec (在 TLS 1.3 中这个协议已经删除，为了兼容 TLS 老版本，可能还会存在) ,TLS 密码切换协议
 alert ,TLS 警告协议
 handshake ,TLS 握手协议
 application_data ,TLS 应用数据协议
 heartbeat (这个是 TLS 1.3 新加的，TLS 1.3 之前的版本没有这个协议)
 
 握手协议是整个 TLS 协议簇中最最核心的协议，HTTPS 能保证安全也是因为它的功劳
 握手协议的目的是为了双方协商出密码块，这个密码块会交给 TLS 记录层进行密钥加密。也就是说握手协议达成的“共识”(密码块)是整个 TLS 和 HTTPS 安全的基础。
 
 协议版本    version
 TLS 1.3    0x0304
 TLS 1.2    0x0303
 TLS 1.1    0x0302
 TLS 1.0    0x0301
 SSL 3.0    0x0300
 
 消息头类型    ContentType
 change_cipher_spec    0x014
 alert    0x015
 handshake    0x016
 application_data    0x017
 heartbeat (TLS 1.3 新增)    0x018
 
 */

#import "BaseRequestApi.h"

@implementation BaseRequestApi
{
    NSDictionary *_bodyDic;
}

- (instancetype)initWithParamsDic:(NSDictionary *)bodyDic
{
    if (self = [super init]) {
        _bodyDic = bodyDic;
    }
    return self;
}

#pragma mark - Overrides
- (NSString *)requestUrl
{
    return @"";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument
{
    return _bodyDic;
}

// HeaderField
- (NSDictionary *)requestHeaderFieldValueDictionary {
    return nil;
}

#pragma mark - 如果是加密方式传输，自定义request
//-(NSURLRequest *)buildCustomUrlRequest{
//    
//    if (!_isOpenAES) {
//        return nil;
//    }
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_main,self.requestUrl]]];
//    
//    //加密header部分
//    NSString *headerContentStr = [[HeaderModel new] modelToJSONString];
//    NSString *headerAESStr = aesEncrypt(headerContentStr);
//    [request setValue:headerAESStr forHTTPHeaderField:@"header-encrypt-code"];
//    
//    NSString *contentStr = [self.requestArgument jsonStringEncoded];
//    NSString *AESStr = aesEncrypt(contentStr);
//    
//    [request setHTTPMethod:@"POST"];
//    
//    [request setValue:@"text/encode" forHTTPHeaderField:@"Content-Type"];
//    
//    
//    NSData *bodyData = [AESStr dataUsingEncoding:NSUTF8StringEncoding];
//    
//    [request setHTTPBody:bodyData];
//    return request;
//    
//}

@end

/*
 MARK:ping
 ping是用来探测本机与网络中另一主机之间是否可达的命令，如果两台主机之间ping不通，则表明这两台主机不能建立起连接
 
 ping 命令是基于 ICMP 协议来工作的，「 ICMP 」全称为 Internet 控制报文协议（Internet Control Message Protocol）。ping 命令会发送一份ICMP回显请求报文给目标主机，并等待目标主机返回ICMP回显应答。因为ICMP协议会要求目标主机在收到消息之后，必须返回ICMP应答消息给源主机，如果源主机在一定时间内收到了目标主机的应答，则表明两台主机之间网络是可达的
 
 「ping」命令的工作过程:
 1）假设有两个主机，主机A（192.168.0.1）和主机B（192.168.0.2），现在我们要监测主机A和主机B之间网络是否可达，那么我们在主机A上输入命令：ping 192.168.0.2；
 2）此时，ping命令会在主机A上构建一个 ICMP的请求数据包（数据包里的内容后面再详述），然后 ICMP协议会将这个数据包以及目标IP（192.168.0.2）等信息一同交给IP层协议；
 3）IP层协议得到这些信息后，将源地址（即本机IP）、目标地址（即目标IP：192.168.0.2）、再加上一些其它的控制信息，构建成一个IP数据包；
 4）IP数据包构建完成后，还不够，还需要加上MAC地址，因此，还需要通过ARP映射表找出目标IP所对应的MAC地址。当拿到了目标主机的MAC地址和本机MAC后，一并交给数据链路层，组装成一个数据帧，依据以太网的介质访问规则，将它们传送出出去；
 5）当主机B收到这个数据帧之后，会首先检查它的目标MAC地址是不是本机，如果是就接收下来处理，接收之后会检查这个数据帧，将数据帧中的IP数据包取出来，交给本机的IP层协议，然后IP层协议检查完之后，再将ICMP数据包取出来交给ICMP协议处理，当这一步也处理完成之后，就会构建一个ICMP应答数据包，回发给主机A；
 6）在一定的时间内，如果主机A收到了应答包，则说明它与主机B之间网络可达，如果没有收到，则说明网络不可达。除了监测是否可达以外，还可以利用应答时间和发起时间之间的差值，计算出数据包的延迟耗时。
 
 ICMP是直接基于网络层的IP协议
 即ICMP报文是封装在IP包中
 当传送的IP数据包发送异常的时候，ICMP就会将异常信息封装在包内，然后回传给源主机
 
 IP协议是一种无连接的，不可靠的数据包协议，它并不能保证数据一定被送达，那么我们要保证数据送到就需要通过其它模块来协助实现，这里就引入的是ICMP协议
 
 ICMP协议大致可分为两类:
 1）查询报文类型
 2）差错报文类型
 
 查询报文主要应用于：ping查询、子网掩码查询、时间戳查询等
 差错报文主要产生于当数据传送发送错误的时候,它包括:目标不可达（网络不可达、主机不可达、协议不可达、端口不可达、禁止分片等）、超时、参数问题、重定向（网络重定向、主机重定向等）等等
 
 利用ICMP 协议定位您的计算机和目标计算机之间的所有路由器。TTL 值可以反映数据包经过的路由器或网关的数量
 */
