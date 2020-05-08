

#import "KCURLProtocol.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>


static NSString *const kcProtocolKey = @"kcProtocolKey";

@implementation KCURLProtocol

// 这个方法是注册后,NSURLProtocol就会通过这个方法确定参数request是否需要被处理
// return : YES 需要经过这个NSURLProtocol"协议" 的处理, NO 这个 协议request不需要遵守这个NSURLProtocol"协议"
// 这个方法的作用 :
//   -| 1, 筛选Request是否需要遵守这个NSURLRequest ,
//   -| 2, 处理http: , https等URL

+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    
    if ([NSURLProtocol propertyForKey:kcProtocolKey inRequest:request]) {
        return NO;
    }
    NSString *scheme         = [[request URL] scheme];
    NSString *absoluteString = [[request URL] absoluteString];
    NSLog(@"absoluteString--%@",absoluteString);
    
    NSString* extension = request.URL.pathExtension;
    NSArray *array = @[@"png", @"jpeg", @"gif", @"jpg"];
    if([array containsObject:extension]){
        return YES;
    }
    
    if ([absoluteString isEqualToString:@"https://m.baidu.com/static/index/plus/plus_logo.png"] || [absoluteString isEqualToString:@"http://www.baidu.com"]) {
        return YES;
    }
    return NO;
}

//这个方法就是返回规范的request
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    return request;
}

// 需要在该方法中发起一个请求，对于NSURLConnection来说，就是创建一个NSURLConnection，对于NSURLSession，就是发起一个NSURLSessionTask
// 另外一点就是这个方法之后,会回调<NSURLProtocolClient>协议中的方法,

- (void)startLoading{
    
    NSLog(@"来了");
    NSMutableURLRequest *request = [self.request mutableCopy];
    NSString *absoluteString = [[request URL] absoluteString];
    [NSURLProtocol setProperty:@(YES) forKey:kcProtocolKey inRequest:request];

    NSData *data = [self getImageData];
    [self.client URLProtocol:self didLoadData:data];

    
//    request.URL = [NSURL URLWithString:@"http://127.0.0.1:8080/pythonJson/"];
//
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//
//        NSLog(@"startLoading == %@---%@",response,data);
//
//        [self.client URLProtocol:self didLoadData:data];
//        [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
//    }];

}

// 这个方法是和start是对应的 一般在这个方法中,断开Connection
// 另外一点就是当NSURLProtocolClient的协议方法都回调完毕后,就会开始执行这个方法了
- (void)stopLoading{
    
}

// 这个方法主要用来判断两个请求是否是同一个请求，
// 如果是，则可以使用缓存数据，通常只需要调用父类的实现即可,默认为YES,而且一般不在这里做事情
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return [super requestIsCacheEquivalent:a toRequest:b];
}


#pragma mark - private

- (NSData *)getImageData{
 
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"lufei.jpg" ofType:@""];
    return [NSData dataWithContentsOfFile:fileName];

}

#pragma mark - hook

+ (void)hookNSURLSessionConfiguration{
    
    Class cls = NSClassFromString(@"__NSCFURLSessionConfiguration") ?: NSClassFromString(@"NSURLSessionConfiguration");
    
    Method originalMethod = class_getInstanceMethod(cls, @selector(protocolClasses));
    Method stubMethod = class_getInstanceMethod([self class], @selector(protocolClasses));
    if (!originalMethod || !stubMethod) {
        [NSException raise:NSInternalInconsistencyException format:@"没有这个方法 无法交换"];
    }
    method_exchangeImplementations(originalMethod, stubMethod);
}

- (NSArray *)protocolClasses {
    return @[[KCURLProtocol class]];
    //如果还有其他的监控protocol,也可以在这里加进去
}



@end
