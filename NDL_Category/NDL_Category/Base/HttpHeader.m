//
//  HttpHeader.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/28.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "HttpHeader.h"
#import "OpenUDID.h"

/*
 Socket开源框架:
 https://github.com/robbiehanson/CocoaAsyncSocket
 https://github.com/socketio/socket.io-client-swift
 WebSocket开源框架:
 https://github.com/facebook/SocketRocket
 https://github.com/tidwall/SwiftWebSocket
 */

@implementation HttpHeader

- (instancetype)init
{
    if (self = [super init]) {
        _userID = [UserInfo sharedUserInfo].userID;
        _imei = [OpenUDID value];
        _osType = 2;
        _appVersion = App_Bundle_Version;
        _channel = @"AppStore";
        _mobileModel = CurrentDevice.machineModel;
        _mobileModelName = CurrentDevice.machineModelName;
        _token = [UserInfo sharedUserInfo].token;
    }
    return self;
}

@end

/*
 WebSocket:
 
 // Test
 // https://www.websocket.org/echo.html
 
 // 协议
 https://tools.ietf.org/html/rfc6455
 
 long poll 和 轮询:
 轮询:让浏览器隔个几秒就发送一次请求，询问服务器是否有新信息
 long poll:都是采用轮询的方式，不过采取的是阻塞模型.客户端发起连接后，如果没消息，就一直不返回Response给客户端。直到有消息才返回
 都是在不断地建立HTTP连接，然后等待服务端处理
 
 Websocket是应用层第七层上的一个应用层协议，它必须依赖 HTTP 协议进行一次握手 ，握手成功后，数据就直接从 TCP 通道传输，与 HTTP 无关了
 Websocket的数据传输是frame形式传输的，比如会将一条消息分为几个frame，按照先后顺序传输出去。这样做会有几个好处：
 1 大数据的传输可以分片传输，不用考虑到数据大小导致的长度标志位不足够的情况。
 2 和http的chunk一样，可以边生成数据边传递消息，即提高传输效率

 协议标识符是ws，请求地址格式：ws://example.com:80/path
 
 握手过程:
 为了建立一个 WebSocket 连接，客户端首先要向服务器发起一个 HTTP 请求，这个请求和通常的 HTTP 请求不同，包含了一些附加头信息
 客户端请求Header:
 --- request header ---
 GET /chat HTTP/1.1
 Upgrade: websocket
 Connection: Upgrade
 Host: 127.0.0.1:8001
 Origin: http://127.0.0.1:8001
 Sec-WebSocket-Key: hj0eNqbhE/A0GkBXDRrYYw==
 Sec-WebSocket-Version: 13
 在请求头加上 Upgrade 字段，该字段用于改变 HTTP 协议版本或者是换用其他协议，这里我们把 Upgrade 的值设为 websocket ，将它升级为 WebSocket 协议
 Sec-WebSocket-Key 字段，它由客户端生成（这个是浏览器随机生成的）并发给服务端，用于证明服务端接收到的是一个可受信的连接握手，可以帮助服务端排除自身接收到的由非 WebSocket 客户端发起的连接，该值是一串随机经过 base64 编码的字符串
 
 服务器的Response:
 HTTP/1.1 101 Switching Protocols
 Content-Length: 0
 Upgrade: websocket
 Sec-Websocket-Accept: ZEs+c+VBk8Aj01+wJGN7Y15796g=
 Server: TornadoServer/4.5.1
 Connection: Upgrade
 Date: Wed, 21 Jun 2017 03:29:14 GMT
 
 重要的是 Sec-WebSocket-Accept ，服务端通过从客户端请求头中读取 Sec-WebSocket-Key 与一串全局唯一的标识字符串（俗称魔串）“258EAFA5-E914-47DA- 95CA-C5AB0DC85B11”做拼接，生成长度为160位的 SHA-1 字符串，然后进行 base64 编码，作为 Sec-WebSocket-Accept 的值回传给客户端
 双方就可以通过这个连接通道自由的传递信息，并且这个连接会持续存在直到客户端或者服务器端的某一方主动的关闭连接
 HTTP已经完成它所有工作了，接下来就是完全按照Websocket协议进行了
 
 init websocket -> open ->  connected -> sendMsg -> handle server response -> close
 
 上述的通道握手建立并且能与服务器简单通信后，就要考虑各种情况的处理，包括断网，信号差等，就需要考虑断线重连，发送心跳包确定是否与服务器保持着连接的状态
 
 关闭连接分为两种：服务端发起关闭和客户端主动关闭。
 服务端发起关闭的时候，会客户端发送一个关闭帧，客户端在接收到帧的时候通过解析出帧的opcode来判断是否是关闭帧，然后同样向服务端再发送一个关闭帧作为回应
 
 服务端就可以主动推送信息给客户端
 （在程序设计中，这种设计叫做回调，即：你有信息了再来通知我，而不是我傻乎乎的每次跑来问你）
 
 https://www.jianshu.com/p/86e1059a3e92
 #import <Foundation/Foundation.h>
 #import "SRWebSocket.h"
 @interface WebSocketManager : NSObject
 
 @property (nonatomic, strong) SRWebSocket *webSocket;
 + (instancetype)sharedSocketManager;//单例
 - (void)connectServer;//建立长连接
 - (void)SRWebSocketClose;//关闭长连接
 - (void)sendDataToServer:(id)data;//发送数据给服务器
 @end
 
 
 主线程异步队列
 #define dispatch_main_async_safe(block)\
 if ([NSThread isMainThread]) {\
 block();\
 } else {\
 dispatch_async(dispatch_get_main_queue(), block);\
 }
 
 
 #import "WebSocketManager.h"
 
 @interface WebSocketManager()<SRWebSocketDelegate>
 
 @property (nonatomic, strong) NSTimer *heartBeatTimer; //心跳定时器
 @property (nonatomic, strong) NSTimer *netWorkTestingTimer; //没有网络的时候检测网络定时器
 @property (nonatomic, strong) dispatch_queue_t queue; //数据请求队列（串行队列）
 @property (nonatomic, assign) NSTimeInterval reConnectTime; //重连时间
 @property (nonatomic, strong) NSMutableArray *sendDataArray; //存储要发送给服务端的数据
 @property (nonatomic, assign) BOOL isActivelyClose;    //用于判断是否主动关闭长连接，如果是主动断开连接，连接失败的代理中，就不用执行 重新连接方法
 
 @end
 
 @implementation WebSocketManager
 
 //单例
 + (instancetype)sharedSocketManager
 {
 static WebSocketManager *_instace = nil;
 static dispatch_once_t onceToken;
 dispatch_once(&onceToken,^{
 _instace = [[self alloc] init];
 });
 return _instace;
 }
 
 - (instancetype)init
 {
 self = [super init];
 if(self)
 {
 self.reConnectTime = 0;
 self.isActivelyClose = NO;
 self.queue = dispatch_queue_create("BF",NULL);
 self.sendDataArray = [[NSMutableArray alloc] init];
 }
 return self;
 }
 
 #pragma mark - NSTimer
 
 //初始化心跳
 - (void)initHeartBeat
 {
 //心跳没有被关闭
 if(self.heartBeatTimer)
 {
 return;
 }
 
 [self destoryHeartBeat];
 
 WS(weakSelf);
 dispatch_main_async_safe(^{
 weakSelf.heartBeatTimer  = [NSTimer timerWithTimeInterval:10 target:weakSelf selector:@selector(senderheartBeat) userInfo:nil repeats:true];
 [[NSRunLoop currentRunLoop]addTimer:weakSelf.heartBeatTimer forMode:NSRunLoopCommonModes];
 });
 }
 
 //取消心跳
 - (void)destoryHeartBeat
 {
 WS(weakSelf);
 dispatch_main_async_safe(^{
 if(weakSelf.heartBeatTimer)
 {
 [weakSelf.heartBeatTimer invalidate];
 weakSelf.heartBeatTimer = nil;
 }
 });
 }
 
 //没有网络的时候开始定时 -- 用于网络检测
 - (void)noNetWorkStartTestingTimer
 {
 WS(weakSelf);
 dispatch_main_async_safe(^{
 weakSelf.netWorkTestingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:weakSelf selector:@selector(noNetWorkStartTesting) userInfo:nil repeats:YES];
 [[NSRunLoop currentRunLoop] addTimer:weakSelf.netWorkTestingTimer forMode:NSDefaultRunLoopMode];
 });
 }
 
 //取消网络检测
 - (void)destoryNetWorkStartTesting
 {
 WS(weakSelf);
 dispatch_main_async_safe(^{
 if(weakSelf.netWorkTestingTimer)
 {
 [weakSelf.netWorkTestingTimer invalidate];
 weakSelf.netWorkTestingTimer = nil;
 }
 });
 }
 
 #pragma mark - private -- webSocket相关方法
 
 //发送心跳
 - (void)senderheartBeat
 {
 //和服务端约定好发送什么作为心跳标识，尽可能的减小心跳包大小
 WS(weakSelf);
 dispatch_main_async_safe(^{
 if(weakSelf.webSocket.readyState == SR_OPEN)
 {
 [weakSelf.webSocket sendPing:nil];
 }
 });
 }
 
 //定时检测网络
 - (void)noNetWorkStartTesting
 {
 //有网络
 if(AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable)
 {
 //关闭网络检测定时器
 [self destoryNetWorkStartTesting];
 //开始重连
 [self reConnectServer];
 }
 }
 
 //建立长连接
 - (void)connectServer
 {
 self.isActivelyClose = NO;
 
 if(self.webSocket)
 {
 self.webSocket = nil;
 }
 
 NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://ip地址:端口号"]];
 self.webSocket = [[SRWebSocket alloc] initWithURLRequest:request];
 self.webSocket.delegate = self;
 [self.webSocket open];
 }
 
 //重新连接服务器
 - (void)reConnectServer
 {
 if(self.webSocket.readyState == SR_OPEN)
 {
 return;
 }
 
 if(self.reConnectTime > 1024)  //重连10次 2^10 = 1024
 {
 self.reConnectTime = 0;
 return;
 }
 
 WS(weakSelf);
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.reConnectTime *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 
 if(weakSelf.webSocket.readyState == SR_OPEN && weakSelf.webSocket.readyState == SR_CONNECTING)
 {
 return;
 }
 
 [weakSelf connectServer];
 CTHLog(@"正在重连......");
 
 if(weakSelf.reConnectTime == 0)  //重连时间2的指数级增长
 {
 weakSelf.reConnectTime = 2;
 }
 else
 {
 weakSelf.reConnectTime *= 2;
 }
 });
 
 }
 
 //关闭连接
 - (void)SRWebSocketClose;
 {
 self.isActivelyClose = YES;
 [self webSocketClose];
 
 //关闭心跳定时器
 [self destoryHeartBeat];
 
 //关闭网络检测定时器
 [self destoryNetWorkStartTesting];
 }
 
 //关闭连接
 - (void)webSocketClose
 {
 if(self.webSocket)
 {
 [self.webSocket close];
 self.webSocket = nil;
 }
 }
 
 //发送数据给服务器
 - (void)sendDataToServer:(id)data
 {
 [self.sendDataArray addObject:data];
 [self sendeDataToServer];
 }
 
 
 - (void)sendeDataToServer
 {
 WS(weakSelf);
 
 //把数据放到一个请求队列中
 dispatch_async(self.queue, ^{
 
 //没有网络
 if (AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable)
 {
 //开启网络检测定时器
 [weakSelf noNetWorkStartTestingTimer];
 }
 else //有网络
 {
 if(weakSelf.webSocket != nil)
 {
 // 只有长连接OPEN开启状态才能调 send 方法，不然会Crash
 if(weakSelf.webSocket.readyState == SR_OPEN)
 {
 if (weakSelf.sendDataArray.count > 0)
 {
 NSString *data = weakSelf.sendDataArray[0];
 [weakSelf.webSocket send:data]; //发送数据
 [weakSelf.sendDataArray removeObjectAtIndex:0];
 
 if([weakSelf.sendDataArray count] > 0)
 {
 [weakSelf sendeDataToServer];
 }
 }
 }
 else if (weakSelf.webSocket.readyState == SR_CONNECTING) //正在连接
 {
 CTHLog(@"正在连接中，重连后会去自动同步数据");
 }
 else if (weakSelf.webSocket.readyState == SR_CLOSING || weakSelf.webSocket.readyState == SR_CLOSED) //断开连接
 {
 //调用 reConnectServer 方法重连,连接成功后 继续发送数据
 [weakSelf reConnectServer];
 }
 }
 else
 {
 [weakSelf connectServer]; //连接服务器
 }
 }
 });
 }
 
 #pragma mark - SRWebSocketDelegate -- webSockect代理
 
 //连接成功回调
 - (void)webSocketDidOpen:(SRWebSocket *)webSocket
 {
 CTHLog(@"webSocket ===  连接成功");
 
 [self initHeartBeat]; //开启心跳
 
 //如果有尚未发送的数据，继续向服务端发送数据
 if ([self.sendDataArray count] > 0){
 [self sendeDataToServer];
 }
 }
 
 //连接失败回调
 - (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
 {
 //用户主动断开连接，就不去进行重连
 if(self.isActivelyClose)
 {
 return;
 }
 
 [self destoryHeartBeat]; //断开连接时销毁心跳
 
 CTHLog(@"连接失败，这里可以实现掉线自动重连，要注意以下几点");
 CTHLog(@"1.判断当前网络环境，如果断网了就不要连了，等待网络到来，在发起重连");
 CTHLog(@"3.连接次数限制，如果连接失败了，重试10次左右就可以了");
 
 //判断网络环境
 if (AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) //没有网络
 {
 [self noNetWorkStartTestingTimer];//开启网络检测定时器
 }
 else //有网络
 {
 [self reConnectServer];//连接失败就重连
 }
 }
 
 //连接关闭,注意连接关闭不是连接断开，关闭是 [socket close] 客户端主动关闭，断开可能是断网了，被动断开的。
 - (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
 {
 // 在这里判断 webSocket 的状态 是否为 open , 大家估计会有些奇怪 ，因为我们的服务器都在海外，会有些时间差，经过测试，我们在进行某次连接的时候，上次重连的回调刚好回来，而本次重连又成功了，就会误以为，本次没有重连成功，而再次进行重连，就会出现问题，所以在这里做了一下判断
 if(self.webSocket.readyState == SR_OPEN || self.isActivelyClose)
 {
 return;
 }
 
 CTHLog(@"被关闭连接，code:%ld,reason:%@,wasClean:%d",code,reason,wasClean);
 
 [self destoryHeartBeat]; //断开连接时销毁心跳
 
 //判断网络环境
 if (AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) //没有网络
 {
 [self noNetWorkStartTestingTimer];//开启网络检测
 }
 else //有网络
 {
 [self reConnectServer];//连接失败就重连
 }
 }
 
 //该函数是接收服务器发送的pong消息，其中最后一个参数是接受pong消息的
 -(void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData*)pongPayload
 {
 NSString* reply = [[NSString alloc] initWithData:pongPayload encoding:NSUTF8StringEncoding];
 CTHLog(@"reply === 收到后台心跳回复 Data:%@",reply);
 }
 
 //收到服务器发来的数据
 - (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
 {
 NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithJsonString:message];
 
 // 根据具体的业务做具体的处理
}

@end
 */
