//
//  BaseRequestApi.h
//  NDL_Category
//
//  Created by dzcx on 2018/6/22.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface BaseRequestApi : YTKRequest

- (instancetype)initWithParamsDic:(NSDictionary *)bodyDic;

@end
