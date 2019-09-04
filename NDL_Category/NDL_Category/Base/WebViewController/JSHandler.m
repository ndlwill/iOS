//
//  JSHandler.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/28.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "JSHandler.h"

@interface JSHandler () <WKScriptMessageHandler>

@property (nonatomic, weak) UIViewController *vc;
@property (nonatomic, strong) WKWebViewConfiguration *configuration;

@property (nonatomic, strong) NSMutableDictionary *handlersDic;

@end

@implementation JSHandler

#pragma mark - Lazy Load
- (NSMutableDictionary *)handlersDic
{
    if (!_handlersDic) {
        _handlersDic = [NSMutableDictionary dictionary];
    }
    return _handlersDic;
}

#pragma mark - init
- (instancetype)initWithViewController:(UIViewController *)vc configuration:(WKWebViewConfiguration *)configuration
{
    if (self = [super init]) {
        _vc = vc;
        _configuration = configuration;
        
        // eg:
        // 注册JS事件
        [configuration.userContentController addScriptMessageHandler:self name:@"backPage"];
        
//        [configuration.userContentController addScriptMessageHandler:self name:@"showImages"];
//        [configuration.userContentController addScriptMessageHandler:self name:@"showVideo"];
//        [configuration.userContentController addScriptMessageHandler:self name:@"issueMoment"];
//        [configuration.userContentController addScriptMessageHandler:self name:@"JSShare"];
    }
    return self;
}

- (void)removeAllScriptMessageHandlers
{
    [_configuration.userContentController removeScriptMessageHandlerForName:@"backPage"];
    
//    [_configuration.userContentController removeScriptMessageHandlerForName:@"showImages"];
//    [_configuration.userContentController removeScriptMessageHandlerForName:@"showVideo"];
//    [_configuration.userContentController removeScriptMessageHandlerForName:@"issueMoment"];
//    [_configuration.userContentController removeScriptMessageHandlerForName:@"JSShare"];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    // message的body只能是 NSNumber, NSString, NSDate, NSArray, NSDictionary, NSNull这几种类型
    NSLog(@"presentingViewController = %@ navigationController = %@", self.vc.presentingViewController, self.vc.navigationController);
    UINavigationController *navigationVC = self.vc.navigationController;
    // JS call Native JS调用OC
    // js会通过以下方法调用原生方法: window.webkit.messageHandlers.<#对象#>.postMessage(<#参数#>)
    // 返回
    if ([message.name isEqualToString:@"backPage"]) {
        if (navigationVC && navigationVC.viewControllers.firstObject != self.vc) {
            [navigationVC popViewControllerAnimated:YES];
        } else {
            [self.vc dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

@end
