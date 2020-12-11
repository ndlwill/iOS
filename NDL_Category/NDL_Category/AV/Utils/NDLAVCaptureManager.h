//
//  NDLAVCaptureManager.h
//  NDL_Category
//
//  Created by youdone-ndl on 2020/11/25.
//  Copyright © 2020 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

// 摄像头采集
@interface NDLAVCaptureManager : NSObject

/// 是否采集正在运行
@property (nonatomic, assign, readonly) BOOL isRunning;

/// 摄像头方向  默认后置摄像头
@property (nonatomic, assign, readonly) AVCaptureDevicePosition devicePosition;

@end

NS_ASSUME_NONNULL_END
