//
//  Target_A.m
//  NDL_Category
//
//  Created by dzcx on 2019/8/1.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "Target_A.h"
#import "TestMeditorViewController.h"

@implementation Target_A

- (UIViewController *)Action_nativeTestViewController:(NSDictionary *)params
{
    TestMeditorViewController *vc = [[TestMeditorViewController alloc] init];
    vc.colorFlag = [params[@"colorFlag"] boolValue];
    return vc;
}

@end
