//
//  CityChoiceTableHeaderView.h
//  DaZhongChuXing
//
//  Created by dzcx on 2018/7/26.
//  Copyright © 2018年 tony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityChoiceTableHeaderView : UIView

@property (nonatomic, strong, readonly) UIButton *locatedCityButton;

@property (nonatomic, copy) NSString *locatedCityStr;
@property (nonatomic, copy) void (^onLocatedCityClicked)(NSString *cityStr);

@end
