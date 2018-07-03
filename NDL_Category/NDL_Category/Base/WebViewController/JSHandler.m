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

@end

@implementation JSHandler

- (instancetype)initWithViewController:(UIViewController *)vc configuration:(WKWebViewConfiguration *)configuration
{
    if (self = [super init]) {
        _vc = vc;
        _configuration = configuration;
        
        // 注册JS事件
        [configuration.userContentController addScriptMessageHandler:self name:@"backPage"];
        
//        [configuration.userContentController addScriptMessageHandler:self name:@"showImages"];
//        [configuration.userContentController addScriptMessageHandler:self name:@"showVideo"];
//        [configuration.userContentController addScriptMessageHandler:self name:@"issueMoment"];
//        [configuration.userContentController addScriptMessageHandler:self name:@"JSShare"];
    }
    return self;
}

- (void)removeAllMessageHandlers
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
    // JS call Native
    // 返回
    if ([message.name isEqualToString:@"backPage"]) {
        if (self.vc.presentingViewController) {
            [self.vc dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.vc.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
