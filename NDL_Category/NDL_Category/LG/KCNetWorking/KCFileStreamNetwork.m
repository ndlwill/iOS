

#import "KCFileStreamNetwork.h"

@interface KCFileStreamNetwork()<NSURLSessionDelegate>

@property (nonatomic, copy) KCFileHandleBlock handleBlock;
@property (nonatomic, copy) NSString *mFileUrl;
@property (nonatomic, strong) NSMutableData *receiveData;
@property (nonatomic, strong) NSOutputStream *outpustream;
@property (nonatomic, strong) NSFileHandle *fileHandle;


@end

@implementation KCFileStreamNetwork

- (instancetype)init {
    
    if(self=[super init]){
        _receiveData = [[NSMutableData alloc] init];
        return self;
    }
    return nil;
}

- (NSURLSessionDataTask*)getDownFileUrl:(NSString*)fileUrl backBlock:(KCFileHandleBlock)handleBlock{
    
    if(fileUrl==nil || handleBlock==nil)  return nil;
    
    self.handleBlock = handleBlock;
    //确定请求路径
    NSURL *url0 = [NSURL URLWithString:fileUrl];
    //创建可变请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url0];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 30.0;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:self
                                                     delegateQueue:[NSOperationQueue   mainQueue]];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    //发送请求
    [dataTask resume];
    
    return dataTask;
    
}


NSInteger fileDownPro = 0;
NSInteger fileTotalPro = 0;
#pragma mark -- NSURLSessionDataDelegate// 1.接收到服务器的响应
//接受的http的 head数据
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    fileTotalPro = response.expectedContentLength;//字节
    completionHandler(NSURLSessionResponseAllow);
}

// 2.接收到http 的body数据
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    //这样会造成内存暴增
    //[self.receiveData appendData:data];
    
    //创建流，append为YES的话，每次写入都是追加到文件尾部
    self.outpustream = [NSOutputStream outputStreamToFileAtPath:[self getSaveFilePath] append:YES];

    //一点一点的存 细水流长
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [self saveFile:data];
        [self.outpustream open];
        [self.outpustream write:data.bytes maxLength:data.length];
        [self.outpustream close];
    });
    
    fileDownPro  = fileDownPro +  data.length;
    float downPro = fileDownPro/(fileTotalPro*1.0)*100;
    NSString *progress = [NSString stringWithFormat:@"%.2f%@",downPro,@"%"];
    self.handleBlock(nil, progress);
}

// 3.3.任务完成时调用
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    NSLog(@"下载完成");
    
    if (!error) {
//        [self.receiveData writeToFile:[self getSaveFilePath] atomically:YES];
    }
}

- (void)saveFile:(NSData *)data {
    //保存文件的路径
    NSString *filePath = [self getSaveFilePath];
    //如果文件不存在，返回的是nil
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    //判断文件存不存在
    if (fileHandle == nil) {
        //如果文件不存在，会自动创建
        [data writeToFile:filePath atomically:YES];
    }else {
        //让offset指向文件的末尾
        [fileHandle seekToEndOfFile];
        //在文件的末尾再继续写入文件
        [fileHandle writeData:data];
        // 同步一下防止操作混乱
        [fileHandle synchronizeFile];
        //关闭文件
        [fileHandle closeFile];
    }
}

- (NSString *)getSaveFilePath{
    
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"video.mp4"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }
    return filePath;
}


@end
