//
//  NSString+NDLExtension.h
//  NDL_Category
//
//  Created by ndl on 2018/1/8.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

// [@"" integerValue] = 0
@interface NSString (NDLExtension)

// 检测字符串是不是电话号码
- (BOOL)ndl_isPhoneNumber;

// 检测字符串中是否包含电话号码
- (NSArray *)ndl_phoneNumberContained;

// 生成随机字符串 length:订单号的长度
+ (instancetype)ndl_generateRandomStringWithLength:(NSUInteger)length;

// md5
- (instancetype)ndl_md5String;

// 移除指定位置的字符，可兼容emoji表情的情况（一个emoji表情占1-4个length）
- (NSString *)ndl_removeCharacterAtIndex:(NSUInteger)index;

// 获取launchImageName
+ (instancetype)ndl_launchImageName;

// 去除字符串中的emoji表情
- (instancetype)ndl_stringWithoutEmoji;

@end
