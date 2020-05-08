

#import "KCNetwork.h"

@interface KCNetwork()<NSURLSessionDelegate>

@property (nonatomic, copy) KCRequestHandleBlock handleBlock;
@property (nonatomic, strong) NSMutableData *receivedData;

@end

@implementation KCNetwork

+ (instancetype)shared{
    static KCNetwork *network;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        network = [[KCNetwork alloc] init];
    });
    return network;
}


- (NSURLSessionDataTask *)post:(NSString*)url token:(NSString*)token reqData:(NSDictionary*)params handle:(KCRequestHandleBlock)handleblock{
    
    // 校验url
    if (!url || url.length == 0) {
        NSLog(@"url 无效!");
        return nil;
    }
    // token
    if (!token || token.length == 0) {
        NSLog(@"token 无效!");
        return nil;
    }
    // 记录回调,在任何你想要操作的地方,随时拿出来
    self.handleBlock = handleblock;
    
    // 操作URL
    NSURL *requestUrl = [NSURL URLWithString:url];
    // 定义request 来设定请求头
    NSMutableURLRequest *mRequest = [NSMutableURLRequest requestWithURL:requestUrl];
    [mRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [mRequest setValue:token forHTTPHeaderField:@"token"];
    // 请求方法
    mRequest.HTTPMethod = @"POST";
    /**
     别回答 参数在url 后面拼接了:
     post get 根本区别: 数据保存的 head VS body
     */
    // 默认60秒
    mRequest.timeoutInterval = 30.0;
    
    // 请求体处理
    mRequest.HTTPBody = [[self convertToJSONData:params] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:self
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    
    //创建请求 Task 该次请求的指针 句柄 *p  dataTask
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:mRequest];
    
    [dataTask resume];
    
    return dataTask;
    
}

#pragma mark -- NSURLSessionDataDelegate

// 1.接收到服务器的响应
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    completionHandler(NSURLSessionResponseAllow);
}

// 返回body 多次返回 为什么 MTU限制  TCP 包按照顺序返回
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    [self.receivedData appendData:data];
    
}

// 任务完成时调用或者失败
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    if(error == nil){
        NSString* jsonString =  [[NSString alloc] initWithData:self.receivedData  encoding:NSUTF8StringEncoding];
        id obj = [self dictionaryWithJsonString:jsonString];
        NSLog(@"%@",obj);
        self.handleBlock(obj, @"请求成功", 200);
    }else{
        self.handleBlock(nil,[self getErrCode:error.code],error.code);
    }
}



#pragma mark - 错误代码

-(NSString*)getErrCode:(NSInteger)code{
    
    switch (code) {
        case 700:
            return @"会话过期";
            break;
            
        case 800:
            return @"后台gg正常维护中";
            break;
            
        case 404:
            return @"网络连接失败";
            break;
            
        case 500:
            return @"服务器拒绝请求";
            break;
            
        default:
            break;
    }
    
    return @"未知错误";
}

#pragma mark - json 序列化
- (NSString*)convertToJSONData:(id)infoDict{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = @"";
    if (!jsonData){
        NSLog(@"json 序列化错误: %@", error);
    }else{
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //去除掉首尾的空白字符和换行字符
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return jsonString;
}

#pragma mark - json 反序列化 -- json 解析
-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err){
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

#pragma mark - lazy

- (NSMutableData *)receivedData{
    if (!_receivedData) {
        _receivedData = [NSMutableData data];
    }
    return _receivedData;
}

@end
