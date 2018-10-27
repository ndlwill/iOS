//
//  BigTitleNavigationView.h
//  NDL_Category
//
//  Created by dzcx on 2018/6/29.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CommonBlock)(void);

// 只针对 左右各一个button的
@interface BigTitleNavigationView : UIView

@property (nonatomic, strong, readonly) UIButton *leftButton;
@property (nonatomic, strong, readonly) UIButton *rightButton;
@property (nonatomic, strong, readonly) UITextField *textField;// 占位文字颜色在设置占位文字后设置
@property (nonatomic, copy) CommonBlock textFieldRightButtonBlock;

// navigationBar背景颜色 default:white
@property (nonatomic, strong) IBInspectable UIColor *navBarBackgroundColor;
// bigTitleStr
@property (nonatomic, copy) IBInspectable NSString *bigTitleStr;
// textField placeholder
@property (nonatomic, copy) IBInspectable NSString *placeHolderStr;
// lineView
@property (nonatomic, assign) IBInspectable BOOL lineViewShowFlag;

// leftButtonTitle
@property (nonatomic, copy) IBInspectable NSString *leftButtonTitle;
// leftButtonImage
@property (nonatomic, strong) IBInspectable UIImage *leftButtonImage;
@property (nonatomic, copy) CommonBlock leftButtonBlock;

// rightButtonTitle
@property (nonatomic, copy) IBInspectable NSString *rightButtonTitle;
// rightButtonImage
@property (nonatomic, strong) IBInspectable UIImage *rightButtonImage;
// rightButtonTitleColor
@property (nonatomic, strong) IBInspectable UIColor *rightButtonTitleColor;
@property (nonatomic, copy) CommonBlock rightButtonBlock;

@end
// 不能IBInspectable: UIFont
