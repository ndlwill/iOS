//
//  SecurityUtils.h
//  NDL_Category
//
//  Created by dzcx on 2018/6/26.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecurityUtils : NSObject
// RSA
// 加载公钥
- (void)loadPublicKeyWithFilePath:(NSString *)filePath;
// 加载私钥 password:导出时的密码ndl
- (void)loadPrivateKeyWithFilePath:(NSString *)filePath password:(NSString *)password;
// RSA 加密字符串 返回base64编码的String
- (NSString *)RSAEncryptString:(NSString *)string;
// RSA 解密字符串 string=base64编码的String
- (NSString *)RSADecryptString:(NSString *)string;

@end
