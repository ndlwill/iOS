//
//  MicrophoneAuthority.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/15.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "MicrophoneAuthority.h"
#import <AVFoundation/AVFoundation.h>

/*
 dispatch_semaphore_t sema = dispatch_semaphore_create(0);
 dispatch_semaphore_signal(sema);
 dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
 */
@implementation MicrophoneAuthority

+ (BOOL)authorized
{
    /*
     AVAudioSession *session = [[AVAudioSession alloc] init];
     NSError *error = nil;
     [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
     [session requestRecordPermission:^(BOOL granted) {
     
     }];
     */
    return ([self authorizationStatus] == AVAudioSessionRecordPermissionGranted);
}

/**
 0 ：AVAudioSessionRecordPermissionUndetermined
 1 ：AVAudioSessionRecordPermissionDenied
 2 ：AVAudioSessionRecordPermissionGranted
 */
+ (NSInteger)authorizationStatus
{
    // iOS 8.0
    return [[AVAudioSession sharedInstance] recordPermission];
}

@end
