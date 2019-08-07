//
//  CTMediator+ModuleA.h
//  NDL_Category
//
//  Created by dzcx on 2019/8/1.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "CTMediator.h"

NS_ASSUME_NONNULL_BEGIN

// 操作这个模块A里面的vc
@interface CTMediator (ModuleA)

- (UIViewController *)moduleA_TestViewController;

@end

NS_ASSUME_NONNULL_END
