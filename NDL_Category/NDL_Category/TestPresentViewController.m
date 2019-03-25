//
//  TestPresentViewController.m
//  NDL_Category
//
//  Created by dzcx on 2019/3/25.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "TestPresentViewController.h"
#import "PresentOneViewController.h"

@interface TestPresentViewController ()

@end

@implementation TestPresentViewController

- (void)dealloc
{
    NSLog(@"TestPresentViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"TestPresentViewController touch");
//    [self presentViewController:[PresentOneViewController new] animated:YES completion:nil];
            [self.navigationController presentViewController:[PresentOneViewController new] animated:YES completion:nil];
    
}


@end
