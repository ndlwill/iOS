//
//  NDLAudioFileHandler.h
//  NDL_Category
//
//  Created by youdone-ndl on 2020/8/5.
//  Copyright © 2020 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreAudioTypes/CoreAudioTypes.h>

NS_ASSUME_NONNULL_BEGIN
// 录制文件的类，一个是负责做音频录制的类
@interface NDLAudioFileHandler : NSObject

+ (instancetype)getInstance;

/**
 * Write audio data to file.
 */
- (void)writeFileWithInNumBytes:(UInt32)inNumBytes
                   ioNumPackets:(UInt32 )ioNumPackets
                       inBuffer:(const void *)inBuffer
                   inPacketDesc:(const AudioStreamPacketDescription*)inPacketDesc;

@end

NS_ASSUME_NONNULL_END
