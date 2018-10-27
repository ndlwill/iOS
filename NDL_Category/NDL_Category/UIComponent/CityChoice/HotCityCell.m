//
//  HotCityCell.m
//  DaZhongChuXing
//
//  Created by dzcx on 2018/7/27.
//  Copyright © 2018年 tony. All rights reserved.
//

#import "HotCityCell.h"
#import "HotCityItemCell.h"

static NSString * const kHotCityItemCellID = @"HotCityItemCellID";

@interface HotCityCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HotCityCell

#pragma mark - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
   if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
      self.selectionStyle = UITableViewCellSelectionStyleNone;
      [self _setupUI];
   }
   return self;
}

#pragma mark - Overrides
- (void)layoutSubviews
{
   [super layoutSubviews];
   
   self.collectionView.frame = CGRectMake(0, 0, self.width - kCollectionViewRight2Edge, self.height);
}

#pragma mark - Private Methods
- (void)_setupUI
{
   self.layout = [[UICollectionViewFlowLayout alloc] init];
   self.layout.itemSize = CGSizeMake(kItemWidth, kItemHeight);
   self.layout.sectionInset = UIEdgeInsetsMake(kFirstRowTop2Edge, kFirstColumnLeft2Edge, kLastRowBottom2Edge, 0);
   self.layout.minimumLineSpacing = kItemVerticalSpacing;
   // 不设置 尽可能的放itemCell(平分)
   CGFloat itemHorizontalSpacing = (self.width - kCollectionViewRight2Edge - kFirstColumnLeft2Edge - kItemWidth * kColumn) / 2.0;
   self.layout.minimumInteritemSpacing = (itemHorizontalSpacing - 1.0);
   
   self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
   self.collectionView.backgroundColor = [UIColor whiteColor];
   self.collectionView.showsVerticalScrollIndicator = NO;//默认垂直滚动
   self.collectionView.scrollEnabled = NO;
   self.collectionView.delegate = self;
   self.collectionView.dataSource = self;
   [self.collectionView registerClass:[HotCityItemCell class] forCellWithReuseIdentifier:kHotCityItemCellID];
   [self addSubview:self.collectionView];
}

#pragma mark - Setter
- (void)setDataSource:(NSArray<NSString *> *)dataSource
{
   _dataSource = dataSource;
   
   [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   NSString *cityName = [self.dataSource objectAtIndex:indexPath.item];
   if (self.itemDidClickedBlock) {
      self.itemDidClickedBlock(cityName);
   }
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   HotCityItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHotCityItemCellID forIndexPath:indexPath];
   cell.hotCityNameStr = self.dataSource[indexPath.item];
   return cell;
}

@end
