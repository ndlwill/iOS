//
//  PacketSplicingPacketBreakingViewController.m
//  NDL_Category
//
//  Created by ndl on 2020/4/18.
//  Copyright © 2020 ndl. All rights reserved.
//

#import "PacketSplicingPacketBreakingViewController.h"

#import <GCDAsyncSocket.h>
// 数据类型
#define kcImageDataType 0x00000001
#define kcVideoDataType 0x00000002

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

@interface PacketSplicingPacketBreakingViewController ()<GCDAsyncSocketDelegate>
@property (nonatomic, strong) GCDAsyncSocket *socket;
// 心跳timer
@property (nonatomic, strong) NSTimer *heartTimer;
// 重连等待时间
@property (nonatomic, assign) NSInteger reconnectTime;

@end

@implementation PacketSplicingPacketBreakingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)didClickConnectSocket:(id)sender {
    
    [self connectSocketOrCreate];
}

- (IBAction)didClickSendAction:(id)sender {
    // 发送图片
    UIImage *image = [UIImage imageNamed:@"test"];
    NSData  *imageData  = UIImagePNGRepresentation(image);

    unsigned int command = kcImageDataType;
    [self sendData:imageData dataType:command];

}

- (IBAction)didClickDisconnectAction:(id)sender {
//    [self.socket disconnect];
//    self.socket = nil;
    // 发送视频
    NSData *data = [@"hello" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData  *videoData  = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"q1.mp4" ofType:nil]];
    unsigned int command = kcVideoDataType;
    [self sendData:data dataType:command];
    
}

#pragma mark - 连接创建socket

- (void)connectSocketOrCreate{
    // 创建socket
    if (self.socket == nil)
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    // 连接socket
    if (!self.socket.isConnected){
        NSError *error;
        [self.socket connectToHost:@"127.0.0.1" onPort:8060 withTimeout:-1 error:&error];
        if (error) NSLog(@"%@",error);
    }
}

#pragma mark - 发送数据格式化
- (void)sendData:(NSData *)data dataType:(unsigned int)dataType{
    
    NSMutableData *mData = [NSMutableData data];
    // 计算数据总长度 data
    // 1000 + 类型 + hello.length
    // 我封装好的数据 - 整个数据长度
    // 0x00007ffee7c48f54 -- data
    // 4字节 存 0x00007ffee7c48f54
    unsigned int dataLength = 4+4+(int)data.length;
    NSData *lengthData = [NSData dataWithBytes:&dataLength length:4];
    [mData appendData:lengthData];
    
    // 数据类型 data
    // 2.拼接指令类型(4~7:指令)
    NSData *typeData = [NSData dataWithBytes:&dataType length:4];
    [mData appendData:typeData];
    
    // 最后拼接数据
    [mData appendData:data];
    NSLog(@"发送数据的总字节大小:%ld",mData.length);
    
    // 发数据
    [self.socket writeData:mData withTimeout:-1 tag:10086];
}

// 重连机制 -
// websocket:
// pingpang -- sendPing
// 不是持久发送 -- 是测试发送
- (void)reconnectSocket{
    // 1:关闭socket
    [self disconnectSocket];
    // 2.1 超时判断 > 5  --- 恶意攻击
    if (self.reconnectTime>64) {
        NSLog(@"网络超时,不再重连");
        return;
    }
    // 2.2 延时等待重连
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.reconnectTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self connectSocketOrCreate];
    });
    
    // 3:发现问题,每次都是毫无处理的重连是不合理的,对那些经常出问题的肯定是有问题的
    // 需要做处理 重连次数 重连时间要处理  2^5 = 64
    // 超时时长处理
    if (self.reconnectTime == 0) {
        self.reconnectTime = 2;
    }else{
        self.reconnectTime *= 2;
    }
    
}

// 关闭socket
- (void)disconnectSocket{
    if (self.socket) {
        [self.socket disconnect];
        self.socket.delegate = nil;
        self.socket = nil;
        [self destoryHeartBeat];
    }
}

// 心跳处理 : 不断去骚扰
- (void)setupHeartBeat{
    
    dispatch_async(dispatch_get_main_queue(), ^{

        // 调试 - 后台调试
        // 后台定位 - 后台
        [self destoryHeartBeat];
        __weak typeof(self) weakSelf = self;
        self.heartTimer = [NSTimer scheduledTimerWithTimeInterval:15 repeats:YES block:^(NSTimer * _Nonnull timer) {
            //尽量简单 节约
            //发送心跳 和后台可以约定发送什么内容
            __weak typeof(self) strongSelf = weakSelf;
            // 为什么要心跳
            // 监听不到:
            // 负载 - 有接受网络能力
            // 心跳 - 反向心跳 -- 保证彼此的连接
            // http - tcp 长链接
            
            NSData *heartData = [@"heartBeat" dataUsingEncoding:NSUTF8StringEncoding];
            [strongSelf.socket writeData:heartData withTimeout:-1 tag:10086];
            NSLog(@"heartBeat");
        }];
    });
}

- (void)destoryHeartBeat{
    //当然这里还以更加严谨一点: 因为已经在主线程了
    dispatch_main_async_safe(^{
        if (self.heartTimer && [self.heartTimer respondsToSelector:@selector(isValid)] && [self.heartTimer isValid]) {
            [self.heartTimer invalidate];
            self.heartTimer = nil;
        }
    });
}

// ping
- (void)ping{
    if (self.socket) {
        NSData *pingData = [@"ping" dataUsingEncoding:NSUTF8StringEncoding];
        [self.socket writeData:pingData withTimeout:-1 tag:10086];
    }
}

// 4 + 4 + hello  = 13

#pragma mark - GCDAsyncSocketDelegate

//已经连接到服务器
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(nonnull NSString *)host port:(uint16_t)port{
    
    NSLog(@"连接成功 : %@---%d",host,port);
    [self.socket readDataWithTimeout:-1 tag:10086];
}

// 连接断开
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"断开 socket连接 原因:%@",err);
    [self reconnectSocket];
}

//已经接收服务器返回来的数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSLog(@"接收到tag = %ld : %ld 长度的数据",tag,data.length);
    
    /**
     *  解析服务器返回的数据
     */
    // 获取总的数据包大小
    // 整段数据长度
    NSData *totalSizeData = [data subdataWithRange:NSMakeRange(0, 4)];
    unsigned int totalSize = 0;
    [totalSizeData getBytes:&totalSize length:4];
    NSLog(@"响应总数据的大小 %u",totalSize);
    
    // 获取指令类型
    NSData *commandIdData = [data subdataWithRange:NSMakeRange(4, 4)];
    unsigned int commandId = 0;
    [commandIdData getBytes:&commandId length:4];
    
    // 结果
    NSData *resultData = [data subdataWithRange:NSMakeRange(8, 4)];
    unsigned int result = 0;
    [resultData getBytes:&result length:4];
    
    NSMutableString *str = [NSMutableString string];
    if (commandId == kcImageDataType) {
        [str appendString:@"图片 "];
    }
    
    if(result == 1){
        [str appendString:@"上传成功"];
    }else{
        [str appendString:@"上传失败"];
    }
    NSLog(@"%@",str);
    
    [self.socket readDataWithTimeout:-1 tag:10086];
    
}

//消息发送成功 代理函数 向服务器 发送消息
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"%ld 的发送数据成功",tag);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
