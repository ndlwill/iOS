//
//  CalendarAuthority.h
//  NDL_Category
//
//  Created by dzcx on 2018/6/15.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>


@interface CalendarAuthority : NSObject

+ (BOOL)authorized;

+ (EKAuthorizationStatus)authorizationStatus;

@end
