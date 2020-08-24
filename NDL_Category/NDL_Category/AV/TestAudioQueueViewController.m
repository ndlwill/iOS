//
//  TestAudioQueueViewController.m
//  NDL_Category
//
//  Created by youdone-ndl on 2020/8/4.
//  Copyright © 2020 ndl. All rights reserved.
//

// MARK: Audio Queue 采集音频(支持不同格式)
/**
 https://developer.apple.com/library/archive/documentation/MusicAudio/Conceptual/AudioQueueProgrammingGuide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40005343
 
 Audio Queue Services是官方推荐的方式以一种直接的,低开销的方式在iOS与Mac OS X中完成录制与播放的操作
 
 使用Audio Queue实现音频数据采集,直接采集PCM无损数据或AAC及其他压缩格式数据.
 使用Audio Queue采集硬件输入端,如麦克风,其他外置具备麦克风功能设备(带麦的耳机,话筒等,前提是其本身要和苹果兼容).
 
 
 */

#import "TestAudioQueueViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface TestAudioQueueViewController ()

@end

@implementation TestAudioQueueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

@end
