//
//  TestMVVMController.m
//  NDL_Category
//
//  Created by dzcx on 2018/8/8.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "TestMVVMController.h"
#import "LoginViewModel.h"
#import "RequestViewModel.h"
#import "Book.h"

@interface TestMVVMController ()

@property (nonatomic, strong) UITextField *accountFiled;
@property (nonatomic, strong) UITextField *pwdField;
@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) LoginViewModel *loginVM;

@property (nonatomic, strong) RequestViewModel *requestVM;

@property (nonatomic, strong) RequestViewModel *requesViewModel;// for tableView

@end

// 请求豆瓣图书信息，url:https://api.douban.com/v2/book/search?q=基础
@implementation TestMVVMController

- (LoginViewModel *)loginVM
{
    if (_loginVM == nil) {
        _loginVM = [[LoginViewModel alloc] init];
    }
    return _loginVM;
}

- (RequestViewModel *)requestVM
{
    if (_requestVM == nil) {
        _requestVM = [[RequestViewModel alloc] init];
    }
    return _requestVM;
}

- (RequestViewModel *)requesViewModel
{
    if (_requesViewModel == nil) {
        _requesViewModel = [[RequestViewModel alloc] init];
    }
    return _requesViewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self bindViewModel];
    
    [self loginEvent];
    
    // 发送请求
    RACSignal *signal = [self.requestVM.requestCommand execute:nil];
    [signal subscribeNext:^(id x) {
        // 模型数组
        Book *book = x[0];
        NSLog(@"%@",x[0]);
    }];
    
    
    // 创建tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.dataSource = self.requesViewModel;
    self.requesViewModel.tableView = tableView;
    [self.view addSubview:tableView];
    // 执行请求
    [self.requesViewModel.reuqesCommand execute:nil];
}

// 绑定viewModel
- (void)bindViewModel
{
    // 1.给视图模型的账号和密码绑定信号
    RAC(self.loginVM, account) = _accountFiled.rac_textSignal;
    RAC(self.loginVM, pwd) = _pwdField.rac_textSignal;
}
// 登录事件
- (void)loginEvent
{
    // 1.处理文本框业务逻辑
    // 设置按钮能否点击
    RAC(_loginBtn,enabled) = self.loginVM.loginEnableSiganl;
    
    
    // 2.监听登录按钮点击
    [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        // 处理登录事件
        [self.loginVM.loginCommand execute:nil];
        
    }];
    
}

@end
