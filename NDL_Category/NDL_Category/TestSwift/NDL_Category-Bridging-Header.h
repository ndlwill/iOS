//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

// 代码诊断
// https://developer.apple.com/documentation/code_diagnostics?language=objc

// MARK: swift库
// https://swift.libhunt.com/categories/688-events

/*
 OC调用Swift:
 第一步
 Build Settings->Defines Module 设置为 YES
 Module Name 配置工程名
 
 第二步
 创建swift,提示创建桥接文件
 命名 XXXX-Bridging-Header [XXXX 表示项目名称]
 
 第三步
 Build Settings->Bridging
 设置桥接文件
 
 第四步
 Build Settings-> Swift Language Version 选择版本（版本就看你swift是哪个版本了）
 在需要用到Swift方法的类中
 引入 #import “XXXX-Swift.h" [XXXX 表示项目名称]
 */


