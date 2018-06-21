//
//  UIButton+NDLBlock.h
//  NDL_Category
//
//  Created by dzcx on 2018/6/19.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (NDLBlock)

- (void)addActionBlock:(void (^)(UIButton *pSender))block;

@end
