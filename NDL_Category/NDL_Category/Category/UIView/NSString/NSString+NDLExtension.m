//
//  NSString+NDLExtension.m
//  NDL_Category
//
//  Created by ndl on 2018/1/8.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "NSString+NDLExtension.h"
#import <CommonCrypto/CommonDigest.h>
#import "CommonDefines.h"

@implementation NSString (NDLExtension)

- (BOOL)ndl_isPhoneNumber
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    NSString * CT = @"^1((33|53|8[09]|7[0-9])[0-9]|349)\\d{7}$";
    
    NSString *PHS = @"^((0\\d{2,3}-?\\d{7,8})|(1[3584]\\d{9}))$";
    
    NSString *DH = @"^(\\d{3})$";
    
    NSString *TY = @"^1([0-9][0-9])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    NSPredicate *regextestdh = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",DH];
    NSPredicate *regextestty = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",TY];
    
    BOOL res1 = [regextestmobile evaluateWithObject:self];
    BOOL res2 = [regextestcm evaluateWithObject:self];
    BOOL res3 = [regextestcu evaluateWithObject:self];
    BOOL res4 = [regextestct evaluateWithObject:self];
    BOOL res5 = [regextestdh evaluateWithObject:self];
    BOOL res6 = [regextestphs evaluateWithObject:self];
    BOOL res7 = [regextestty evaluateWithObject:self];
    
    if (res1 || res2 || res3 || res4 || res5 || res6 || res7){
        return YES;
    }
    else {
        return NO;
    }
}

- (NSArray *)ndl_phoneNumberContained
{
    NSError *error;
    
    NSString *TY = @"1([0-9][0-9])\\d{8}";
    
    NSString *PHS = @"((0\\d{2,3}-?\\d{7,8})|(1[3584]\\d{9}))";
    
    NSRegularExpression *regexTY = [NSRegularExpression
                                    regularExpressionWithPattern:TY
                                    options:NSRegularExpressionCaseInsensitive
                                    error:&error];
    
    NSArray *arrayOfAllMatchesTY = [regexTY matchesInString:self options:0 range:NSMakeRange(0, [self length])];
    
    NSRegularExpression *regexPHS = [NSRegularExpression
                                     regularExpressionWithPattern:PHS
                                     options:NSRegularExpressionCaseInsensitive
                                     error:&error];
    
    NSArray *arrayOfAllMatchesPHS = [regexPHS matchesInString:self options:0 range:NSMakeRange(0, [self length])];
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (NSTextCheckingResult *match in arrayOfAllMatchesTY) {
        NSString *str = [self substringWithRange:match.range];
        [resultArray addObject:str];
    }
    
    for (NSTextCheckingResult *match in arrayOfAllMatchesPHS) {
        NSString *str = [self substringWithRange:match.range];
        [resultArray addObject:str];
    }
    
    NSMutableArray *strArray = [NSMutableArray array];
    for (int i = 0; i < resultArray.count; i++) {
        if (![strArray containsObject:resultArray[i]]) {
            [strArray addObject:resultArray[i]];
        }
    }
    
    return strArray;
}

+ (instancetype)ndl_generateRandomStringWithLength:(NSUInteger)length
{
    NSString *srcString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [NSMutableString string];
    for (int i = 0; i < length; i++) {
        //unsigned int
        NSInteger index = arc4random_uniform((unsigned int)srcString.length);
        NSString *charStr = [srcString substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:charStr];
    }
    
    return resultStr;
}

- (instancetype)ndl_md5String
{
    const char *cStr = [self UTF8String];
    if (cStr == NULL) {
        cStr = "";
    }
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    
//    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
//    unsigned char result[CC_MD5_DIGEST_LENGTH];
//    CC_MD5(data.bytes, (CC_LONG)data.length, result);
//    return [NSString stringWithFormat:
//            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
//            result[0],  result[1],  result[2],  result[3],
//            result[4],  result[5],  result[6],  result[7],
//            result[8],  result[9],  result[10], result[11],
//            result[12], result[13], result[14], result[15]
//            ];
}


- (NSString *)ndl_removeCharacterAtIndex:(NSUInteger)index
{
    NSRange rangeToRemove = [self rangeOfComposedCharacterSequenceAtIndex:index];
    NSString *resultStr = [self stringByReplacingCharactersInRange:rangeToRemove withString:@""];
    return resultStr;
}


+ (instancetype)ndl_launchImageName
{
    NSString *viewOrientation = @"Portrait";
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        viewOrientation = @"Landscape";
    }
    NSString *launchImageName = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    CGSize viewSize = KeyWindow.bounds.size;
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImageName = dict[@"UILaunchImageName"];
        }
    }
    return launchImageName;
}

- (instancetype)ndl_stringWithoutEmoji
{
    //  \u0020-\\u007E  标点符号，大小写字母，数字
    //  \u00A0-\\u00BE  特殊标点  (¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾)
    //  \u2E80-\\uA4CF  繁简中文,日文，韩文 彝族文字
    //  \uF900-\\uFAFF  部分汉字
    //  \uFE30-\\uFE4F  特殊标点(︴︵︶︷︸︹)
    //  \uFF00-\\uFFEF  日文  (ｵｶｷｸｹｺｻ)
    //  \u2000-\\u201f  特殊字符(‐‑‒–—―‖‗‘’‚‛“”„‟)
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    // 把匹配到的替换为@""
    NSString* resultStr = [regex stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:@""];
    
    return resultStr;
}

- (instancetype)ndl_json2string:(NSDictionary *)jsonDic
{
    if (!jsonDic) {
        return nil;
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSAttributedString *)ndl_attrStrWithAttrDic:(NSDictionary *)attrDic range:(NSRange)range
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self];
    [attrStr setAttributes:attrDic range:range];
    return [attrStr copy];
}

- (instancetype)ndl_CN2UTF8String
{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];// ios9 deprecate
}

- (instancetype)ndl_UTF8String2CN
{
    return [self stringByRemovingPercentEncoding];
//    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];// ios9 deprecate
}


/*
🤨
Unicode: U+1F928，UTF-8: F0 9F A4 A8
 */
- (instancetype)ndl_emojiStringEncoding
{
    NSData *data = [self dataUsingEncoding:NSNonLossyASCIIStringEncoding];// self: 🤨
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];// return:\ud83e\udd28
}

- (instancetype)ndl_emojiStringDecoding
{
    const char *cStr = [self UTF8String];// self:\ud83e\udd28
    NSData *data = [NSData dataWithBytes:cStr length:strlen(cStr)];
    return [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];// return:🤨
}

// NSLog(@"\"");->输出“,\是转义符  NSLog(@"\\\"");->输出\"
- (instancetype)ndl_unicode2UTF8
{
    NSString *tempStr1 = [self stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *data = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *returnStr = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:NULL];// ios8 deprecate
    
    NSString *returnStr = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable  format:NULL  error:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

+ (instancetype)ndl_integerStr:(NSInteger)value
{
    return [NSString stringWithFormat:@"%@", @(value)];
}

+ (instancetype)ndl_cgfloatStr:(CGFloat)value decimal:(NSUInteger)decimal
{
    NSString *formatStr = [NSString stringWithFormat:@"%%.%@f",@(decimal)];
    return [NSString stringWithFormat:formatStr, value];
}

+ (instancetype)ndl_hexStringFromDecimalSystemValue:(NSInteger)value
{
    NSString *hexString = @"";
    NSInteger remainder = 0;
    for (NSInteger i = 0; i < 9; i++) {
        remainder = value % 16;
        value = value / 16;
        NSString *letter = [self hexLetterStringWithInteger:remainder];
        hexString = [letter stringByAppendingString:hexString];
        if (value == 0) {
            break;
        }
        
    }
    return hexString;
}

// letter:字母
+ (NSString *)hexLetterStringWithInteger:(NSInteger)integer {
    NSAssert(integer < 16, @"要转换的数必须是16进制里的个位数，也即小于16，但你传给我是%@", @(integer));
    
    NSString *letter = nil;
    switch (integer) {
        case 10:
            letter = @"A";
            break;
        case 11:
            letter = @"B";
            break;
        case 12:
            letter = @"C";
            break;
        case 13:
            letter = @"D";
            break;
        case 14:
            letter = @"E";
            break;
        case 15:
            letter = @"F";
            break;
        default:
            letter = [[NSString alloc]initWithFormat:@"%@", @(integer)];
            break;
    }
    return letter;
}

- (instancetype)ndl_trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (instancetype)ndl_trimAllWhiteSpace
{
    return [self stringByReplacingOccurrencesOfString:@"\\s" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
}

- (instancetype)ndl_removeSpecialCharacter
{
    if (self.length == 0) {
        return self;
    }
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\u0300-\u036F]" options:NSRegularExpressionCaseInsensitive error:&error];
    return [regex stringByReplacingMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length) withTemplate:@""];
}

- (instancetype)ndl_extractDigit
{
    NSCharacterSet *nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [self stringByTrimmingCharactersInSet:nonDigits];
}

+ (instancetype)ndl_stringWithTimeInterval:(NSTimeInterval)timeInterval
{
    NSInteger minute = timeInterval / 60;
    NSInteger second = (NSInteger)round(timeInterval) % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", minute ,second];
}

- (NSUInteger)ndl_numberOfBytesWhenGBKEncoding
{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [self dataUsingEncoding:encoding];
    return data.length;
}

- (NSUInteger)ndl_numberOfBytesWhenCountingNonASCIICharacterAsTwo
{
    NSUInteger numberOfBytes = 0;
    char *p = (char *)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (NSInteger i = 0, l = [self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i < l; i++) {
        if (*p) {
            numberOfBytes++;
        }
        p++;
    }
    return numberOfBytes;
}

- (BOOL)ndl_matchFirstLetter
{
    NSString *letterRegex = @"^[A-Za-z]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", letterRegex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)ndl_isWholeCN
{
    if (self.length == 0) {
        return NO;
    }
    NSString *regex = @"[\u4e00-\u9fa5]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)ndl_isWholeDigit
{
    if (self.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]*";// 写了*上面必须写 不写的话不然@""也能匹配成功
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)ndl_isWholeLetter
{
    if (self.length == 0) {
        return NO;
    }
    NSString *regex = @"[a-zA-Z]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:self];
}

@end
