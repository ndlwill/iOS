//
//  TestModelController.m
//  NDL_Category
//
//  Created by dzcx on 2018/10/31.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "TestModelController.h"
#import "Book.h"

@interface TestModelController ()

@end

@implementation TestModelController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.model.title = @"cc";
    NSLog(@"TestModel:title = %@ subTitle = %@", self.model.title, self.model.subtitle);
    
    if (self.callback) {
        self.callback(self.model);
    }
}


@end
