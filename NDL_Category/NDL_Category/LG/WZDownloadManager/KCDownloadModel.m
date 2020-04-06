//
//  KCDownloadModel.m
//  KCDownloadManagerDemo
//
//  Created by cooci on 17/2/7.
//  Copyright © 2017年 cooci. All rights reserved.
//

#import "KCDownloadModel.h"

@implementation KCDownloadModel

- (void)closeOutputStream {
    
    if (!_outputStream) {
        return;
    }
    if (_outputStream.streamStatus > NSStreamStatusNotOpen && _outputStream.streamStatus < NSStreamStatusClosed) {
        [_outputStream close];
    }
    _outputStream = nil;
}

- (void)openOutputStream {
    
    if (!_outputStream) {
        return;
    }
    [_outputStream open];
}

@end
