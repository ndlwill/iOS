//
//  NSString+NDLSecurity.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/25.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "NSString+NDLSecurity.h"
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"

@implementation NSString (NDLSecurity)

- (instancetype)ndl_aesEncrypt
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *aesData = [self _aes128WithOperation:kCCEncrypt data:data key:kAES_Key iv:kAES_IV];
    
    // 对aesData进行base64编码
    NSString *gtmBase64Str = [GTMBase64 stringByEncodingData:aesData];
    NSString *base64Str = [aesData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSLog(@"gtm = %@ ios = %@", gtmBase64Str, base64Str);
    
    return base64Str;
    
}

- (instancetype)ndl_aesDecrypt
{
    // 解码base64
    NSData *base64DecodedData = [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];// 解码后的data = aesData
//    NSData *gtmBase64DecodedData = [GTMBase64 decodeString:self];
    
    NSData *originData = [self _aes128WithOperation:kCCDecrypt data:base64DecodedData key:kAES_Key iv:kAES_IV];
    
    NSString *originStr = [[NSString alloc] initWithData:originData encoding:NSUTF8StringEncoding];
    return originStr;
}

// 128密钥长度
- (NSData *)_aes128WithOperation:(CCOperation)operation data:(NSData *)data key:(NSString *)key iv:(NSString *)iv
{
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    char cKey[kCCKeySizeAES128];
    bzero(cKey, sizeof(cKey));
    [keyData getBytes:cKey length:kCCKeySizeAES128];// 拷贝data的bytes到buffer
    
    NSData *ivData = [iv dataUsingEncoding:NSUTF8StringEncoding];
    char cIV[kCCBlockSizeAES128];
    bzero(cIV, sizeof(cIV));
    // 默认CBC mode
    // 若选择非ECB模式 kCCOptionPKCS7Padding
    int option = kCCOptionPKCS7Padding | kCCOptionECBMode;
    if (ivData) {
        [ivData getBytes:cIV length:kCCBlockSizeAES128];
        option = kCCOptionPKCS7Padding;
    }
    
    size_t bufferSize = [data length] + kCCBlockSizeAES128;// bytes
    void *buffer = malloc(bufferSize);
    
    size_t dataOutMoved = 0;
    CCCryptorStatus cryptorStatus = CCCrypt(operation, kCCAlgorithmAES128, option, cKey, kCCKeySizeAES128, cIV, data.bytes, data.length, buffer, bufferSize, &dataOutMoved);
    if (cryptorStatus == kCCSuccess) {
        NSLog(@"dataOutMoved = %ld", dataOutMoved);
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:dataOutMoved];
        return resultData;
    }
    free(buffer);
    // =========================================
    
    /*
    // char *
    char pKey[kCCKeySizeAES128 + 1];// 使用 null 字符 '\0' 终止
    bzero(pKey, sizeof(pKey));
    if (![key getCString:pKey maxLength:sizeof(pKey) encoding:NSUTF8StringEncoding]) {
        NSLog(@"pkey = nil");
    }
    
    char pIV[kCCBlockSizeAES128 + 1];
    bzero(pIV, sizeof(pIV));
    if (![iv getCString:pIV maxLength:sizeof(pIV) encoding:NSUTF8StringEncoding]) {
        NSLog(@"piv = nil");
    }
    
    size_t bufferSize = [data length] + kCCBlockSizeAES128;// bytes
    void *buffer = malloc(bufferSize);
    
    size_t dataOutMoved = 0;

//     CCCrypt
//     @param op#> 加密 || 解密 description#>
//     @param alg#> 加密算法 description#>
//     @param options#> 加密模式 description#>
//     @param key#> 秘钥 description#>
//     @param keyLength#> 密钥长度 description#>
//     @param iv#> 偏移向量 description#>
//     @param dataIn#> data数据 description#>
//     @param dataInLength#> data长度 description#>
//     @param dataOut#> 返回的数据 description#>
//     @param dataOutAvailable#> 返回的数据的长度 description#>
//     @param dataOutMoved#> 输出数据的长度 description#>
//     @return CCCryptorStatus
    
    CCCryptorStatus cryptorStatus = CCCrypt(operation, kCCAlgorithmAES128, kCCOptionPKCS7Padding, pKey, kCCKeySizeAES128, pIV, data.bytes, data.length, buffer, bufferSize, &dataOutMoved);
    if (cryptorStatus == kCCSuccess) {
        NSLog(@"dataOutMoved = %ld", dataOutMoved);
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:dataOutMoved];
        return resultData;
    }
    free(buffer);
    */
    return nil;
}

@end
