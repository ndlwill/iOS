//
//  CustomTextField.m
//  NDL_Category
//
//  Created by ndl on 2018/1/12.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//- (void)drawPlaceholderInRect:(CGRect)rect
//{
//    NSLog(@"drawPlaceholderInRect");
//    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
//    // 设置富文本对象的颜色
//    attributes[NSForegroundColorAttributeName] = [UIColor redColor];
//    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:30];
//
//    
//    [self.placeholder drawInRect:rect withAttributes:attributes];
//}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
//    CGRect newRect  = CGRectInset(bounds, 20, 0);
//    NSLog(@"old = %@ new = %@", NSStringFromCGRect(bounds), NSStringFromCGRect(newRect));
//    return newRect;
    CGRect inset = CGRectMake(bounds.origin.x+50, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
    return inset;
}

- (BOOL)becomeFirstResponder
{
    return [super becomeFirstResponder];
}

@end
