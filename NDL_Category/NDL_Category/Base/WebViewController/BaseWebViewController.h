//
//  BaseWebViewController.h
//  NDL_Category
//
//  Created by dzcx on 2018/6/22.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "BaseViewController.h"
#import "JSHandler.h"
// 什么东西与文件内容相关呢？利用数据摘要算法 对文件求摘要信息，摘要信息与文件内容一一对应

//强制浏览器使用本地缓存（cache-control/expires）

/*
 webview有缓存 html页面没有更新 解决方案:
 //加载请求的时候忽略缓存
 self.request = [NSURLRequest requestWithURL:[NSURL URLWithString:htmlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
 
 引入CSS、JS文件时路径后面拼接时间戳或者版本号
 <link href="index.css?t=20180322">
 或者
 <link href="index.css?v=1.0.1">
 */

// webViewURL: http://xueit.cn

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
