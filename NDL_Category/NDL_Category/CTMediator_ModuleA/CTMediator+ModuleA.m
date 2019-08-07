//
//  CTMediator+ModuleA.m
//  NDL_Category
//
//  Created by dzcx on 2019/8/1.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "CTMediator+ModuleA.h"

static NSString * const kTarget_A = @"A";
static NSString * const kAction_NativeTestViewController = @"nativeTestViewController";

@implementation CTMediator (ModuleA)

- (UIViewController *)moduleA_TestViewController
{
    UIViewController *vc = [self performTarget:kTarget_A action:kAction_NativeTestViewController params:@{@"colorFlag" : @(YES)} shouldCacheTarget:NO];
    if ([vc isKindOfClass:[UIViewController class]]) {
        return vc;
    } else {
        return [[UIViewController alloc] init];
    }
}

@end
