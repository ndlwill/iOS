//
//  TestAudioSessionViewController.m
//  NDL_Category
//
//  Created by youdone-ndl on 2020/7/16.
//  Copyright © 2020 ndl. All rights reserved.
//

// MARK: Audio Session
/**
 https://developer.apple.com/library/archive/documentation/Audio/Conceptual/AudioSessionProgrammingGuide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40007875-CH1-SW1
 AVAudioSession:
 音频输出作为硬件资源，对于iOS系统来说是唯一的，那么要如何协调和各个App之间对这个稀缺的硬件持有关系呢？
 iOS给出的解决方案是"AVAudioSession"
 通过它可以实现对App当前上下文音频资源的控制，比如插拔耳机、接电话、是否和其他音频数据混音等
 是进行录音还是播放？
 当系统静音键按下时该如何表现？
 是从扬声器还是从听筒里面播放声音？
 插拔耳机后如何表现？
 来电话/闹钟响了后如何表现？
 其他音频App启动后如何表现？
 
 Session默认行为:
 可以进行播放，但是不能进行录制。
 当用户将手机上的静音拨片拨到“静音”状态时，此时如果正在播放音频，那么播放内容会被静音。
 当用户按了手机的锁屏键或者手机自动锁屏了，此时如果正在播放音频，那么播放会静音并被暂停。
 如果你的App在开始播放的时候，此时QQ音乐等其他App正在播放，那么其他播放器会被静音并暂停。

 默认的行为相当于设置了Category为“AVAudioSessionCategorySoloAmbient”
 
 因为AVAudioSession会影响其他App的表现，当自己App的Session被激活，其他App的就会被解除激活，如何要让自己的Session解除激活后恢复其他App Session的激活状态呢？
 此时可以使用：
 (BOOL)setActive:(BOOL)active
 withOptions:(AVAudioSessionSetActiveOptions)options
 error:(NSError * _Nullable *)outError;

 这里的options传入AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation 即可。
 当然，也可以通过otherAudioPlaying变量来提前判断当前是否有其他App在播放音频。
 
 七大Category:
 可以控制：
 当App激活Session的时候，是否会打断其他不支持混音的App声音
 当用户触发手机上的“静音”键时或者锁屏时，是否相应静音
 当前状态是否支持录音
 当前状态是否支持播放
 
 每个App启动时都会设置成上面说的默认状态，即其他App会被中断同时相应“静音”键的播放模式。
 
 AVAudioSessionCategoryAmbient ： 只用于播放音乐时，并且可以和QQ音乐同时播放，比如玩游戏的时候还想听QQ音乐的歌，那么把游戏播放背景音就设置成这种类别。同时，当用户锁屏或者静音时也会随着静音，这种类别基本使用所有App的背景场景。
 AVAudioSessionCategorySoloAmbient： 也是只用于播放,但是和"AVAudioSessionCategoryAmbient"不同的是，用了它就别想听QQ音乐了，比如不希望QQ音乐干扰的App，类似节奏大师。同样当用户锁屏或者静音时也会随着静音，锁屏了就玩不了节奏大师了。
 AVAudioSessionCategoryPlayback： 如果锁屏了还想听声音怎么办？用这个类别，比如App本身就是播放器，同时当App播放时，其他类似QQ音乐就不能播放了。所以这种类别一般用于播放器类App
 AVAudioSessionCategoryRecord： 有了播放器，肯定要录音机，比如微信语音的录制，就要用到这个类别，既然要安静的录音，肯定不希望有QQ音乐了，所以其他播放声音会中断。想想微信语音的场景，就知道什么时候用他了。
 AVAudioSessionCategoryPlayAndRecord： 如果既想播放又想录制该用什么模式呢？比如VoIP，打电话这种场景，PlayAndRecord就是专门为这样的场景设计的 。
 AVAudioSessionCategoryMultiRoute： 想象一个DJ用的App，手机连着HDMI到扬声器播放当前的音乐，然后耳机里面播放下一曲，这种常人不理解的场景，这个类别可以支持多个设备输入输出。
 AVAudioSessionCategoryAudioProcessing: 主要用于音频格式处理，一般可以配合AudioUnit进行使用
 
 - (BOOL)setCategory:(NSString *)category error:(NSError **)outError;
 @property(readonly) NSArray<NSString *> *availableCategories;
 
 类别的选项：
 上面介绍的这个七大类别，可以认为是设定了七种主场景，而这七类肯定是不能满足开发者所有的需求的。CoreAudio提供的方法是，首先定下七种的一种基调，然后在进行微调。CoreAudio为每种Category都提供了些许选项来进行微调。
 在设置完类别后，可以通过
 @property(readonly) AVAudioSessionCategoryOptions categoryOptions;
 属性，查看当前类别设置了哪些选项，注意这里的返回值是AVAudioSessionCategoryOptions，实际是多个options的“|”运算。默认情况下是0。
 
 选项
 适用类别
 作用

 AVAudioSessionCategoryOptionMixWithOthers
 AVAudioSessionCategoryPlayAndRecord, AVAudioSessionCategoryPlayback, and  AVAudioSessionCategoryMultiRoute
 是否可以和其他后台App进行混音

 AVAudioSessionCategoryOptionDuckOthers
 AVAudioSessionCategoryAmbient, AVAudioSessionCategoryPlayAndRecord, AVAudioSessionCategoryPlayback, and AVAudioSessionCategoryMultiRoute
 是否压低其他App声音

 AVAudioSessionCategoryOptionAllowBluetooth
 AVAudioSessionCategoryRecord and AVAudioSessionCategoryPlayAndRecord
 是否支持蓝牙耳机

 AVAudioSessionCategoryOptionDefaultToSpeaker
 AVAudioSessionCategoryPlayAndRecord
 是否默认用免提声音

 AVAudioSessionCategoryOptionMixWithOthers ： 如果确实用的AVAudioSessionCategoryPlayback实现的一个背景音，但是呢，又想和QQ音乐并存，那么可以在AVAudioSessionCategoryPlayback类别下在设置这个选项，就可以实现共存了。

 AVAudioSessionCategoryOptionDuckOthers：在实时通话的场景，比如QQ音乐，当进行视频通话的时候，会发现QQ音乐自动声音降低了，此时就是通过设置这个选项来对其他音乐App进行了压制。
 
 AVAudioSessionCategoryOptionAllowBluetooth：如果要支持蓝牙耳机电话，则需要设置这个选项
 
 AVAudioSessionCategoryOptionDefaultToSpeaker： 如果在VoIP模式下，希望默认打开免提功能，需要设置这个选项
 
 通过接口：
 - (BOOL)setCategory:(NSString *)category withOptions:(AVAudioSessionCategoryOptions)options error:(NSError **)outError
 来对当前的类别进行选项的设置
 
 七大模式：
 为此CoreAudio提供了七大比较常见微调后的子场景。叫做各个类别的模式。
 
 模式
 适用的类别
 场景

 AVAudioSessionModeDefault
 所有类别
 默认的模式

 AVAudioSessionModeVoiceChat
 AVAudioSessionCategoryPlayAndRecord
 VoIP

 AVAudioSessionModeGameChat
 AVAudioSessionCategoryPlayAndRecord
 游戏录制，由GKVoiceChat自动设置，无需手动调用

 AVAudioSessionModeVideoRecording
 AVAudioSessionCategoryPlayAndRecord AVAudioSessionCategoryRecord
 录制视频时

 AVAudioSessionModeMoviePlayback
 AVAudioSessionCategoryPlayback
 视频播放

 AVAudioSessionModeMeasurement
 AVAudioSessionCategoryPlayAndRecord AVAudioSessionCategoryRecord AVAudioSessionCategoryPlayback
 最小系统

 AVAudioSessionModeVideoChat
 AVAudioSessionCategoryPlayAndRecord
 视频通话
 
 @property(readonly) NSArray<NSString *> *availableModes;
 AVAudioSessionModeDefault： 每种类别默认的就是这个模式，所有要想还原的话，就设置成这个模式。
 AVAudioSessionModeVoiceChat：主要用于VoIP场景，此时系统会选择最佳的输入设备，比如插上耳机就使用耳机上的麦克风进行采集。此时有个副作用，他会设置类别的选项为"AVAudioSessionCategoryOptionAllowBluetooth"从而支持蓝牙耳机。
 AVAudioSessionModeVideoChat ： 主要用于视频通话，比如QQ视频、FaceTime。时系统也会选择最佳的输入设备，比如插上耳机就使用耳机上的麦克风进行采集并且会设置类别的选项为"AVAudioSessionCategoryOptionAllowBluetooth" 和 "AVAudioSessionCategoryOptionDefaultToSpeaker"。
 AVAudioSessionModeGameChat ： 适用于游戏App的采集和播放，比如“GKVoiceChat”对象，一般不需要手动设置
 
 另外几种和音频APP关系不大，一般我们只需要关注VoIP或者视频通话即可。
 - (BOOL)setMode:(NSString *)mode error:(NSError **)outError
 
 系统中断响应:
 AVAudioSession提供了多种Notifications来进行此类状况的通知。其中将来电话、闹铃响等都归结为一般性的中断，用
 AVAudioSessionInterruptionNotification来通知。其回调回来的userInfo主要包含两个键：
 AVAudioSessionInterruptionTypeKey： 取值为AVAudioSessionInterruptionTypeBegan表示中断开始，我们应该暂停播放和采集，取值为AVAudioSessionInterruptionTypeEnded表示中断结束，我们可以继续播放和采集。
 AVAudioSessionInterruptionOptionKey： 当前只有一种值AVAudioSessionInterruptionOptionShouldResume表示此时也应该恢复继续播放和采集。
 
 而将其他App占据AudioSession的时候用AVAudioSessionSilenceSecondaryAudioHintNotification来进行通知。其回调回来的userInfo键为：
 AVAudioSessionSilenceSecondaryAudioHintTypeKey
 可能包含的值：
 AVAudioSessionSilenceSecondaryAudioHintTypeBegin： 表示其他App开始占据Session
 AVAudioSessionSilenceSecondaryAudioHintTypeEnd: 表示其他App开始释放Session

 外设改变：
 除了其他App和系统服务，会对我们的App产生影响以外，用户的手也会对我们产生影响。默认情况下，AudioSession会在App启动时选择一个最优的输出方案，比如插入耳机的时候，就用耳机。但是这个过程中，用户可能拔出耳机，我们App要如何感知这样的情况呢？
 同样AVAudioSession也是通过Notifications来进行此类状况的通知
 
 最开始在录音时，用户插入和拔出耳机我们都停止录音，这里通过Notification来通知有新设备了，或者设备被退出了，然后我们控制停止录音。或者在播放时，当耳机被拔出出时，Notification给了通知，我们先暂停音乐播放，待耳机插回时，在继续播放。
 
 在NSNotificationCenter中对AVAudioSessionRouteChangeNotification进行注册。在其userInfo中有键：
 AVAudioSessionRouteChangeReasonKey ： 表示改变的原因
 
 枚举值
 意义

 AVAudioSessionRouteChangeReasonUnknown
 未知原因

 AVAudioSessionRouteChangeReasonNewDeviceAvailable
 有新设备可用

 AVAudioSessionRouteChangeReasonOldDeviceUnavailable
 老设备不可用

 AVAudioSessionRouteChangeReasonCategoryChange
 类别改变了

 AVAudioSessionRouteChangeReasonOverride
 App重置了输出设置

 AVAudioSessionRouteChangeReasonWakeFromSleep
 从睡眠状态呼醒

 AVAudioSessionRouteChangeReasonNoSuitableRouteForCategory
 当前Category下没有合适的设备

 AVAudioSessionRouteChangeReasonRouteConfigurationChange
 Rotuer的配置改变了
 
 AVAudioSession构建了一个音频使用生命周期的上下文。当前状态是否可以录音、对其他App有怎样的影响、是否响应系统的静音键、如何感知来电话了等都可以通过它来实现。尤为重要的是AVAudioSession不仅可以和AVFoundation中的AVAudioPlyaer/AVAudioRecorder配合，其他录音/播放工具比如AudioUnit、AudioQueueService也都需要他进行录音、静音等上下文配合。
 
 ===================================
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
