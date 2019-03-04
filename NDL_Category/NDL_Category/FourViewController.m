//
//  FourViewController.m
//  NDL_Category
//
//  Created by ndl on 2017/12/13.
//  Copyright © 2017年 ndl. All rights reserved.
//

#import "FourViewController.h"
#import <WebKit/WebKit.h>

#import "CustomTextField.h"

// WKUIDelegate主要是做跟网页交互的，可以显示javascript的一些alert或者Action
@interface FourViewController () <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (strong, nonatomic) WKWebView *webView;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, weak) UITextField *tf;

@end

@implementation FourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor purpleColor];
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wechat"]];
//    self.title = @"Four";
    
//    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
//    self.webView.navigationDelegate = self;
//    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
//    [self.view addSubview:self.webView];
//
//    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 2)];
//    self.progressView.progressTintColor = [UIColor cyanColor];
//    self.progressView.trackTintColor = [UIColor greenColor];
//    [self.view addSubview:self.progressView];
    
//    WKUserContentController *userContentController =[[WKUserContentController alloc]init];
//    userContentController addScriptMessageHandler:<#(nonnull id<WKScriptMessageHandler>)#> name:<#(nonnull NSString *)#>
    
//    [self.webView evaluateJavaScript:<#(nonnull NSString *)#> completionHandler:<#^(id _Nullable, NSError * _Nullable error)completionHandler#>];
    
    
//    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(0, 100, 200, 44)];
//    tf.secureTextEntry = NO;
//    tf.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:tf];
//    self.tf = tf;
//    
//    tf.placeholder = @"123";
//    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
//    // 设置富文本对象的颜色
//    attributes[NSForegroundColorAttributeName] = [UIColor redColor];
//    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:30];
//
//    tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"345" attributes:attributes];
    
    
    
//    CustomTextField *tf = [[CustomTextField alloc] initWithFrame:CGRectMake(0, 100, 200, 44)];
//    tf.secureTextEntry = NO;
//    tf.backgroundColor = [UIColor lightGrayColor];
//    tf.placeholder = @"w ove u";
//    [tf setValue:[UIColor greenColor] forKeyPath:@"_placeholderLabel.textColor"];
//    [tf setValue:[UIColor greenColor] forKeyPath:@"_placeholderLabel.backgroundColor"];
//    [self.view addSubview:tf];
    
//    [tf setValue:[UIColor greenColor] forKeyPath:@"_placeholderLabel.backgroundColor"];
    //UILabel *placeLabel = [tf valueForKeyPath:@"_placeholderLabel"];
    //placeLabel.backgroundColor = [UIColor greenColor];
    
    
    NSLog(@"start draw");
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"%s", __FUNCTION__);
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
NSLog(@"%s", __FUNCTION__);
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
NSLog(@"======%s %f", __FUNCTION__, webView.scrollView.contentSize.height);
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
NSLog(@"%s", __FUNCTION__);
}


// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"%s", __FUNCTION__);
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@",navigationAction.request.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
    
    
}

//- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
//{
//
//}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        //NSLog(@"%f", self.webView.estimatedProgress);
        
        NSLog(@"old = %f new = %f", [change[@"old"] floatValue], [change[@"new"] floatValue]);
        // 0-1
        self.progressView.progress = [change[@"new"] floatValue];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch");
    self.tf.secureTextEntry = !self.tf.secureTextEntry;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    
}

- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

@end
