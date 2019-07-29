//
//  HttpHeader.h
//  NDL_Category
//
//  Created by dzcx on 2018/6/28.
//  Copyright © 2018年 ndl. All rights reserved.
//

// 大端模式，是指数据的高字节保存在内存的低地址中，而数据的低字节保存在内存的高地址中。把数据当作字符串顺序处理：地址由小向大增加，而数据从高位往低位放
// 小端模式，是指数据的高字节保存在内存的高地址中，而数据的低字节保存在内存的低地址中
/*
 unsigned int value = 0x12345678
 
 可以用unsigned char buf[4]来表示value
 Big-Endian: 低地址存放高位，如下：
 高地址
 　　---------------
 　　buf[3] (0x78) -- 低位
 　　buf[2] (0x56)
 　　buf[1] (0x34)
 　　buf[0] (0x12) -- 高位
 　　---------------
 　　低地址
 
 Little-Endian: 低地址存放低位，如下：
 高地址
 　　---------------
 　　buf[3] (0x12) -- 高位
 　　buf[2] (0x34)
 　　buf[1] (0x56)
 　　buf[0] (0x78) -- 低位
    --------------
    低地址
 
 内存地址    小端模式存放内容    大端模式存放内容
 0x4000    0x78    0x12
 0x4001    0x56    0x34
 0x4002    0x34    0x56
 0x4003    0x12    0x78
 */

// NSURLErrorUnknown
// ###使用协议提升拓展性### 或者 协议替换为配置对象

// 协议 && 密码学
// https://www.jianshu.com/u/12201cdd5d7a

/*
 Json web token（JWT）
 JWT 的声明一般被用来在身份提供者和服务提供者间传递被认证的用户身份信息，以便于从资源服务器获取资源
 JWT是由三部分构成，将这三段信息文本用链接构成了JWT字符串
 第一部分我们称它为头部（header）第二部分我们称其为载荷（payload，类似于飞机上承载的物品），第三部分是签证（signature）
 */

/*
 基于token的鉴权机制:
 用户使用用户名密码请求服务器
 服务器进行验证用户信息
 服务器通过验证发送给用户一个token
 客户端存储token，并在每次请求时附加这个token值
 服务器验证token，并返回数据
 */

/*
 当前主流的IM（尤其新一代的移动端IM）中，都是“长”（指TCP或UDP长连接）、“短”（是指Http短连接）相结合的方式
 1）短连接用途1：前置HTTP的SSO单点接口来实现身份认证；
 2）短连接用途2：集群式的IM中可能还会有独立（或集成于SSO单独登陆接口中）的SLB接口（即基于HTTP短连接拉取IM服务器集群IP列表）；
 3）短连接用途3：各种小文件的上传、下载接口实现（头像、图片、语音、文件等）都会是基于Http实现；
 4）长连接用途1：用户的实时上、下线状态通知；
 5）长连接用途2：实时的加友、加群等指令收发；
 6）长连接用途3：服务端发起的其它实时指令推送等
 
 ##SSO(Single Sign On)单点登陆（或者说身份认证）接口:##
 假设一个场景：公司内部有财务、OA、订单服务等各类相互独立的应用系统，员工张三对这些系统有操作权限，如果张三想要登录某个系统进行业务操作，那么他需要输入相应的账号与密码
 我们需要引入一个这样的机制：张三只要输入一次用户名和密码登录，成功登录后，他就可以访问财务系统、OA 系统、订单服务等系统——这就是单点登录
 
 用户只需要登录一次，就可以在个人权限范围内，访问所有相互信任应用的功能模块，不管整个应用群的内部有多么复杂，对用户而言，都是一个统一的整体。用户访问 Web 系统的整个应用群与访问单个系统一样，登录和注销分别只要一次就够了
 
 你登录了百度网页之后，点击跳转到百度贴吧，这时可以发现你已经自动登录了百度贴吧——这就是单独登陆的原理
 
 用户系统：负责用户名、密码等帐户信息管理，包括增加、修改、启用、停用用户帐号，同时为认证中心提供对用户名和密码的校验；
 认证中心：负责凭证 token 的生成、加密、颁发、验证、销毁、登入 Login、登出 Logout。用户只有拥有凭证并验证通过才能访问企业门户；
 权限系统：负责角色管理、资源设置、授权设置、鉴定权限，具体实现可参考 RBAC。权限系统可为企业门户提供用户权限范围内的导航；
 企业门户：作为应用系统的集成门户 (Portal)，集成了多个应用系统的功能，为用户提供链接导航、用户信息和登出功能等。
 
 服务端功能实现:
 登录认证：接收登录帐号信息，让用户系统验证用户的登录信息；
 凭证生成：创建授权凭证 token，生成的凭证一般包含用户帐号信息、过期时间等信息，它是一串加密的字符串，加密算法如 AES｛凭证明文 +MD5 加信息｝，可采用 JWT 标准；
 凭证颁发：与 SSO 客户端通信，发送凭证给 SSO 客户端；
 凭证验证：接收并校验来自 SSO 客户端的凭证有效性，凭证验证包括算法验证和数据验证；
 凭证销毁与登出：接收来自 SSO 客户端的登出请求，记录并销毁凭证，跳转至登录页面。
 
 客户端的实现逻辑大致如下:
 1）请求拦截：拦截应用未登录请求，跳转至登录页面；
 2）获取凭证：接收并存储由 SSO 服务端发来的凭证，凭证存储的方式有 Cookie、Session、网址传参、Header 等；
 3）提交凭证验证：与 SSO 服务端通信，发出校验凭证有效性的请求；
 4）获取用户权限：获取该凭证的用户权限，并返回受保护资源给用户；
 5）凭证销毁与登出：销毁本地会话，然后跳转至登出页面。
 
 用户的单点登录流程如下:
 1）登录：将用户输入的用户名和密码发送至认证中心，然后认证中心调用用户系统来验证登录信息；
 2）生成并颁发凭证：通过登录信息的验证后，认证中心创建授权凭证 token，然后把这个授权凭证 token 返回给 SSO 客户端。SSO 客户端拿到这个 token，进行存储。在后续请求中，在 HTTP 请求数据中都得加上这个 token；
 3）凭证验证：SSO 客户端发送凭证 token 给认证中心，认证中心校验这个 token 的有效性。凭证验证有算法验证和数据验证，算法验证可在 SSO 客户端完成
 
 用户的访问流程，如果用户没有有效的凭证，认证中心将强制用户进入登录流程。对于单点注销，用户如果注销了应用群内的其中一个应用，那么全局 token 也会被销毁，应用群内的所有应用将不能再被访问
 */
#import <Foundation/Foundation.h>

// UDID的全名为 Unique Device Identifier :设备唯一标识符 UDID是一个40位十六进制序列 UDID是只和iOS设备有关的
// 被苹果禁用了 将UUID保存在keychain里面，每次调用先检查钥匙串里面有没有，有则使用，没有则写进去，保证其唯一性
@interface HttpHeader : NSObject

@property (nonatomic, assign) long long userID;// 用户ID
@property (nonatomic, copy) NSString *imei;// 设备号 唯一
@property (nonatomic, assign) NSUInteger osType;// 0-未知,1-安卓,2-iOS
@property (nonatomic, copy) NSString *appVersion;// 当前APP版本
@property (nonatomic, copy) NSString *channel;// 渠道 @"AppStore"

// [UIDevice currentDevice].model: e.g. @"iPhone"

@property (nonatomic, copy) NSString *mobileModel;// eg:x86_64 与下面的相对应
@property (nonatomic, copy) NSString *mobileModelName;// eg:Simulator x64

@property (nonatomic, copy) NSString *token;// 用户登录后分配的登录Token

@end

/*
 NSURLProtocol:
 决定请求是否需要当前协议对象处理的方法是：+ canInitWithRequest
 
 请求经过 + canInitWithRequest: 方法过滤之后，我们得到了所有要处理的请求，接下来需要对请求进行一定的操作，而这都会在 + canonicalRequestForRequest: 中进行
 
 NSURLProtocol 只能拦截 UIURLConnection、NSURLSession 和 UIWebView 中的请求，对于 WKWebView 中发出的网络请求也无能为力，如果真的要拦截来自 WKWebView 中的请求，还是需要实现 WKWebView对应的 WKNavigationDelegate，并在代理方法中获取请求
 无论是 NSURLProtocol、NSURLConnection 还是 NSURLSession 都会走底层的 socket
 */


/*
 NSProxy 的目的就是负责将消息转发到真正的 target 的代理类
 */

