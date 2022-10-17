//
//  OSVideoUtils.h
//  OverSeas
//
//  Created by RainDou on 2022/3/29.
//  Copyright © 2022 ZhuYu.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <VideoToolBox/VideoToolBox.h>
// MARK: - FFMPEG
#import <ffmpegkit/MediaInformationJsonParser.h>
#import <ffmpegkit/FFmpegKitConfig.h>
#import <ffmpegkit/FFprobeKit.h>
#import <ffmpegkit/FFmpegKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OSVideoUtils : NSObject

// https://www.jianshu.com/p/cb93e618e041
/// 是否支持H265硬解码[即hevc，hevc的hvc1 tag视频能在iOS11以上系统播放，hev1 tag不能在iOS上播放，iPhone7以上机型可以hevc硬解码，其他iOS11以上可以软解码]
+ (BOOL)hevcHardwareDecodeSupported;

/// 本地视频获取首帧[可能会失败]
+ (UIImage *)getFirstFrameWith:(AVAsset *)asset;

/// 本地视频获取首帧[可能会失败]
+ (UIImage *)getFirstFrame:(NSString *)filePath;

/// 本地视频获取关键帧
+ (void)generateImageWith:(AVAsset *)asset completedBlock:(void(^)(UIImage *img))completedBlock;

/// 本地视频获取关键帧
+ (void)generateImage:(NSString *)filePath completedBlock:(void(^)(UIImage *img))completedBlock;

/// 本地视频获取时长
+ (int)getDurationWith:(AVAsset *)asset;

/// 本地视频获取时长
+ (int)getDuration:(NSString *)filePath;


/// 本地视频获取宽度[获取的是分辨率宽度，不是尺寸宽度，如竖屏 2160*3840，获取的宽度3840]
+ (CGFloat)getWidthWith:(AVAsset *)asset;

/// 本地视频获取宽度[获取的是分辨率宽度，不是尺寸宽度，如竖屏 2160*3840，获取的宽度3840]
+ (CGFloat)getWidth:(NSString *)filePath;

/// 本地视频获取高度[获取的是分辨率高度，不是尺寸高度，如竖屏 2160*3840，获取的高度2160]
+ (CGFloat)getHeightWith:(AVAsset *)asset;

/// 本地视频获取高度[获取的是分辨率高度，不是尺寸高度，如竖屏 2160*3840，获取的高度2160]
+ (CGFloat)getHeight:(NSString *)filePath;

/// 获取视频旋转角度
+ (NSUInteger)getDegressWith:(AVAsset *)asset;

/// 获取视频旋转角度
+ (NSUInteger)getDegress:(NSString *)filePath;

/// 获取视频轨道所有字节数
+ (long long)getVideoTrackTotalLength:(NSString *)filePath;

/// 获取沙盒路径下视频大小
+ (NSInteger)getDataLength:(NSURL *)url;

/// 压缩转码的时候将它添入AVAssetExportSession的videoComposition中
+ (AVMutableVideoComposition *)getComposition:(NSString *)filePath;

/// 从Asset导出压缩视频[系统导出MP4并指定质量]
+ (AVAssetExportSession *)exportFromAsset:(AVAsset *)asset completion:(void (^)(NSString *exportPath))completion;
/// 本地视频压缩[系统导出MP4并指定质量]
+ (AVAssetExportSession *)exportCompress:(NSString *)inputPath completion:(void (^)(NSString *exportPath))completion;

/// h265[Hevc 编码，tag hvc1，moov前置，MP4容器]
+ (FFmpegSession *)transcode2Hevc:(NSString *)inputPath completion:(void (^)(NSString *transcodePath))completion;

/// 通过路径删除视频
+ (void)deleteVideo:(NSString *)path;

/// 打印视频信息
+ (void)printVideoInfo:(NSString *)inputPath;

@end

NS_ASSUME_NONNULL_END
