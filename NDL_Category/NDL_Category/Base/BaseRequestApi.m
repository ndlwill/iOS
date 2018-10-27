//
//  BaseRequestApi.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/22.
//  Copyright © 2018年 ndl. All rights reserved.
//

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
