//
//  NSString+NDLSecurity.h
//  NDL_Category
//
//  Created by dzcx on 2018/6/25.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NDLSecurity)
// AES
- (instancetype)ndl_aesEncrypt;
- (instancetype)ndl_aesDecrypt;
// RSA
// Certificate Signing Request,证书请求,CSR文件

/*
 CRT扩展用于证书  证书可以被编码为二进制DER或ASCII PEM
 
 // 512密钥位数(512bit)
 1.创建私钥，生成安全强度是512（也可以是1024）的RAS私钥，.pem是base64(ASCII)的证书文件
 openssl genrsa -out private.pem 512
 
 2.生成一个证书请求，生成证书请求文件.csr  密码:1234567890
 openssl req -new -key private.pem -out rsacert.csr
 
 3.签名，找证书颁发机构签名，证明证书合法有效的，也可以自签名一个证书
 生成证书并签名，有效期10年，生成一个.crt的一个base64公钥文件   .crt = 证书
 openssl x509 -req -days 3650 -in rsacert.csr -signkey private.pem -out rsacert.crt
 由于iOS开发时使用的时候不能是base64的，必须解成二进制文件
 
 4.解成.der公钥二进制文件，放程序做加密用   .der = 二进制DER编码证书
 openssl x509 -outform der -in rsacert.crt -out rsacert.der
 
 5.生成.p12二进制私钥文件  .pem 是base64的不能直接使用，必须导成.p12信息交换文件用来传递秘钥  export密码:ndl
 openssl pkcs12 -export -out p.p12 -inkey private.pem -in rsacert.crt
 
 ###加密解密使用了两种文件 .p12是私钥 .der是公钥###
 
 ###证书转换 在服务器人员，给你发送的crt证书后，进到证书路径
 openssl x509 -in 你的证书.crt -out 你的证书.cer -outform der 这样你就可以得到cer类型的证书了###
 */

@end
