//
//  NSHTTPCookie+Util.m
//  WKWebViewDemo
//
//  Created by vampire on 2018/6/11.
//  Copyright © 2018年 vampire. All rights reserved.
//

#import "NSHTTPCookie+Util.h"

@implementation NSHTTPCookie (Util)

- (NSString *)kc_formatCookieString{
    NSString *string = [NSString stringWithFormat:@"%@=%@;domain=%@;path=%@",
                        self.name,
                        self.value,
                        self.domain,
                        self.path ?: @"/"];
    
    if (self.secure) {
        string = [string stringByAppendingString:@";secure=true"];
    }
    
    return string;
}

@end
