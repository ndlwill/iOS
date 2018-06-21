//
//  NetworkDataAuthority.h
//  NDL_Category
//
//  Created by dzcx on 2018/6/19.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

// 网络数据
@interface NetworkDataAuthority : NSObject

+ (void)authorizeWithCompletion:(void (^)(BOOL granted))completion;

@end
