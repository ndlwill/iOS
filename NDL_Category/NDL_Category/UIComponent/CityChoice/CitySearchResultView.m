//
//  CitySearchResultView.m
//  DaZhongChuXing
//
//  Created by dzcx on 2018/7/27.
//  Copyright © 2018年 tony. All rights reserved.
//

#import "CitySearchResultView.h"

@interface CitySearchResultView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CitySearchResultView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
   if (self = [super initWithFrame:frame]) {
      [self _setupUI];
   }
   return self;
}

#pragma mark - Private Methods
- (void)_setupUI
{
   self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
   self.tableView.separatorInset = UIEdgeInsetsMake(0, 24, 0, 24);
    self.tableView.separatorColor = UIColorFromHex(0xE5E5E5);
   self.tableView.showsVerticalScrollIndicator = NO;
   self.tableView.delegate = self;
   self.tableView.dataSource = self;
   
   self.tableView.estimatedRowHeight = 0;
   self.tableView.estimatedSectionHeaderHeight = 0;
   self.tableView.estimatedSectionFooterHeight = 0;
   self.tableView.rowHeight = 53.0;
   
   self.tableView.tableFooterView = [[UIView alloc] init];
   [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCommonCellID];
   [self addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//   [tableView deselectRowAtIndexPath:indexPath animated:NO];
   if (self.cellDidSelectedBlock) {
      self.cellDidSelectedBlock([self.dataSource objectAtIndex:indexPath.row]);
   }
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommonCellID forIndexPath:indexPath];
   cell.selectionStyle = UITableViewCellSelectionStyleNone;
   cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    cell.textLabel.textColor = UIColorFromHex(0x2C2C2C);
   cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
   return cell;
}

#pragma mark - Setter
- (void)setDataSource:(NSArray<NSString *> *)dataSource
{
   _dataSource = dataSource;
   [self.tableView reloadData];
}
@end
