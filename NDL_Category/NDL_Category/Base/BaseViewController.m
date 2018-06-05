//
//  BaseViewController.m
//  NDL_Category
//
//  Created by ndl on 2018/2/26.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()


@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    id object = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY"];// object == nil
//    NSString *objStr = [NSString stringWithFormat:@"%@", object];// objStr == (null)
}

#pragma mark - Public Methods
- (void)showAlertViewForAppSettingWithTitle:(NSString *)titleStr msg:(NSString *)msgStr cancel:(NSString *)cancelStr setting:(NSString *)settingStr
{
    if (@available(iOS 8.0, *)) {
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:titleStr message:msgStr preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelStr style:UIAlertActionStyleCancel handler:nil];
        [vc addAction:cancelAction];
        
        UIAlertAction *settingAction = [UIAlertAction actionWithTitle:settingStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [CommonUtils openAppSettingURL];
        }];
        [vc addAction:settingAction];
        
        [self presentViewController:vc animated:YES completion:nil];
    }
}

// 滚动调整
//- (void)scrollAdjustWithScrollView:(UIScrollView *)scrollView
//{
//    CGFloat offsetY = scrollView.contentOffset.y;
//    self.totalOffsetY += offsetY;
//    
//    // self.totalOffsetY判断
//    if (self.totalOffsetY >= 0 && self.totalOffsetY <= kBigTitleHeight) {
//        scrollView.contentOffset = CGPointZero;
//        self.bigTitleViewTopOffsetToNavigationViewBottomCons.constant = -self.totalOffsetY;
//        [self.view layoutIfNeeded];
//    } else if (self.totalOffsetY < 0) {
//        self.totalOffsetY = 0;
//        if (self.bigTitleViewTopOffsetToNavigationViewBottomCons.constant != 0) {
//            self.bigTitleViewTopOffsetToNavigationViewBottomCons.constant = 0;
//            [self.view layoutIfNeeded];
//        }
//    } else if (self.totalOffsetY > kBigTitleHeight) {
//        self.totalOffsetY = kBigTitleHeight;
//        if (self.bigTitleViewTopOffsetToNavigationViewBottomCons.constant != -kBigTitleHeight) {
//            self.bigTitleViewTopOffsetToNavigationViewBottomCons.constant = -kBigTitleHeight;
//            [self.view layoutIfNeeded];
//        }
//    }
//    
//    // 显示隐藏 titleLabel
//    if (self.totalOffsetY >= 0 && self.totalOffsetY < kBigTitleMaxY) {
//        if (!self.navigationTitleLabel.hidden) {
//            self.navigationTitleLabel.hidden = YES;
//        }
//    } else if (self.totalOffsetY >= kBigTitleMaxY && self.totalOffsetY <= kBigTitleHeight) {
//        if (self.navigationTitleLabel.hidden) {
//            self.navigationTitleLabel.hidden = NO;
//        }
//    }
//}

@end
