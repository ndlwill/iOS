//
//  OSVideoUtils.m
//  OverSeas
//
//  Created by RainDou on 2022/3/29.
//  Copyright © 2022 ZhuYu.ltd. All rights reserved.
//

#import "OSVideoUtils.h"

@implementation OSVideoUtils

// https://www.jianshu.com/p/cb93e618e041
/// 是否支持H265硬解码[即hevc，hevc的hvc1 tag视频能在iOS11以上系统播放，hev1 tag不能在iOS上播放，iPhone7以上机型可以hevc硬解码，其他iOS11以上可以软解码]
+ (BOOL)hevcHardwareDecodeSupported {
    if (@available(iOS 11.0, *)) { // 该工程iOS12，所以可以直接用 VTIsHardwareDecodeSupported(kCMVideoCodecType_HEVC)
        return VTIsHardwareDecodeSupported(kCMVideoCodecType_HEVC);
    }
    return NO;
}

/// 本地视频获取首帧[可能会失败]
+ (UIImage *)getFirstFrameWith:(AVAsset *)asset {
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    generator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels; // https://www.jianshu.com/p/e08f358f5e91
    generator.requestedTimeToleranceAfter = kCMTimeZero;
    generator.requestedTimeToleranceBefore = kCMTimeZero;
    CMTime time = CMTimeMake(1, 60); // a当前第几帧，b每秒钟多少帧。当前播放时间a/b
    NSError *error = nil;
    CGImageRef cgImg = [generator copyCGImageAtTime:time actualTime:NULL error:&error];
    if (error) return nil;
    return [UIImage imageWithCGImage:cgImg];
}
/// 本地视频获取首帧[可能会失败]
+ (UIImage *)getFirstFrame:(NSString *)filePath {
    return [self getFirstFrameWith:[AVURLAsset assetWithURL:[NSURL fileURLWithPath:filePath]]];
}

/// 本地视频获取关键帧
+ (void)generateImageWith:(AVAsset *)asset completedBlock:(void(^)(UIImage *img))completedBlock {
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    CMTime thumbTime = CMTimeMakeWithSeconds(0, 30); // a当前时间，b每秒钟多少帧。 https://www.jianshu.com/p/6b6ffe0e4981
    generator.requestedTimeToleranceAfter = kCMTimeZero;
    generator.requestedTimeToleranceBefore = kCMTimeZero;
    
    AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result != AVAssetImageGeneratorSucceeded) {
                completedBlock(nil);
            } else {
                completedBlock([UIImage imageWithCGImage:im]);
            }
        });
    };
    [generator generateCGImagesAsynchronouslyForTimes:@[[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
    // [generator cancelAllCGImageGeneration];
}

/// 本地视频获取关键帧
+ (void)generateImage:(NSString *)filePath completedBlock:(void(^)(UIImage *img))completedBlock {
    [self generateImageWith:[AVURLAsset assetWithURL:[NSURL fileURLWithPath:filePath]] completedBlock:completedBlock];
}

/// 本地视频获取时长
+ (int)getDurationWith:(AVAsset *)asset {
    return ceil(asset.duration.value / asset.duration.timescale);
}

/// 本地视频获取时长
+ (int)getDuration:(NSString *)filePath {
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:fileUrl options:@{AVURLAssetPreferPreciseDurationAndTimingKey: @(YES)}];
    return ceil(asset.duration.value / asset.duration.timescale);
}

/// 本地视频获取宽度[获取的是分辨率宽度，不是尺寸宽度，如竖屏 2160*3840，获取的宽度3840]
+ (CGFloat)getWidthWith:(AVAsset *)asset {
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *videoTrack = tracks.firstObject;
    if (videoTrack) {
        return videoTrack.naturalSize.width;
    }
    return 0; // 无视轨
}

/// 本地视频获取宽度[获取的是分辨率宽度，不是尺寸宽度，如竖屏 2160*3840，获取的宽度3840]
+ (CGFloat)getWidth:(NSString *)filePath {
    return [self getWidthWith:[AVURLAsset assetWithURL:[NSURL fileURLWithPath:filePath]]];
}

/// 本地视频获取高度[获取的是分辨率高度，不是尺寸高度，如竖屏 2160*3840，获取的高度2160]
+ (CGFloat)getHeightWith:(AVAsset *)asset {
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *videoTrack = tracks.firstObject;
    if (videoTrack) {
        // videoTrack.preferredTransform; // 矩阵旋转角度
        return videoTrack.naturalSize.height;
    }
    return 0; // 无视轨
}

/// 本地视频获取高度[获取的是分辨率高度，不是尺寸高度，如竖屏 2160*3840，获取的高度2160]
+ (CGFloat)getHeight:(NSString *)filePath {
    return [self getHeightWith:[AVURLAsset assetWithURL:[NSURL fileURLWithPath:filePath]]];
}

/// 获取视频轨道所有字节数
+ (long long)getVideoTrackTotalLength:(NSString *)filePath {
    AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:filePath]];
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    long long length = 0;
    for (AVAssetTrack *track in tracks) {
        LOG_DEBUG(@"track.totalSampleDataLength: %lld", track.totalSampleDataLength);// 视频文件字节大小
        length += track.totalSampleDataLength;
    }
    return length;
}

/// 获取沙盒路径下视频大小
+ (NSInteger)getDataLength:(NSURL *)url {
    NSData *data = [NSData dataWithContentsOfURL:url];
    return data.length;
}

/// 获取视频旋转角度
+ (NSUInteger)getDegressWith:(AVAsset *)asset {
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *videoTrack = tracks.firstObject;
    if (videoTrack) {
        CGAffineTransform t = videoTrack.preferredTransform;
       if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0) { // Portrait
            return 90;
        } else if (t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0) { // PortraitUpsideDown
           return 270;
        } else if (t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0) { // LandscapeRight
            return 0;
        } else if (t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0) {// LandscapeLeft
            return 180;
        }
   }
   return 0;
}

/// 获取视频旋转角度
+ (NSUInteger)getDegress:(NSString *)filePath {
    return [self getDegressWith:[AVURLAsset assetWithURL:[NSURL fileURLWithPath:filePath]]];
}

/// 压缩转码的时候将它添入AVAssetExportSession的videoComposition中
+ (AVMutableVideoComposition *)getComposition:(NSString *)filePath {
    AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:filePath]];
    AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    CGSize videoSize = videoTrack.naturalSize;
    if(videoTrack) {
        CGAffineTransform t = videoTrack.preferredTransform;
        if((t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0) || (t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0)) {
            videoSize = CGSizeMake(videoSize.height, videoSize.width);
        }
    }
    composition.naturalSize = videoSize;
    videoComposition.renderSize = videoSize;
    videoComposition.frameDuration = CMTimeMakeWithSeconds( 1 / videoTrack.nominalFrameRate, 600);
    
    AVMutableCompositionTrack *compositionVideoTrack;
    compositionVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:videoTrack atTime:kCMTimeZero error:nil];
    AVMutableVideoCompositionLayerInstruction *layerInst;
    layerInst = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    [layerInst setTransform:videoTrack.preferredTransform atTime:kCMTimeZero];
    AVMutableVideoCompositionInstruction *inst = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    inst.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
    inst.layerInstructions = [NSArray arrayWithObject:layerInst];
    videoComposition.instructions = [NSArray arrayWithObject:inst];
    return videoComposition;
}

/// 从Asset导出压缩视频[系统导出MP4并指定质量]
+ (AVAssetExportSession *)exportFromAsset:(AVAsset *)asset completion:(void (^)(NSString *exportPath))completion {
    NSString *outputPath = [NSString stringWithFormat:@"%@/%ld.mp4", NSTemporaryDirectory(), (long)[[NSDate date] timeIntervalSince1970]];
    CGFloat minWH = MIN([self getWidthWith:asset], [self getHeightWith:asset]);
    // 测试4K 92M 变1.2M AVAssetExportPresetMediumQuality 变成了568*320
    // 测试4K 92M 变59M AVAssetExportPresetHighestQuality 还是4K 16s
    // 测试4K 92M 变27M AVAssetExportPresetHEVC1920x1080 7s
    NSString *presetQuality = AVAssetExportPresetHighestQuality;
    if (minWH >= 1080) {
        presetQuality = AVAssetExportPresetHEVC1920x1080;
    }
    LOG_DEBUG(@"exportFromAsset %lf %lf", [self getWidthWith:asset], [self getHeightWith:asset]);
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:presetQuality];
    session.outputURL = [NSURL fileURLWithPath:outputPath];
    session.outputFileType = AVFileTypeMPEG4;
    session.shouldOptimizeForNetworkUse = YES;
    [session exportAsynchronouslyWithCompletionHandler:^{
        switch (session.status) {
            case AVAssetExportSessionStatusCancelled: LOG_DEBUG(@"AVAssetExportSessionStatusCancelled"); break;
            case AVAssetExportSessionStatusUnknown:  LOG_DEBUG(@"AVAssetExportSessionStatusUnknown"); break;
            case AVAssetExportSessionStatusWaiting: LOG_DEBUG(@"AVAssetExportSessionStatusWaiting"); break;
            case AVAssetExportSessionStatusExporting:  LOG_DEBUG(@"AVAssetExportSessionStatusExporting"); break;
            case AVAssetExportSessionStatusCompleted: { LOG_DEBUG(@"AVAssetExportSessionStatusCompleted");
                dispatch_main_safe(^{
                    if(completion) completion(outputPath);
                });
                break;
            }
            case AVAssetExportSessionStatusFailed:  LOG_DEBUG(@"AVAssetExportSessionStatusFailed"); break;
        }
    }];
    return session;
}

/// 本地视频压缩[系统导出MP4并指定质量]
+ (AVAssetExportSession *)exportCompress:(NSString *)inputPath completion:(void (^)(NSString *exportPath))completion {
    if ([[NSFileManager defaultManager] fileExistsAtPath:inputPath]) {
        return [self exportFromAsset:[AVAsset assetWithURL:[NSURL fileURLWithPath:inputPath]] completion:completion];
    } else {
        completion(inputPath);
        return nil;
    }
}

/// h265[Hevc 编码，tag hvc1，moov前置，MP4容器]
+ (FFmpegSession *)transcode2Hevc:(NSString *)inputPath completion:(void (^)(NSString *transcodePath))completion {
    if ([[NSFileManager defaultManager] fileExistsAtPath:inputPath]) {
        NSString *outputPath = [NSString stringWithFormat:@"%@_hevc.mp4", [inputPath stringByDeletingPathExtension]];
        NSString *normal = @"-c:a copy -movflags faststart -threads 8 -preset veryfast -tag:v hvc1";
        NSString *encode = [self hevcHardwareDecodeSupported] ? @"-c:v hevc_videotoolbox" : @"-c:v libx265";
        NSString *resolution = @"-vf \"scale='if(gte(iw,ih),min(1920,iw),-1)':'if(lt(iw,ih),min(1920,ih),-1)'\"";
        NSString *command = [NSString stringWithFormat:@"-i %@ %@ %@ %@ -y %@", inputPath, normal, encode, resolution, outputPath];
        LOG_DEBUG(@"%@", command);
        MJWeakSelf
        FFmpegSession *session = [FFmpegKit executeAsync:command withCompleteCallback:^(FFmpegSession* session) {
            ReturnCode *returnCode = [session getReturnCode];
            if ([returnCode isValueSuccess]) {
                [weakSelf deleteVideo:inputPath];
                LOG_DEBUG(@"ffmpeg transcode state: success in %ld milliseconds", [session getDuration]);
                completion(outputPath);
            } else {
                LOG_DEBUG(@"ffmpeg transcode state: %@", [FFmpegKitConfig sessionStateToString:[session getState]]);
                completion(inputPath);
            }
        } withLogCallback:^(Log *log) {
            LOG_DEBUG(@"ffmpeg transcode logCallback: %@", [log getMessage]);
        } withStatisticsCallback:^(Statistics *statistics) {
           
        }];
        return session;
    } else {
        completion(inputPath);
        return nil;
    }
}

/// 通过路径删除视频
+ (void)deleteVideo:(NSString *)path {
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}

/// 打印视频信息
+ (void)printVideoInfo:(NSString *)inputPath {
    [FFprobeKit getMediaInformationAsync:inputPath withCompleteCallback:^(MediaInformationSession *session) {
        MediaInformation *information = [session getMediaInformation];
        if ([information getSize]) {
            LOG_DEBUG(@"video size: %@\n", [information getSize]);
        }
        if ([information getFormat]) {
            LOG_DEBUG(@"video formate: %@\n", [information getFormat]);
        }
        if ([information getStreams] != nil) {
            for (StreamInformation* stream in [information getStreams]) {
                if ([stream getWidth] != nil) {
                    LOG_DEBUG(@"Stream width: %@\n", [stream getWidth]);
                }
                if ([stream getHeight] != nil) {
                    LOG_DEBUG(@"Stream height: %@\n", [stream getHeight]);;
                }
                if ([stream getIndex] != nil) {
                    LOG_DEBUG(@"Stream index: %@\n", [stream getIndex]);
                }
                if ([stream getType] != nil) {
                    LOG_DEBUG(@"Stream type: %@\n", [stream getType]);
                }
                if ([stream getCodec] != nil) {
                    LOG_DEBUG(@"Stream codec: %@\n", [stream getCodec]);
                }
                if ([stream getCodecLong] != nil) {
                    LOG_DEBUG(@"Stream codec long: %@\n", [stream getCodecLong]);
                }
                if ([stream getFormat] != nil) {
                    LOG_DEBUG(@"Stream format: %@\n", [stream getFormat]);
                }
                if ([stream getBitrate] != nil) {
                    LOG_DEBUG(@"Stream bitrate: %@\n", [stream getBitrate]);
                }
                if ([stream getSampleRate] != nil) {
                    LOG_DEBUG(@"Stream sample rate: %@\n", [stream getSampleRate]);
                }
                if ([stream getSampleFormat] != nil) {
                    LOG_DEBUG(@"Stream sample format: %@\n", [stream getSampleFormat]);
                }
                if ([stream getChannelLayout] != nil) {
                    LOG_DEBUG(@"Stream channel layout: %@\n", [stream getChannelLayout]);
                }

                if ([stream getSampleAspectRatio] != nil) {
                    LOG_DEBUG(@"Stream sample aspect ratio: %@\n", [stream getSampleAspectRatio]);
                }
                if ([stream getDisplayAspectRatio] != nil) {
                    LOG_DEBUG(@"Stream display ascpect ratio: %@\n", [stream getDisplayAspectRatio]);
                }
                if ([stream getAverageFrameRate] != nil) {
                    LOG_DEBUG(@"Stream average frame rate: %@\n", [stream getAverageFrameRate]);
                }
                if ([stream getRealFrameRate] != nil) {
                    LOG_DEBUG(@"Stream real frame rate: %@\n", [stream getRealFrameRate]);
                }
                if ([stream getTimeBase] != nil) {
                    LOG_DEBUG(@"Stream time base: %@\n", [stream getTimeBase]);
                }
                if ([stream getCodecTimeBase] != nil) {
                    LOG_DEBUG(@"Stream codec time base: %@\n", [stream getCodecTimeBase]);
                }

                if ([stream getTags] != nil) {
                    NSDictionary* tags = [stream getTags];
                    for(NSString *key in [tags allKeys]) {
                        LOG_DEBUG(@"Stream tag: %@:%@\n", key, [tags objectForKey:key]);
                    }
                }
            }
        }
    }];
}

@end
