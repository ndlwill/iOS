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
    
    NSString* resultStr = [regex stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:@""];
    
    return resultStr;
}

@end
