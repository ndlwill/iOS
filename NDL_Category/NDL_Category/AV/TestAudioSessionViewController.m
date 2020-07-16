//
//  TestAudioSessionViewController.m
//  NDL_Category
//
//  Created by youdone-ndl on 2020/7/16.
//  Copyright © 2020 ndl. All rights reserved.
//

// MARK: Audio Session
/**
 Audio Session:系统与应用程序的中介
 Apple通过audio sessions管理app, app与其他app, app与外部音频硬件间的行为.
 使用audio session可以向系统传达你将如何使用音频.audio session充当着app与系统间的中介.这样我们无需了解硬件相关却可以操控硬件行为.
 
 配置audio session类别与模式去告诉系统在app中你想怎么使用音频
 激活audio session使配置的类别与模式可以工作
 添加通知,响应重要的audio session通知,例如音频中断与硬件线路改变
 配置音频采样率,声道数等信息
 
 ===配置Audio Session
 1.Audio Session管理Audio
 audio session是应用程序与系统间的中介,用于配置音频行为,APP启动时,会自动获得一个audio session的单例对象,配置并且激活它以让音频按照期望开始工作.
 2.Categories代表Audio作用
 audio session category代表音频的主要行为.通过设置类别, 可以指明app是否使用的当前的输入或输出音频设备,以及当别的app中正在播放音频进入我们app时他们的音频是强制停止还是与我们的音频一起播放等等.
 
 AVFoundation中定义了很多audio session categories, 你可以根据需要自定义音频行为,很多类别支持播放,录制,录制与播放同时进行,当系统了解了你定义的音频规则,它将提供给你合适的路径去访问硬件资源.系统也将确保别的app中的音频以适合你应用的方式运行.

 一些categories可以根据Mode进一步定制,该模式用于专门指定类别的行为,例如当使用视频录制模式时,系统可能会选择一个不同于默认内置麦克风的麦克风,系统还可以针对录制调整麦克风的信号强度.
 3.中断处理
 如果audio意外中断,系统会将aduio session置为停用状态,音频也会因此立即停止.当一个别的app的audio session被激活并且它的类别未设置与系统类别或你应用程序类别混合时,中断就会发生.你的应用程序在收到中断通知后应该保存当时的状态,以及更新用户界面等相关操作.通过注册AVAudioSessionInterruptionNotification可以观察中断的开始与结束点.
 4.音频线路改变
 当用户做出连接,断开音频输入,输出设备时,(如:插拔耳机)音频线路发生变化,通过注册AVAudioSessionRouteChangeNotification可以在音频线路发生变化时做出相应处理
 5.Audio Sessions控制设备配置
 App不能直接控制设备的硬件,但是audio session提供了一些接口去获取或设置一些高级的音频设置,如采样率,声道数等等.
 6.Audio Sessions保护用户隐私
 App如果想使用音频录制功能必须请求用户授权,否则无法使用.
 
 ===激活Audio Session
 在设置了audio session的category, options, mode后,我们可以激活它以启动音频.
 1.系统如何解决音频竞争
 随着app的启动,内置的一些服务(短信,音乐,浏览器,电话等)也将在后台运行.前面的这些内置服务都可能产生音频,如有电话打来,有短信提示等等..
 2.激活,停用Audio Session
 虽然AVFoundation中播放与录制可以自动激活你的audio session, 但你可以手动激活并且测试是否激活成功.
 系统会停用你的audio session当有电话打进来,闹钟响了,或是日历提醒等消息介入.当处理完这些介入的消息后,系统允许我们手动重新激活audio sesseion.
 let session = AVAudioSession.sharedInstance()
 do {
     // 1) Configure your audio session category, options, and mode
     // 2) Activate your audio session to enable your custom configuration
     try session.setActive(true)
 } catch let error as NSError {
     print("Unable to activate audio session:  \(error.localizedDescription)")
 }
 如果我们使用AVFoundation对象(AVPlayer, AVAudioRecorder等),系统负责在中断结束时重新激活audio session.然而,如果你注册了通知去重新激活audio session,你可以验证是否激活成功并且更新用户界面.
 
 确保在后台运行的VoIP应用程序的音频会话仅在应用程序处理呼叫时才处于激活状态。在后台，若未收到呼叫,VoIP应用程序的音频会话不应该是激活的。
 确保使用录制类别的应用程序的音频会话仅在录制时处于激活状态。在录制开始和停止之前，请确保您的会话处于未激活状态，以允许播放其他声音，例如系统声音。
 如果应用程序支持后台音频播放或录制，但在应用程序未主动使用音频（或准备使用音频）时，在进入后台时停用其音频会话。这样做允许系统释放音频资源，以便其他进程可以使用它们。

 3.检查别的Audio是否正在播放
 当你的app被激活前,当前设备可能正在播放别的声音,如果你的app是一个游戏的app,知道别的声音来源显得十分重要,因为许多游戏允许同时播放别的音乐以增强用户体验.
 在app进入前台前,我们可以通过applicationDidBecomeActive:代理方法在其中使用secondaryAudioShouldBeSilencedHint属性来确定音频是否正在播放.当别的app正在播放的audio session为不可混音配置时,该值为true. app可以使用此属性消除次要音频.
 
 func setupNotifications() {
     NotificationCenter.default.addObserver(self,
                                            selector: #selector(handleSecondaryAudio),
                                            name: .AVAudioSessionSilenceSecondaryAudioHint,
                                            object: AVAudioSession.sharedInstance())
 }
  
 func handleSecondaryAudio(notification: Notification) {
     // Determine hint type
     guard let userInfo = notification.userInfo,
         let typeValue = userInfo[AVAudioSessionSilenceSecondaryAudioHintTypeKey] as? UInt,
         let type = AVAudioSessionSilenceSecondaryAudioHintType(rawValue: typeValue) else {
             return
     }
  
     if type == .begin {
         // Other app audio started playing - mute secondary audio
     } else {
         // Other app audio stopped playing - restart secondary audio
     }
 }
 
 ===响应中断
 在app中断后可以通过代码做出响应.音频中断将会导致audio session停用,同时应用程序中音频立即终止.当一个来自其他app的竞争的audio session被激活且这个audio session类别不支持与你的app进行混音时,中断发生.注册通知后我们可以在得知音频中断后做出相应处理.
 
 App会因为中断被暂停,当用户接到电话时,闹钟,或其他系统事件被触发时,当中断结束后,App会继续运行,但是需要我们手动重新激活audio session.
 1.中断的生命周期
 2.中断处理方法
 通过注册监听中断的通知可以在中断来的时候进行处理.处理中断取决于你当前正在执行的操作:播放,录制,音频格式转换,读取音频数据包等等.一般而言,我们应尽量避免中断并且做到中断后尽快恢复.
 中断前
 保存状态与上下文
 更新用户界面
 中断后
 恢复状态与上下文
 更新用户界面
 重新激活audio session.
 
 Audio technology
 How interruptions work

 AVFoundation framework
 系统在中断时会自动暂停录制与播放,当中断结束后重新激活audio session,恢复录制与播放

 Audio Queue Services, I/O audio unit
 系统会发出中断通知,开发者可以保存播放与录制状态并且在中断结束后重新激活audio session

 System Sound Services
 使用系统声音服务在中断来临时保持静音,如果中断结束,声音自动播放.
 3.处理Siri
 当处理Siri时,与其他中断不同,我们在中断期间需要对Siri进行监听,如在中断期间,用户要求Siri去暂停开发者app中的音频播放,当app收到中断结束的通知时,不应该自动恢复播放.同时,用户界面需要跟Siri要求的保持一致.
 4.监听中断
 注册AVAudioSessionInterruptionNotification通知可以监听中断
 func registerForNotifications() {
     NotificationCenter.default.addObserver(self,
                                            selector: #selector(handleInterruption),
                                            name: .AVAudioSessionInterruption,
                                            object: AVAudioSession.sharedInstance())
 }
  
 func handleInterruption(_ notification: Notification) {
     // Handle interruption
 }

 func handleInterruption(_ notification: Notification) {
     guard let info = notification.userInfo,
         let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
         let type = AVAudioSessionInterruptionType(rawValue: typeValue) else {
             return
     }
     if type == .began {
         // Interruption began, take appropriate actions (save state, update user interface)
     }
     else if type == .ended {
         guard let optionsValue =
             userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else {
                 return
         }
         let options = AVAudioSessionInterruptionOptions(rawValue: optionsValue)
         if options.contains(.shouldResume) {
             // Interruption Ended - playback should resume
         }
     }
 }

 注意: 无法确保在开始中断后一定有一个结束中断,所以,如果没有结束中断,我们在app重新播放音频时需要总是检查aduio session是否被激活.
 5.响应媒体服务器重置操作
 
 */
#import "TestAudioSessionViewController.h"

@interface TestAudioSessionViewController ()

@end

@implementation TestAudioSessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


@end
