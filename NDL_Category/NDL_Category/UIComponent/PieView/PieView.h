//
//  PieView.h
//  NDL_Category
//
//  Created by ndl on 2018/2/24.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PieView : UIView

- (instancetype)initWithFrame:(CGRect)frame values:(NSArray<NSNumber *> *)values titles:(NSArray *)titles;

@end
