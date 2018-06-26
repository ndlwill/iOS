//
//  SecurityUtils.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/26.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "SecurityUtils.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation SecurityUtils
{
    SecKeyRef _publicKeyRef;
    SecKeyRef _privateKeyRef;
}

- (void)loadPublicKeyWithFilePath:(NSString *)filePath
{
    if (_publicKeyRef) {
        CFRelease(_publicKeyRef);
    }
    
    // 从一个 DER 表示的证书创建一个证书对象
    NSData *derCertData = [NSData dataWithContentsOfFile:filePath];
    SecCertificateRef derCertRef = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)derCertData);
    NSAssert(derCertRef != NULL, @"公钥文件错误");
    
    // 返回一个默认 X509 策略的公钥对象，使用之后需要调用 CFRelease 释放
    SecPolicyRef policyRef = SecPolicyCreateBasicX509();
    // 包含信任管理信息的结构体
    SecTrustRef trustRef;
    // 基于证书和策略创建一个信任管理对象
    OSStatus status = SecTrustCreateWithCertificates(derCertRef, policyRef, &trustRef);
    NSAssert(status == errSecSuccess, @"创建信任管理对象失败");
    
    // 信任结果
    SecTrustResultType trustResult;
    // 评估指定证书和策略的信任管理是否有效
    status = SecTrustEvaluate(trustRef, &trustResult);
    NSAssert(status == errSecSuccess, @"信任评估失败");
    
    // 评估之后返回公钥子证书
    _publicKeyRef = SecTrustCopyPublicKey(trustRef);
    NSAssert(_publicKeyRef != NULL, @"公钥创建失败");
    
    if (derCertRef) CFRelease(derCertRef);
    if (policyRef) CFRelease(policyRef);
    if (trustRef) CFRelease(trustRef);
}

- (void)loadPrivateKeyWithFilePath:(NSString *)filePath password:(NSString *)password
{
    // 删除当前私钥
    if (_privateKeyRef) CFRelease(_privateKeyRef);
    
    NSData *PKCS12Data = [NSData dataWithContentsOfFile:filePath];
    CFDataRef inPKCS12Data = (__bridge CFDataRef)PKCS12Data;
    CFStringRef passwordRef = (__bridge CFStringRef)password;
    
    // 从 PKCS #12 证书中提取标示和证书
    SecIdentityRef myIdentity;
    SecTrustRef myTrust;
    const void *keys[] = {kSecImportExportPassphrase};
    const void *values[] = {passwordRef};
    CFDictionaryRef optionsDictionary = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    
    // 返回 PKCS #12 格式数据中的标示和证书
    OSStatus status = SecPKCS12Import(inPKCS12Data, optionsDictionary, &items);
    
    if (status == noErr) {
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex(items, 0);
        myIdentity = (SecIdentityRef)CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemIdentity);
        myTrust = (SecTrustRef)CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemTrust);
    }
    
    if (optionsDictionary) CFRelease(optionsDictionary);
    
    NSAssert(status == noErr, @"提取身份和信任失败");
    
    SecTrustResultType trustResult;
    // 评估指定证书和策略的信任管理是否有效
    status = SecTrustEvaluate(myTrust, &trustResult);
    NSAssert(status == errSecSuccess, @"信任评估失败");
    
    // 提取私钥
    status = SecIdentityCopyPrivateKey(myIdentity, &_privateKeyRef);
    NSAssert(status == errSecSuccess, @"私钥创建失败");
    
    CFRelease(items);
}

- (NSString *)RSAEncryptString:(NSString *)string
{
    NSAssert(_publicKeyRef, @"公钥为空");
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSAssert(data, @"明文数据为空");
    
    OSStatus status = noErr;
    size_t cipherBufferSize = 0;// 密文缓冲区长度
    size_t dataBufferSize = 0;// 原始data缓冲区长度
    
    NSData *cipher = nil;// 生成的密文data
    uint8_t *cipherBuffer = NULL;// 生成的密文缓冲区
    
    // 计算缓冲区大小
    cipherBufferSize = SecKeyGetBlockSize(_publicKeyRef);
    dataBufferSize = data.length;
    
    if (kSecPaddingPKCS1 == kSecPaddingNone) {
        NSAssert(dataBufferSize <= cipherBufferSize, @"加密内容太大");
    } else {
        NSAssert(dataBufferSize <= (cipherBufferSize - 11), @"加密内容太大");
    }
    
    // 分配密文缓冲区
    cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    memset((void *)cipherBuffer, 0x0, cipherBufferSize);
    
    // 使用公钥加密
    status = SecKeyEncrypt(_publicKeyRef,
                                kSecPaddingPKCS1,
                                (const uint8_t *)data.bytes,
                                dataBufferSize,
                                cipherBuffer,
                                &cipherBufferSize
                                );
    
    NSAssert(status == noErr, @"加密错误，OSStatus == %d", status);
    
    // 生成密文数据
    cipher = [NSData dataWithBytes:(const void *)cipherBuffer length:(NSUInteger)cipherBufferSize];
    
    if (cipherBuffer) free(cipherBuffer);
    
    return [cipher base64EncodedStringWithOptions:0];
}

- (NSString *)RSADecryptString:(NSString *)string
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:0];
    
    OSStatus sanityCheck = noErr;
    size_t cipherBufferSize = 0;
    size_t dataBufferSize = 0;
    
    NSData *originData = nil;// 解密后的原始data
    uint8_t *dataBuffer = NULL;// 数据缓冲区
    
    SecKeyRef privateKey = _privateKeyRef;
    NSAssert(privateKey != NULL, @"私钥不存在");
    
    // 计算缓冲区大小
    cipherBufferSize = SecKeyGetBlockSize(privateKey);
    dataBufferSize = data.length;
    
    NSAssert(dataBufferSize <= cipherBufferSize, @"解密内容太大");
    
    // 分配缓冲区
    dataBuffer = malloc(dataBufferSize * sizeof(uint8_t));
    memset((void *)dataBuffer, 0x0, dataBufferSize);
    
    // 使用私钥解密
    sanityCheck = SecKeyDecrypt(privateKey,
                                kSecPaddingPKCS1,
                                (const uint8_t *)data.bytes,
                                cipherBufferSize,
                                dataBuffer,
                                &dataBufferSize
                                );
    
    NSAssert1(sanityCheck == noErr, @"解密错误，OSStatus == %d", sanityCheck);
    
    // 生成明文数据
    originData = [NSData dataWithBytes:(const void *)dataBuffer length:(NSUInteger)dataBufferSize];
    
    if (dataBuffer) free(dataBuffer);
    
    return [[NSString alloc] initWithData:originData encoding:NSUTF8StringEncoding];
}

@end
