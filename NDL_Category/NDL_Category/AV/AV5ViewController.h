//
//  AV5ViewController.h
//  NDL_Category
//
//  Created by youdone-ndl on 2020/12/16.
//  Copyright © 2020 ndl. All rights reserved.
//

// MARK: AVKit用法-AVPlayerViewController
/**
 #import<MediaPlayer/MediaPlayer.h>，iOS8.0以后可以不再使用这个库，iOS9.0之后已经彻底放弃这个库文件，另外在iOS8.0之后提供了更加灵活的AVKit与AVFoundation结合的方式播放视频。
 
 # pragma 远程/网络视频地址
 NSURL *fileUrl = [NSURL URLWithString:@"http://devstreaming.apple.com/videos/wwdc/2014/503xx50xm4n63qe/503/503_sd_mastering_modern_media_playback.mov"];//视频网络地址
 
 iOS 8.0之后引入AVKit框架，相对于之前的Media Player框架，更复杂也更加灵活强大。iOS9.0之后Media Player将被遗弃，所以更要关注的是AVKit。
 //初始化viewcontroller
 AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
 NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"WeChatSight3033" withExtension:@"mp4"];
 //创建AVPlayer
 AVPlayer *player = [[AVPlayer alloc] initWithURL:fileUrl];
     
 //将Player赋值给AVPlayerViewController
 playerVC.player = player;

 [self presentViewController:playerVC animated:YES completion:nil];

 player(AVPlayer): 播放视图的资源媒体内容
 showsPlaybackControls(BOOL): 表示播放空间是否显示或隐藏，默认YES-显示。
 videoGravity(NSString): 设置视频资源与视图承载范围的适应情况。
 readyForDisplay(BOOL): 通过观察这个值来确定视频内容是否已经准备好进行展示。
 videoBounds(CGRect): 视频相对于图层的尺寸和位置
 contentOverlayView(UIView): 只读，可以添加自定义view，在视频与控件之间。

 为AVPlayerViewController提供资源的步骤
 //1、 通过URL创建资源
 AVAsset *asset = [AVAsset assetWithURL:fileUrl];
     
 //2、 为资源创建playerItem
 AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];

 //3、 通过playerItem创建Player
 AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
     
 //4、 将player与playerViewController关联。
 playerViewController.player = player;


 //最简单的方式，将以上四步简化为一步。但是对应的更多操作将会受到限制，根据实际情况处理。
 playerViewController.player = [AVPlayer playerWithURL:fileUrl];

 关于AVPlayerViewController更多的高级用法，更多是AVPlayer的用法，与AVPlayerItem、AVAsset相关密切。也即是与AVFoundation的联合使用。
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AV5ViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
