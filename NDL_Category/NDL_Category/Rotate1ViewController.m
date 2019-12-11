//
//  Rotate1ViewController.m
//  NDL_Category
//
//  Created by ndl on 2019/11/17.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "Rotate1ViewController.h"

@interface Rotate1ViewController ()

@end

@implementation Rotate1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

@end
