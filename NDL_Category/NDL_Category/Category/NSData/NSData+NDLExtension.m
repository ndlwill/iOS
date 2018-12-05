//
//  NSData+NDLExtension.m
//  NDL_Category
//
//  Created by dzcx on 2018/11/13.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "NSData+NDLExtension.h"

@implementation NSData (NDLExtension)

- (NSString *)ndl_convertData2StrWithSpliceStr:(NSString *)spliceStr
{
    if (self == nil || self.length == 0) {
        return @"";
    }
    // BytePtr 就是 Byte *
    BytePtr bytes = (BytePtr)[self bytes];
    NSMutableString *dataStr = [NSMutableString string];
    // self.length: the number of bytes
    for (NSInteger i = 0; i < self.length; i++) {
        if (i == 0) {
            [dataStr appendString:[NSString stringWithFormat:@"%d", bytes[i]]];
        } else {
            [dataStr appendString:spliceStr];
            [dataStr appendString:[NSString stringWithFormat:@"%d", bytes[i]]];
        }
    }
    return dataStr;
}

- (NSString *)ndl_convertData2HexStr
{
    if (self == nil || self.length == 0) {
        return @"";
    }
    NSMutableString *dataHexStr = [NSMutableString string];
    // 只走一次
    [self enumerateByteRangesUsingBlock:^(const void * _Nonnull bytes, NSRange byteRange, BOOL * _Nonnull stop) {
        // typedef unsigned char                   UInt8;
        UInt8 *dataBytes = (UInt8 *)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
//            NSString *hexStr = [NSString stringWithFormat:@"%x", dataBytes[i]];
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i] & 0xFF)];
            if (hexStr.length == 2) {
                [dataHexStr appendString:hexStr];
            } else {// 补位（补0）
                [dataHexStr appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return dataHexStr;
}

@end
