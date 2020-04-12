//
//  WKCookieManager.h
//  WKWebViewDemo
//  002---HTTPCookie
//
//  Created by Cooci on 2018/8/23.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@class WKProcessPool;

@interface WKCookieManager : NSObject

+ (instancetype)shareManager;

@property (strong,readonly, nonatomic) WKProcessPool *processPool;

/**
 拼接同步到 NSHTTPCookieStorage 中的 Cookei
 @return 拼接了 Cookie 字段后的请求
 */
- (NSURLRequest *)cookieAppendRequest;

/**
 跨域请求丢失问题
 @return 注入的 JS 代码块
 */
- (WKUserScript *)futhureCookieScript;

/**
 解决新的跳转 Cookie 丢失问题
 @param originalRequest 拦截的请求
 @return 带上 Cookie 的请求
 */
- (NSURLRequest *)fixNewRequestCookieWithRequest:(NSURLRequest *)originalRequest;

@end
