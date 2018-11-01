//
//  TestModelController.h
//  NDL_Category
//
//  Created by dzcx on 2018/10/31.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Book;
NS_ASSUME_NONNULL_BEGIN

typedef void(^BookBlock)(Book *book);

@interface TestModelController : UIViewController

@property (nonatomic, strong) Book *model;
@property (nonatomic, copy) BookBlock callback;

@end

NS_ASSUME_NONNULL_END
