//
//  HotCityCell.h
//  DaZhongChuXing
//
//  Created by dzcx on 2018/7/27.
//  Copyright © 2018年 tony. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const kFirstRowTop2Edge = 8.0;
static CGFloat const kLastRowBottom2Edge = 20.0;
static CGFloat const kFirstColumnLeft2Edge = 24.0;

static CGFloat const kItemWidth = 84.0;
static CGFloat const kItemHeight = 28.0;
static CGFloat const kItemVerticalSpacing = 16.0;

static CGFloat const kCollectionViewRight2Edge = 52.0;

static NSUInteger const kColumn = 3.0;

// tableViewCell
@interface HotCityCell : UITableViewCell

@property (nonatomic, copy) NSArray<NSString *> *dataSource;
@property (nonatomic, copy) void (^itemDidClickedBlock)(NSString *cityName);

@end
