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

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, strong) UIColor *progressColor;

@end
