//
//  UITextField+NDLExtension.h
//  NDL_Category
//
//  Created by dzcx on 2018/7/3.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (NDLExtension)

- (UILabel *)ndl_placeholderLabel;

- (void)ndl_selectAllText;

- (void)ndl_selectTextWithRange:(NSRange)range;

@end
