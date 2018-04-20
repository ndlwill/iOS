//
//  LoadingView.h
//  NDL_Category
//
//  Created by dzcx on 2018/4/20.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LoadingStatus) {
    LoadingStatus_Success,
    LoadingStatus_Fail
};

@interface LoadingView : UIView

@property (nonatomic, assign) LoadingStatus loadingStatus;

- (void)startAnimation;

@end
