//
//  SearchResultViewController.m
//  NDL_Category
//
//  Created by dzcx on 2018/9/19.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "SearchResultViewController.h"

@interface SearchResultViewController ()

@property (nonatomic, copy) NSString *searchKeyword;

@end

@implementation SearchResultViewController
// 执行顺序
// 1.
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"###SearchResultViewController viewDidLoad###");
    self.view.backgroundColor = [UIColor redColor];
}

#pragma mark - UISearchResultsUpdating
// 2.
// searchController.searchBar.text改变一下就走一次
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"===updateSearchResultsForSearchController===");
    NSString *newKeyword = [searchController.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([self.searchKeyword isEqualToString:newKeyword]) {
        return;
    }
    self.searchKeyword = newKeyword;
    if (self.searchKeyword.length > 0) {
        // TODO SearchRequest // tableView reloadData
    }
}


@end
