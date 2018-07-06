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

// json(dic)->string
- (instancetype)ndl_json2string:(NSDictionary *)jsonDic;

// 设置字符串的一段富文本
- (NSAttributedString *)ndl_attrStrWithAttrDic:(NSDictionary *)attrDic range:(NSRange)range;

// GBK中文@"我们是888AAaa中国人"->UTF8 // 对字符串进行UTF-8编码
- (instancetype)ndl_CN2UTF8String;

// UTF8(eg:%E6%88%91)->GBK中文(eg:@"我")
- (instancetype)ndl_UTF8String2CN;

// 含有emoji的字符串 编码(上传服务器) 🤨->\ud83e\udd28 （8🤨w我->8\ud83e\udd28w\u6211）
- (instancetype)ndl_emojiStringEncoding;
// 含有emoji的字符串 解码(请求服务器获取) \ud83e\udd28->🤨
- (instancetype)ndl_emojiStringDecoding;
// unicodeStr->UTF8Str \ud83e\udd28->🤨 和上面方法一样的效果
- (instancetype)ndl_unicode2UTF8;

// 10->@"10"
+ (instancetype)ndl_integerStr:(NSInteger)value;
// 10.12->@"10.12"
+ (instancetype)ndl_cgfloatStr:(CGFloat)value decimal:(NSUInteger)decimal;

// 十进制数字->十六进制字符串 “10”->“A”
+ (instancetype)ndl_hexStringFromDecimalSystemValue:(NSInteger)value;

// 去除头尾空白字符(空格)
- (instancetype)ndl_trim;
// 去除所有的空白字符
- (instancetype)ndl_trimAllWhiteSpace;

// 去除特殊字符
- (instancetype)ndl_removeSpecialCharacter;

// 提取字符串中的数字
- (instancetype)ndl_extractDigit;

// double 分:秒 00:00
+ (instancetype)ndl_stringWithTimeInterval:(NSTimeInterval)timeInterval;

// GBK编码下的字节数
- (NSUInteger)ndl_numberOfBytesWhenGBKEncoding;

// 所占字节数 一个汉字占两个字节，一个英文字母占一个字节
- (NSUInteger)ndl_numberOfBytesWhenCountingNonASCIICharacterAsTwo;

@end
