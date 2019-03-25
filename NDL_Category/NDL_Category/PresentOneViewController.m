//
//  PresentOneViewController.m
//  NDL_Category
//
//  Created by dzcx on 2019/3/25.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "PresentOneViewController.h"
#import "PresentTwoViewController.h"

@interface PresentOneViewController ()

@end

@implementation PresentOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
}

- (void)dealloc
{
    NSLog(@"PresentOneViewController dealloc");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"PresentOneViewController touch");
    [self presentViewController:[PresentTwoViewController new] animated:YES completion:nil];
}



@end
