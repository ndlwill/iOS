//
//  KCDownloadManager.m
//  KCDownloadManagerDemo
//
//  Created by cooci on 17/2/7.
//  Copyright © 2017年 cooci. All rights reserved.
//

#import "KCDownloadManager.h"

#define KCDownloadDirectory self.saveFilesDirectory ?: [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] \
stringByAppendingPathComponent:NSStringFromClass([self class])]

#define KCFileName(URL) [URL lastPathComponent] // use URL's last path component as the file's name

#define KCFilePath(URL) [KCDownloadDirectory stringByAppendingPathComponent:KCFileName(URL)]

#define KCFilesTotalLengthPlistPath [KCDownloadDirectory stringByAppendingPathComponent:@"KCFilesTotalLength.plist"]


@interface KCDownloadManager () <NSURLSessionDelegate, NSURLSessionDataDelegate>

@property (nonatomic, strong) NSMutableDictionary *downloadModelsDic; // a dictionary contains downloading and waiting models

@property (nonatomic, strong) NSMutableArray *downloadingModels; // a array contains models which are downloading now

@property (nonatomic, strong) NSMutableArray *waitingModels; // a array contains models which are waiting for download


@end

@implementation KCDownloadManager

#pragma mark --- lazy load
- (NSMutableDictionary *)downloadModelsDic {
    
    if (!_downloadModelsDic) {
        _downloadModelsDic = [NSMutableDictionary dictionary];
    }
    return _downloadModelsDic;
}

- (NSMutableArray *)downloadingModels {
    
    if (!_downloadingModels) {
        _downloadingModels = [NSMutableArray array];
    }
    return _downloadingModels;
}

- (NSMutableArray *)waitingModels {
    
    if (!_waitingModels) {
        _waitingModels = [NSMutableArray array];
    }
    return _waitingModels;
}


#pragma mark --- Singleton
+ (instancetype)sharedManager{
    
    static KCDownloadManager *downloadManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloadManager = [[self alloc] init];
        downloadManager.maxConcurrentCount = -1;
        downloadManager.waitingQueueMode = KCWaitingQueueModeFIFO;
    });
    return downloadManager;
}


- (instancetype)init{
    if (self = [super init]) {
        NSString *downloadDirectory = KCDownloadDirectory;
        BOOL isDirectory = NO;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isExists = [fileManager fileExistsAtPath:downloadDirectory isDirectory:&isDirectory];
        if (!isExists || !isDirectory) {
            [fileManager createDirectoryAtPath:downloadDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return self;
}

- (void)download:(NSURL *)URL
        destPath:(NSString *)destPath
           state:(void(^)(KCDownloadState state))state
        progress:(void(^)(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress))progress
      completion:(void(^)(BOOL isSuccess, NSString *filePath, NSError *error))completion{
    
    
    if (!URL) {
        return;
    }
    
    
    if ([self isDownloadCompletedOfURL:URL]) { // if this URL has been downloaded
        if (state) {
            state(KCDownloadStateCompleted);
        }
        if (completion) {
            completion(YES, [self fileFullPathOfURL:URL], nil);
        }
        return;
    }
    
    KCDownloadModel *downloadModel = self.downloadModelsDic[KCFileName(URL)];
    
    if (downloadModel) { // if the download model of this URL has been added in downloadModelsDic
        downloadModel.progress = progress;
        downloadModel.completion = completion;
        return;
    }
    
    // means: the download model should be created
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:URL];
    [requestM setValue:[NSString stringWithFormat:@"bytes=%ld-", (long)[self hasDownloadedLength:URL]] forHTTPHeaderField:@"Range"];
    NSURLSessionDataTask *dataTask = [[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                                    delegate:self
                                                               delegateQueue:[[NSOperationQueue alloc] init]] dataTaskWithRequest:requestM];
    dataTask.taskDescription = KCFileName(URL);
    
    downloadModel = [[KCDownloadModel alloc] init];
    downloadModel.dataTask = dataTask;
    downloadModel.outputStream = [NSOutputStream outputStreamToFileAtPath:[self fileFullPathOfURL:URL] append:YES];
    downloadModel.URL = URL;
    downloadModel.destPath = destPath;
    downloadModel.state = state;
    downloadModel.progress = progress;
    downloadModel.completion = completion;
    self.downloadModelsDic[dataTask.taskDescription] = downloadModel;
    
    KCDownloadState downloadState;
    if ([self canResumeDownload]) {
        [self.downloadingModels addObject:downloadModel];
        [dataTask resume];
        downloadState = KCDownloadStateRunning;
    } else {
        [self.waitingModels addObject:downloadModel];
        downloadState = KCDownloadStateWaiting;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (downloadModel.state) {
            downloadModel.state(downloadState);
        }
    });
    
}


#pragma mark --- NSURLSession delegate
// get response
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    KCDownloadModel *downloadModel = self.downloadModelsDic[dataTask.taskDescription];
    if (!downloadModel) {
        return;
    }
    
    [downloadModel openOutputStream];
    
    NSInteger totalLength = (long)response.expectedContentLength + [self hasDownloadedLength:downloadModel.URL];
    downloadModel.totalLength = totalLength;
    NSMutableDictionary *filesTotalLength = [NSMutableDictionary dictionaryWithContentsOfFile:KCFilesTotalLengthPlistPath] ?: [NSMutableDictionary dictionary];
    filesTotalLength[KCFileName(downloadModel.URL)] = @(totalLength);
    [filesTotalLength writeToFile:KCFilesTotalLengthPlistPath atomically:YES];
    
    completionHandler(NSURLSessionResponseAllow);
}

// getting data
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    
    KCDownloadModel *downloadModel = self.downloadModelsDic[dataTask.taskDescription];
    if (!downloadModel) {
        return;
    }
    [downloadModel.outputStream write:data.bytes maxLength:data.length];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (downloadModel.progress) {
            NSUInteger receivedSize = [self hasDownloadedLength:downloadModel.URL];
            NSUInteger expectedSize = downloadModel.totalLength;
            if (expectedSize == 0) {
                return;
            }
            CGFloat progress = 1.0 * receivedSize / expectedSize;
            downloadModel.progress(receivedSize, expectedSize, progress);
        }
    });
    
}
// getted done
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    
    if (error && error.code == -999) { // cancel task
        return;
    }
    
    KCDownloadModel *downloadModel = self.downloadModelsDic[task.taskDescription];
    if (!downloadModel) {
        return;
    }
    [downloadModel closeOutputStream];
    
    
    
    [self.downloadModelsDic removeObjectForKey:task.taskDescription];
    [self.downloadingModels removeObject:downloadModel];

    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self isDownloadCompletedOfURL:downloadModel.URL]) {
            NSString *destPath = downloadModel.destPath;
            NSString *fullPath = [self fileFullPathOfURL:downloadModel.URL];
            if (destPath) {
                NSError *error;
                if (![[NSFileManager defaultManager] moveItemAtPath:fullPath toPath:destPath error:&error]) {
                    NSLog(@"moveItemAtPath error: %@", error);
                }
            }
            if (downloadModel.state) {
                downloadModel.state(KCDownloadStateCompleted);
            }
            if (downloadModel.completion) {
                downloadModel.completion(YES, destPath ?: fullPath, error);
            }
        } else {
            if (downloadModel.state) {
                downloadModel.state(KCDownloadStateFailed);
            }
            if (downloadModel.completion) {
                downloadModel.completion(NO, nil, error);
            }
        }
    });
    
    [self resumeNextDowloadModel];
    
}


#pragma mark --- Assist Methods

- (BOOL)canResumeDownload {
    
    if (self.maxConcurrentCount == -1) {
        return YES;
    }
    if (self.downloadingModels.count >= self.maxConcurrentCount) {
        return NO;
    }
    return YES;
}


- (NSInteger)totalLength:(NSURL *)URL {
    
    NSDictionary *filesTotalLenth = [NSDictionary dictionaryWithContentsOfFile:KCFilesTotalLengthPlistPath];
    if (!filesTotalLenth) {
        return 0;
    }
    if (!filesTotalLenth[KCFileName(URL)]) {
        return 0;
    }
    return [filesTotalLenth[KCFileName(URL)] integerValue];
}

- (NSInteger)hasDownloadedLength:(NSURL *)URL {
    
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[self fileFullPathOfURL:URL] error:nil];
    if (!fileAttributes) {
        return 0;
    }
    return [fileAttributes[NSFileSize] integerValue];
}

- (void)resumeNextDowloadModel {
    
    if (self.maxConcurrentCount == -1) { // no limit so no waiting for download models
        return;
    }
    
    if (self.waitingModels.count == 0) {
        return;
    }
    
    KCDownloadModel *downloadModel;
    switch (self.waitingQueueMode) {
        case KCWaitingQueueModeFIFO:
            downloadModel = self.waitingModels.firstObject;
            break;
        case KCWaitingQueueModeFILO:
            downloadModel = self.waitingModels.lastObject;
            break;
    }
    [self.waitingModels removeObject:downloadModel];
    
    KCDownloadState downloadState;
    if ([self canResumeDownload]) {
        [self.downloadingModels addObject:downloadModel];
        [downloadModel.dataTask resume];
        downloadState = KCDownloadStateRunning;
    } else {
        [self.waitingModels addObject:downloadModel];
        downloadState = KCDownloadStateWaiting;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (downloadModel.state) {
            downloadModel.state(downloadState);
        }
    });
}


#pragma mark - Public Methods

- (BOOL)isDownloadCompletedOfURL:(NSURL *)URL {
    
    NSInteger totalLength = [self totalLength:URL];
    if (totalLength != 0) {
        if (totalLength == [self hasDownloadedLength:URL]) {
            return YES;
        }
    }
    return NO;
}


- (void)setSaveFilesDirectory:(NSString *)saveFilesDirectory {
    
    _saveFilesDirectory = saveFilesDirectory;
    
    if (!saveFilesDirectory) {
        return;
    }
    BOOL isDirectory = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:saveFilesDirectory isDirectory:&isDirectory];
    if (!isExists || !isDirectory) {
        [fileManager createDirectoryAtPath:saveFilesDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
}


#pragma mark - Downloads
- (void)suspendDownloadOfURL:(NSURL *)URL {
    
    KCDownloadModel *downloadModel = self.downloadModelsDic[KCFileName(URL)];
    if (!downloadModel) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (downloadModel.state) {
            downloadModel.state(KCDownloadStateSuspended);
        }
    });
    if ([self.waitingModels containsObject:downloadModel]) {
        [self.waitingModels removeObject:downloadModel];
    } else {
        [downloadModel.dataTask suspend];
        [self.downloadingModels removeObject:downloadModel];
    }
    
    [self resumeNextDowloadModel];
}

- (void)suspendAllDownloads {
    
    if (self.downloadModelsDic.count == 0) {
        return;
    }
    
    if (self.waitingModels.count > 0) {
        for (NSInteger i = 0; i < self.waitingModels.count; i++) {
            KCDownloadModel *downloadModel = self.waitingModels[i];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (downloadModel.state) {
                    downloadModel.state(KCDownloadStateSuspended);
                }
            });
        }
        [self.waitingModels removeAllObjects];
    }
    
    if (self.downloadingModels.count > 0) {
        for (NSInteger i = 0; i < self.downloadingModels.count; i++) {
            KCDownloadModel *downloadModel = self.downloadingModels[i];
            [downloadModel.dataTask suspend];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (downloadModel.state) {
                    downloadModel.state(KCDownloadStateSuspended);
                }
            });
        }
        [self.downloadingModels removeAllObjects];
    }
}

- (void)resumeDownloadOfURL:(NSURL *)URL {
    
    KCDownloadModel *downloadModel = self.downloadModelsDic[KCFileName(URL)];
    if (!downloadModel) {
        return;
    }
    
    KCDownloadState downloadState;
    if ([self canResumeDownload]) {
        [self.downloadingModels addObject:downloadModel];
        [downloadModel.dataTask resume];
        downloadState = KCDownloadStateRunning;
    } else {
        [self.waitingModels addObject:downloadModel];
        downloadState = KCDownloadStateWaiting;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (downloadModel.state) {
            downloadModel.state(downloadState);
        }
    });
}

- (void)resumeAllDownloads {
    
    if (self.downloadModelsDic.count == 0) {
        return;
    }
    
    NSArray *downloadModels = self.downloadModelsDic.allValues;
    for (KCDownloadModel *downloadModel in downloadModels) {
        KCDownloadState downloadState;
        if ([self canResumeDownload]) {
            [self.downloadingModels addObject:downloadModel];
            [downloadModel.dataTask resume];
            downloadState = KCDownloadStateRunning;
        } else {
            [self.waitingModels addObject:downloadModel];
            downloadState = KCDownloadStateWaiting;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (downloadModel.state) {
                downloadModel.state(downloadState);
            }
        });
    }
}


- (void)cancelDownloadOfURL:(NSURL *)URL {
    
    KCDownloadModel *downloadModel = self.downloadModelsDic[KCFileName(URL)];
    if (!downloadModel) {
        return;
    }
    
    [downloadModel closeOutputStream];
    [downloadModel.dataTask cancel];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (downloadModel.state) {
            downloadModel.state(KCDownloadStateCanceled);
        }
    });
    
    if ([self.waitingModels containsObject:downloadModel]) {
        [self.waitingModels removeObject:downloadModel];
    } else {
        [self.downloadingModels removeObject:downloadModel];
    }
    [self.downloadModelsDic removeObjectForKey:KCFileName(URL)];
    
    [self resumeNextDowloadModel];
}

- (void)cancelAllDownloads {
    
    if (self.downloadModelsDic.count == 0) {
        return;
    }
    
    NSArray *downloadModels = self.downloadModelsDic.allValues;
    for (KCDownloadModel *downloadModel in downloadModels) {
        [downloadModel closeOutputStream];
        [downloadModel.dataTask cancel];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (downloadModel.state) {
                downloadModel.state(KCDownloadStateCanceled);
            }
        });
    }
    
    [self.waitingModels removeAllObjects];
    [self.downloadingModels removeAllObjects];
    [self.downloadModelsDic removeAllObjects];
}

#pragma mark - Files
- (NSString *)fileFullPathOfURL:(NSURL *)URL {
    
    return KCFilePath(URL);
}

- (CGFloat)fileHasDownloadedProgressOfURL:(NSURL *)URL {
    
    if ([self isDownloadCompletedOfURL:URL]) {
        return 1.0;
    }
    if ([self totalLength:URL] == 0) {
        return 0.0;
    }
    return 1.0 * [self hasDownloadedLength:URL] / [self totalLength:URL];
}

- (void)deleteFile:(NSString *)fileName {
    
    NSMutableDictionary *filesTotalLenth = [NSMutableDictionary dictionaryWithContentsOfFile:KCFilesTotalLengthPlistPath];
    [filesTotalLenth removeObjectForKey:fileName];
    [filesTotalLenth writeToFile:KCFilesTotalLengthPlistPath atomically:YES];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [KCDownloadDirectory stringByAppendingPathComponent:fileName];
    if (![fileManager fileExistsAtPath:filePath]) {
        return;
    }
    [fileManager removeItemAtPath:filePath error:nil];
}

- (void)deleteFileOfURL:(NSURL *)URL {
    
    [self cancelDownloadOfURL:URL];
    
    [self deleteFile:KCFileName(URL)];
}

- (void)deleteAllFiles {
    
    [self cancelAllDownloads];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileNames = [fileManager contentsOfDirectoryAtPath:KCDownloadDirectory error:nil];
    for (NSString *fileName in fileNames) {
        NSString *filePath = [KCDownloadDirectory stringByAppendingPathComponent:fileName];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

/*
 <LKDownLoadModel: 0x1c4294cd0>
 <__NSCFLocalDataTask: 0x111d2ae60>{ taskIdentifier: 1 } { running }

 
 <LKDownLoadModel: 0x1c4294cd0>
 <__NSCFLocalDataTask: 0x111d2ae60>{ taskIdentifier: 1 } { suspended }
 
 
 <LKDownLoadModel: 0x1c4294cd0>
 <__NSCFLocalDataTask: 0x111d2ae60>{ taskIdentifier: 1 } { suspended }
 */

@end
