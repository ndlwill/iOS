//
//  BaseWebViewController.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/22.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "BaseWebViewController.h"

@interface BaseWebViewController () <WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) JSHandler *jsHandler;

@end

@implementation BaseWebViewController

#pragma mark - init
- (instancetype)initWithURL:(NSString *)urlStr
{
    NSLog(@"BaseWebViewController initWithURL");
    if (self = [super init]) {
        _urlStr = urlStr;
        _progressColor = [UIColor lightGrayColor];
    }
    return self;
}

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"BaseWebViewController viewDidLoad edgesForExtendedLayout = %ld translucent = %ld", self.edgesForExtendedLayout, [NSNumber numberWithBool:self.navigationController.navigationBar.translucent].integerValue);// 默认UIRectEdgeAll = 15 translucent = 0
    
    //[self _setupUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"BaseWebViewController viewDidAppear edgesForExtendedLayout = %ld translucent = %ld", self.edgesForExtendedLayout, [NSNumber numberWithBool:self.navigationController.navigationBar.translucent].integerValue);// 默认UIRectEdgeAll = 15 translucent = 0
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
    
    CGRect webViewFrame = self.view.bounds;
    if (self.navigationController && (self.navigationController.navigationBar.hidden == NO)) {// 嵌套了navVC
        webViewFrame = CGRectMake(0, 0, self.view.width, self.view.height - TopExtendedLayoutH);
    }
    self.webView = [[WKWebView alloc] initWithFrame:webViewFrame configuration:configuration];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.allowsBackForwardNavigationGestures = YES;// 打开网页间的滑动返回手势
    self.webView.scrollView.backgroundColor = [UIColor cyanColor];
    self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    [self.view addSubview:self.webView];
    
    [self loadRequest];
}

#pragma mark - Public Methods
- (void)loadRequest
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_urlStr]];
    NSString *headerStr = [[[HttpHeader alloc] init] modelToJSONString];
    NSLog(@"headerStr = %@", headerStr);
    NSString *headerAESStr = [headerStr ndl_aes128Encrypt];
    [request setValue:headerAESStr forHTTPHeaderField:@"header-encrypt-code"];
    [self.webView loadRequest:request];
}

#pragma mark - WKUIDelegate

#pragma mark - WKNavigationDelegate


@end
