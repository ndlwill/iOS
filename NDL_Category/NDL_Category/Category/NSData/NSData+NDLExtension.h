//
//  NSData+NDLExtension.h
//  NDL_Category
//
//  Created by dzcx on 2018/11/13.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (NDLExtension)
// spliceStr: 拼接符
- (NSString *)ndl_convertData2StrWithSpliceStr:(NSString *)spliceStr;

- (NSString *)ndl_convertData2HexStr;

@end

NS_ASSUME_NONNULL_END
