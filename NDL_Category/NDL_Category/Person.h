//
//  Person.h
//  NDL_Category
//
//  Created by ndl on 2018/2/27.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;

+ (instancetype)personWithName:(NSString *)name age:(NSInteger)age;

@end
