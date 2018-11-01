//
//  QCPresenter.m
//  QCMVP
//
//  Created by EricZhang on 2018/5/31.
//  Copyright © 2018年 BYX. All rights reserved.
//

#import "QCPresenter.h"
#import "QCDataSource.h"


@interface QCPresenter()

//model数据源
@property(nonatomic,strong) QCDataSource *dataSource;
//p和v相互持有，互有对象，所以通过weak打破循环引用
@property(nonatomic,weak)id<QCTestProtocal> attachView;

@end


@implementation QCPresenter

-(void)attatchView:(id<QCTestProtocal>)view{
    
    self.attachView = view;
    self.dataSource = [QCDataSource new];
    
}


-(void)exchangeData{
    
    //改变一下view的背景色
    [self.attachView changeBgColor];
    
    //传递数据，先从model得到数据
    [self.dataSource getDataSuccess:^(NSDictionary *dic) {
        
        
        NSArray * arr = [dic valueForKey:@"data"];
        //可以直接把数据传过去
        [self.attachView bindDataSurce:arr];

        
        //也可以把数据筛选再造一个数组传过去
        /*
        NSMutableArray *newArr = [NSMutableArray new];
        for (NSDictionary *dic in arr) {
            if ([[dic valueForKey:@"tag"] isEqual:@1]) {
                [newArr addObject:dic];
            }
        }
        [self.attachView bindDataSurce:newArr];
         */

        
    } AndFailure:^(NSDictionary *dic) {
        
        NSLog(@"%@",dic[@"error"]);
        
    }];
    
}


@end
