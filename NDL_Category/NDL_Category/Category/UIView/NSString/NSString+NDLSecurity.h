//
//  NSString+NDLSecurity.h
//  NDL_Category
//
//  Created by dzcx on 2018/6/25.
//  Copyright © 2018年 ndl. All rights reserved.
//

/*
 openssl:
 1.对称加密
 指定密钥和初始向量:
 $ openssl enc -aes-128-cbc -in in.txt -out out.txt -K 12345678901234567890 -iv 12345678
 将 in.txt 文件的内容进行加密后输出到 out.txt 中。这里通过 -K 指定密钥，-iv 指定初始向量。注意 AES 算法的密钥和初始向量都是 128 位的，这里 -K 和 -iv 后的参数都是 16 进制表示的，最大长度为 32。 即 -iv 1234567812345678 指定的初始向量在内存中为 | 12 34 56 78 12 34 56 78 00 00 00 00 00 00 00 00 |
 通过 -d 参数表示进行解密:
 $ openssl enc -aes-128-cbc -in in.txt -out out.txt -K 12345678901234567890 -iv 12345678 -d
 表示将加密的 in.txt 解密后输出到 out.txt 中
 
 
 通过字符串密码加/解密:
 $ openssl enc -aes-128-cbc -in in.txt -out out.txt -pass pass:helloworld
 这时程序会根据字符串 "helloworld" 和随机生成的 salt 生成密钥和初始向量，也可以用 -nosalt 不加盐。
 
 2.RSA
 使用 genrsa 子命令生成密钥对，密钥对是一个文件
 // 生成密钥长度为 2048 比特
 $ openssl genrsa -out mykey.pem 2048
 
 从密钥对中分离出公钥:
 $ openssl rsa -in mykey.pem -pubout -out mypubkey.pem
 
 校验密码对文件是否正确:
 // -noout 参数表示不打印密钥对信息，如果校验成功，说明密钥对文件无误
 $ openssl rsa -in mykey.pem -check -noout
 
 显示公钥信息:
 $ openssl rsa -pubin -in mypubkey.pem -text
 Modulus 是 RSA 加密结构中的 N。Exponent 是公钥中的 E。-----BEGIN PUBLIC KEY----- 和 -----END PUBLIC KEY----- 之间是公钥具体的值
 
 使用密钥对加密:
 // rsautl 命令默认填充机制是 PKCS#1 v1.5
 $ openssl rsautl -encrypt -inkey mykey.pem -in plain.txt -out cipher.txt
 // 指定 rsautl 填充机制为 PKCS#1 OAEP
 $ openssl rsautl -encrypt -inkey mykey.pem -in plain.txt -out cipher.txt -oaep
 
 使用公钥加密，务必有 -pubin 参数表明 -inkey 参数输入的是公钥文件:
 $ openssl rsautl -encrypt -pubin -inkey mypubkey.pem -in plain.txt -out cipher2.txt
 
 解密:
 $ openssl rsautl -decrypt -inkey mykey.pem -in cipher.txt
 */

#import <Foundation/Foundation.h>

@interface NSString (NDLSecurity)
// AES
/*
 参数统一
 密钥长度（Key Size）
 加密模式（Cipher Mode） AES属于块加密（Block Cipher），块加密中有CBC、ECB、CTR、OFB、CFB等几种工作模式
 填充方式（Padding） 由于块加密只能对特定长度的数据块进行加密，因此CBC、ECB模式需要在最后一数据块加密前进行数据填充
 （CFB，OFB和CTR模式由于与key进行加密操作的是上一块加密后的密文，因此不需要对最后一段明文进行填充）
 
 // 1byte=8bits
 初始向量（Initialization Vector）使用除ECB以外的其他加密模式均需要传入一个初始向量，其大小与Block Size相等（AES的Block Size为128 bits）
 */
- (instancetype)ndl_aes128Encrypt;
- (instancetype)ndl_aes128Decrypt;
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
