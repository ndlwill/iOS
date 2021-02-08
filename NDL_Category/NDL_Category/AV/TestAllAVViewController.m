//
//  TestAllAVViewController.m
//  NDL_Category
//
//  Created by youdone-ndl on 2020/12/16.
//  Copyright © 2020 ndl. All rights reserved.
//

#import "TestAllAVViewController.h"
#import <CoreMedia/CoreMedia.h>

#import <AVFoundation/AVFoundation.h>

// MARK: CMTime
/**
 typedef struct
 {
     CMTimeValue value;  //64位有符号整型变量，作为分子
     CMTimeScale timescale;   //32位有符号整型变量，作为分母
     // value/timescale = 对应时间-秒
     CMTimeFlags flags; //位掩码，表示时间的指定状态，比如判定诗句是否有效、不确定或是是否出现舍入等
     CMTimeEpoch epoch;
 } CMTime;
 
 在处理视频内容时常见的时间刻度为600，这是大部分常用视频帧率24FPS、25FPS、30FPS的公倍数。音频常见的时间刻度就是采样率，如44.1kHz(44100)、48kHz(48000)。
 
 typedef struct
 {
     CMTime          start;
     CMTime          duration;
 } CMTimeRange;
 */
@interface TestAllAVViewController ()

@end

@implementation TestAllAVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // ===创建CMTime===
    /*
    // CMTimeMake(), CMTime CMTimeMake( int64_t value,int32_t timescale)
    // 创建一个代表3秒的CMTime表达式(value/timescale)：
    CMTime ts1 = CMTimeMake(3, 1);
    CMTime ts2 = CMTimeMake(1800, 600);
    CMTime ts3 = CMTimeMake(132300, 44100);

    //打印时间结果
    CMTimeShow(ts1);
    CMTimeShow(ts2);
    CMTimeShow(ts3);

    //打印结果
    // {3/1 = 3.000}
    // {1800/600 = 3.000}
    // {132300/44100 = 3.000}
    
    // CMTimeMakeWithSeconds(), CMTime CMTimeMakeWithSeconds( Float64 seconds, int32_t preferredTimescale)
    CMTime t = CMTimeMakeWithSeconds(5, 1); // 5 seconds
    CMTimeShow(t);//{5/1 = 5.000}
    
    // CMTimeMakeFromDictionary
    NSDictionary *timeData = @{(id)kCMTimeValueKey : @2,
                               (id)kCMTimeScaleKey : @1,
                               (id)kCMTimeFlagsKey : @1,
                               (id)kCMTimeEpochKey : @0};
    CMTime t1 = CMTimeMakeFromDictionary((__bridge CFDictionaryRef)timeData);
    CMTimeShow(t1);//{2/1 = 2.000}
    */
    
    // ===CMTime运算===
    /*
    // 1、加减
    CMTime ts1 = CMTimeMake(3, 1);
    CMTime ts2 = CMTimeMake(5, 2);
        
    CMTime result;
    result = CMTimeAdd(ts1, ts2);
    CMTimeShow(result);//{11/2 = 5.500}
        
    result = CMTimeSubtract(ts1, ts2);
    CMTimeShow(result);//{1/2 = 0.500}
    
    // 2、比较 CMTimeCompare(), CMTIME_COMPARE_INLINE()
    CMTime t1 = CMTimeMake(300, 100); // 3 seconds
    CMTime t2 = CMTimeMakeWithSeconds(5, 1); // 5 seconds
    int32_t r  = CMTimeCompare(t1, t2);
    NSLog(@"compare: %d",r);
    //t1 < t2   => -1
    //t1 == t2  => 0
    //t1 > ts   => 1
    
    NSLog(@"t1 > t2 => %@",CMTIME_COMPARE_INLINE(t1, >, t2) ? @"YES":@"NO");
    // t1 > t2 => NO
    
    // 3、验证CMTIME_IS_VALID()
    NSLog(@"ti is valid :%@",CMTIME_IS_VALID(t1) ? @"YES":@"NO");// ti is valid :YES
    */
     
    // ===3、CMTime转换为秒===
    /*
    // Float64 CMTimeGetSeconds( CMTime time)
    CMTime t1 = CMTimeMake(3001, 100);
    NSLog(@"second : %f",CMTimeGetSeconds(t1));//second : 30.010000
     */
    
    // ===4、转换字典NSDictionary===
    CMTime structTime = CMTimeMake(1, 3);
    NSDictionary *timeDict = CFBridgingRelease(CMTimeCopyAsDictionary(structTime, NULL));
    NSLog(@"%@", timeDict);

    structTime = CMTimeMakeFromDictionary((__bridge CFDictionaryRef)(timeDict));
    CMTimeShow(structTime);
    /*
    {
       epoch = 0;
       flags = 1;
       timescale = 3;
       value = 1;
    }
    {1/3 = 0.333}

    */
    
    // ===CMTimeRange===
    // 时间范围的数据类型：CMTimeRange，由两个CMTime值组成，第一个定义时间范围的起点，第二个定义时间范围的持续时间。

    // ===创建===
    /*
    // CMTimeRangeMake()， CMTimeRange CMTimeRangeMake( CMTime start, CMTime duration) 根据开始时间点与持续时间确定时间范围。
    // 创建一个时间范围，从时间轴的5秒位置开始，持续时长5秒
    CMTime duration = CMTimeMake(5, 1);
    CMTimeRange range = CMTimeRangeMake(duration, duration);
    CMTimeRangeShow(range);//{{5/1 = 5.000}, {5/1 = 5.000}}
    
    // CMTimeRangeFromTimeToTime()
    // CMTimeRange CMTimeRangeFromTimeToTime( CMTime start, CMTime end ) 根据起始时间点和终止时间点，确定时间范围。
    CMTime beginTime = CMTimeMake(5, 1);
    CMTime endTime = CMTimeMake(12, 1);
    CMTimeRange rangeTime = CMTimeRangeFromTimeToTime(beginTime, endTime);
    CMTimeRangeShow(rangeTime);//{{5/1 = 5.000}, {7/1 = 7.000}}
     */
    
    // ===运算===
    CMTime duration = CMTimeMake(5, 1);
    CMTimeRange range = CMTimeRangeMake(duration, duration);
    CMTimeRangeShow(range);//{{5/1 = 5.000}, {5/1 = 5.000}}
        
    CMTime beginTime = CMTimeMake(7, 1);
    CMTime endTime = CMTimeMake(12, 1);
    CMTimeRange rangeTime = CMTimeRangeFromTimeToTime(beginTime, endTime);
    CMTimeRangeShow(rangeTime);//{{7/1 = 7.000}, {5/1 = 5.000}}
    
    // 取时间范围总和
    CMTimeRange intersetionRange = CMTimeRangeGetIntersection(range, rangeTime);
    CMTimeRangeShow(intersetionRange);//{{7/1 = 7.000}, {3/1 = 3.000}}
    // 取时间范围总和
    CMTimeRange unionRange = CMTimeRangeGetUnion(range, rangeTime);
    CMTimeRangeShow(unionRange);//{{5/1 = 5.000}, {7/1 = 7.000}}
    
    // ===转换成字典NSDictionary===
    CMTimeRange structTimeRange = CMTimeRangeMake(kCMTimeZero, kCMTimePositiveInfinity);

    NSDictionary *timeRangeDict = CFBridgingRelease(CMTimeRangeCopyAsDictionary(structTimeRange, NULL));
    NSLog(@"%@", timeRangeDict);

    structTimeRange = CMTimeRangeMakeFromDictionary((__bridge CFDictionaryRef)(timeRangeDict));
    CMTimeRangeShow(structTimeRange);

    /*
     {
        duration =     {
            epoch = 0;
            flags = 5;
            timescale = 0;
            value = 0;
        };
        start =     {
            epoch = 0;
            flags = 1;
            timescale = 1;
            value = 0;
        };
    }
    {{0/1 = 0.000}, {+INFINITY}}
    */

}

- (void)testAVAssetWriterXXX {
    
}

@end
