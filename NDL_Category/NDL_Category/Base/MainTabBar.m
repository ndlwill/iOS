//
//  MainTabBar.m
//  NDL_Category
//
//  Created by dzcx on 2018/7/9.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "MainTabBar.h"
#import "BaseViewController.h"

@interface MainTabBar ()

@property (nonatomic, weak) UIButton *publishButton;

@end

@implementation MainTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置tabbar的背景图片
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
        
        UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [publishButton addTarget:self action:@selector(publishClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:publishButton];
        
        self.publishButton = publishButton;
    }
    return self;
}


- (void)publishClicked
{
    BaseViewController *vc = [[BaseViewController alloc] init];
    
    // vc加载在window上面  tabBarVC暂时移开
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:NO completion:nil];
    //或者 用window显示PublishView（UIView）
    
    /*
     //不用presentVC   而是显示PublishView在当前window
     PublishView *view = [PublishView publicView];
     UIWindow *window = [UIApplication sharedApplication].keyWindow;
     view.frame = window.bounds;
     [window addSubview:view];
     */
    
    
    //[[UIApplication sharedApplication].keyWindow.rootViewController.view.userInteractionEnabled = NO;
    
    //独立创建一个窗口并显示
    //    window = [[UIWindow alloc] init];
    //    window.frame = CGRectMake(100, 100, 200, 200);
    //    window.backgroundColor = [UIColor redColor];
    //window.windowLevel  级别normal < StatusBar < Alert
    //    window.hidden = NO;
    
    //window = nil;//销毁窗口
    
    //状态栏也是个window StatusBar级别
}

//重新布局子控件
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置发布按钮的frame
    self.publishButton.bounds = CGRectMake(0, 0, self.publishButton.currentBackgroundImage.size.width, self.publishButton.currentBackgroundImage.size.height);
    self.publishButton.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);//这边才能得到self.frame.size   initWithFrame还拿不到frame
    
    // 设置其他UITabBarButton的frame
    CGFloat buttonY = 0;
    CGFloat buttonW = self.frame.size.width / 5;
    CGFloat buttonH = self.frame.size.height;
    NSInteger index = 0;
    for (UIControl *button in self.subviews) {
        if (![button isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue;
        
        // 计算按钮的x值
        CGFloat buttonX = buttonW * ((index > 1)?(index + 1):index);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        // 增加索引
        index++;
    }
}

@end

