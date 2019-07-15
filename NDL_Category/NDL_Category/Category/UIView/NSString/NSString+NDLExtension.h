//
//  NSString+NDLExtension.h
//  NDL_Category
//
//  Created by ndl on 2018/1/8.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 code point & code unit
 
 Unicode:
 是世界通用的字符编码标准
 
 code point即码字
 
 UTF-8：使用变长的字节序列来表示字符；某个字符(对应一个code point)可能使用1-4个字节才能表示；这样1个字节就是一个code unit，即代码单元。代表最小的可用来识别一个合法字符的最小字节数；即一个code point可能由1-4个code unit组成，code unit为一个字节
 UTF-16：使用变长字节序列来表示字符；某个字符(对应一个code point)可能使用2个或者4个字节来表示；这样2个字节就是一个code unit；因为2个字节序列是最小的能够识别一个code point的单位；即一个code point可能由1-2个code unit组成，code unit为2个字节
 UTF-32：定长的4个字节表示一个字符；一个code point对应一个4字节的序列，这样4个字节数就是一个code unit。即一个code point由1个code unit组成，code unit为4个字节
 
 字符集（Code Set）是一个集合，集合中的元素就是字符
 为了在计算机中处理字符集，必须把字符集数字化，就是给字符集中的每一个字符一个编号，计算机程序中要用字符，直接用这个编号就可以了
 于是就出现了编码后的字符集，叫做编码字符集(Coded Code Set)
 Unicode是一个编码字符集
 编码字符集中每一个字符都和一个编号对应。那么这个编号就是码点（Code Point）
 
 代码单元（Code Unit）：是指一个已编码的文本中具有最短的比特组合的单元
 对于UTF-8来说，代码单元是8比特长；对于UTF-16来说，代码单元是16比特长
 换一种说法就是UTF-8的是以一个字节为最小单位的，UTF-16是以两个字节为最小单位的

 二进制:1字节，8位 0000 0000
 2^8=256
 2^16=65536
 
 65536个代码点为了统一表示每个代码点必须要有两个字节表示才行。但是为了节省空间0-127的ASCII码就可以不用两个字节来表示，只需要一个字节，于是不同的表示方案就形成了不同的编码方案，比如utf-8、utf-16等。对utf-8而言代码单元就是一个字节，对utf-16而言代码单元就是两个字节
 */

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

// 移除指定位置的字符，可兼容emoji表情的情况 ###已确认###
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
// 十进制数字->十六进制字符串（设置十六进制长度，不足补0）
+ (instancetype)ndl_hexStringWithLength:(NSUInteger)length fromDecimalSystemValue:(NSInteger)value;
// 十六进制字符串->十进制数字
- (NSUInteger)ndl_hex2Decimal;
// 二进制字符串->十进制数字
- (NSUInteger)ndl_binary2Decimal;
// 十进制数字->二进制字符串
+ (instancetype)ndl_binaryStringFromDecimalSystemValue:(NSInteger)value;
// 十六进制字符串->NSData
- (NSData *)ndl_dataFromHexString;

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

// eg:@"s"   匹配单个字符串是不是字母
- (BOOL)ndl_matchFirstLetter;

// 常用正则表达式 http://tool.oschina.net/regex/#
// 汉字字符集编码查询 http://www.qqxiuzi.cn/bianma/zifuji.php
// 汉字的Unicode编码范围为/u4E00-/u9FA5 /uF900-/uFA2D,
// 是否全汉字
- (BOOL)ndl_isWholeCN;
// 是否全数字
- (BOOL)ndl_isWholeDigit;
// 是否全字母
- (BOOL)ndl_isWholeLetter;
// 字母或数字 @"[a-zA-Z0-9]*"

+ (instancetype)ndl_fileMD5WithFilePath:(NSString *)filePath;

@end
