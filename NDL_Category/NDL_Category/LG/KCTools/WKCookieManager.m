//
//  WKCookieManager.m
//  002---HTTPCookie
//
//  Created by Cooci on 2018/8/23.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import "WKCookieManager.h"
#import "NSHTTPCookie+Util.h"

@interface WKCookieManager()

@end

static WKCookieManager *_instance;

@implementation WKCookieManager

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[WKCookieManager alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _processPool = [[WKProcessPool alloc] init];
    }
    return self;
}

/*
 第一次尝试如何让 URL 刚开始加载是带上自己的 Cookie,可以通过抓包工具去查看，只能查看 HTTP，无法查看 HTTPS,这时可以看到 Cookie 有你自己的字段
 */
- (NSURLRequest *)cookieAppendRequest{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://m.baidu.com"]];
    NSArray *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    //Cookies数组转换为requestHeaderFields
    NSDictionary *requestHeaderFields = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    //设置请求头
    request.allHTTPHeaderFields = requestHeaderFields;
    NSLog(@"%@",request.allHTTPHeaderFields);
    return request;
}

- (WKUserScript *)futhureCookieScript{
    WKUserScript * cookieScript = [[WKUserScript alloc] initWithSource:[self cookieString] injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    return cookieScript;
}

- (NSString *)cookieString
{
    NSMutableString *script = [NSMutableString string];
    [script appendString:@"var cookieNames = document.cookie.split('; ').map(function(cookie) { return cookie.split('=')[0] } );\n"];
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {

        if ([cookie.value rangeOfString:@"'"].location != NSNotFound) {
            continue;
        }
        [script appendFormat:@"if (cookieNames.indexOf('%@') == -1) { document.cookie='%@'; };\n", cookie.name, cookie.kc_formatCookieString];
    }
    return script;
}

- (NSURLRequest *)fixNewRequestCookieWithRequest:(NSURLRequest *)originalRequest{
    NSMutableURLRequest *fixedRequest;
    if ([originalRequest isKindOfClass:[NSMutableURLRequest class]]) {
        fixedRequest = (NSMutableURLRequest *)originalRequest;
    } else {
        fixedRequest = originalRequest.mutableCopy;
    }
    //防止Cookie丢失
    NSDictionary *dict = [NSHTTPCookie requestHeaderFieldsWithCookies:[NSHTTPCookieStorage sharedHTTPCookieStorage].cookies];
    if (dict.count) {
        NSMutableDictionary *mDict = originalRequest.allHTTPHeaderFields.mutableCopy;
        [mDict setValuesForKeysWithDictionary:dict];
        fixedRequest.allHTTPHeaderFields = mDict;
    }
    return fixedRequest;
}

@end
