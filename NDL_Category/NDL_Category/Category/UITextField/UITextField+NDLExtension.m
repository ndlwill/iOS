//
//  UITextField+NDLExtension.m
//  NDL_Category
//
//  Created by dzcx on 2018/7/3.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "UITextField+NDLExtension.h"

@implementation UITextField (NDLExtension)

// 默认placeholderLabel的font等于UITextField设置的font 同一个对象
// 默认placeholderLabel的大小等于UITextField的大小
- (UILabel *)ndl_placeholderLabel
{
    return (UILabel *)[self valueForKeyPath:@"_placeholderLabel"];
}

- (void)ndl_selectAllText
{
    UITextRange *textRange = [self textRangeFromPosition:self.beginningOfDocument toPosition:self.endOfDocument];
    [self setSelectedTextRange:textRange];
}

- (void)ndl_selectTextWithRange:(NSRange)range
{
    UITextPosition *beginPosition = self.beginningOfDocument;
    UITextPosition *startPosition = [self positionFromPosition:beginPosition offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:beginPosition offset:NSMaxRange(range)];
    UITextRange *selectedTextRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectedTextRange];
}

@end
