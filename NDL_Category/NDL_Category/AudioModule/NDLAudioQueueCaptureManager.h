//
//  NDLAudioQueueCaptureManager.h
//  NDL_Category
//
//  Created by youdone-ndl on 2020/8/5.
//  Copyright © 2020 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 音频采集的类
@interface NDLAudioQueueCaptureManager : NSObject

@property (nonatomic, assign, readonly) BOOL isRunning;
@property (nonatomic, assign) BOOL isRecordVoice;

- (instancetype)getInstance;

/**
 * Start / Stop Audio Queue
 */
- (void)startAudioCapture;
- (void)stopAudioCapture;


/**
 * Start / Pause / Stop record file
 */
- (void)startRecordFile;
- (void)pauseAudioCapture;
- (void)stopRecordFile;


/**
 * free related resources
 */
- (void)freeAudioCapture;

@end

NS_ASSUME_NONNULL_END
