//
//  GLSL1ViewController.m
//  NDL_Category
//
//  Created by ndl on 2020/3/22.
//  Copyright © 2020 ndl. All rights reserved.
//


#import "GLSL1ViewController.h"
#import "OpenGLESView.h"

@interface GLSL1ViewController ()

@property(nonnull,strong)OpenGLESView *myView;

@end

@implementation GLSL1ViewController

- (void)loadView {
    
    self.view = [[OpenGLESView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myView = (OpenGLESView *)self.view;
}



@end
