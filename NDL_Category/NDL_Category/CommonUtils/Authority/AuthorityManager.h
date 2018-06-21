//
//  AuthorityManager.h
//  NDL_Category
//
//  Created by dzcx on 2018/5/21.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

/* http://www.jb51.net/article/132642.htm */
@interface AuthorityManager : NSObject

+ (BOOL)authorizedWithType:(AuthorityType)type;

+ (void)authorizedWithType:(AuthorityType)type completion:(void (^)(BOOL granted))completion;

@end
