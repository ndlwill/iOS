//
//  NSDictionary+NDLExtension.h
//  NDL_Category
//
//  Created by dzcx on 2018/4/10.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NDLExtension)

- (id)notNullObjectForKey:(id)key;

- (id)notNullArrayForKey:(id)key;

@end
