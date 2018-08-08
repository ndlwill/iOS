//
//  RequestViewModel.m
//  NDL_Category
//
//  Created by dzcx on 2018/8/8.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "RequestViewModel.h"
#import <AFNetworking.h>
#import "Book.h"

@implementation RequestViewModel

- (instancetype)init
{
    if (self = [super init]) {
        
        [self setUp];
        
        [self initialBind];// for tableView
    }
    return self;
    
}


- (void)setUp
{
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        // 执行命令
        // 发送请求
        
        // 创建信号
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            
            // 创建请求管理者
//            AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
//
//            [mgr GET:@"https://api.douban.com/v2/book/search" parameters:@{@"q":@"美女"} success:^(AFHTTPRequestOperation * _Nonnull operation, NSDictionary * _Nonnull responseObject) {
//                // 请求成功的时候调用
//                NSLog(@"请求成功");
//
//                NSArray *dictArr = responseObject[@"books"];
//
//                NSArray *modelArr = [[dictArr.rac_sequence map:^id(id value) {
//
//                    return [Book bookWithDict:value];
//                }] array];
//
//
//                [subscriber sendNext:modelArr];
//
//
//            } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//
//            }];
            
            
            return nil;
        }];
        
        
        return signal;
    }];
}

- (void)initialBind
{
    _reuqesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"q"] = @"基础";
            
//            // 发送请求
//            [[AFHTTPRequestOperationManager manager] GET:@"https://api.douban.com/v2/book/search" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//                NSLog(@"%@",responseObject);
//                
//                // 请求成功调用
//                // 把数据用信号传递出去
//                [subscriber sendNext:responseObject];
//                
//                [subscriber sendCompleted];
//                
//                
//            } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//                // 请求失败调用
//                
//            }];
            
            return nil;
        }];
        
        
        
        
        // 在返回数据信号时，把数据中的字典映射成模型信号，传递出去
        return [requestSignal map:^id(NSDictionary *value) {
            NSMutableArray *dictArr = value[@"books"];
            
            // 字典转模型，遍历字典中的所有元素，全部映射成模型，并且生成数组
            NSArray *modelArr = [[dictArr.rac_sequence map:^id(id value) {
                
                return [Book bookWithDict:value];
            }] array];
            
            return modelArr;
        }];
        
    }];
    
    // 获取请求的数据
    [_reuqesCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *x) {
        
        // 有了新数据，刷新表格
        _models = x;
        
        // 刷新表格
        [self.tableView reloadData];
        
    }];
}

#pragma mark - dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    Book *book = self.models[indexPath.row];
    cell.detailTextLabel.text = book.subtitle;
    cell.textLabel.text = book.title;
    
    return cell;
}

@end
