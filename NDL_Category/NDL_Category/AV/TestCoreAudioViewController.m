//
//  TestCoreAudioViewController.m
//  NDL_Category
//
//  Created by youdone-ndl on 2020/7/16.
//  Copyright © 2020 ndl. All rights reserved.
//

#import "TestCoreAudioViewController.h"
// frameworks: CoreAudio
#import <CoreAudio/CoreAudioTypes.h>
// frameworks: AudioToolbox
#import <AudioToolbox/AudioToolbox.h>

@interface TestCoreAudioViewController ()

@end

@implementation TestCoreAudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     #import <CoreAudio/CoreAudioTypes.h>
     AudioStreamBasicDescription
     AudioStreamPacketDescription
     
     #import <AudioToolbox/AudioToolbox.h>
     AudioQueue.h
     AudioQueueRef
     
     AudioFile.h
     AudioFileID
     */
    
}

// 将一个文件中magic cookie拷贝提供给audio queue
- (void)copyMagicCookieToQueue:(AudioQueueRef)queue fromFile:(AudioFileID)file {
    UInt32 propertySize = sizeof(UInt32);
     
    OSStatus result = AudioFileGetPropertyInfo (
                            file,
                            kAudioFilePropertyMagicCookieData,
                            &propertySize,
                            NULL
                        );
 
    if (!result && propertySize) {
 
        char *cookie = (char *) malloc (propertySize);
 
        AudioFileGetProperty (
            file,
            kAudioFilePropertyMagicCookieData,
            &propertySize,
            cookie
        );
 
        AudioQueueSetProperty (
            queue,
            kAudioQueueProperty_MagicCookie,
            cookie,
            propertySize
        );
 
        free (cookie);
    }
}


@end
