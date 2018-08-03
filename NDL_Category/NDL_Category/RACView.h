//
//  RACView.h
//  NDL_Category
//
//  Created by dzcx on 2018/8/3.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RACView : UIView

@property (nonatomic, strong) RACSubject *delegateSignal;

- (void)buttonDidClicked:(UIButton *)button;

@end
