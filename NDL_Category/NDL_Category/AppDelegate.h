//
//  AppDelegate.h
//  NDL_Category
//
//  Created by ndl on 2017/9/14.
//  Copyright © 2017年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

//https://blog.csdn.net/u013282507/article/category/6429655
//https://github.com/mengxianliang?tab=repositories

/*
Bitbucket:
ndlwill1020@126.com
gmail:
ndlwill1020@gmail.com
 */

/*
 图片浏览器:
 PhotoBrowser
 ImageViewer
 */

/*
 导入调试包:command+shift+g
 /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/DeviceSupport
 把文件解压到这个文件夹下，重新启动Xcode，连上真机运行，Xcode会开始下载调试组件（2-3G），下载完成之后就能在真机上运行了
 
 保留常用的系统版本所对应的调试组件，删除调试组件
 ~/Library/Developer/Xcode/iOS DeviceSupport
 */

/*
fishhook是Facebook提供的一个动态修改链接mach-O文件的工具。
利用MachO文件加载原理，通过修改懒加载和非懒加载两个表的指针达到C函数HOOK的目的
 
// https://blog.csdn.net/Hello_Hwc/article/details/78444203
 
 更轻量的 View Controllers:
 1.将业务逻辑移到 Model 中(User)
 2.创建 Store 类   Store 对象会关心数据加载、缓存和设置数据栈。它也经常被称为服务层或者仓库
 3.把网络请求逻辑移到 Model 层
 4.把 View 代码移到 View 层
 */

// xcode
// commad + shift + K  clean项目

// the icon size of iOS 11 must be 120*120 pixels

// 推送(阿里云)
// 将App上传App Store前，可以在注册的测试上，运行Ad Hoc环境的App，用以测试App生产环境的的功能，包括生产环境的远程推送通知
// 开发环境和生产环境App获取的deviceToken是不同的
// 通过xcode安装的是dev环境
// iphoneX device-token
// (卸载安装 每次都不一样)dev-db33aa54 d21dd18b fc554e13 e6d3705e c118f36a cf76edc8 74a8e287 2d510a2a
//                        89d9968b 6127f805 5dc0ecb7 1dabd512 4bf9ead6 b05751ef f98a2be4 2d41ef7d
// dis-93caf972 50ec26e0 430dbb18 43a2fca7 2fc4cb97 a882c0fe 8120ff60 a113fd0a
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

