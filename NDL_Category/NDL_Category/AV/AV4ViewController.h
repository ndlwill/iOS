//
//  AV4ViewController.h
//  NDL_Category
//
//  Created by youdone-ndl on 2020/12/15.
//  Copyright © 2020 ndl. All rights reserved.
//

// MARK: 播放功能AVPlayer
/**
 AVPlayer用来播放基于时间的视听媒体的控制器对象。支持播放从本地、分步下载或通过HTTP Live Streaming协议得到的流媒体
 
 AVPlayer是一个不可见组件，如果播放MP3或AAC音频文件，那么没有可视化的用户界面不会有什么问题。如果是要播放一个QuickTime电影或一个MPEG-4视频，就会导致非常不好的用户体验，要将视频资源导出到用户界面的目标位置，需要使用AVPlayerLayer类。

 AVPlayer管理一个单独资源的播放。AVqueuePlayer可以用来管理一个资源队列，当需要在一个序列中播放多个条目或者为视频、音频设置播放循环时可以使用。
 
 AVPlayerLayer:
 AVPlayerLayer构建于Core Animation之上，是AV Foundation中位数不多的可见组件。
 
 Core Animation本身有基于时间的属性，并且基于OpenGL，有很好的性能，能够满足AV Foundation的各种需求。
 
 AVPlayerLayer扩展了Core Animation的CALayer类，通过框架在屏幕上显示视频内容。创建他需要一个指向AVPlayer实例的指针，将图层和播放器绑定在一起，保证当播放器基于时间的方法出现时使二者保持同步。它与CALayer一样，可以设置为UIView的备用层或者手动添加到一个已有的层继承关系中。
 
 AVPlayerLayer中可以自定义的领域只有Video gravity,确定在承载层的范围内视频可以拉伸或缩放的程度。
 AVLayerVideoGravityResizeAspect --在承载层范围内缩放视频大小来保持视频原始宽高比，默认值，适用于大部分情况
 AVLayerVideoGravityResizeAspectFill --保留视频宽高比，通过缩放填满层的范围区域，会导致视频图片被部分裁剪。
 AVLayerVideoGravityResize --拉伸视频内容拼配承载层的范围，会导致图片扭曲，funhouse effect效应。

 AVPlayerItem:
 AVAsset只包含媒体资源静态信息，无法实现播放功能。需要对一个资源及其相关曲目进行播放时，首先需要通过AVPlayerItem和APlayerItemTrack来构建相应的动态内容。
 
 AVPlayerItem建立媒体资源动态视角的数据模型并保存AVPlayer在播放资源时的呈现状态。AVPlayerItem由一个或多个媒体曲目组成，由AVPlayerItemTrack建立模型。AVPlayerItemTrack实例用于表示播放器条目中的类型统一的媒体流。AVPlayerItem中曲目直接与AVAsset中的AVAssetTrack实例相对应。

 播放:
 NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"WeChatSight3033" withExtension:@"mp4"];;
     
     //创建一个资源实例
 AVAsset *asset = [AVAsset assetWithURL:fileUrl];
     
 // 关联播放资源
 AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
     
 //添加监听PlayerItem属性值status。
 [playerItem addObserver:self forKeyPath:@"status" options:0 context:&PlayerStatusContext];
     
 // 创建player
 _player = [AVPlayer playerWithPlayerItem:playerItem];
     
 // 创建playerLayer 粗放资源内容
 AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
 playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
 playerLayer.frame = self.view.frame;
     
 [self.view.layer addSublayer:playerLayer];
 
 AVPlayerItem有一个status的AVPlayerItemStatus类型的属性。创建的时候由AVPlayerItemStatusUnknown状态开始，在具体播放前需要状态变为AVPlayerItemStatusReadyToPlay。所以在这里为PlayerItem的status属性添加一个观察者，当status发生改变时，可以做出相应的处理。
 
 要在将AVPlayerItem与AVPlayer关联之前，添加status属性观察。
 - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
     if (context == &PlayerStatusContext) {
         NSLog(@"status change");
         AVPlayerItem *item = (AVPlayerItem *)object;
         NSLog(@"status :%zd -- %zd",item.status,AVPlayerItemStatusReadyToPlay);
         if (item.status == AVPlayerItemStatusReadyToPlay) {
             [self.player play];
         }
     }
 }
 
 处理时间 CMTime:
 浮点类型数据的运算会有不精确的情况，多时间累加是不精确的情况会更加严重，会导致媒体的多个数据流几乎无法实现铜鼓。另外浮点型数据呈现时间信息无法做到自我描述。AV Foundation中使用CMTime数据结构记录时间信息。
 typedef struct
 {
     CMTimeValue value;
     CMTimeScale timescale;
     CMTimeFlags flags;
     CMTimeEpoch epoch;
 } CMTime;
 
 CMTime以分数表示时间，value-分子，timescale-分母，flags-位掩码，表示时间的指定状态

 CMTime的创建 CMTimeMake()函数
 通过CMTimeShow()函数，打印CMTime相关信息

 //1/5 秒
 CMTime time = CMTimeMake(1, 5);
 //44.1kHz 一帧的时间
 CMTime oneSample = CMTimeMake(1, 44100);
 //0
 CMTime zeroTime = kCMTimeZero;

 CMTimeShow(time);
 CMTimeShow(oneSample);
 CMTimeShow(zeroTime);

 打印结果：
 {1/5 = 0.200}
 {1/44100 = 0.000}
 {0/1 = 0.000}

 CMTime计算:
 //相加 CMTimeAdd()
 CMTime time = CMTimeMake(1, 5);
 CMTime time1 = CMTimeMake(1, 3);
 CMTime time2 = CMTimeAdd(time, time1);
 CMTimeShow(time2); //{8/15 = 0.533}

 //相减，CMTimeSubtract()，time1-time
 CMTime time3 = CMTimeSubtract(time1, time);
 CMTimeShow(time3); //{2/15 = 0.133}

 //通过，CMTimeGetSeconds()获取秒数
 NSLog(@"%f", CMTimeGetSeconds(time3))

 CMTimeRange，表示时间范围:
 typedef struct
 {
     CMTime          start;   //起始点
     CMTime          duration; //持续时间
 } CMTimeRange;
 CMTimeRangeMake()或CMTimeRangeFromTimeToTime()创建
 CMTimeRange range1 = CMTimeRangeMake(time1, time);
 CMTimeRange range2 = CMTimeRangeFromTimeToTime(time, time1);
 
 时间监听:
 KVO可以监听AVPlayerItem和AVPlayer的许多属性，不过KVO也有不足的地方，比附需要监听AVPlayer的时间变化。这些监听自身有明显的动态特性并需要非常高的精准度，这一点要比标准的键值监听要求高。AVPayer提供两种基于时间的监听方法，对时间变化进行精准的监听

 1、定期监听
 addPeriodicTimeObserverForInterval: queue: usingBlock:可以以一定的时间间隔获得通知，比如需要随着时间的变化移动播放头位置或更新时间显示。
 interval：指定通知周期间隔的CMTime值
 queue：通知发送的顺序调度序列，大多时候，我们希望这些通知发生在主队列，在没有明确指定的情况下则默认为主队列。不可以使用并行调度队列，API没有处理并行队列的方法；。
 block：一个在指定的时间间隔中就会在队列上调用的回调块。这个块传递一个CMTime值用于指示播放器的当前时间。

 2、边界时间监听
 addBoundaryTimeObserverForTimes: queue: usingBlock:针对性的方法监听时间，可以得到播放器时间轴中多个边界点的遍历结果。用于同步用户界面变更或随着视频播放记录一些非可视化数据。比如可以定义25%、50%边界的标记，判断用户的播放进度。
 times：CMTime值组成的一个NSArray数组定义了需要通知的边界点。
 queue：与定期监听类似，为方法提供一个用来发送通知的顺序调度队列。指定NULL等同于明确设置主队列。
 block：每当正常播放中跨域一个边界点时就会在队列中回调方法块，不提供遍历的CMTime值，需要为此执行一些额外计算进行确定。

 3、条目结束监听
 AVPlayerItemDidPlayToEndTimeNotification播放完成时，AVPlayerItem会发送这个通知 。注册成为监听器，即获得项目结束通知。
 
 [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(playOverNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
                                          
 //作对应操作
 - (void)playOverNotification:(NSNotification *)notification {
     [self.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
         self.playButton.selected = NO;
         self.timeLabel.text = @"0/0";
         self.progressSlider.value = 0.f;
     }];
 }
 
 创建视频播放器：
 通过playerItemWithAsset:asset automaticallyLoadedAssetKeys:创建一个AVPlayerItem，将任意属性集委托给该框架，就可以自动载入对应的属性，省去了loadValuesAsynchronouslyForKeys: completionHandler载入需要访问其他资源属性。

 #import "LFAVPlayerVC.h"
 #import <AVFoundation/AVFoundation.h>
 @interface LFAVPlayerVC ()
 @property (nonatomic,strong) AVPlayer *player;
 @property (strong, nonatomic) IBOutlet UIButton *playButton;//播放

 @property (strong, nonatomic) IBOutlet UISlider *progressSlider;//进度条
 @property (strong, nonatomic) IBOutlet UILabel *assetTitleLable;

 @property (strong, nonatomic) IBOutlet UILabel *timeLabel;//显示时间



 @end

 static const NSString *PlayerStatusContext ;
 static const NSString *PlayerItemTimeContext ;
 static const NSString *PlayerItemEndObserverForPlayerItem ;

 @implementation LFAVPlayerVC

 - (void)viewDidLoad {
     [super viewDidLoad];
     
     NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"WeChatSight3033" withExtension:@"mp4"];;
     
     //创建一个资源实例
     AVAsset *asset = [AVAsset assetWithURL:fileUrl];
     
     
     NSArray *keyArray = @[@"tracks",@"duration",@"commonMetadata"];
     // 关联播放资源
     AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset automaticallyLoadedAssetKeys:keyArray];
 //    [asset loadValuesAsynchronouslyForKeys:<#(nonnull NSArray<NSString *> *)#> completionHandler:<#^(void)handler#>]
     //通过`playerItemWithAsset:asset automaticallyLoadedAssetKeys:`创建一个AVPlayerItem，将任意属性集委托给该框架，就可以自动载入对应的属性，省去了`loadValuesAsynchronouslyForKeys: completionHandler`载入需要访问其他资源属性。
     
     //添加监听PlayerItem属性值status。
     [playerItem addObserver:self forKeyPath:@"status" options:0 context:&PlayerStatusContext];
     
     
     
     
     // 创建player
     _player = [AVPlayer playerWithPlayerItem:playerItem];
     
     dispatch_queue_t queue = dispatch_get_main_queue();
     
     __weak typeof(self) weakSelf = self;
     
     [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 2) queue:queue usingBlock:^(CMTime time) {
         NSTimeInterval currentTime = CMTimeGetSeconds(time);
         NSTimeInterval durationTime = CMTimeGetSeconds(playerItem.duration);
         weakSelf.timeLabel.text = [NSString stringWithFormat:@"%.0f:%.0f",currentTime,durationTime];
         weakSelf.progressSlider.maximumValue = durationTime;
         weakSelf.progressSlider.value = currentTime;
         
     }];
 //    _player addPeriodicTimeObserverForInterval: queue: usingBlock:
 //    _player addBoundaryTimeObserverForTimes: queue: usingBlock:
     // 创建playerLayer 粗放资源内容
     AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
     playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
     playerLayer.frame = self.view.frame;
     [self.view.layer addSublayer:playerLayer];
     
     [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(playOverNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
     
 }

 - (void)playOverNotification:(NSNotification *)notification {
     [self.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
         self.playButton.selected = NO;
         self.timeLabel.text = @"0/0";
         self.progressSlider.value = 0.f;
     }];
 }

 //播放
 - (IBAction)playButtonClicked:(id)sender {
     
     if (self.playButton.selected) { //播放中，暂停
         [self.player pause];
         self.playButton.selected = NO;
     } else { //暂停中，开始播放
         [self.player play];
         self.playButton.selected = YES;
     }
     
 }


 - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
     dispatch_async(dispatch_get_main_queue(), ^{
         //不知道通知在哪个线程发生，通过dispatch_async确保应用程序回到主线程
         if (context == &PlayerStatusContext) {
             NSLog(@"status change");
             AVPlayerItem *item = (AVPlayerItem *)object;
             NSLog(@"status :%zd -- %zd",item.status,AVPlayerItemStatusReadyToPlay);
             if (item.status == AVPlayerItemStatusReadyToPlay) {
                 [self.player play];
                 self.playButton.selected = YES;
 //                self.assetTitleLable.text = item.
             } else {
                 NSLog(@"prepare video failure");
             }
         }
     });
     
 }

 - (void)dealloc {
     [[NSNotificationCenter defaultCenter] removeObserver:self];
     
 }

 - (void)didReceiveMemoryWarning {
     [super didReceiveMemoryWarning];
     // Dispose of any resources that can be recreated.
 }

 @end
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AV4ViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
