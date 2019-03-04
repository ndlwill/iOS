//
//  TableViewDataSource.m
//  NDL_Category
//
//  Created by dzcx on 2019/2/12.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "TableViewDataSource.h"

@interface TableViewDataSource ()

@property (nonatomic, copy) NSArray *items;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) TableViewCellConfigurationBlock configureCellBlock;

@end

@implementation TableViewDataSource

#pragma mark - init
- (instancetype)initWithItems:(NSArray *)items cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(TableViewCellConfigurationBlock)configureCellBlock
{
    if (self = [super init]) {
        self.items = items;
        self.cellIdentifier = cellIdentifier;
        self.configureCellBlock = configureCellBlock;
    }
    return self;
}

#pragma mark - public methods
- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.items[indexPath.row];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    self.configureCellBlock(cell, item);
    return cell;
}

@end
