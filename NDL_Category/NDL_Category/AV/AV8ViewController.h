//
//  AV8ViewController.h
//  NDL_Category
//
//  Created by youdone-ndl on 2020/12/17.
//  Copyright © 2020 ndl. All rights reserved.
//

// MARK: 捕捉功能之人脸识别
/**
 这里的人脸检测是通过AVFoundation实现的实时人脸检测功能，会在检测到人脸自动建立相应的焦点。
 
 AVFoundation中通过特定的AVCaptureOutput类型的AVCaptureMetadataOutput实现这个功能。它的输出同之前类似，输出的不是静态图片或影片，而是元数据。定义了用来处理多种元数据类型的接口，当使用人脸检测时，会输出一个具体子类类型AVMetadataFaceObject。
 
 AVMetadataFaceObject几个重要属性：
 rollAngle:倾斜角，表示人的头部向肩膀方向的侧倾角度。
 yawAngle:偏转角，表示人脸绕y轴旋转的角度。
 bounds:边界，对应的是设备坐标。
 人脸识别的整个流程与之前用到的静态图片和视频捕捉是一样的，不同的是一些配置的不同，以及对获取到的脸部数据对象的处理。
 
 1、创建会话，并配置输入输出
 self.captureSession = [[AVCaptureSession alloc] init];
 self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;

 AVCaptureDevice *videoDevice =
         [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

 AVCaptureDeviceInput *videoInput =
     [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:error];
 if (videoInput) {
     if ([self.captureSession canAddInput:videoInput]) {
         [self.captureSession addInput:videoInput];
         self.activeVideoInput = videoInput;
     } else {
         if (error) {
            
         }
     }
 }

 // Setup the still image output
 self.imageOutput = [[AVCaptureStillImageOutput alloc] init];
 //self.imageOutput.outputSettings = @{AVVideoCodecKey : AVVideoCodecJPEG};

 if ([self.captureSession canAddOutput:self.imageOutput]) {
     [self.captureSession addOutput:self.imageOutput];
 } else {
     if (error) {
     
     }
 }

 // 添加元数据输出捕捉
 self.metadataOutput = [[AVCaptureMetadataOutput alloc] init];
 if ([self.captureSession canAddOutput:self.metadataOutput]) {
     [self.captureSession addOutput:self.metadataOutput];
     // 添加新的捕捉会话输出
     
     NSArray *metadataObjectTypes = @[AVMetadataObjectTypeFace];
     self.metadataOutput.metadataObjectTypes = metadataObjectTypes;
     //指定输出的元数据类型。
     
     dispatch_queue_t mainqueue = dispatch_get_main_queue();
     [self.metadataOutput setMetadataObjectsDelegate:self queue:mainqueue];
     //有新的元数据被检测到时，会都回调代理AVCaptureMetadataOutputObjectsDelegate中的方法
     //可以自定义系列的调度队列，不过由于人脸检测用到硬件加速，而且许多人物都要在主线程中执行，所以需要为这个参数指定主队列。
     
 2、设置回调代理方法
 #pragma  -- mark AVCaptureMetadataOutputObjectsDelegate

 - (void)captureOutput:(AVCaptureOutput *)captureOutput
 didOutputMetadataObjects:(NSArray *)metadataObjects
        fromConnection:(AVCaptureConnection *)connection {

    //metadataObjects 就是人脸检测结果的元数据，
    //包含多个人脸数据信息，可以做相应处理，
    // 比如将要实现的，在人脸上画框标记。

 }

 3、开始会话和结束会话
 - (void)startSession {
     if (![self.captureSession isRunning]) {
         dispatch_async(self.videoQueue, ^{
             [self.captureSession startRunning];
         });
     }
 }

 - (void)stopSession {
     if ([self.captureSession isRunning]) {
         dispatch_async(self.videoQueue, ^{
             [self.captureSession stopRunning];
         });
     }
 }

 4、设置必要的预览层
 视频预览层，和将要标记人脸的数据集合以及标记人脸方框的父layer。
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AV8ViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
