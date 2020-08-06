//
//  NDLAudioQueueCaptureManager.m
//  NDL_Category
//
//  Created by youdone-ndl on 2020/8/5.
//  Copyright © 2020 ndl. All rights reserved.
//

#import "NDLAudioQueueCaptureManager.h"
#import <AVFoundation/AVFoundation.h>

/**
 #if __has_feature(objc_arc)
 #define SingletonM \
 static id _instace = nil; \
 + (id)allocWithZone:(struct _NSZone *)zone \
 { \
 if (_instace == nil) { \
 static dispatch_once_t onceToken; \
 dispatch_once(&onceToken, ^{ \
 _instace = [super allocWithZone:zone]; \
 }); \
 } \
 return _instace; \
 } \
 \
 + (id)copyWithZone:(struct _NSZone *)zone \
 { \
 return _instace; \
 } \
 \
 + (id)mutableCopyWithZone:(struct _NSZone *)zone \
 { \
 return _instace; \
 }
 #else
 #endif
 */

// 以下两个参数描述在采集PCM数据时对于iOS平台而言必须填入的信息
#define NDLAudioPCMFramesPerPacket 1
#define NDLAudioPCMBitsPerChannel  16

static const int kNumberBuffers = 3;

struct NDLRecorderInfo {
    AudioStreamBasicDescription  mDataFormat;
    AudioQueueRef                mQueue;
    AudioQueueBufferRef          mBuffers[kNumberBuffers];
};
typedef struct NDLRecorderInfo *NDLRecorderInfoType;

static NDLRecorderInfoType m_audioInfo;
static NDLAudioQueueCaptureManager *_instance;

@interface NDLAudioQueueCaptureManager ()

// 当前Audio Queue是否正在工作
@property (nonatomic, assign, readwrite) BOOL isRunning;

@end

@implementation NDLAudioQueueCaptureManager

+ (void)initialize {
    m_audioInfo = malloc(sizeof(struct NDLRecorderInfo));
}

// 因为iPhone中输入端只能接收一个音频输入设备,所以如果使用Audio Queue采集,该采集对象在应用程序声明周期内应该是单一存在的,所以使用单例实现.
- (instancetype)getInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[NDLAudioQueueCaptureManager alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureAudioCaptureWithAudioInfo:m_audioInfo
                                        formatID:kAudioFormatMPEG4AAC// kAudioFormatLinearPCM
                                      sampleRate:44100 channelCount:1 durationSec:0.05 bufferSize:1024 isRunning:&self->_isRunning];
    }
    return self;
}

- (void)dealloc
{
    
}

#pragma mark - callback
/**
 指定了CaptureAudioDataCallback采集音频数据回调函数的名称.回调函数的定义必须遵从如下格式.因为系统会将采集到值赋值给此函数中的参数,函数名称可以自己指定.
 
 typedef void (*AudioQueueInputCallback)(void *inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer, const AudioTimeStamp *inStartTime, UInt32 inNumberPacketDescriptions, const AudioStreamPacketDescription *inPacketDescs);
 */
static void CaptureAudioDataCallback(void *                                 inUserData,
                                     AudioQueueRef                          inAQ,
                                     AudioQueueBufferRef                    inBuffer,
                                     const AudioTimeStamp *                 inStartTime,
                                     UInt32                                 inNumPackets,
                                     const AudioStreamPacketDescription*    inPacketDesc) {
    
//    XDXAudioQueueCaptureManager *instance = (__bridge XDXAudioQueueCaptureManager *)inUserData;
//
//    /*  Test audio fps
//    static Float64 lastTime = 0;
//    Float64 currentTime = CMTimeGetSeconds(CMClockMakeHostTimeFromSystemUnits(inStartTime->mHostTime))*1000;
//    NSLog(@"Test duration - %f",currentTime - lastTime);
//    lastTime = currentTime;
//    */
//
//    /*  Test size
//    if (inPacketDesc) {
//        NSLog(@"Test data: %d,%d,%d,%d",inBuffer->mAudioDataByteSize,inNumPackets,inPacketDesc->mDataByteSize,inPacketDesc->mVariableFramesInPacket);
//    }else {
//        NSLog(@"Test data: %d,%d",inBuffer->mAudioDataByteSize,inNumPackets);
//    }
//    */
//
//    if (instance.isRecordVoice) {
//        UInt32 bytesPerPacket = m_audioInfo->mDataFormat.mBytesPerPacket;
//        if (inNumPackets == 0 && bytesPerPacket != 0) {
//            inNumPackets = inBuffer->mAudioDataByteSize / bytesPerPacket;
//        }
//
//        [[XDXAudioFileHandler getInstance] writeFileWithInNumBytes:inBuffer->mAudioDataByteSize
//                                                      ioNumPackets:inNumPackets
//                                                          inBuffer:inBuffer->mAudioData
//                                                      inPacketDesc:inPacketDesc];
//    }
//
//    if (instance.isRunning) {
//        AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
//    }
}


#pragma mark - private
// 设置你需要的音频参数,如音频数据格式为PCM还是AAC,采样率大小,声道数,采样时间等
- (void)configureAudioCaptureWithAudioInfo:(NDLRecorderInfoType)audioInfo formatID:(UInt32)formatID sampleRate:(Float64)sampleRate channelCount:(UInt32)channelCount durationSec:(float)durationSec bufferSize:(UInt32)bufferSize isRunning:(BOOL *)isRunning {
    
    // Get Audio format ASBD
    audioInfo->mDataFormat = [self getAudioFormatWithFormatID:formatID
                                                   sampleRate:sampleRate
                                                 channelCount:channelCount];
    
    // Set sample time
    [[AVAudioSession sharedInstance] setPreferredIOBufferDuration:durationSec error:NULL];
    
    // New queue, Creates a new recording audio queue object.
    // 使用AudioQueueNewInput函数可以将创建出来的Audio Queue对象赋值给我们定义的全局变量
    /**
     inFormat: 音频流格式
     inCallbackProc: 设置回调函数
     inUserData: 开发者自己定义的任何数据,一般将本类的实例传入,因为回调函数中无法直接调用OC的属性与方法,此参数可以作为OC与回调函数沟通的桥梁.即传入本类对象.
     inCallbackRunLoop: 回调函数在哪个循环中被调用.设置为NULL为默认值,即回调函数所在的线程由audio queue内部控制.
     inCallbackRunLoopMode: 回调函数运行循环模式通常使用kCFRunLoopCommonModes.
     inFlags: 系统保留值,只能为0.
     outAQ:将创建好的audio queue赋值给填入对象.
     */
    OSStatus status = AudioQueueNewInput(&audioInfo->mDataFormat,
                                         CaptureAudioDataCallback,
                                         (__bridge void *)(self),
                                         NULL,
                                         kCFRunLoopCommonModes,
                                         0,
                                         &audioInfo->mQueue);
    
    if (status != noErr) {
        NSLog(@"Audio Recorder: audio queue new input failed status:%d \n", (int)status);
    }
    
    // Set audio format for audio queue
    UInt32 size = sizeof(audioInfo->mDataFormat);
    // 获取设置的音频流格式
    // 用以下方法验证获取到音频格式是否与我们设置的相符.
    status = AudioQueueGetProperty(audioInfo->mQueue,
                                   kAudioQueueProperty_StreamDescription,
                                   &audioInfo->mDataFormat,
                                   &size);
    if (status != noErr) {
        NSLog(@"Audio Recorder: get ASBD status:%d",(int)status);
    }
    
    // 计算Audio Queue中每个buffer的大小
    // Set capture data size
    UInt32 maxBufferByteSize;
    if (audioInfo->mDataFormat.mFormatID == kAudioFormatLinearPCM) {
        int frames = (int)ceil(durationSec * audioInfo->mDataFormat.mSampleRate);
        maxBufferByteSize = frames*audioInfo->mDataFormat.mBytesPerFrame*audioInfo->mDataFormat.mChannelsPerFrame;
    }else {
        // AAC durationSec MIN: 23.219708 ms
        maxBufferByteSize = durationSec * audioInfo->mDataFormat.mSampleRate;
        
        if (maxBufferByteSize < 1024) {
            maxBufferByteSize = 1024;
        }
    }
    
    if (bufferSize > maxBufferByteSize || bufferSize == 0) {
        bufferSize = maxBufferByteSize;
    }
    
    // Allocate and Enqueue
    for (int i = 0; i != kNumberBuffers; i++) {
        status = AudioQueueAllocateBuffer(audioInfo->mQueue,
                                          bufferSize,
                                          &audioInfo->mBuffers[i]);
        if (status != noErr) {
            NSLog(@"Audio Recorder: Allocate buffer status:%d",(int)status);
        }
        
        status = AudioQueueEnqueueBuffer(audioInfo->mQueue,
                                         audioInfo->mBuffers[i],
                                         0,
                                         NULL);
        if (status != noErr) {
            NSLog(@"Audio Recorder: Enqueue buffer status:%d",(int)status);
        }
    }
}

/**
 设置音频流数据格式:
 需要注意的是,音频数据格式与硬件直接相关,如果想获取最高性能,最好直接使用硬件本身的采样率,声道数等音频属性,所以,如采样率,当我们手动进行更改后,Audio Queue会在内部自行转换一次,虽然代码上没有感知,但一定程序上还是降低了性能.
 
 iOS中不支持直接设置双声道,如果想模拟双声道,可以自行填充音频数据
 
 理解AudioSessionGetProperty函数,该函数表明查询当前硬件指定属性的值,如下,kAudioSessionProperty_CurrentHardwareSampleRate为查询当前硬件采样率,kAudioSessionProperty_CurrentHardwareInputNumberChannels为查询当前采集的声道数.
 
 你必须了解未压缩格式(PCM...)与压缩格式(AAC...)
 
 使用iOS直接采集未压缩数据是可以直接拿到硬件采集到的数据,而如果直接设置如AAC这样的压缩数据格式,其原理是Audio Queue在内部帮我们做了一次转换,
 
 使用PCM数据格式必须设置采样值的flag:mFormatFlags,每个声道中采样的值换算成二进制的位宽mBitsPerChannel,iOS中每个声道使用16位的位宽,每个包中有多少帧mFramesPerPacket,对于PCM数据而言,因为其未压缩,所以每个包中仅有1帧数据.每个包中有多少字节数(即每一帧中有多少字节数),可以根据如下简单计算得出
 
 如果是其他压缩数据格式,大多数不需要单独设置以上参数,默认为0.这是因为对于压缩数据而言,每个音频采样包中压缩的帧数以及每个音频采样包压缩出来的字节数可能是不同的,所以我们无法预知进行设置,就像mFramesPerPacket参数,因为压缩出来每个包具体有多少帧只有压缩完成后才能得知.
 */
- (AudioStreamBasicDescription)getAudioFormatWithFormatID:(UInt32)formatID sampleRate:(Float64)sampleRate channelCount:(UInt32)channelCount {
    // ASBD
    AudioStreamBasicDescription dataFormat = {0};
    
    UInt32 size = sizeof(dataFormat.mSampleRate);
    // Get hardware origin sample rate. (Recommended it)
    Float64 hardwareSampleRate = 0;
    AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareSampleRate,
                            &size,
                            &hardwareSampleRate);
    // Manual set sample rate
    dataFormat.mSampleRate = sampleRate;
    
    size = sizeof(dataFormat.mChannelsPerFrame);
    // Get hardware origin channels number. (Must refer to it)
    UInt32 hardwareNumberChannels = 0;
    AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareInputNumberChannels,
                            &size,
                            &hardwareNumberChannels);
    dataFormat.mChannelsPerFrame = channelCount;
    
    // Set audio format
    dataFormat.mFormatID = formatID;
    
    // Set detail audio format params
    if (formatID == kAudioFormatLinearPCM) {
        dataFormat.mFormatFlags     = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
        dataFormat.mBitsPerChannel  = NDLAudioPCMBitsPerChannel;
        dataFormat.mBytesPerPacket  = dataFormat.mBytesPerFrame = (dataFormat.mBitsPerChannel / 8) * dataFormat.mChannelsPerFrame;
        dataFormat.mFramesPerPacket = NDLAudioPCMFramesPerPacket;
    } else if (formatID == kAudioFormatMPEG4AAC) {
        dataFormat.mFormatFlags = kMPEG4Object_AAC_Main;
    }

    NSLog(@"Audio Recorder: starup PCM audio encoder:%f,%d", sampleRate, channelCount);
    return dataFormat;
}

@end
