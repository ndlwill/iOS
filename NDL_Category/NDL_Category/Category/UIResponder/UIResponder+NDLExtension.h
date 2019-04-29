//
//  UIResponder+NDLExtension.h
//  NDL_Category
//
//  Created by dzcx on 2019/3/28.
//  Copyright © 2019 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (NDLExtension)

- (void)ndl_userInterationWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo;

@end

NS_ASSUME_NONNULL_END
