//
//  UIButton+NDLExtension.h
//  NDL_Category
//
//  Created by dzcx on 2018/7/2.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (NDLExtension)

// 最稳健的放在- (void)viewDidLayoutSubviews
// autoLayout:一定要放在setTitle setImage [self.view addSubview:btn]; 和约束后面
// frame:一定要放在[self.view addSubview:btn]; [btn sizeToFit]; btn.width += 8;后面
- (void)ndl_convertToRightImageButtonWithSpace:(CGFloat)space;

@end
