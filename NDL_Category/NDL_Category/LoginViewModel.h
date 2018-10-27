//
//  LoginViewModel.h
//  NDL_Category
//
//  Created by dzcx on 2018/8/8.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginViewModel : NSObject

// 保存登录界面的账号和密码
/** 账号 */
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *pwd;

// 处理登录按钮是否允许点击
@property (nonatomic, strong, readonly) RACSignal *loginEnableSiganl;


/** 登录按钮命令 */
@property (nonatomic, strong, readonly) RACCommand *loginCommand;

@end
