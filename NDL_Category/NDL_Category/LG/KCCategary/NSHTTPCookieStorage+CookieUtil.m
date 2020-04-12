//
//  NSHTTPCookieStorage+CookieUtil.m
//  002---HTTPCookie
//
//  Created by Cooci on 2018/8/23.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import "NSHTTPCookieStorage+CookieUtil.h"
#import <objc/runtime.h>

@implementation NSHTTPCookieStorage (CookieUtil)

/**
 *  方法替换。Method Swizzling技术。使类中的方法实现和自己的方法实现互换，达到替换默认，且还可以调用默认方法的目的。
 *
 *  @param class            替换的方法所属的类
 *  @param originalSelector 原始的方法选择器
 *  @param swizzledSelector 用以替换的方法选择器
 */
static inline void class_methodSwizzling(Class class, SEL originalSelector, SEL swizzledSelector)
{
    // When swizzling a class method, use the following:
    // Class class = object_getClass((id)self);
    // Others, use the following:
    // Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    //如果可以在原有类中添加方法，说明原有的类并没有实现，可能是继承自父类的方法。
    //那么，我们添加一个方法，方法名为原方法名，实现为我们自己的实现。之后再将自己的方法替换成原始的实现。
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    //这么做，避免了替换方法时，由于本class中没有实现，从而替换了父类的方法。造成不可预知的错误。
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }
    else
    {
        //如果类中已经实现了这个原始方法，那么就与我们的方法互换一下实现。
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)load
{
    class_methodSwizzling(self, @selector(cookies), @selector(kc_cookies));
}

- (NSArray<NSHTTPCookie *> *)kc_cookies
{
    NSArray *cookies = [self kc_cookies];
    BOOL isExist = NO;
    for (NSHTTPCookie *cookie in cookies) {
        if ([cookie.name isEqualToString:@"Custom_Client_Cookie"]) {
            isExist = YES;
            break;
        }
    }
    if (!isExist) {
        //CookieStroage中添加
        NSHTTPCookie *cookie = [self fetchAccessTokenCookie];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        NSMutableArray *mCookies = cookies.mutableCopy;
        [mCookies addObject:cookie];
        cookies = mCookies.copy;
    }
    return cookies;
}

- (NSHTTPCookie *)fetchAccessTokenCookie {
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    [properties setObject:@"Custom_Client_Cookie" forKey:NSHTTPCookieName];
    [properties setObject:@"Cooci" forKey:NSHTTPCookieValue];
    [properties setObject:@"" forKey:NSHTTPCookieDomain];
    [properties setObject:@"/" forKey:NSHTTPCookiePath];
    NSHTTPCookie *accessCookie = [[NSHTTPCookie alloc] initWithProperties:properties];
    return accessCookie;
}

@end
