//
//  BaseWebViewController.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/22.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "BaseWebViewController.h"
#import "UIApplication+NDLExtension.h"

@interface BaseWebViewController () <WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) JSHandler *jsHandler;

@property (nonatomic, strong) UIProgressView *progressView;//progress-(0-1) default = 0

@end

@implementation BaseWebViewController

#pragma mark - init
- (instancetype)initWithURL:(NSString *)urlStr
{
    NSLog(@"BaseWebViewController initWithURL");
    if (self = [super init]) {
        _urlStr = urlStr;
        _progressColor = [UIColor lightGrayColor];
        _progressShowInNavBarFlag = NO;
    }
    return self;
}

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"BaseWebViewController viewDidLoad edgesForExtendedLayout = %ld translucent = %ld", self.edgesForExtendedLayout, [NSNumber numberWithBool:self.navigationController.navigationBar.translucent].integerValue);// 默认UIRectEdgeAll = 15 translucent = 0
    
    [self _setupUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"BaseWebViewController viewDidAppear edgesForExtendedLayout = %ld translucent = %ld", self.edgesForExtendedLayout, [NSNumber numberWithBool:self.navigationController.navigationBar.translucent].integerValue);// 默认UIRectEdgeAll = 15 translucent = 0
}

- (void)dealloc
{
    [self.jsHandler removeAllScriptMessageHandlers];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - Private Methods
- (void)_setupUI
{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.preferences.javaScriptEnabled = YES;// 允许js交互
    self.jsHandler = [[JSHandler alloc] initWithViewController:self configuration:configuration];
    

    // for test
    // UIRectEdgeAll + translucent = NO
    // 有导航栏 navBottom为0
//    [self.navigationController setNavigationBarHidden:YES];// 屏幕顶部为0
    
    
    //    self.navigationController.navigationBar.translucent = YES;
    // UIRectEdgeAll + translucent = YES
    // 有导航栏 屏幕顶部为0
    //    [self.navigationController setNavigationBarHidden:YES];// 屏幕顶部为0
    
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    // UIRectEdgeNone + translucent = NO
    // 有导航栏 navBottom为0
    //    [self.navigationController setNavigationBarHidden:YES];// 屏幕顶部为0
    
    //    self.navigationController.navigationBar.translucent = YES;
    // UIRectEdgeNone + translucent = YES
    // 有导航栏 navBottom为0
    //    [self.navigationController setNavigationBarHidden:YES];// 屏幕顶部为0
    /*
    UIView *testView = [[UIView alloc] init];
    testView.backgroundColor = [UIColor redColor];
    testView.frame = CGRectMake(0, 10, NDLScreenW, 100);
    [self.view addSubview:testView];
     */
    
    // webViewFrame && progressViewFrame
    CGRect webViewFrame = self.view.bounds;
    CGRect progressViewFrame = CGRectMake(0, 0, self.view.width, 2.0);
    if (self.navigationController && (self.navigationController.navigationBar.hidden == NO)) {// 嵌套了navVC
        if (self.navigationController.navigationBar.translucent) {
            webViewFrame = CGRectMake(0, TopExtendedLayoutH, self.view.width, self.view.height - TopExtendedLayoutH);
            progressViewFrame = CGRectMake(0, TopExtendedLayoutH, self.view.width, 2.0);
        } else {
            webViewFrame = CGRectMake(0, 0, self.view.width, self.view.height - TopExtendedLayoutH);
        }
        
        if (_progressShowInNavBarFlag) {
            progressViewFrame = CGRectMake(0, NavigationBarH - 2.0, self.view.width, 2.0);
        }
    }
    
    // webView
    self.webView = [[WKWebView alloc] initWithFrame:webViewFrame configuration:configuration];
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
        if (iPhoneX) {
            self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, AdditionaliPhoneXBottomSafeH, 0);
            self.webView.scrollView.scrollIndicatorInsets = self.webView.scrollView.contentInset;
        }
    }
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.allowsBackForwardNavigationGestures = YES;// 打开网页间的滑动返回手势
    self.webView.scrollView.backgroundColor = [UIColor cyanColor];
    self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:self.webView];
    
    
    // webView进度条
    self.progressView = [[UIProgressView alloc] initWithFrame:progressViewFrame];
    self.progressView.progressTintColor = _progressColor;
    self.progressView.trackTintColor = [UIColor clearColor];
    if (_progressShowInNavBarFlag) {
        [self.navigationController.navigationBar addSubview:self.progressView];
    } else {
        [self.view addSubview:self.progressView];
    }
    
    // 请求url
    [self loadRequest];
}

#pragma mark - Overrides
- (void)backButtonDidClicked
{
    [self.webView stopLoading];
    if (self.webView.canGoBack) {
        WKNavigation *navigation = [self.webView goBack];
        NSLog(@"navigation = %@", navigation);
    } else {
        [super backButtonDidClicked];
    }
}

#pragma mark - Public Methods
- (void)loadRequest
{
    self.progressView.alpha = 1.0;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_urlStr]];
    // app store
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/da-zhong-chu-xing/id1071516426?mt=8"]];
    NSString *headerStr = [[[HttpHeader alloc] init] modelToJSONString];
    NSLog(@"headerStr = %@", headerStr);
    NSString *headerAESStr = [headerStr ndl_aes128Encrypt];
    // 添加请求头，服务端可以在这里取一些数据
    [request setValue:headerAESStr forHTTPHeaderField:@"header-encrypt-code"];
    [self.webView loadRequest:request];
    
    // 加载本地
    // 1.html文件
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"JSToOC" ofType:@"html"];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
    // 2.html string
//    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"JSToOC" ofType:@"html"];
//    NSString *htmlStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    [self.webView loadHTMLString:htmlStr baseURL:baseURL];
}

- (void)updateNavigationItems
{
    
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        double latestValue = [change[@"new"] doubleValue];

        BOOL animated = latestValue > self.progressView.progress;
        [self.progressView setProgress:latestValue animated:animated];

        if (latestValue == 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.progressView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - WKUIDelegate
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"runJavaScriptAlertPanel message = %@ WKFrameInfo = %@", message, frame);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message ? : @"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    NSLog(@"runJavaScriptConfirmPanel message = %@ WKFrameInfo = %@", message, frame);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message ? : @"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    NSLog(@"runJavaScriptTextInputPanel prompt = %@ WKFrameInfo = %@ defaultText = %@", prompt, frame, defaultText);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields.firstObject.text ? : @"");
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSLog(@"decidePolicyForNavigationAction url.scheme = %@ navigationAction.request.URL = %@", webView.URL.scheme, navigationAction.request.URL);
    [self updateNavigationItems];
    
    // WKNavigationActionPolicyCancel表示禁止webView打开app store通过系统浏览器打开
    NSURL *url = webView.URL;
    if ([url.scheme isEqualToString:@"tel"]) {
        if ([Application canOpenURL:url]) {
            [Application ndl_openURL:url];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    if ([url.absoluteString containsString:@"itunes.apple.com"]) {
        if ([Application canOpenURL:url]) {
            [Application ndl_openURL:url];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 加载https才会走这个方法
// WKWebView加载不受信任的https(服务器证书无效,实际就是不受信任)
/*
 1.
 在plist文件中设置:
 Allow Arbitrary Loads in Web Content置为YES,
 假如有设置NSAllowsArbitraryLoads为YES,可不用设置上面
 2.实现这个方法
 */
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    NSLog(@"authenticationMethod = %@ NSURLAuthenticationMethodServerTrust = %@", challenge.protectionSpace.authenticationMethod, NSURLAuthenticationMethodServerTrust);
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *cert = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, cert);
    }
}

// 加载完毕
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"didFinishNavigation");
    self.title = webView.title;
    
    [self updateNavigationItems];
}

@end
