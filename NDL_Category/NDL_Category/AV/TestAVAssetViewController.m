//
//  TestAVAssetViewController.m
//  NDL_Category
//
//  Created by youdone-ndl on 2020/7/17.
//  Copyright © 2020 ndl. All rights reserved.
//

#import "TestAVAssetViewController.h"
#import <CoreServices/CoreServices.h>

#import <AVFoundation/AVFoundation.h>

// iOS4.0-9.0
#import <AssetsLibrary/AssetsLibrary.h>
// ALAssetsLibrary

// MARK: AVAsset
/**
 #import <AVFoundation/AVFoundation.h>
 AVAudioPlayer
 AVAudioRecorder
 
 #import <CoreMedia/CoreMedia.h>
 CMSampleBufferRef
 
 AVAudioPlayer: 播放音频文件
 AVAudioRecorder: 录制音频文件
 AVAsset: 一个或多个媒体数据(音频轨道,视频轨道)的集合
 Thumbnails: 使用AVAssetImageGenerator生成缩略图
 Editing: 对获取的视频文件做一些编辑操作:改变背景颜色,透明度,快进等等...
 Still and Video Media Capture: 使用capture session来捕捉此相机的视频数据与麦克风的音频数据.
 
 AVAsset是AVFoundation框架中的核心的类,它提供了基于时间的音视频数据.(如电影文件,视频流),一个asset包含很多轨道的结合,如audio, video, text, closed captions, subtitles...
 AVMetadataItem:提供了一个asset相关的所有资源信息.
 AVAssetTrack: 一个轨道可以代表一个音频轨道或视频轨道
 
 AVAsset代表了一种基于时间的音视频数据的抽象类型,其结构决定了很多框架的工作原理.AVFoundation中一些用于代表时间与媒体数据的sample buffer来自Core Media框架.
 
 Media的表示：
 CMSampleBuffer: 表示视频帧数据
 CMSampleBufferGetPresentationTimeStamp,CMSampleBufferGetDecodeTimeStamp: 获取原始时间与解码时间戳
 CMFormatDescriptionRef: 格式信息
 CMGetAttachment: 获取元数据
 
 CMTime:
 CMTime是一个C语言结构类型的有理数,它使用分子(int64_t)与分母(int32_t)表示时间.
 AVFoundation中关于时间的代码均使用此数据结构
 
 特定CMTime的值
 kCMTimeZero
 kCMTimePositiveInfinity
 kCMTimeInvalid
 kCMTimeNegativeInfinity
 
 CMTime作为一个对象
 可以用CMTimeCopyAsDictionary与CMTimeMakeFromDictionary将CMTime转换为CFDictionary.还可以使用CMTimeCopyDescription获取一个代表CMTime的字符串
 
 CMTimeRange表示一个时间段
 CMTimeRange是一个拥有开始时间与持续时间的C语言数据结构.
 比较
 CMTimeRangeContainsTime
 CMTimeRangeEqual
 CMTimeRangeContainsTimeRange
 CMTimeRangeGetUnion
 
 特定的CMTimeRange
 kCMTimeRangeInvalid
 kCMTimeRangeZero
 
 转换
 使用CMTimeRangeCopyAsDictionary与CMTimeRangeMakeFromDictionary将CMTimeRange转为CFDictionary.
 
  Assets 可以来自一个文件或用户的相册,可以理解为多媒体资源
 创建Asset对象时,我们无法立即获取其所有数据, 因为含音视频的资源文件可能很大,系统需要花时间遍历它.一旦获取到asset后,可以从中提取静态图像, 或者将它转码为其他格式, 亦或是做裁剪操作.
 
 访问用户相册
 我们可以获取用户相册中的视频资源
 iPod: MPMediaQuery
 iPhone: ALAssetsLibrary
 
 ==============Playback:
 需要使用AVPlayer对象播放asset.
 
 播放assets
 使用AVPlayer播放一个asset
 使用AVQueuePlayer播放一定数量的items.
 
 处理不同类型asset
 基于文件:
 创建一个AVURLAsset
 使用asset创建一个AVPlayerItem
 使用AVPlayer关联AVPlayerItem
 使用KVO检测item状态变化
 
 播放Item
 [player play];
 
 改变播放速率
 canPlayReverse : 是否支持倒放
 canPlaySlowReverse:0.0 and -1.0
 canPlayFastReverse : less than -1.0
 
 aPlayer.rate = 0.5;
 aPlayer.rate = 1; // 正常播放
 aPlayer.rate = 0; // 暂停
 aPlayer.rate = -0.5; // 倒放
 
 重新定位播放头:主要用于调节播放视频的位置,及播放完后重置播放头
 seekToTime:针对性能
 seekToTime:toleranceBefore:toleranceAfter: 针对精确度
 
 播放多个Items
 可以使用play播放多个Items, 它们将按顺序播放.

 advanceToNextItem:跳过下一个
 insertItem:afterItem: 插入一个
 removeItem:删除一个
 removeAllItems: 删除所有
 NSArray *items = <#An array of player items#>;
 AVQueuePlayer *queuePlayer = [[AVQueuePlayer alloc] initWithItems:items];

 AVPlayerItem *anItem = <#Get a player item#>;
 if ([queuePlayer canInsertItem:anItem afterItem:nil]) {
     [queuePlayer insertItem:anItem afterItem:nil];
 }

 监听播放:
 如果用户切换到别的APP, rate会降到0
 播放远程媒体时,item的loadedTimeRanges and seekableTimeRanges等更多数据的可用性发生变化
 currentItem属性在Item通过HTTP live stream创建
 item的track属性也变化如果当前正在播放HTTP live stream.
 item的stataus属性也会随着播放失败的原因而变化
 
 使用AVPlayerLayer 播放视频文件:
 配置AVPlayerLayer
 创建AVPlayer
 创建一个基于asset的AVPlayerItem对象并使用KVO观察他的状态
 准备播放
 播放完成后恢复播放头
 
 ==================Editing
 AVFoundation 提供了一组丰富功能的类去编辑asset, 编辑的核心是组合. 组合是来自一个或多个asset的集合
 AVMutableComposition类提供了插入,删除,管理tracks顺序的界面,下图展示了两个asset结合成一个新的asset.
 使用AVMutableAudioMix类,可以执行自定义的音频处理.
 AVMutableVideoComposition: 使用合成的track进行编辑 AVMutableVideoCompositionLayerInstruction: 变换,渐变变换,不透明度,渐变不透明
 AVAssetExportSession: 将音视频合成
 
 新建Composition
 类型
 AVMediaTypeVideo
 AVMediaTypeAudio
 AVMediaTypeSubtitle
 AVMediaTypeText.
 
 添加音视频数据
 
 生成一个音量坡度
 
 自定义视频处理
 
 组合多个asset, 保存到相册
 
 ============导出AVAsset
 为了读写asset,必须使用由AVFoundation提供的导出API. AVAssetExportSession类提供了一些导出的方法,如改变文件格式,裁剪asset长度等等.
 AVAssetReader: 当你相对asset内容进行操作时,比如读取音轨以生成波形图
 AVAssetWriter: 从媒体(sample buffers或still images)中生成asset.
 
 asset reader and writer 不适用于实时处理. asset reader不能读取HTTP直播流. 然而,如果你使用asset writer做实时流操作,设置expectsMediaDataInRealTime为YES.对于非实时流的数据如果设置该属性则会报错.
 1.Reading an Asset
 每个AVAssetReader对象仅仅能和一个asset关联,但是这个asset可以包含多个tracks.
 
 创建Asset Reader
 
 建立Asset Reader输出
 创建好asset reader后,至少设置一个输出对象以接收当前正在去读的媒体数据.设置好输出后,请确保alwaysCopiesSampleData为NO以便得到性能的提升.
 如果仅仅想要从一个或多个轨道中读取媒体数据并且将其转为不同的格式,可以使用AVAssetReaderTrackOutput类. 通过使用一个单独的轨道输出对象对每个AVAssetTrack对象你想要从asset中读取的.
 
 使用AVAssetReaderAudioMixOutput与AVAssetReaderVideoCompositionOutput类分别读取由AVAudioMix与AVVideoComposition对象合成的媒体数据.通常被用在从AVComposition中读取数据.
 
 Reading the Asset’s Media Data 设置好输出后,可以调用startReading开始读取.接下来,使用copyNextSampleBuffer方法从每个输出中单独检索数据
 
 2.Writing an Asset
 AVAssetWriter: 用于将多个源的媒体数据写入指定格式的单个文件中.你不必去关联你的asset writer对象与一个特定的asset, 但必须使用一个单独的asset为你创建的每个输出文件.
 
 3.重新编码Assets
 
 */

@interface PlayerView : UIView
@property (nonatomic) AVPlayer *player;
@end
 
@implementation PlayerView
+ (Class)layerClass {
    return [AVPlayerLayer class];
}
- (AVPlayer*)player {
    return [(AVPlayerLayer *)[self layer] player];
}
- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}
@end

@class PlayerView;
@interface PlayerViewController : UIViewController
 
@property (nonatomic) AVPlayer *player;
@property (nonatomic) AVPlayerItem *playerItem;
@property (nonatomic, weak) IBOutlet PlayerView *playerView;
@property (nonatomic, weak) IBOutlet UIButton *playButton;
- (IBAction)loadAssetFromFile:sender;
- (IBAction)play:sender;
- (void)syncUI;
@end

// Define this constant for the key-value observation context.
static const NSString *ItemStatusContext;
@implementation PlayerViewController
- (void)syncUI {
    if ((self.player.currentItem != nil) &&
        ([self.player.currentItem status] == AVPlayerItemStatusReadyToPlay)) {
        self.playButton.enabled = YES;
    }
    else {
        self.playButton.enabled = NO;
    }
}

- (IBAction)play:sender {
    [self.player play];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    [self.player seekToTime:kCMTimeZero];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self syncUI];
}
- (IBAction)loadAssetFromFile:sender {
 
    NSURL *fileURL = [[NSBundle mainBundle]
        URLForResource:@"VideoFileName" withExtension:@"extension"];
 
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
    NSString *tracksKey = @"tracks";
 
    [asset loadValuesAsynchronouslyForKeys:@[tracksKey] completionHandler:
     ^{
         // The completion block goes here.
        dispatch_async(dispatch_get_main_queue(),
                    ^{
                        NSError *error;
                        AVKeyValueStatus status = [asset statusOfValueForKey:tracksKey error:&error];
         
                        if (status == AVKeyValueStatusLoaded) {
                            self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
                             // ensure that this is done before the playerItem is associated with the player
                            [self.playerItem addObserver:self forKeyPath:@"status"
                                        options:NSKeyValueObservingOptionInitial context:&ItemStatusContext];
                            [[NSNotificationCenter defaultCenter] addObserver:self
                                                                      selector:@selector(playerItemDidReachEnd:)
                                                                          name:AVPlayerItemDidPlayToEndTimeNotification
                                                                        object:self.playerItem];
                            self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                            [self.playerView setPlayer:self.player];
                        }
                        else {
                            // You should deal with the error appropriately.
                            NSLog(@"The asset's tracks were not loaded:\n%@", [error localizedDescription]);
                        }
                    });
     }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {

    if (context == &ItemStatusContext) {
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [self syncUI];
                       });
        return;
    }
    [super observeValueForKeyPath:keyPath ofObject:object
           change:change context:context];
    return;
}


@end


// ==================================================
@interface TestAVAssetViewController ()

@property (strong, nonatomic) dispatch_queue_t mainSerializationQueue;
@property (strong, nonatomic) dispatch_queue_t rwAudioSerializationQueue;
@property (strong, nonatomic) dispatch_queue_t rwVideoSerializationQueue;

@end

@implementation TestAVAssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 基于HTTP流
//    NSURL *url = [NSURL URLWithString:@""];
//    // You may find a test stream at <http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8>.
//    self.playerItem = [AVPlayerItem playerItemWithURL:url];
//    [playerItem addObserver:self forKeyPath:@"status" options:0 context:&ItemStatusContext];
//    self.player = [AVPlayer playerWithPlayerItem:playerItem];

//    CMTime fiveSecondsIn = CMTimeMake(5, 1);
//    [player seekToTime:fiveSecondsIn];
//    CMTime fiveSecondsIn = CMTimeMake(5, 1);
//    [player seekToTime:fiveSecondsIn toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
    /**
     时间追踪
     addPeriodicTimeObserverForInterval:queue:usingBlock:
     addBoundaryTimeObserverForTimes:queue:usingBlock:
     // Assume a property: @property (strong) id playerObserver;
      
     Float64 durationSeconds = CMTimeGetSeconds([<#An asset#> duration]);
     CMTime firstThird = CMTimeMakeWithSeconds(durationSeconds/3.0, 1);
     CMTime secondThird = CMTimeMakeWithSeconds(durationSeconds*2.0/3.0, 1);
     NSArray *times = @[[NSValue valueWithCMTime:firstThird], [NSValue valueWithCMTime:secondThird]];
      
     self.playerObserver = [<#A player#> addBoundaryTimeObserverForTimes:times queue:NULL usingBlock:^{
      
         NSString *timeDescription = (NSString *)
             CFBridgingRelease(CMTimeCopyDescription(NULL, [self.player currentTime]));
         NSLog(@"Passed a boundary at %@", timeDescription);
     }];

     */

    // 播放结束 注册AVPlayerItemDidPlayToEndTimeNotification当播放结束
    // 播放完后,应该重新将播放头设置为0,以便下次继续播放
    // Register with the notification center after creating the player item.
    [[NSNotificationCenter defaultCenter]
            addObserver:self
            selector:@selector(playerItemDidReachEnd:)
            name:AVPlayerItemDidPlayToEndTimeNotification
            object:nil];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
//                        change:(NSDictionary *)change context:(void *)context {
//
//    if (context == <#Player status context#>) {
//        AVPlayer *thePlayer = (AVPlayer *)object;
//        if ([thePlayer status] == AVPlayerStatusFailed) {
//            NSError *error = [<#The AVPlayer object#> error];
//            // Respond to error: for example, display an alert sheet.
//            return;
//        }
//        // Deal with other status change if appropriate.
//    }
//    // Deal with other change notifications if appropriate.
//    [super observeValueForKeyPath:keyPath ofObject:object
//           change:change context:context];
//    return;
//}



- (void)playerItemDidReachEnd:(NSNotification *)notification {
//    [player seekToTime:kCMTimeZero];
}

- (void)testCMTime {
    CMTime time1 = CMTimeMake(200, 2); // 200 half-seconds
    CMTime time2 = CMTimeMake(400, 4); // 400 quarter-seconds
     
    // time1 and time2 both represent 100 seconds, but using different timescales.
    if (CMTimeCompare(time1, time2) == 0) {
        NSLog(@"time1 and time2 are the same");
    }
     
    Float64 float64Seconds = 200.0 / 3;
    CMTime time3 = CMTimeMakeWithSeconds(float64Seconds , 3); // 66.66... third-seconds
    time3 = CMTimeMultiply(time3, 3);
    // time3 now represents 200 seconds; next subtract time1 (100 seconds).
    time3 = CMTimeSubtract(time3, time1);
    CMTimeShow(time3);
     
    if (CMTIME_COMPARE_INLINE(time2, ==, time3)) {
        NSLog(@"time2 and time3 are the same");
    }
    
    if (CMTIME_IS_INVALID(time1)) {
        
    }
    
//    CMTimeRange myTimeRange = CMTimeRangeMake(<#CMTime start#>, <#CMTime duration#>)
//    if (CMTIMERANGE_IS_EMPTY(myTimeRange)) {
//
//    }
}

- (void)testAVAseet {
    // 通过URL作为一个asset对象的标识. 这个URL可以是本地文件路径或网络流
    NSURL *url = [NSURL URLWithString:@""];
    /**
     AVURLAssetPreferPreciseDurationAndTimingKey是一个Bool类型的值,他决定了是否应准备好指示精确的持续时间并按时间提供精确的随机访问。
     获取精确的时间需要大量的处理开销. 使用近似时间开销较小且可以满足播放功能.
     如果仅仅想播放asset,可以设置nil,它将默认为NO
     如果想要用asset做一个合成操作,我们需要一个精确的访问.则需要设置为true.
     */
    NSDictionary *options = @{AVURLAssetPreferPreciseDurationAndTimingKey: @YES};
    AVURLAsset *anAsset = [[AVURLAsset alloc] initWithURL:url options:options];
    
    
    // 初始化asset并意味着你检索的信息可以马上使用. 它可能需要一定时间去计算视频的信息.因此我们需要使用block异步接受处理的结果. 使用AVAsynchronousKeyValueLoading协议.
    NSArray *keys = @[@"duration"];
     
    [anAsset loadValuesAsynchronouslyForKeys:keys completionHandler:^() {
        NSError *error = nil;
        AVKeyValueStatus tracksStatus = [anAsset statusOfValueForKey:@"duration" error:&error];
        switch (tracksStatus) {
            case AVKeyValueStatusLoaded:
//                [self updateUserInterfaceForDuration];
                break;
            case AVKeyValueStatusFailed:
//                [self reportError:error forAsset:asset];
                break;
            case AVKeyValueStatusCancelled:
                // Do whatever is appropriate for cancelation.
                break;
       }
    }];
    
    // 从Video中获取静止图像
    // 为了从asset的播放回调中获取像缩略图这样的静态图片,需要使用 AVAssetImageGenerator对象.可以使用tracksWithMediaCharacteristic:.测试asset是否有具有视频信息
    if ([[anAsset tracksWithMediaType:AVMediaTypeVideo] count] > 0) {
        AVAssetImageGenerator *imageGenerator =
            [AVAssetImageGenerator assetImageGeneratorWithAsset:anAsset];
    }
}

- (void)testALAssetsLibrary {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
     
    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
     
    // Within the group enumeration block, filter to enumerate just videos.
    [group setAssetsFilter:[ALAssetsFilter allVideos]];
     
    // For this example, we're only interested in the first item.
    [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:0]
                            options:0
                         usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
     
                             // The end of the enumeration is signaled by asset == nil.
                             if (alAsset) {
                                 ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                                 NSURL *url = [representation url];
                                 AVAsset *avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
                                 // Do something interesting with the AV asset.
                             }
                         }];
                     }
                     failureBlock: ^(NSError *error) {
                         // Typically you should handle an error more gracefully than this.
                         NSLog(@"No groups");
                     }];
}

// 生成一张图片
// 可以使用copyCGImageAtTime:actualTime:error:在特定时间生成一张图片. AVFoundation不能在一个精准时间生成一张请求的图片.
- (void)generateImage {
    NSURL *url = [NSURL URLWithString:@""];
    AVAsset *myAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:myAsset];
     
    Float64 durationSeconds = CMTimeGetSeconds([myAsset duration]);
    CMTime midpoint = CMTimeMakeWithSeconds(durationSeconds/2.0, 600);
    
    NSError *error;
    CMTime actualTime;
     
    CGImageRef halfWayImage = [imageGenerator copyCGImageAtTime:midpoint actualTime:&actualTime error:&error];
     
    if (halfWayImage != NULL) {
     
        NSString *actualTimeString = (__bridge_transfer NSString *)CMTimeCopyDescription(NULL, actualTime);
        NSString *requestedTimeString = (__bridge_transfer NSString *)CMTimeCopyDescription(NULL, midpoint);
        NSLog(@"Got halfWayImage: Asked for %@, got %@", requestedTimeString, actualTimeString);
     
        // Do something interesting with the image.
        CGImageRelease(halfWayImage);
    }
}

// 生成一系列图像
// 为了生成一系列图像,可以使用generateCGImagesAsynchronouslyForTimes:completionHandler:方法生成某个时间段内的连续图片.
// 另外,调用cancelAllCGImageGeneration可以取消上面正在生成的图片.
- (void)generateImages {
    NSURL *url = [NSURL URLWithString:@""];
    AVAsset *myAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    // Assume: @property (strong) AVAssetImageGenerator *imageGenerator;
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:myAsset];
     
    Float64 durationSeconds = CMTimeGetSeconds([myAsset duration]);
    CMTime firstThird = CMTimeMakeWithSeconds(durationSeconds/3.0, 600);
    CMTime secondThird = CMTimeMakeWithSeconds(durationSeconds*2.0/3.0, 600);
    CMTime end = CMTimeMakeWithSeconds(durationSeconds, 600);
    NSArray *times = @[[NSValue valueWithCMTime:kCMTimeZero],
                      [NSValue valueWithCMTime:firstThird], [NSValue valueWithCMTime:secondThird],
                      [NSValue valueWithCMTime:end]];
     
    [imageGenerator generateCGImagesAsynchronouslyForTimes:times
                    completionHandler:^(CMTime requestedTime, CGImageRef image, CMTime actualTime,
                                        AVAssetImageGeneratorResult result, NSError *error) {
     
                    NSString *requestedTimeString = (NSString *)
                        CFBridgingRelease(CMTimeCopyDescription(NULL, requestedTime));
                    NSString *actualTimeString = (NSString *)
                        CFBridgingRelease(CMTimeCopyDescription(NULL, actualTime));
                    NSLog(@"Requested: %@; actual %@", requestedTimeString, actualTimeString);
     
                    if (result == AVAssetImageGeneratorSucceeded) {
                        // Do something interesting with the image.
                    }
     
                    if (result == AVAssetImageGeneratorFailed) {
                        NSLog(@"Failed with error: %@", [error localizedDescription]);
                    }
                    if (result == AVAssetImageGeneratorCancelled) {
                        NSLog(@"Canceled");
                    }
      }];
}

// 裁剪,转码一个视频文件
// 可以使用AVAssetExportSession对象对视频做格式转码,裁剪功能.
- (void)transcodes {
    NSURL *url = [NSURL URLWithString:@""];
    AVAsset *anAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    // preset: 预置
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:anAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]
            initWithAsset:anAsset presetName:AVAssetExportPresetLowQuality];
        // Implementation continues.

        exportSession.outputURL = [NSURL URLWithString:@""];
        exportSession.outputFileType = AVFileTypeQuickTimeMovie;

        CMTime start = CMTimeMakeWithSeconds(1.0, 600);
        CMTime duration = CMTimeMakeWithSeconds(3.0, 600);
        CMTimeRange range = CMTimeRangeMake(start, duration);
        exportSession.timeRange = range;
        
        // 使用exportAsynchronouslyWithCompletionHandler:.方法将创建一个新的文件.
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
               switch ([exportSession status]) {
                   case AVAssetExportSessionStatusFailed:
                       NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                       break;
                   case AVAssetExportSessionStatusCancelled:
                       NSLog(@"Export canceled");
                       break;
                   default:
                       break;
               }
           }];
    }
    // 可以使用cancelExport取消导出操作
    //导出操作可能因为一下原因失败
    //有来电显示
    //有别的应用程序开始播放音频当程序进入后台
}

- (void)testEditing {
    // 新建Composition
    // 使用AVMutableComposition创建对象,然后添加音视频数据,通过AVMutableCompositionTrack添加.
    
    AVMutableComposition *mutableComposition = [AVMutableComposition composition];
    // Create the video composition track.
    AVMutableCompositionTrack *mutableCompositionVideoTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    // Create the audio composition track.
    AVMutableCompositionTrack *mutableCompositionAudioTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];

    // kCMPersistentTrackID_Invalid: 将自动为您生成唯一标识符并与轨道关联。

    // You can retrieve AVAssets from a number of places, like the camera roll for example.
    AVAsset *videoAsset = [AVAsset assetWithURL:[NSURL URLWithString:@""]];
    AVAsset *anotherVideoAsset = [AVAsset assetWithURL:[NSURL URLWithString:@""]];
    // Get the first video track from each asset.
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVAssetTrack *anotherVideoAssetTrack = [[anotherVideoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    // Add them both to the composition.
    [mutableCompositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,videoAssetTrack.timeRange.duration) ofTrack:videoAssetTrack atTime:kCMTimeZero error:nil];
    [mutableCompositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,anotherVideoAssetTrack.timeRange.duration) ofTrack:anotherVideoAssetTrack atTime:videoAssetTrack.timeRange.duration error:nil];

    AVMutableCompositionTrack *compatibleCompositionTrack = [mutableComposition mutableTrackCompatibleWithTrack:mutableCompositionVideoTrack];

    if (compatibleCompositionTrack) {
        // Implementation continues.
    }

    // AVMutableAudioMix对象可以单独地对你的合成的全部音频执行自定义处理,
    AVMutableAudioMix *mutableAudioMix = [AVMutableAudioMix audioMix];
    // Create the audio mix input parameters object.
    AVMutableAudioMixInputParameters *mixParameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:mutableCompositionAudioTrack];
    // Set the volume ramp to slowly fade the audio out over the duration of the composition.
    [mixParameters setVolumeRampFromStartVolume:1.f toEndVolume:0.f timeRange:CMTimeRangeMake(kCMTimeZero, mutableComposition.duration)];
    // Attach the input parameters to the audio mix.
    mutableAudioMix.inputParameters = @[mixParameters];

    // 自定义视频处理
    // AVMutableVideoComposition对象在你的视频合成轨道中执行所有自定义的处理.你可以直接设置渲染尺寸,scal, 帧率在你合成的视频轨道上.
    
    // 改变背影颜色
    AVMutableVideoCompositionInstruction *mutableVideoCompositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mutableVideoCompositionInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, mutableComposition.duration);
    mutableVideoCompositionInstruction.backgroundColor = [[UIColor redColor] CGColor];

    // 应用不透明坡度
    AVAsset *firstVideoAssetTrack = [AVAsset assetWithURL:[NSURL URLWithString:@""]];
    AVAsset *secondVideoAssetTrack = [AVAsset assetWithURL:[NSURL URLWithString:@""]];
    // Create the first video composition instruction.
    AVMutableVideoCompositionInstruction *firstVideoCompositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    // Set its time range to span the duration of the first video track.
    firstVideoCompositionInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, firstVideoAssetTrack.duration);
    // Create the layer instruction and associate it with the composition video track.
    AVMutableVideoCompositionLayerInstruction *firstVideoLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:mutableCompositionVideoTrack];
    
    // Create the opacity ramp to fade out the first video track over its entire duration.
    [firstVideoLayerInstruction setOpacityRampFromStartOpacity:1.f toEndOpacity:0.f timeRange:CMTimeRangeMake(kCMTimeZero, firstVideoAssetTrack.duration)];
    
    // Create the second video composition instruction so that the second video track isn't transparent.
    AVMutableVideoCompositionInstruction *secondVideoCompositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    // Set its time range to span the duration of the second video track.
    secondVideoCompositionInstruction.timeRange = CMTimeRangeMake(firstVideoAssetTrack.duration, CMTimeAdd(firstVideoAssetTrack.duration, secondVideoAssetTrack.duration));
    // Create the second layer instruction and associate it with the composition video track.
    AVMutableVideoCompositionLayerInstruction *secondVideoLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:mutableCompositionVideoTrack];
    
    // Attach the first layer instruction to the first video composition instruction.
    firstVideoCompositionInstruction.layerInstructions = @[firstVideoLayerInstruction];
    // Attach the second layer instruction to the second video composition instruction.
    secondVideoCompositionInstruction.layerInstructions = @[secondVideoLayerInstruction];
    
    // Attach both of the video composition instructions to the video composition.
    AVMutableVideoComposition *mutableVideoComposition = [AVMutableVideoComposition videoComposition];
    mutableVideoComposition.instructions = @[firstVideoCompositionInstruction, secondVideoCompositionInstruction];
    /*
    Incorporating Core Animation Effects
    A video composition can add the power of Core Animation to your composition through the animationTool property. Through this animation tool, you can accomplish tasks such as watermarking video and adding titles or animating overlays. Core Animation can be used in two different ways with video compositions: You can add a Core Animation layer as its own individual composition track, or you can render Core Animation effects (using a Core Animation layer) into the video frames in your composition directly. The following code displays the latter option by adding a watermark to the center of the video:
*/
    
    CALayer *watermarkLayer = [CALayer layer];
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, mutableVideoComposition.renderSize.width, mutableVideoComposition.renderSize.height);
    videoLayer.frame = CGRectMake(0, 0, mutableVideoComposition.renderSize.width, mutableVideoComposition.renderSize.height);
    [parentLayer addSublayer:videoLayer];
    watermarkLayer.position = CGPointMake(mutableVideoComposition.renderSize.width/2, mutableVideoComposition.renderSize.height/4);
    [parentLayer addSublayer:watermarkLayer];
    
    mutableVideoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];

    // 结合Core Animation动画效果 video composition通过animationTool属性添加Core Animation中的动画到合成轨道中.你可以利用它去做视频水印,添加标题,动画叠加等操作.
    // Core Animation主要用于以下两方面 - 你可以把Core Animation图层添加到自己的合成轨道 - 直接将 Core Animation 效果渲染到你合成轨道的视频帧中.
}

// 组合多个asset, 保存到相册
- (void)combineAssets {
    // 1.创建Composition,使用AVMutableComposition将多个asset组合在一起
    AVMutableComposition *mutableComposition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *videoCompositionTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *audioCompositionTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];

    // 2.添加assets
    AVAsset *firstVideoAsset = [AVAsset assetWithURL:[NSURL URLWithString:@""]];
    AVAsset *secondVideoAsset = [AVAsset assetWithURL:[NSURL URLWithString:@""]];
    AVAsset *audioAsset = [AVAsset assetWithURL:[NSURL URLWithString:@""]];
    AVAssetTrack *firstVideoAssetTrack = [[firstVideoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVAssetTrack *secondVideoAssetTrack = [[secondVideoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    [videoCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstVideoAssetTrack.timeRange.duration) ofTrack:firstVideoAssetTrack atTime:kCMTimeZero error:nil];
    [videoCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, secondVideoAssetTrack.timeRange.duration) ofTrack:secondVideoAssetTrack atTime:firstVideoAssetTrack.timeRange.duration error:nil];
    
    [audioCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeAdd(firstVideoAssetTrack.timeRange.duration, secondVideoAssetTrack.timeRange.duration)) ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];

    // 3.检查视频方向
    // 一旦添加了音频和视频轨道到composition,请确保视频轨道的方向是正确的.默认,所有视频被指定为横屏方向.如果你的视频是纵向拍摄的,则导出视频无法正确定位.同样地,如果将横向视频与纵向视频结合也将出错.
    BOOL isFirstVideoPortrait = NO;
    CGAffineTransform firstTransform = firstVideoAssetTrack.preferredTransform;
    // Check the first video track's preferred transform to determine if it was recorded in portrait mode.
    if (firstTransform.a == 0 && firstTransform.d == 0 && (firstTransform.b == 1.0 || firstTransform.b == -1.0) && (firstTransform.c == 1.0 || firstTransform.c == -1.0)) {
        isFirstVideoPortrait = YES;
    }
    
    BOOL isSecondVideoPortrait = NO;
    CGAffineTransform secondTransform = secondVideoAssetTrack.preferredTransform;
    // Check the second video track's preferred transform to determine if it was recorded in portrait mode.
    if (secondTransform.a == 0 && secondTransform.d == 0 && (secondTransform.b == 1.0 || secondTransform.b == -1.0) && (secondTransform.c == 1.0 || secondTransform.c == -1.0)) {
        isSecondVideoPortrait = YES;
    }
    
    if ((isFirstVideoPortrait && !isSecondVideoPortrait) || (!isFirstVideoPortrait && isSecondVideoPortrait)) {
        UIAlertView *incompatibleVideoOrientationAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Cannot combine a video shot in portrait mode with a video shot in landscape mode." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [incompatibleVideoOrientationAlert show];
        return;
    }
    
    // 4.视频合成指令
    // 一旦知道视频的兼容方向,可以对视频片段加以说明
    AVMutableVideoCompositionInstruction *firstVideoCompositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    // Set the time range of the first instruction to span the duration of the first video track.
    firstVideoCompositionInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, firstVideoAssetTrack.timeRange.duration);
    
    AVMutableVideoCompositionInstruction * secondVideoCompositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    // Set the time range of the second instruction to span the duration of the second video track.
    secondVideoCompositionInstruction.timeRange = CMTimeRangeMake(firstVideoAssetTrack.timeRange.duration, CMTimeAdd(firstVideoAssetTrack.timeRange.duration, secondVideoAssetTrack.timeRange.duration));
    
    AVMutableVideoCompositionLayerInstruction *firstVideoLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoCompositionTrack];
    // Set the transform of the first layer instruction to the preferred transform of the first video track.
    [firstVideoLayerInstruction setTransform:firstTransform atTime:kCMTimeZero];
    
    AVMutableVideoCompositionLayerInstruction *secondVideoLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoCompositionTrack];
    // Set the transform of the second layer instruction to the preferred transform of the second video track.
    [secondVideoLayerInstruction setTransform:secondTransform atTime:firstVideoAssetTrack.timeRange.duration];
    
    firstVideoCompositionInstruction.layerInstructions = @[firstVideoLayerInstruction];
    secondVideoCompositionInstruction.layerInstructions = @[secondVideoLayerInstruction];
    
    AVMutableVideoComposition *mutableVideoComposition = [AVMutableVideoComposition videoComposition];
    mutableVideoComposition.instructions = @[firstVideoCompositionInstruction, secondVideoCompositionInstruction];

    // 5.设置渲染尺寸和帧率
    CGSize naturalSizeFirst, naturalSizeSecond;
    // If the first video asset was shot in portrait mode, then so was the second one if we made it here.
    if (isFirstVideoPortrait) {
    // Invert the width and height for the video tracks to ensure that they display properly.
        naturalSizeFirst = CGSizeMake(firstVideoAssetTrack.naturalSize.height, firstVideoAssetTrack.naturalSize.width);
        naturalSizeSecond = CGSizeMake(secondVideoAssetTrack.naturalSize.height, secondVideoAssetTrack.naturalSize.width);
    }
    else {
    // If the videos weren't shot in portrait mode, we can just use their natural sizes.
        naturalSizeFirst = firstVideoAssetTrack.naturalSize;
        naturalSizeSecond = secondVideoAssetTrack.naturalSize;
    }
    
    float renderWidth, renderHeight;
    // Set the renderWidth and renderHeight to the max of the two videos widths and heights.
    if (naturalSizeFirst.width > naturalSizeSecond.width) {
        renderWidth = naturalSizeFirst.width;
    }
    else {
        renderWidth = naturalSizeSecond.width;
    }
    
    if (naturalSizeFirst.height > naturalSizeSecond.height) {
        renderHeight = naturalSizeFirst.height;
    }
    else {
        renderHeight = naturalSizeSecond.height;
    }
    mutableVideoComposition.renderSize = CGSizeMake(renderWidth, renderHeight);
    // Set the frame duration to an appropriate value (i.e. 30 frames per second for video).
    mutableVideoComposition.frameDuration = CMTimeMake(1,30);

    // 6.导出合成的视频
    // Create a static date formatter so we only have to initialize it once.
    static NSDateFormatter *kDateFormatter;
    if (!kDateFormatter) {
        kDateFormatter = [[NSDateFormatter alloc] init];
        kDateFormatter.dateStyle = NSDateFormatterMediumStyle;
        kDateFormatter.timeStyle = NSDateFormatterShortStyle;
    }
    
    // Create the export session with the composition and set the preset to the highest quality.
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mutableComposition presetName:AVAssetExportPresetHighestQuality];
    // Set the desired output URL for the file created by the export process.

    // “Uniform Type Identifier(UTI)”，我把它翻译成“统一类型标识符”
    exporter.outputURL = [[[[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil] URLByAppendingPathComponent:[kDateFormatter stringFromDate:[NSDate date]]] URLByAppendingPathExtension:(NSString *)CFBridgingRelease(UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)AVFileTypeQuickTimeMovie, kUTTagClassFilenameExtension))];
    // Set the output file type to be a QuickTime movie.
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = mutableVideoComposition;
    // Asynchronously export the composition to a video file and save this file to the camera roll once export completes.
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (exporter.status == AVAssetExportSessionStatusCompleted) {
                ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
                if ([assetsLibrary videoAtPathIsCompatibleWithSavedPhotosAlbum:exporter.outputURL]) {
                    [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:exporter.outputURL completionBlock:NULL];
                }
            }
        });
    }];

}

- (void)testAVAssetReader {
    NSError *outError;
    AVAsset *someAsset = [AVAsset assetWithURL:nil];
    AVAssetReader *assetReader = [AVAssetReader assetReaderWithAsset:someAsset error:&outError];
    BOOL success = (assetReader != nil);
    
    // 1.
    AVAsset *localAsset = assetReader.asset;
    // Get the audio track to read.
    AVAssetTrack *audioTrack = [[localAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    // Decompression settings for Linear PCM
    NSDictionary *decompressionAudioSettings = @{ AVFormatIDKey : [NSNumber numberWithUnsignedInt:kAudioFormatLinearPCM] };
    // Create the output with the audio track and decompression settings.
    AVAssetReaderOutput *trackOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:audioTrack outputSettings:decompressionAudioSettings];
    // Add the output to the reader if possible.
    if ([assetReader canAddOutput:trackOutput])
        [assetReader addOutput:trackOutput];
    
    // 2.
//    AVAudioMix *audioMix = [[AVAudioMix alloc] init];
//    // Assumes that assetReader was initialized with an AVComposition object.
//    AVComposition *composition = (AVComposition *)assetReader.asset;
//    // Get the audio tracks to read.
//    NSArray *audioTracks = [composition tracksWithMediaType:AVMediaTypeAudio];
//    // Get the decompression settings for Linear PCM.
//    NSDictionary *decompressionAudioSettings = @{ AVFormatIDKey : [NSNumber numberWithUnsignedInt:kAudioFormatLinearPCM] };
//    // Create the audio mix output with the audio tracks and decompression setttings.
//    AVAssetReaderAudioMixOutput *audioMixOutput = [AVAssetReaderAudioMixOutput assetReaderAudioMixOutputWithAudioTracks:audioTracks audioSettings:decompressionAudioSettings];
//    // Associate the audio mix used to mix the audio tracks being read with the output.
//    audioMixOutput.audioMix = audioMix;
//    // Add the output to the reader if possible.
//    if ([assetReader canAddOutput:audioMixOutput])
//        [assetReader addOutput:audioMixOutput];

    // 3.
//    AVVideoComposition *videoComposition = [AVVideoComposition videoCompositionWithPropertiesOfAsset:nil];
//    // Assumes assetReader was initialized with an AVComposition.
//    AVComposition *composition = (AVComposition *)assetReader.asset;
//    // Get the video tracks to read.
//    NSArray *videoTracks = [composition tracksWithMediaType:AVMediaTypeVideo];
//    // Decompression settings for ARGB.
//    NSDictionary *decompressionVideoSettings = @{ (id)kCVPixelBufferPixelFormatTypeKey : [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32ARGB], (id)kCVPixelBufferIOSurfacePropertiesKey : [NSDictionary dictionary] };
//    // Create the video composition output with the video tracks and decompression setttings.
//    AVAssetReaderVideoCompositionOutput *videoCompositionOutput = [AVAssetReaderVideoCompositionOutput assetReaderVideoCompositionOutputWithVideoTracks:videoTracks videoSettings:decompressionVideoSettings];
//    // Associate the video composition used to composite the video tracks being read with the output.
//    videoCompositionOutput.videoComposition = videoComposition;
//    // Add the output to the reader if possible.
//    if ([assetReader canAddOutput:videoCompositionOutput])
//        [assetReader addOutput:videoCompositionOutput];


    // Start the asset reader up.
    [assetReader startReading];
    BOOL done = NO;
    while (!done)
    {
        // Copy the next sample buffer from the reader output.
        CMSampleBufferRef sampleBuffer = [trackOutput copyNextSampleBuffer];
        if (sampleBuffer)
        {
            // Do something with sampleBuffer here.
            CFRelease(sampleBuffer);
            sampleBuffer = NULL;
        }
        else
        {
            // Find out why the asset reader output couldn't copy another sample buffer.
            if (assetReader.status == AVAssetReaderStatusFailed)
            {
                NSError *failureError = assetReader.error;
                // Handle the error here.
            }
            else
            {
                // The asset reader output has read all of its samples.
                done = YES;
            }
        }
    }
}

- (void)testAssetWriter {
    // 创建Asset Writer
    NSError *outError;
    NSURL *outputURL = [NSURL URLWithString:@""];
    // 指定输出文件的URL与类型
    AVAssetWriter *assetWriter = [AVAssetWriter assetWriterWithURL:outputURL
                                                          fileType:AVFileTypeQuickTimeMovie
                                                             error:&outError];
    BOOL success = (assetWriter != nil);

    // 建立 Asset Writer输入
    // Configure the channel layout as stereo.
    AudioChannelLayout stereoChannelLayout = {
        .mChannelLayoutTag = kAudioChannelLayoutTag_Stereo,// 立体声音响
        .mChannelBitmap = 0,
        .mNumberChannelDescriptions = 0
    };
     
    // Convert the channel layout object to an NSData object.
    NSData *channelLayoutAsData = [NSData dataWithBytes:&stereoChannelLayout length:offsetof(AudioChannelLayout, mChannelDescriptions)];
     
    // Get the compression settings for 128 kbps AAC.
    NSDictionary *compressionAudioSettings = @{
        AVFormatIDKey         : [NSNumber numberWithUnsignedInt:kAudioFormatMPEG4AAC],
        AVEncoderBitRateKey   : [NSNumber numberWithInteger:128000],
        AVSampleRateKey       : [NSNumber numberWithInteger:44100],
        AVChannelLayoutKey    : channelLayoutAsData,
        AVNumberOfChannelsKey : [NSNumber numberWithUnsignedInteger:2]
    };
     
    // Create the asset writer input with the compression settings and specify the media type as audio.
    AVAssetWriterInput *assetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:compressionAudioSettings];
    // Add the input to the writer if possible.
    if ([assetWriter canAddInput:assetWriterInput])
        [assetWriter addInput:assetWriterInput];
        
    AVAsset *videoAsset = [AVAsset assetWithURL:nil];
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    assetWriterInput.transform = videoAssetTrack.preferredTransform;

    NSDictionary *pixelBufferAttributes = @{
         (__bridge NSString *)kCVPixelBufferCGImageCompatibilityKey : [NSNumber numberWithBool:YES],
         (__bridge NSString *)kCVPixelBufferCGBitmapContextCompatibilityKey : [NSNumber numberWithBool:YES],
         (__bridge NSString *)kCVPixelBufferPixelFormatTypeKey : [NSNumber numberWithInt:kCVPixelFormatType_32ARGB]
    };
    AVAssetWriterInputPixelBufferAdaptor *inputPixelBufferAdaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:assetWriterInput sourcePixelBufferAttributes:pixelBufferAttributes];

    // Writing Media Data
    CMTime halfAssetDuration = CMTimeMultiplyByFloat64(videoAsset.duration, 0.5);
    [assetWriter startSessionAtSourceTime:halfAssetDuration];
    
    // 可以使用endSessionAtSourceTime:结束当前正在写的session, 然而,如果你的session将执行到文件末尾, 可以调用finishWriting.
    
//    // Prepare the asset writer for writing.
//    [assetWriter startWriting];
//    // Start a sample-writing session.
//    [assetWriter startSessionAtSourceTime:kCMTimeZero];
//    // Specify the block to execute when the asset writer is ready for media data and the queue to call it on.
//    [assetWriterInput requestMediaDataWhenReadyOnQueue:myInputSerialQueue usingBlock:^{
//         while ([assetWriterInput isReadyForMoreMediaData])
//         {
//              // Get the next sample buffer.
//              CMSampleBufferRef nextSampleBuffer = [self copyNextSampleBufferToWrite];
//              if (nextSampleBuffer)
//              {
//                   // If it exists, append the next sample buffer to the output file.
//                   [assetWriterInput appendSampleBuffer:nextSampleBuffer];
//                   CFRelease(nextSampleBuffer);
//                   nextSampleBuffer = nil;
//              }
//              else
//              {
//                   // Assume that lack of a next sample buffer means the sample buffer source is out of samples and mark the input as finished.
//                   [assetWriterInput markAsFinished];
//                   break;
//              }
//         }
//    }];
}

- (void)reencodeAssets {
    NSString *serializationQueueDescription = [NSString stringWithFormat:@"%@ serialization queue", self];
     
    // Create a serialization queue for reading and writing.
    dispatch_queue_t serializationQueue = dispatch_queue_create([serializationQueueDescription UTF8String], NULL);
     
    // Specify the block to execute when the asset writer is ready for media data and the queue to call it on.
//    [self.assetWriterInput requestMediaDataWhenReadyOnQueue:serializationQueue usingBlock:^{
//         while ([self.assetWriterInput isReadyForMoreMediaData])
//         {
//              // Get the asset reader output's next sample buffer.
//              CMSampleBufferRef sampleBuffer = [self.assetReaderOutput copyNextSampleBuffer];
//              if (sampleBuffer != NULL)
//              {
//                   // If it exists, append this sample buffer to the output file.
//                   BOOL success = [self.assetWriterInput appendSampleBuffer:sampleBuffer];
//                   CFRelease(sampleBuffer);
//                   sampleBuffer = NULL;
//                   // Check for errors that may have occurred when appending the new sample buffer.
//                   if (!success && self.assetWriter.status == AVAssetWriterStatusFailed)
//                   {
//                        NSError *failureError = self.assetWriter.error;
//                        //Handle the error.
//                   }
//              }
//              else
//              {
//                   // If the next sample buffer doesn't exist, find out why the asset reader output couldn't vend another one.
//                   if (self.assetReader.status == AVAssetReaderStatusFailed)
//                   {
//                        NSError *failureError = self.assetReader.error;
//                        //Handle the error here.
//                   }
//                   else
//                   {
//                        // The asset reader output must have vended all of its samples. Mark the input as finished.
//                        [self.assetWriterInput markAsFinished];
//                        break;
//                   }
//              }
//         }
//    }];
    
    // ###使用Asset Reader and Writer串联去重新编码Asset###
    /**
     流程

     使用串行队列处理异步读取与写入的数据.
     初始化asset reader并且配置两个asset reader的输出(一个video,一个audio)
     初始化asset writer并且配置两个asset writer的输入出(一个video,一个audio)
     使用一个asset reader通过两种不同的输入输出结合将数据传给asset writer
     使用dispatch group通知重新编码的过程完成
     允许用户取消开始后的重新编码的过程
     */


}

// 创建三个单独的同步队列去管理读写进程,主队列用于管理asset reader, writer的启动与停止,其他两个队列用于通过输入,输出读取组合串行化读取与写入.
- (void)testAll {
    NSString *serializationQueueDescription = [NSString stringWithFormat:@"%@ serialization queue", self];
     
    // Create the main serialization queue.
    self.mainSerializationQueue = dispatch_queue_create([serializationQueueDescription UTF8String], NULL);
    NSString *rwAudioSerializationQueueDescription = [NSString stringWithFormat:@"%@ rw audio serialization queue", self];
     
    // Create the serialization queue to use for reading and writing the audio data.
    self.rwAudioSerializationQueue = dispatch_queue_create([rwAudioSerializationQueueDescription UTF8String], NULL);
    NSString *rwVideoSerializationQueueDescription = [NSString stringWithFormat:@"%@ rw video serialization queue", self];
     
    // Create the serialization queue to use for reading and writing the video data.
    self.rwVideoSerializationQueue = dispatch_queue_create([rwVideoSerializationQueueDescription UTF8String], NULL);
    
//    self.asset = <#AVAsset that you want to reencode#>;
//    self.cancelled = NO;
//    self.outputURL = <#NSURL representing desired output URL for file generated by asset writer#>;
//    // Asynchronously load the tracks of the asset you want to read.
//    [self.asset loadValuesAsynchronouslyForKeys:@[@"tracks"] completionHandler:^{
//         // Once the tracks have finished loading, dispatch the work to the main serialization queue.
//         dispatch_async(self.mainSerializationQueue, ^{
//              // Due to asynchronous nature, check to see if user has already cancelled.
//              if (self.cancelled)
//                   return;
//              BOOL success = YES;
//              NSError *localError = nil;
//              // Check for success of loading the assets tracks.
//              success = ([self.asset statusOfValueForKey:@"tracks" error:&localError] == AVKeyValueStatusLoaded);
//              if (success)
//              {
//                   // If the tracks loaded successfully, make sure that no file exists at the output path for the asset writer.
//                   NSFileManager *fm = [NSFileManager defaultManager];
//                   NSString *localOutputPath = [self.outputURL path];
//                   if ([fm fileExistsAtPath:localOutputPath])
//                        success = [fm removeItemAtPath:localOutputPath error:&localError];
//              }
//              if (success)
//                   success = [self setupAssetReaderAndAssetWriter:&localError];
//              if (success)
//                   success = [self startAssetReaderAndWriter:&localError];
//              if (!success)
//                   [self readingAndWritingDidFinishSuccessfully:success withError:localError];
//         });
//    }];


}

//  初始化Asset Reader and Writer
- (BOOL)setupAssetReaderAndAssetWriter:(NSError **)outError
{
//     // Create and initialize the asset reader.
//     self.assetReader = [[AVAssetReader alloc] initWithAsset:self.asset error:outError];
//     BOOL success = (self.assetReader != nil);
//     if (success)
//     {
//          // If the asset reader was successfully initialized, do the same for the asset writer.
//          self.assetWriter = [[AVAssetWriter alloc] initWithURL:self.outputURL fileType:AVFileTypeQuickTimeMovie error:outError];
//          success = (self.assetWriter != nil);
//     }
//
//     if (success)
//     {
//          // If the reader and writer were successfully initialized, grab the audio and video asset tracks that will be used.
//          AVAssetTrack *assetAudioTrack = nil, *assetVideoTrack = nil;
//          NSArray *audioTracks = [self.asset tracksWithMediaType:AVMediaTypeAudio];
//          if ([audioTracks count] > 0)
//               assetAudioTrack = [audioTracks objectAtIndex:0];
//          NSArray *videoTracks = [self.asset tracksWithMediaType:AVMediaTypeVideo];
//          if ([videoTracks count] > 0)
//               assetVideoTrack = [videoTracks objectAtIndex:0];
//
//          if (assetAudioTrack)
//          {
//               // If there is an audio track to read, set the decompression settings to Linear PCM and create the asset reader output.
//               NSDictionary *decompressionAudioSettings = @{ AVFormatIDKey : [NSNumber numberWithUnsignedInt:kAudioFormatLinearPCM] };
//               self.assetReaderAudioOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:assetAudioTrack outputSettings:decompressionAudioSettings];
//               [self.assetReader addOutput:self.assetReaderAudioOutput];
//               // Then, set the compression settings to 128kbps AAC and create the asset writer input.
//               AudioChannelLayout stereoChannelLayout = {
//                    .mChannelLayoutTag = kAudioChannelLayoutTag_Stereo,
//                    .mChannelBitmap = 0,
//                    .mNumberChannelDescriptions = 0
//               };
//               NSData *channelLayoutAsData = [NSData dataWithBytes:&stereoChannelLayout length:offsetof(AudioChannelLayout, mChannelDescriptions)];
//               NSDictionary *compressionAudioSettings = @{
//                    AVFormatIDKey         : [NSNumber numberWithUnsignedInt:kAudioFormatMPEG4AAC],
//                    AVEncoderBitRateKey   : [NSNumber numberWithInteger:128000],
//                    AVSampleRateKey       : [NSNumber numberWithInteger:44100],
//                    AVChannelLayoutKey    : channelLayoutAsData,
//                    AVNumberOfChannelsKey : [NSNumber numberWithUnsignedInteger:2]
//               };
//               self.assetWriterAudioInput = [AVAssetWriterInput assetWriterInputWithMediaType:[assetAudioTrack mediaType] outputSettings:compressionAudioSettings];
//               [self.assetWriter addInput:self.assetWriterAudioInput];
//          }
//
//          if (assetVideoTrack)
//          {
//               // If there is a video track to read, set the decompression settings for YUV and create the asset reader output.
//               NSDictionary *decompressionVideoSettings = @{
//                    (id)kCVPixelBufferPixelFormatTypeKey     : [NSNumber numberWithUnsignedInt:kCVPixelFormatType_422YpCbCr8],
//                    (id)kCVPixelBufferIOSurfacePropertiesKey : [NSDictionary dictionary]
//               };
//               self.assetReaderVideoOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:assetVideoTrack outputSettings:decompressionVideoSettings];
//               [self.assetReader addOutput:self.assetReaderVideoOutput];
//               CMFormatDescriptionRef formatDescription = NULL;
//               // Grab the video format descriptions from the video track and grab the first one if it exists.
//               NSArray *videoFormatDescriptions = [assetVideoTrack formatDescriptions];
//               if ([videoFormatDescriptions count] > 0)
//                    formatDescription = (__bridge CMFormatDescriptionRef)[formatDescriptions objectAtIndex:0];
//               CGSize trackDimensions = {
//                    .width = 0.0,
//                    .height = 0.0,
//               };
//               // If the video track had a format description, grab the track dimensions from there. Otherwise, grab them direcly from the track itself.
//               if (formatDescription)
//                    trackDimensions = CMVideoFormatDescriptionGetPresentationDimensions(formatDescription, false, false);
//               else
//                    trackDimensions = [assetVideoTrack naturalSize];
//               NSDictionary *compressionSettings = nil;
//               // If the video track had a format description, attempt to grab the clean aperture settings and pixel aspect ratio used by the video.
//               if (formatDescription)
//               {
//                    NSDictionary *cleanAperture = nil;
//                    NSDictionary *pixelAspectRatio = nil;
//                    CFDictionaryRef cleanApertureFromCMFormatDescription = CMFormatDescriptionGetExtension(formatDescription, kCMFormatDescriptionExtension_CleanAperture);
//                    if (cleanApertureFromCMFormatDescription)
//                    {
//                         cleanAperture = @{
//                              AVVideoCleanApertureWidthKey            : (id)CFDictionaryGetValue(cleanApertureFromCMFormatDescription, kCMFormatDescriptionKey_CleanApertureWidth),
//                              AVVideoCleanApertureHeightKey           : (id)CFDictionaryGetValue(cleanApertureFromCMFormatDescription, kCMFormatDescriptionKey_CleanApertureHeight),
//                              AVVideoCleanApertureHorizontalOffsetKey : (id)CFDictionaryGetValue(cleanApertureFromCMFormatDescription, kCMFormatDescriptionKey_CleanApertureHorizontalOffset),
//                              AVVideoCleanApertureVerticalOffsetKey   : (id)CFDictionaryGetValue(cleanApertureFromCMFormatDescription, kCMFormatDescriptionKey_CleanApertureVerticalOffset)
//                         };
//                    }
//                    CFDictionaryRef pixelAspectRatioFromCMFormatDescription = CMFormatDescriptionGetExtension(formatDescription, kCMFormatDescriptionExtension_PixelAspectRatio);
//                    if (pixelAspectRatioFromCMFormatDescription)
//                    {
//                         pixelAspectRatio = @{
//                              AVVideoPixelAspectRatioHorizontalSpacingKey : (id)CFDictionaryGetValue(pixelAspectRatioFromCMFormatDescription, kCMFormatDescriptionKey_PixelAspectRatioHorizontalSpacing),
//                              AVVideoPixelAspectRatioVerticalSpacingKey   : (id)CFDictionaryGetValue(pixelAspectRatioFromCMFormatDescription, kCMFormatDescriptionKey_PixelAspectRatioVerticalSpacing)
//                         };
//                    }
//                    // Add whichever settings we could grab from the format description to the compression settings dictionary.
//                    if (cleanAperture || pixelAspectRatio)
//                    {
//                         NSMutableDictionary *mutableCompressionSettings = [NSMutableDictionary dictionary];
//                         if (cleanAperture)
//                              [mutableCompressionSettings setObject:cleanAperture forKey:AVVideoCleanApertureKey];
//                         if (pixelAspectRatio)
//                              [mutableCompressionSettings setObject:pixelAspectRatio forKey:AVVideoPixelAspectRatioKey];
//                         compressionSettings = mutableCompressionSettings;
//                    }
//               }
//               // Create the video settings dictionary for H.264.
//               NSMutableDictionary *videoSettings = (NSMutableDictionary *) @{
//                    AVVideoCodecKey  : AVVideoCodecH264,
//                    AVVideoWidthKey  : [NSNumber numberWithDouble:trackDimensions.width],
//                    AVVideoHeightKey : [NSNumber numberWithDouble:trackDimensions.height]
//               };
//               // Put the compression settings into the video settings dictionary if we were able to grab them.
//               if (compressionSettings)
//                    [videoSettings setObject:compressionSettings forKey:AVVideoCompressionPropertiesKey];
//               // Create the asset writer input and add it to the asset writer.
//               self.assetWriterVideoInput = [AVAssetWriterInput assetWriterInputWithMediaType:[videoTrack mediaType] outputSettings:videoSettings];
//               [self.assetWriter addInput:self.assetWriterVideoInput];
//          }
//     }
//     return success;
    
    // ##test##
    return YES;
}

// 重编码asset
- (BOOL)startAssetReaderAndWriter:(NSError **)outError
{
//     BOOL success = YES;
//     // Attempt to start the asset reader.
//     success = [self.assetReader startReading];
//     if (!success)
//          *outError = [self.assetReader error];
//     if (success)
//     {
//          // If the reader started successfully, attempt to start the asset writer.
//          success = [self.assetWriter startWriting];
//          if (!success)
//               *outError = [self.assetWriter error];
//     }
//
//     if (success)
//     {
//          // If the asset reader and writer both started successfully, create the dispatch group where the reencoding will take place and start a sample-writing session.
//          self.dispatchGroup = dispatch_group_create();
//          [self.assetWriter startSessionAtSourceTime:kCMTimeZero];
//          self.audioFinished = NO;
//          self.videoFinished = NO;
//
//          if (self.assetWriterAudioInput)
//          {
//               // If there is audio to reencode, enter the dispatch group before beginning the work.
//               dispatch_group_enter(self.dispatchGroup);
//               // Specify the block to execute when the asset writer is ready for audio media data, and specify the queue to call it on.
//               [self.assetWriterAudioInput requestMediaDataWhenReadyOnQueue:self.rwAudioSerializationQueue usingBlock:^{
//                    // Because the block is called asynchronously, check to see whether its task is complete.
//                    if (self.audioFinished)
//                         return;
//                    BOOL completedOrFailed = NO;
//                    // If the task isn't complete yet, make sure that the input is actually ready for more media data.
//                    while ([self.assetWriterAudioInput isReadyForMoreMediaData] && !completedOrFailed)
//                    {
//                         // Get the next audio sample buffer, and append it to the output file.
//                         CMSampleBufferRef sampleBuffer = [self.assetReaderAudioOutput copyNextSampleBuffer];
//                         if (sampleBuffer != NULL)
//                         {
//                              BOOL success = [self.assetWriterAudioInput appendSampleBuffer:sampleBuffer];
//                              CFRelease(sampleBuffer);
//                              sampleBuffer = NULL;
//                              completedOrFailed = !success;
//                         }
//                         else
//                         {
//                              completedOrFailed = YES;
//                         }
//                    }
//                    if (completedOrFailed)
//                    {
//                         // Mark the input as finished, but only if we haven't already done so, and then leave the dispatch group (since the audio work has finished).
//                         BOOL oldFinished = self.audioFinished;
//                         self.audioFinished = YES;
//                         if (oldFinished == NO)
//                         {
//                              [self.assetWriterAudioInput markAsFinished];
//                         }
//                         dispatch_group_leave(self.dispatchGroup);
//                    }
//               }];
//          }
//
//          if (self.assetWriterVideoInput)
//          {
//               // If we had video to reencode, enter the dispatch group before beginning the work.
//               dispatch_group_enter(self.dispatchGroup);
//               // Specify the block to execute when the asset writer is ready for video media data, and specify the queue to call it on.
//               [self.assetWriterVideoInput requestMediaDataWhenReadyOnQueue:self.rwVideoSerializationQueue usingBlock:^{
//                    // Because the block is called asynchronously, check to see whether its task is complete.
//                    if (self.videoFinished)
//                         return;
//                    BOOL completedOrFailed = NO;
//                    // If the task isn't complete yet, make sure that the input is actually ready for more media data.
//                    while ([self.assetWriterVideoInput isReadyForMoreMediaData] && !completedOrFailed)
//                    {
//                         // Get the next video sample buffer, and append it to the output file.
//                         CMSampleBufferRef sampleBuffer = [self.assetReaderVideoOutput copyNextSampleBuffer];
//                         if (sampleBuffer != NULL)
//                         {
//                              BOOL success = [self.assetWriterVideoInput appendSampleBuffer:sampleBuffer];
//                              CFRelease(sampleBuffer);
//                              sampleBuffer = NULL;
//                              completedOrFailed = !success;
//                         }
//                         else
//                         {
//                              completedOrFailed = YES;
//                         }
//                    }
//                    if (completedOrFailed)
//                    {
//                         // Mark the input as finished, but only if we haven't already done so, and then leave the dispatch group (since the video work has finished).
//                         BOOL oldFinished = self.videoFinished;
//                         self.videoFinished = YES;
//                         if (oldFinished == NO)
//                         {
//                              [self.assetWriterVideoInput markAsFinished];
//                         }
//                         dispatch_group_leave(self.dispatchGroup);
//                    }
//               }];
//          }
//          // Set up the notification that the dispatch group will send when the audio and video work have both finished.
//          dispatch_group_notify(self.dispatchGroup, self.mainSerializationQueue, ^{
//               BOOL finalSuccess = YES;
//               NSError *finalError = nil;
//               // Check to see if the work has finished due to cancellation.
//               if (self.cancelled)
//               {
//                    // If so, cancel the reader and writer.
//                    [self.assetReader cancelReading];
//                    [self.assetWriter cancelWriting];
//               }
//               else
//               {
//                    // If cancellation didn't occur, first make sure that the asset reader didn't fail.
//                    if ([self.assetReader status] == AVAssetReaderStatusFailed)
//                    {
//                         finalSuccess = NO;
//                         finalError = [self.assetReader error];
//                    }
//                    // If the asset reader didn't fail, attempt to stop the asset writer and check for any errors.
//                    if (finalSuccess)
//                    {
//                         finalSuccess = [self.assetWriter finishWriting];
//                         if (!finalSuccess)
//                              finalError = [self.assetWriter error];
//                    }
//               }
//               // Call the method to handle completion, and pass in the appropriate parameters to indicate whether reencoding was successful.
//               [self readingAndWritingDidFinishSuccessfully:finalSuccess withError:finalError];
//          });
//     }
//     // Return success here to indicate whether the asset reader and writer were started successfully.
//     return success;
    
    // ##test##
    return YES;
}

// 处理完成
- (void)readingAndWritingDidFinishSuccessfully:(BOOL)success withError:(NSError *)error
{
//     if (!success)
//     {
//          // If the reencoding process failed, we need to cancel the asset reader and writer.
//          [self.assetReader cancelReading];
//          [self.assetWriter cancelWriting];
//          dispatch_async(dispatch_get_main_queue(), ^{
//               // Handle any UI tasks here related to failure.
//          });
//     }
//     else
//     {
//          // Reencoding was successful, reset booleans.
//          self.cancelled = NO;
//          self.videoFinished = NO;
//          self.audioFinished = NO;
//          dispatch_async(dispatch_get_main_queue(), ^{
//               // Handle any UI tasks here related to success.
//          });
//     }
}

// 处理取消
- (void)cancel
{
//     // Handle cancellation asynchronously, but serialize it with the main queue.
//     dispatch_async(self.mainSerializationQueue, ^{
//          // If we had audio data to reencode, we need to cancel the audio work.
//          if (self.assetWriterAudioInput)
//          {
//               // Handle cancellation asynchronously again, but this time serialize it with the audio queue.
//               dispatch_async(self.rwAudioSerializationQueue, ^{
//                    // Update the Boolean property indicating the task is complete and mark the input as finished if it hasn't already been marked as such.
//                    BOOL oldFinished = self.audioFinished;
//                    self.audioFinished = YES;
//                    if (oldFinished == NO)
//                    {
//                         [self.assetWriterAudioInput markAsFinished];
//                    }
//                    // Leave the dispatch group since the audio work is finished now.
//                    dispatch_group_leave(self.dispatchGroup);
//               });
//          }
//
//          if (self.assetWriterVideoInput)
//          {
//               // Handle cancellation asynchronously again, but this time serialize it with the video queue.
//               dispatch_async(self.rwVideoSerializationQueue, ^{
//                    // Update the Boolean property indicating the task is complete and mark the input as finished if it hasn't already been marked as such.
//                    BOOL oldFinished = self.videoFinished;
//                    self.videoFinished = YES;
//                    if (oldFinished == NO)
//                    {
//                         [self.assetWriterVideoInput markAsFinished];
//                    }
//                    // Leave the dispatch group, since the video work is finished now.
//                    dispatch_group_leave(self.dispatchGroup);
//               });
//          }
//          // Set the cancelled Boolean property to YES to cancel any work on the main queue as well.
//          self.cancelled = YES;
//     });
}


// Asset Output Settings Assistant
// The AVOutputSettingsAssistant class aids in creating output-settings dictionaries for an asset reader or writer. This makes setup much simpler, especially for high frame rate H264 movies that have a number of specific presets.
- (void)testAVOutputSettingsAssistant {
//    AVOutputSettingsAssistant *outputSettingsAssistant = [AVOutputSettingsAssistant outputSettingsAssistantWithPreset:<some preset>];
//    CMFormatDescriptionRef audioFormat = [self getAudioFormat];
//
//    if (audioFormat != NULL)
//        [outputSettingsAssistant setSourceAudioFormat:(CMAudioFormatDescriptionRef)audioFormat];
//
//    CMFormatDescriptionRef videoFormat = [self getVideoFormat];
//
//    if (videoFormat != NULL)
//        [outputSettingsAssistant setSourceVideoFormat:(CMVideoFormatDescriptionRef)videoFormat];
//
//    CMTime assetMinVideoFrameDuration = [self getMinFrameDuration];
//    CMTime averageFrameDuration = [self getAvgFrameDuration]
//
//    [outputSettingsAssistant setSourceVideoAverageFrameDuration:averageFrameDuration];
//    [outputSettingsAssistant setSourceVideoMinFrameDuration:assetMinVideoFrameDuration];
//
//    AVAssetWriter *assetWriter = [AVAssetWriter assetWriterWithURL:<some URL> fileType:[outputSettingsAssistant outputFileType] error:NULL];
//    AVAssetWriterInput *audioInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:[outputSettingsAssistant audioSettings] sourceFormatHint:audioFormat];
//    AVAssetWriterInput *videoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:[outputSettingsAssistant videoSettings] sourceFormatHint:videoFormat];

}

// MARK: capture捕获


// Create a UIImage from sample buffer data
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
 
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
 
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
 
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
 
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
      bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
 
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
 
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
 
    // Release the Quartz image
    CGImageRelease(quartzImage);
 
    return (image);
}






@end
