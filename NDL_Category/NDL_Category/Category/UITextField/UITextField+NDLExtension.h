//
//  UITextField+NDLExtension.h
//  NDL_Category
//
//  Created by dzcx on 2018/7/3.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 MARK: marked text
 当我们使用系统的拼音输入法输入中文时，首先需要输入拼音字母，这个叫做 marked text
 marked text 也是会被 shouldChangeCharactersIn 方法强制获取到的
 */
@interface UITextField (NDLExtension)

- (UILabel *)ndl_placeholderLabel;

- (void)ndl_selectAllText;

- (void)ndl_selectTextWithRange:(NSRange)range;

@end
