//
//  TableViewDataSource.h
//  NDL_Category
//
//  Created by dzcx on 2019/2/12.
//  Copyright © 2019 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TableViewCellConfigurationBlock)(id cell, id item);

@interface TableViewDataSource : NSObject <UITableViewDataSource>

- (instancetype)initWithItems:(NSArray *)items
               cellIdentifier:(NSString *)cellIdentifier
           configureCellBlock:(TableViewCellConfigurationBlock)configureCellBlock;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
