//
//  ContactsAuthority.h
//  NDL_Category
//
//  Created by dzcx on 2018/6/15.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactsAuthority : NSObject

+ (BOOL)authorized;

+ (NSInteger)authorizationStatus;

@end
