//
//  JSHandler.h
//  NDL_Category
//
//  Created by dzcx on 2018/6/28.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

// https://www.cnblogs.com/someonelikeyou/p/6890587.html
@interface JSHandler : NSObject

- (instancetype)initWithViewController:(UIViewController *)vc configuration:(WKWebViewConfiguration *)configuration;

//- (void)addScriptMessageName:(NSString *)messageName handler:(CommonNoParamNoReturnValueBlock)handlerBlock;

- (void)removeAllScriptMessageHandlers;

@end
