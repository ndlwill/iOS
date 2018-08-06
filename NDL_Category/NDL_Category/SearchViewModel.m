//
//  SearchViewModel.m
//  NDL_Category
//
//  Created by dzcx on 2018/8/6.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "SearchViewModel.h"

@implementation SearchViewModel

- (instancetype)init
{
    if (self = [super init]) {
        RACSignal *validSearchSignal = [[RACObserve(self, searchText) map:^id _Nullable(NSString *text) {
            return @(text.length > 3);
        }] distinctUntilChanged];
        
        // 在vc中将此命令连接到View
        self.executeSearch = [[RACCommand alloc] initWithEnabled:validSearchSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [self executeSearchSignal];
        }];
        
//        [self.executeSearch.executing not];// 反转信号的非操作
    }
    return self;
}

- (RACSignal *)executeSearchSignal
{
    return [[RACSignal empty] logAll];// logAll:调试ReactiveCocoa代码
}

@end
