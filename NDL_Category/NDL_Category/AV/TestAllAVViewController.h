//
//  TestAllAVViewController.h
//  NDL_Category
//
//  Created by youdone-ndl on 2020/12/16.
//  Copyright © 2020 ndl. All rights reserved.
//

// MARK: AVFoundation实现视频倒放以及性能优化
/**
 反转视频和核心方法有两种
 1.用AVAssetImageGenerator倒序的读取每一个time的图片，并使用AVAssetWriterInputPixelBufferAdaptor、AVAssetWriter和AVAssetWriterInput写出新的视频
 2.使用AVAssetReader读取每一帧，保存到数组中再将其倒序并使用AVAssetWriterInputPixelBufferAdaptor、AVAssetWriter和AVAssetWriterInput写出新的视频
 
 第一种方式效率较低，4s的视频就需要非常长的一段时间，但耗内存少。而第二种方式效率高一些，但内存占用大，容易crash。
 主要使用第二种方法，并介绍如何在使用第二种方法的情况下保持内存平稳。
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestAllAVViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
