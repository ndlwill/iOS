//
//  KCDownloadManager.h
//  KCDownloadManagerDemo
//
//  Created by cooci on 17/2/7.
//  Copyright © 2017年 cooci. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCDownloadModel.h"

typedef NS_ENUM(NSInteger, KCWaitingQueueMode) {
    KCWaitingQueueModeFIFO, // 先入先出
    KCWaitingQueueModeFILO  // 先入后出
};

@interface KCDownloadManager : NSObject
/**
 The directory where the downloaded files are saved, default is .../Library/Caches/KCDownloadManager if not setted.
 */
@property (nonatomic, copy) NSString *saveFilesDirectory;

/**
 The count of max concurrent downloads, default is -1 which means no limit.
 */
@property (nonatomic, assign) NSInteger maxConcurrentCount;

/**
 The mode of waiting for download queue, default is FIFO.
 */
@property (nonatomic, assign) KCWaitingQueueMode waitingQueueMode;

+ (instancetype)sharedManager;


- (void)download:(NSURL *)URL
        destPath:(NSString *)destPath
           state:(void(^)(KCDownloadState state))state
        progress:(void(^)(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress))progress
      completion:(void(^)(BOOL isSuccess, NSString *filePath, NSError *error))completion;


- (BOOL)isDownloadCompletedOfURL:(NSURL *)URL;

#pragma mark - Downloads
- (void)suspendDownloadOfURL:(NSURL *)URL;
- (void)suspendAllDownloads;

- (void)resumeDownloadOfURL:(NSURL *)URL;
- (void)resumeAllDownloads;

- (void)cancelDownloadOfURL:(NSURL *)URL;
- (void)cancelAllDownloads;

#pragma mark - Files

- (NSString *)fileFullPathOfURL:(NSURL *)URL;

- (CGFloat)fileHasDownloadedProgressOfURL:(NSURL *)URL;

- (void)deleteFile:(NSString *)fileName;
- (void)deleteFileOfURL:(NSURL *)URL;
- (void)deleteAllFiles;






@end
