//
//  AV3ViewController.h
//  NDL_Category
//
//  Created by youdone-ndl on 2020/12/14.
//  Copyright © 2020 ndl. All rights reserved.
//

// MARK: 资源AVAsset
/**
 AVAsset是一个抽象类和不可变类，定义媒体资源混合呈现的方式，将媒体资源的静态属性模块化成为一个整体，比如标题、时长和元数据等。
 
 AVAsset本身不是媒体资源，但他可以作为时基媒体的容器，由一个或多个带有描述自身元数据的媒体组成。
 
 AVAssetTrack类代表保存在资源的统一类型媒体，并对每个资源建立相应的模型。
 资源的曲目可以通过tracks属性进行访问。
 
 NSURL *fileUrl;
 NSDictionary *dict = @{AVURLAssetPreferPreciseDurationAndTimingKey : @YES};
 AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileUrl options:dict];
 
 AVURLAssetPreferPreciseDurationAndTimingKey这个布尔值支出这个asset是否应该准备标出一个准确的时间和提供一个以时间为种子的随机存取。
 只是播放asset，options传递nil，或者字典里对应的值是NO(包含在NSValue对象中)
 
 iPod Library歌曲（也称作本地音乐库歌曲）也就是用户从iTunes中导入的歌曲。MediaPlayer框架提供了API，实现在这个库中查询和获取条目。当需要的条目找到后可以获取其URL并使用这个URL初始化一个资源：
 需要导入库文件<MediaPlayer/MediaPlayer.h>
 MPMediaPropertyPredicate *artistPredicate = [MPMediaPropertyPredicate predicateWithValue:@"刘德华" forProperty:MPMediaItemPropertyArtist];
 MPMediaPropertyPredicate *albumPredicate = [MPMediaPropertyPredicate predicateWithValue:@"真永远" forProperty:MPMediaItemPropertyArtist];
 MPMediaPropertyPredicate *songPredicate = [MPMediaPropertyPredicate predicateWithValue:@"今天" forProperty:MPMediaItemPropertyArtist];
 MPMediaQuery *query = [[MPMediaQuery alloc] init];
 [query addFilterPredicate:artistPredicate];
 [query addFilterPredicate:albumPredicate];
 [query addFilterPredicate:songPredicate];
 NSArray *results = [query items];
 if (results.count > 0) {
     MPMediaItem *item = results[0];
     NSURL *assetURL = [item valueForProperty:MPMediaItemPropertyAssetURL];
     AVAsset *asset = [AVAsset assetWithURL:assetURL];
     
 }
 
 异步载入:
 AVAsset和AVAssetTrack都采用了AVAsynchornousKeyValueLoading协议
 NSURL *assetUrl = [[NSBundle mainBundle] URLForResource:@"崔健-假行僧" withExtension:@"mp3"];
 AVAsset *asset = [AVAsset assetWithURL:assetUrl];
     
 NSArray *keys = @[@"tracks"];
     
 [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
     NSError *error;
     
     AVKeyValueStatus status = [asset statusOfValueForKey:@"tracks" error:&error];
     switch (status) {
         case AVKeyValueStatusLoaded:
             //已经加载，继续处理
             NSLog(@"loaded");
             NSLog(@"%@",asset.tracks);
             break;
         case AVKeyValueStatusFailed:
             NSLog(@"failure");
             break;
         case AVKeyValueStatusCancelled:
             NSLog(@"canceld");
             break;
         case AVKeyValueStatusUnknown:
             NSLog(@"unknown");
             break;
             
         default:
             NSLog(@"default");
             break;
     }
 }];

 可使用statusOfValueForKey: error:方法查询一个给定属性的状态，该方法会返回一个枚举类型的AVKeyValueStatus值，用于表示当前所请求的属性的状态。如果状态不是AVKeyValueStatusLoaded，意味着此时请求该属性可能导致程序卡杜，需要异步载入一个给定的属性，可以调用loadValuesAsynchronouslyForKeys: completionHandler:方法，为其提供一个具有一个或多个key的数组(资源的属性名)和一个completionHandler块，当资源处于回应请求状态时，就会回调这个块方法。

 completionHandler可能会在任意一个队列中被调用，在对用户界面做出相应更新之前，必须先回到主队列中。
 在请求多个属性时，每次调用loadValuesAsynchronouslyForKeys: completionHandler:方法只会调用一次completionHandler，调用该方法的次数并不是根据传递给这个方法的键的个数决定的。
 需要为每个请求的属性调用statusOfValueForKey: error:不能假设所有属性都返回相同的状态值。
 
 媒体元数据:
 元数据格式
 Apple环境下遇到的媒体类型主要有4种，分别是：QuickTime(mov)、MPEG-4 video(mp4或m4v)、MPEG-4 Audio(m4a)、MPEG-Layer III audio(mp3)。
 QuickTime
 MPEG-4音频和视频
 MP3
 
 使用元数据:
 AVAsset和AVAssetTrack都可以实现查询相关元数据的功能，大部分情况使用AVAsset提供的元数据，不过涉及获取曲目一级元数据等情况时会使用AVAssetTrack。
 读取具体资源元数据的接口由AVMetadataItem提供。提供一个面向对象的接口，可以对存储于QuickTime、MPEG-4 atom和ID3帧中的元素进行访问。
 键空间(key spaces): AV中使用键空间作为将相关键组合在一起的方法，可以实现对AVMetadataItem实例集合的筛选，每个资源至少包含两个键空间，供从中获取元数据。
 common键空间用来定义所有支持的媒体类型的键，包括诸如曲名、歌手和插图信息等常见元素。可以通过查询资源或曲目的[asset commonMetadata]属性从common键空间获取与数据，这个属性会返回一个包含所有可用元数据的数据.

 metadataForFormat:访问指定格式的元数据格式，返回一个包含所有相关元数据信息的NSArray。
 [asset availableMetadataFormats]返回资源中包含的所有元数据格式
 
 查找元数据:
 AVMetadataItem最基本的形式是一个封装键值对的封装器。而已通过它查询key或commonKey。value属性被定义成id<NSObject，NSCopying>形式，AVMetadataItem还提供了三个类型强制属性stringValue、numberValue、dataValue，如果已经提前知道value类型，可以强制转换。

 NSURL *assetUrl = [[NSBundle mainBundle] URLForResource:@"今天" withExtension:@"mp3"];
 AVAsset *asset = [AVAsset assetWithURL:assetUrl];

 for (AVMetadataFormat item in [asset availableMetadataFormats]) {
     NSArray *medata = [asset metadataForFormat:item];
     for (AVMetadataItem *mitem in medata) {
         NSLog(@"%@:%@",mitem.key,mitem.value);
     }
 }

 //    TPE1:刘德华
 //    TALB:真永远
 //    TIT2:今天
 //    TYER:1995-08-01
 
 保存元数据:
 AVAsset是一个不可变类，如果要保存元数据的修改，使用AVAssetExportSession导出一个新的资源副本以及元数据改动。
 
 AVAssetExportSession用于将AVAsset内容根据导出预设条件进行转码，并将导出资源写到磁盘。它提供了多个功能来实现将一种格式转换为另一种格式、修订资源的内容、修改资源的音频和视频行为、写入新的元数据。

 创建一个AVAssetExportSession实例需要提供资源和导出预设。导出预设用于确定导出内容的质量、大小等属性。创建导出会话后，还要指定导出内容地址outputURL，并且给出一个outputFileType表示要导出的格式。最后调用exportAsynchronouslyWithCompletionHandler:开始导出。
 
 NSString *presetName = AVAssetExportPresetPassthrough;
 AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:self.asset presetName:presetName];
     
 NSURL *outputUrl ;
     
 exportSession.outputURL = outputUrl;
 exportSession.outputFileType = @"";
 //    exportSession.metadata = [_asset availableMetadataFormats]
     
 [exportSession exportAsynchronouslyWithCompletionHandler:^{
     AVAssetExportSessionStatus status = exportSession.status;
     BOOL success = (status == AVAssetExportSessionStatusCompleted);
     if (success) {
         
     }
     
 }];
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AV3ViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
