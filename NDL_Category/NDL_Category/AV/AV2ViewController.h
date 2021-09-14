//
//  AV2ViewController.h
//  NDL_Category
//
//  Created by youdone-ndl on 2020/12/14.
//  Copyright © 2020 ndl. All rights reserved.
//

// MARK: 音频会话 AVAudioSession
/**
 音频会话在应用程序和操作系统之间扮演着中间人的角色，提供一种简单实用的方法是OS得知应用程序应该如何与iOS音频环境进行交互。
 每个iOS应用程序都有自己的一个音频会话，这个会话可以被AVAudioSession的类方法sharedInstance访问。
 音频会话是一个单例对象，可以使用它来设置应用程序的音频上下文环境，并向系统表达您的应用程序音频行为的意图。
 
 使用它可以实现：
 启用或停用应用程序中的音频工作
 设置音频会话类别和模式，
 配置音频设置，如采样率，I/O缓冲区持续时间和通道数
 处理音频输出更改
 相应重要的音频时间，如更改底层Media Services守护程序的可用性。
 
 音频会话分类/类别：
 Ambient 游戏、效率应用程序 AVAudioSessionCategoryAmbient / kAudioSessionCategory_AmbientSound 使用这个分类应用会随着静音键和屏幕关闭而静音，且不会终止其他应用播放的声音，可以和其他自带应用如iPod、Safari同时播放声音。该类别无法在后台播放声音

 Solo Ambient(默认) 游戏、效率应用程序 AVAudioSessionCategorySoloAmbient/kAudioSessionCategory_SoloAmbientSound 类似Ambient不同之处在于它会终止其它应用播放声音。该类别无法在后台播放声音

 Playback 音频和视频播放 AVAudioSessionCategoryPlayback / kAudioSessionCategory_MediaPlayback 用于以音频为主的应用，不会随着静音键和平不关闭而静音。可在后台播放声音。

 Record 录音机、视频捕捉 AVAudioSessionCategoryRecord / kAudioSessionCategory_RecordAudio 录音应用，除了来电铃声、闹钟、日历提醒之外的其他系统声音不会被播放。只提供单纯录音功能。

 Play and Record VoIP、语音聊天 AVAudioSessionCategoryPlayAndRecord / kAudioSessionCategory_PlayAndRecord 提供录音和播放功能，如果应用需要用到iPhone上的听筒，这个类别是你唯一的选择，在这个类别下，声音的默认出口为听筒或者耳机。

 Audio Processing 离线会话和处理 AVAudioSessionCategoryAudioProcessing / kAudioSessionCategory_AudioProcessing 在不播放或录制音频时使用音频硬件编解码器或信号处理器的类别。例如在执行离线音频格式转换时，此类别禁用播放和禁用录音。应用处于后台时，音频处理通常不会继续，但是可以在应用移至后台时，请求更多时间来完成处理。

 Multi-Route 使用外部硬件的高级A/V应用程序 AVAudioSessionCategoryMultiRoute 通过可以用的音频辅助设备和内置音频硬件设备，我们可以自定义使用类型
 
 并不是一个应用只能使用一个category，可以根据实际需求来切换设置不同的category。
 通过音频会话单例对象的setCategory: error:设置iOS应用音频会话类别和模式。
 
 配置音频会话:
 音频会话在应用程序的生命周期中是可以修改的，一般在应用程序启动时，对其进行配置。
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     
     AVAudioSession *audioSession = [AVAudioSession sharedInstance];
     NSError *error;
     
     if (![audioSession setCategory:AVAudioSessionCategoryPlayback error:&error]) {
         NSLog(@"Category error :%@",[error localizedDescription]);
     }
     if (![audioSession setActive:YES error:&error]) {
         NSLog(@"Activation Error :%@",[error localizedDescription]);
     }
     
     return YES;
 }
 
 未压缩的线性PCM音频
 
 进行音频计量：播放发生时从播放器读取播放力度的平均值和峰值。
 将这些数据提供给VU计量器或其他可视化元件。向用户提供可视化的反馈效果。
 
 音频会话通知:
 添加通知监听，监听是否发生中断事件。通知名称为AVAudioSessionInterruptionNotification。
 推送的消息会包含许多重要信息的userInfo字典，通过关键字AVAudioSessionInterruptionTypeKey获取中断类型AVAudioSessionInterruptionType，根据中断状态执行不同操作

 - (void)handleInterruption:(NSNotification *)notification {
     NSDictionary *infoDict = notification.userInfo;
     AVAudioSessionInterruptionType type = [infoDict[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
     
     if (type == AVAudioSessionInterruptionTypeBegan) {
         [self stop];//开始中断，停止播放

     } else {

         AVAudioSessionInterruptionOptions options = [infoDict[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
         if (options == AVAudioSessionInterruptionOptionShouldResume) {
             [self play];
         }
     }
 }
 
 对线路改变的响应:
 在iOS设备上添加或移除音频输入、输出线路时，会发生线路改变，有多重原因会导致线路的变化，比如插入耳机或断开USB麦克风。当这些时间发生时，音频会根据情况改变输入或输出线路，同时AVAudioSession会广播一个描述该变化的通知给所有相关的监听者。

 添加监听的通知名称：AVAudioSessionRouteChangeNotification。该通知同样包含一个userInfo字典，带有相应通知发送的原因一前一个线路的描述，以此可以确定线路变化的情况。

 判断线路变更发生的原因，取keyAVAudioSessionRouteChangeReasonKey对应的AVAudioSessionRouteChangeReason类型值。根据变更原因，作相应处理。
 
 typedef NS_ENUM(NSUInteger, AVAudioSessionRouteChangeReason)
 {
     AVAudioSessionRouteChangeReasonUnknown = 0,
     原因不明；
     AVAudioSessionRouteChangeReasonNewDeviceAvailable = 1,
     有新设备可用，如耳机插入
     AVAudioSessionRouteChangeReasonOldDeviceUnavailable = 2,
     一个旧设备不可用，如耳机拔出
     AVAudioSessionRouteChangeReasonCategoryChange = 3,
     音频类别被改变，如Audio从Play back 变成Play And Record
     
     AVAudioSessionRouteChangeReasonOverride = 4,
     音频线路(route)改变，如类别是Play and Record，输出社诶已经从默认的接收器改变成为扬声器
     AVAudioSessionRouteChangeReasonWakeFromSleep = 6,
     设备从休眠中醒来
     
     AVAudioSessionRouteChangeReasonNoSuitableRouteForCategory = 7,
     没有路径返回当前的类别，如Record雷彪当前没有输入设备
     AVAudioSessionRouteChangeReasonRouteConfigurationChange NS_ENUM_AVAILABLE_IOS(7_0) = 8
     当前输入/输出口没变，但设置修改，如一个端口的数据选择已经改变。
 }

 知道有设备断开连接后，需要向userInfo字典提出请求，一会的其中用于描述前一个线路的AVAudioSessionRouteDescription，其对应的key为AVAudioSessionRouteChangePreviousRouteKey。线路的描述信息整合在一个输入NSArray和一个输出NSArray中。数组中的元素都是AVAudioSessionPortDescription的实例。
 
 输入口不同类型，input port type
 AVAudioSessionPortLineIn
 AVAudioSessionPortBuiltInMic ：内置麦克风
 AVAudioSessionPortHeadsetMic ：耳机线中的麦克风
 
 输出口不同类型，output port type
 AVAudioSessionPortLineOut
 AVAudioSessionPortHeadphones ：耳机或者耳机式输出设备
 AVAudioSessionPortBuiltInReceiver ：帖耳朵时候内置扬声器（打电话的时候的听筒）
 AVAudioSessionPortBuiltInSpeaker ：iOS设备的扬声器
 AVAudioSessionPortBluetoothA2DP ：A2DP协议式的蓝牙设备
 AVAudioSessionPortHDMI ：高保真多媒体接口设备
 AVAudioSessionPortAirPlay ：远程AirPlay设备
 AVAudioSessionPortBluetoothLE ：蓝牙低电量输出设备

 - (void)handleRouteChange:(NSNotification *)notification {
     NSDictionary *infoDict = notification.userInfo;
     AVAudioSessionRouteChangeReason reason = [infoDict[AVAudioSessionRouteChangeReasonKey] unsignedIntegerValue];
     if (reason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
 //        AVAudioSessionRouteDescription
 //        AVAudioSessionPortDescription
         AVAudioSessionRouteDescription *previousRoute = infoDict[AVAudioSessionRouteChangePreviousRouteKey];
         //取出所有线路描述
         NSLog(@"count :%zd",previousRoute.outputs.count);
         AVAudioSessionPortDescription *previousOutput = previousRoute.outputs[0];
         //取出前一次线路描述
         NSString *portType = previousOutput.portType;
         if ([portType isEqualToString:AVAudioSessionPortHeadphones]) {
             [self stop];
         }
         
     }
 }

 配置录音会话参数：
 AVFormatIDKey --写入内容的音频格式，常用的音频格式支持的值：
 kAudioFormatLinearPCM
 kAudioFormatMPEG4AAC
 kAudioFormatAppleLossless
 kAudioFormatAppleIMA4
 kAudioFormatiLBC
 kAudioFormatULaw

 kAudioFormatLinearPCM -会将未压缩的音频流写入文件中，
 这种格式的保真度最高，相应的文件也最大。
 AAC或Apple IMA4的压缩格式会显著缩小文件，还能保证高质量的音频内容。
 
 AVSampleRateKey --定义录音器采样率。采样率定义了对输入的模拟音频信号每一秒内的采样数。采样率决定音频的质量及最终文件大小。一般标准的采样率：8k、16k、22.5k、44.1k。
 
 AVNumbeOfChannelsKey -- 定义记录音频通道数。默认值1，单声道录制。设置2-立体声录制。除非使用外部硬件进行录制，一般应该创建单声道录音。
 
 使用Audio Metering：
 AVAudioPlayer和AVAudioRecorder中最强大和最实用的功能是对音频进行测量，Audio Metering可让开发者读取音频的平均分贝和峰值分贝数据，并使这些数据以可视化方式将声音大小呈献给用户。
 
 通过averagePowerForChannel:和peakPowerForChannel:获取平均分贝和峰值分贝，返回一个用于表示声音分贝(dB)等级的浮点值，这个值的范围是从表示最大分贝的0dB(full scale)到最小分贝或静音的-160dB。获取这两个值之前，要先设置属性meteringEnabled为YES，才能对音频进行测量。另，每当需要读取值时，需要先调用updateMeters方法才能获取最新的值。
 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AV2ViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
