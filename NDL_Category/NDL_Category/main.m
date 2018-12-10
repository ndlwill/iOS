//
//  main.m
//  NDL_Category
//
//  Created by ndl on 2017/9/14.
//  Copyright © 2017年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <FBAllocationTracker/FBAllocationTrackerManager.h>

int main(int argc, char * argv[]) {
    @autoreleasepool {
        // profiler-分析器
        FBAllocationTrackerManager *allocationTrackerManager = [FBAllocationTrackerManager sharedManager];
        [allocationTrackerManager startTrackingAllocations];
        [allocationTrackerManager enableGenerations];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
