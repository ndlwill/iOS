//
//  SearchViewModel.h
//  NDL_Category
//
//  Created by dzcx on 2018/8/6.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchViewModel : NSObject

@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) RACCommand *executeSearch;

@end
