//
//  Object1.h
//  NDL_Category
//
//  Created by dzcx on 2019/8/24.
//  Copyright © 2019 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Object2;


@interface Object1 : NSObject

@property (nonatomic, strong) Object2 *obj;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;

@end

