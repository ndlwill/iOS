//
//  BaseWebViewController.h
//  NDL_Category
//
//  Created by dzcx on 2018/6/22.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "BaseViewController.h"
#import "JSHandler.h"

// (case-insensitive)不区分大小写
@interface BaseWebViewController : BaseViewController

- (instancetype)initWithURL:(NSString *)urlStr;

- (void)loadRequest;

- (void)updateNavigationItems;

#pragma mark - readonly property
@property (nonatomic, strong, readonly) WKWebView *webView;


@property (nonatomic, copy) NSString *urlStr;
// default: lightGray
@property (nonatomic, strong) UIColor *progressColor;
// progressView 是否显示在NavBar上面 default: NO
@property (nonatomic, assign) BOOL progressShowInNavBarFlag;
// 网页多级跳转 是否显示关闭按钮
@property (nonatomic, assign) BOOL showCloseButtonFlag;

@end
