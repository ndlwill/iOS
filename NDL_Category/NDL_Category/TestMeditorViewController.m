//
//  TestMeditorViewController.m
//  NDL_Category
//
//  Created by dzcx on 2019/8/1.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "TestMeditorViewController.h"
#import "CoreTextView.h"

@interface TestMeditorViewController ()

@end

@implementation TestMeditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.colorFlag) {
        self.view.backgroundColor = [UIColor cyanColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    CoreTextView *ctView = [[CoreTextView alloc] initWithFrame:CGRectMake(10, 120, self.view.width - 20, 450)];
    ctView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:ctView];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        CGSize size = [ctView sizeThatFits:CGSizeZero];
//        ctView.size = size;
//    });
}


@end
