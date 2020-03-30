//
//  GLSL1ViewController.m
//  NDL_Category
//
//  Created by ndl on 2020/3/22.
//  Copyright © 2020 ndl. All rights reserved.
//


#import "GLSL1ViewController.h"
#import "OpenGLESView.h"
#import "IndexedArrayDrawView.h"

@interface GLSL1ViewController ()

@property(nonnull,strong)OpenGLESView *myView;

@end

@implementation GLSL1ViewController

- (void)loadView {
    
//    self.view = [[OpenGLESView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.view = [[IndexedArrayDrawView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.myView = (OpenGLESView *)self.view;
    // 索引数组绘图
    self.myView = (IndexedArrayDrawView *)self.view;
}



@end
