//
//  NSURLRequest+Extension.m
//  NDL_Category
//
//  Created by dzcx on 2019/6/14.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "NSURLRequest+Extension.h"

@implementation NSURLRequest (Extension)

- (NSDictionary<NSString *, NSString *> *)ndl_requestHeaderCookies
{
    NSDictionary<NSString *, NSString *> *requestHeaderCookies = nil;
    NSArray<NSHTTPCookie *> *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:self.URL];
    if (cookies.count) {
        requestHeaderCookies = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    }
    
    return requestHeaderCookies;
}

@end
