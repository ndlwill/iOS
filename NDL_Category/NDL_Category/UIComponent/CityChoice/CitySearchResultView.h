//
//  CitySearchResultView.h
//  DaZhongChuXing
//
//  Created by dzcx on 2018/7/27.
//  Copyright © 2018年 tony. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kCommonCellID = @"CommonCellID";
@interface CitySearchResultView : UIView

@property (nonatomic, copy) NSArray<NSString *> *dataSource;
@property (nonatomic, copy) void (^cellDidSelectedBlock)(NSString *cityName);

@end
