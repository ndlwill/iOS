//
//  CityChoiceController.h
//  DaZhongChuXing
//
//  Created by dzcx on 2018/7/26.
//  Copyright © 2018年 tony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityChoiceController : UIViewController

@property (nonatomic, copy) void (^chooseCityBlock)(NSString *cityName);

@end
