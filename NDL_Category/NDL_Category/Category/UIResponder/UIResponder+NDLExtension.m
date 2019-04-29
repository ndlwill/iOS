//
//  UIResponder+NDLExtension.m
//  NDL_Category
//
//  Created by dzcx on 2019/3/28.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "UIResponder+NDLExtension.h"

@implementation UIResponder (NDLExtension)

- (void)ndl_userInterationWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    UIResponder *nextResponder = self.nextResponder;
    if (nextResponder) {
        NSLog(@"nextResponder = %@", nextResponder.description);
        
        if ([nextResponder respondsToSelector:@selector(ndl_userInterationWithEventName:userInfo:)]) {
            [nextResponder ndl_userInterationWithEventName:eventName userInfo:userInfo];
        }
    }
}

@end
