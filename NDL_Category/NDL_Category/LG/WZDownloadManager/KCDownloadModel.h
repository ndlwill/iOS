//
//  KCDownloadModel.h
//  KCDownloadManagerDemo
//
//  Created by cooci on 17/2/7.
//  Copyright © 2017年 cooci. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KCDownloadState) {
    KCDownloadStateWaiting,
    KCDownloadStateRunning,
    KCDownloadStateSuspended,
    KCDownloadStateCanceled,
    KCDownloadStateCompleted,
    KCDownloadStateFailed
};

@interface KCDownloadModel : NSObject

@property (nonatomic, strong) NSOutputStream *outputStream; // write datas to the file

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@property (nonatomic, strong) NSURL *URL;

@property (nonatomic, assign) NSInteger totalLength;

@property (nonatomic, copy) NSString *destPath;

@property (nonatomic, copy) void (^state)(KCDownloadState state);

@property (nonatomic, copy) void (^progress)(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress);

@property (nonatomic, copy) void (^completion)(BOOL isSuccess, NSString *filePath, NSError *error);

- (void)closeOutputStream;

- (void)openOutputStream;

@end
