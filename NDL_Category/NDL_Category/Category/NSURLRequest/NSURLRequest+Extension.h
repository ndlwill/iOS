//
//  NSURLRequest+Extension.h
//  NDL_Category
//
//  Created by dzcx on 2019/6/14.
//  Copyright © 2019 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLRequest (Extension)

- (NSDictionary<NSString *, NSString *> *)ndl_requestHeaderCookies;

@end

NS_ASSUME_NONNULL_END
