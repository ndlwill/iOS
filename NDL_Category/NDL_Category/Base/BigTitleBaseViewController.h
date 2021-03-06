//
//  BigTitleBaseViewController.h
//  NDL_Category
//
//  Created by dzcx on 2019/3/22.
//  Copyright © 2019 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BigTitleBaseViewController : UIViewController

@property (nonatomic, copy) NSString *titleStr;

// ovverrides
- (void)setupMainViewWithBigTitleStr:(NSString *)bigTitleStr referToNavigationView:(UIView *)navigationView;

@end

NS_ASSUME_NONNULL_END
