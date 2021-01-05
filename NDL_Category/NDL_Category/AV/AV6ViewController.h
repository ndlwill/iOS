//
//  AV6ViewController.h
//  NDL_Category
//
//  Created by youdone-ndl on 2020/12/16.
//  Copyright © 2020 ndl. All rights reserved.
//

// MARK: 捕捉媒体
/**
 捕捉会话 AVCaptureSession:
 一个捕捉会话相当于一个虚拟的“插线板”，用于连接输入和输出的资源。
 捕捉会话管理从屋里设备得到的数据流，比如摄像头和麦克风设备，输出到一个或多个目的地。可以动态配置输入和输出的线路，可以再会话进行中按需配置捕捉环境。
 捕捉会话还可以额外配置一个会话预设值(session preset)，用来控制捕捉数据的格式和质量。会话预设值默认为AVCaptureSessionPresetHigh，适用于大多数情况。还有很多预设值，可以根据需求设置。

 捕捉设备 AVCaptureDevice:
 AVCaptureDevice为摄像头或麦克风等物理设备定义了一个接口。对硬件设备定义了大量的控制方法，如对焦、曝光、白平衡和闪光灯等。
 
 AVCaptureDevice定义大量类方法用用访问系统的捕捉设备，最常用的是defaultDeviceWithMediaType:，根据给定的媒体类型返回一个系统指定的默认设备
 AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];请求的是一个默认的视频设备，在包含前置和后置摄像头的iOS系统，返回后置摄像头。
 
 捕捉设备的输入 AVCaptureInput:
 AVCaptureInput是一个抽象类，提供一个连接接口将捕获到的输入源连接到AVCaptureSession
 抽象类无法直接使用，只能通过其子类满足需求：AVCaptureDeviceInput-使用该对象从AVCaptureDevice获取设备数据(摄像头、麦克风等)、AVCaptureScreenInput-通过屏幕获取数据(如录屏)、AVCaptureMetaDataInput-获取元数据
 以 AVCaptureDeviceInput 为例:
 使用捕捉设备进行处理前，需要将它添加为捕捉会话的输入。通过将设备(AVCaptureDevice)封装到AVCaptureDeviceInput实例中，实现将设备插入到AVCaptureSession中。
 AVCaptureDeviceInput在设备输出数据和捕捉会话间，扮演接线板的作用
 AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
 NSError *error;
 AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
 
 捕捉的输出 AVCaptureOutput:
 AVCaptureOutput是一个抽象基类，用于从捕捉会话得到的数据寻找输出目的地。

 框架定义一些这个基类的高级扩展类，比如
 AVCaptureStillImageOutput用来捕捉静态图片，AVCaptureMovieFileOutput捕捉视频

 还有一些底层扩展，如AVCaptureAudioDataOutput和AVCaptureVideoDataOutput使用它们可以直接访问硬件捕捉到的数字样本。使用底层输出类需要对捕捉设备的数据渲染有更好的理解，不过这些类可以提供更强大的功能，比如对音频和视频流进行实时处理。
 
 捕捉连接 AVCaptureConnection:
 捕捉会话首先确定有给定捕捉设备输入渲染的媒体类型，并自动建立其到能够接收该媒体类型的捕捉输出端的连接。
 附加AVCaptureConnection解决一个图像旋转90°的问题：(setVideoOrientation:方法)
 AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
 AVCaptureVideoOrientation  avcaptureOrientation = [self avOrientationForDeviceOrientation:UIDeviceOrientationPortrait];
 [stillImageConnection setVideoOrientation:avcaptureOrientation];
 
 捕捉预览 AVCaptureVideoPreviewLayer:
 AVCaptureVideoPreviewLayer是一个CoreAnimation的CALayer的子类，对捕捉视频数据进行实时预览。
 类似于AVPlayerLayer，不过针对摄像头捕捉的需求进行了定制。他也支持视频重力概念setVideoGravity:
 AVLayerVideoGravityResizeAspect --在承载层范围内缩放视频大小来保持视频原始宽高比，默认值，适用于大部分情况
 AVLayerVideoGravityResizeAspectFill --保留视频宽高比，通过缩放填满层的范围区域，会导致视频图片被部分裁剪。
 AVLayerVideoGravityResize --拉伸视频内容拼配承载层的范围，会导致图片扭曲，funhouse effect效应。
 
 ###创建简单捕捉会话###
 1、创建捕捉会话 AVCaptureSession，可以设置为成员变量，开始会话以及停止会话都是用到实例对象。
 AVCaptureSession *session = [[AVCaptureSession alloc] init];
 2、创建获取捕捉设备 AVCaptureDevice
 AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
 3、创建捕捉输入 AVCaptureDeviceInput
 NSError *error;
 AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
 4、将捕捉输入加到会话中
 if ([session canAddInput:input]) {
     //首先检测是否能够添加输入，直接添加可能会有crash
     [session addInput:input];
 }
 5、创建一个静态图片输出 AVCaptureStillImageOutput
 AVCaptureStillImageOutput *imageOutput = [[AVCaptureStillImageOutput alloc] init];
 6、将捕捉输出添加到会话中
 if ([session canAddOutput:imageOutput]) {
     //检测是否可以添加输出
     [session addOutput:imageOutput];
 }
 7、创建图像预览层AVCaptureVideoPreviewLayer
 AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
 previewLayer.frame = self.view.frame;
 [self.view.layer addSublayer:previewLayer];
 8、开始会话
 [session startRunning];
 开始之前先获取设备摄像头权限。
 当开始运行会话，视频数据流就可以再系统中传输。
 
 =====创建一个简单的拍照视频项目=====
 1、创建捕捉会话
 self.captureSession = [[AVCaptureSession alloc] init];
     self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
     
     //获取设备摄像头
     AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
     // 得到一个指向默认视频捕捉设备的指针。
     
     AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:error];
     //将设备添加到Session之前，先封装到AVCaptureDeviceInput对象
     
     if (videoInput) {
         if ([self.captureSession canAddInput:videoInput]) {
             [self.captureSession addInput:videoInput];
             self.activeVideoInput = videoInput;
         }
     } else {
         return NO ;
     }
     
     //获取设备麦克风功能
     AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
     AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:error];
     if (audioInput) {
         if ([self.captureSession canAddInput:audioInput]) {
             //对于有效的input，添加到会话并给它传递捕捉设备的输入信息
             [self.captureSession addInput:audioInput];
         }
     } else {
         return NO ;
     }
     
     //设置 静态图片输出
     self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
     
     self.stillImageOutput.outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
     //配置字典表示希望捕捉JPEG格式图片
     
     if ([self.captureSession canAddOutput:self.stillImageOutput]) {
         // 测试输出是否可以添加到捕捉对话，然后再添加
         [self.captureSession addOutput:self.stillImageOutput];
     }
     
     
     //设置视频文件输出
     
     self.movieOutput = [[AVCaptureMovieFileOutput alloc] init];
     
     if ([self.captureSession canAddOutput:self.movieOutput]) {
         [self.captureSession addOutput:self.movieOutput];
         NSLog(@"add movie output success");
     }
 
 2、开始和结束会话
 - (dispatch_queue_t)globalQueue {
     return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
 }

 //开始捕捉会话
 - (void)startSession {
     if (![self.captureSession isRunning]) {
         dispatch_async([self globalQueue], ^{
             //开始会话 同步调用会消耗一定时间，所以用异步方式在videoQueue排队调用该方法，不会阻塞主线程。
             [self.captureSession startRunning];
         });
     }
 }

 //停止捕捉会话
 - (void)stopSession {
     if ([self.captureSession isRunning]) {
         dispatch_async([self globalQueue], ^{
             [self.captureSession stopRunning];
         });
     }
 }
 
 3、切换摄像头
 切换前置和后置摄像头需要重新配置捕捉回话，可以动态重新配置AVCaptureSession，不必担心停止会话和重新启动会话带来的开销。
 对会话进行的任何改变，都要通beginConfiguration和commitConfiguration，进行单独的、原子性的变化。
 - (BOOL)switchCameras { //验证是否有可切换的摄像头
     if (![self canSwitchCameras]) {
         return NO;
     }
     NSError *error;
     AVCaptureDevice *videoDevice = [self inactiveCamera];
     
     AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
     if (videoInput) {
         [self.captureSession beginConfiguration];
         // 标注源自配置变化的开始
         
         [self.captureSession removeInput:self.activeVideoInput];
         if ([self.captureSession canAddInput:videoInput]) {
             [self.captureSession addInput:videoInput];
             self.activeVideoInput = videoInput;
         } else if (self.activeVideoInput) {
             [self.captureSession addInput:self.activeVideoInput];
         }
         [self.captureSession commitConfiguration];
     } else {
         [self.delegate deviceConfigurationFailedWithError:error];
         return NO;
     }
     return YES;
 }
 
 // 返回指定位置的AVCaptureDevice 有效位置为 AVCaptureDevicePositionFront 和AVCaptureDevicePositionBack，遍历可用视频设备，并返回position参数对应的值
 - (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
     NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
     for (AVCaptureDevice *device  in devices) {
         if (device.position  == position) {
             return device;
         }
     }
     return nil;
 }

 // 当前捕捉会话对应的摄像头，返回激活的捕捉设备输入的device属性
 - (AVCaptureDevice *)activeCamera {
     return self.activeVideoInput.device;
 }

 // 返回当前未激活摄像头
 - (AVCaptureDevice *)inactiveCamera {
     AVCaptureDevice *device = nil;
     if (self.cameraCount > 1) {
         if ([self activeCamera].position == AVCaptureDevicePositionBack) {
             device = [self cameraWithPosition:AVCaptureDevicePositionFront];
         } else {
             device = [self cameraWithPosition:AVCaptureDevicePositionBack];
         }
     }
     return device;
 }

 - (BOOL)canSwitchCameras {
     return self.cameraCount > 1;
 }

 // 返回可用视频捕捉设备的数量
 - (NSUInteger)cameraCount {
     return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
 }
 
 4、捕获静态图片
 AVCaptureConnection，当创建一个会话并添加捕捉设备输入和捕捉输出时，会话自动建立输入和输出的链接，按需选择信号流线路。访问这些连接，可以更好地对发送到输出端的数据进行控制。
 CMSampleBuffer是有CoreMedia框架定义的CoreFoundation对象。可以用来保存捕捉到的图片数据。图片格式根据输出对象设定的格式决定。
 
 - (void)captureStillImage {
     NSLog(@"still Image");
     AVCaptureConnection *connection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
     if (connection.isVideoOrientationSupported) {
         connection.videoOrientation = [self currentVideoOrientation];
     }
     id handler = ^(CMSampleBufferRef sampleBuffer,NSError *error) {
         if (sampleBuffer != NULL) {
             NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:sampleBuffer];
             UIImage *image = [UIImage imageWithData:imageData];
             //这就得到了拍摄到的图片，可以做响应处理。
             
             
         } else {
             NSLog(@"NULL sampleBuffer :%@",[error localizedDescription]);
         }
     };
     [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:handler];
 }
 
 处理图片方向问题
 - (AVCaptureVideoOrientation)currentVideoOrientation {
     AVCaptureVideoOrientation orientation;
     
     switch ([[UIDevice currentDevice] orientation]) {
         case UIDeviceOrientationPortrait:
             orientation = AVCaptureVideoOrientationPortrait;
             break;
         case UIDeviceOrientationLandscapeRight:
             orientation = AVCaptureVideoOrientationLandscapeLeft;
             break;
         case UIDeviceOrientationPortraitUpsideDown:
             orientation = AVCaptureVideoOrientationPortraitUpsideDown;
             break;

         default:
             orientation = AVCaptureVideoOrientationLandscapeRight;
             break;
     }
     
     return orientation;
 }
 
 5、录制视频
 视频内容捕捉，设置捕捉会话，添加名为AVCaptureMovieFileOutput的输出。将QuickTime影片捕捉大磁盘，这个类的大多数核心功能继承与超类AVCaptureFileOutput。
 通常当QuickTime应聘准备发布时，影片头的元数据处于文件的开始位置，有利于视频播放器快速读取头包含的信息。录制的过程中，知道所有的样本都完成捕捉后才能创建信息头。
 - (void)startRecording {
     if (![self isRecording]) {
         
         AVCaptureConnection *videoConnection = [self.movieOutput connectionWithMediaType:AVMediaTypeVideo];
         if ([videoConnection isVideoOrientationSupported]) {
             videoConnection.videoOrientation = [self currentVideoOrientation];
         }
         if ([videoConnection isVideoStabilizationSupported]) {
             videoConnection.preferredVideoStabilizationMode = YES;
             
         }
         
         //如果支持preferredVideoStabilizationMode，设置为YES。支持视频稳定可以显著提升捕捉到的视频质量。
         // 只在录制视频文件时才会涉及。
         
         AVCaptureDevice *device = [self activeCamera];
         if (device.isSmoothAutoFocusEnabled) {
             NSError *error;
             if ([device lockForConfiguration:&error]) {
                 device.smoothAutoFocusEnabled = YES;
                 [device unlockForConfiguration];
             } else {
                 [self.delegate deviceConfigurationFailedWithError:error];
             }
             //摄像头可以进行平滑对焦模式的操作，减慢摄像头镜头对焦的速度。
             //通常情况下，用户移动拍摄时摄像头会尝试快速自动对焦，这会在捕捉视频中出现脉冲式效果。
             //当平滑对焦时，会较低对焦操作的速率，从而提供更加自然的视频录制效果。
         }
         
         self.outputURL = [self uniqueURL];
         NSLog(@"url %@",self.outputURL);
         [self.movieOutput startRecordingToOutputFileURL:self.outputURL recordingDelegate:self];
         // 查找写入捕捉视频的唯一文件系统URL。保持对地址的强引用，这个地址在后面处理视频时会用到
         // 添加代理，处理回调结果。
         
     }
 }

 // 获取录制时间
 - (CMTime)recordedDuration {
     return self.movieOutput.recordedDuration;
 }

 // 设置存储路径
 - (NSURL *)uniqueURL {
     NSFileManager *fileManager = [NSFileManager defaultManager];
     NSString *directionPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"camera_movie"];
   
     NSLog(@"unique url ：%@",directionPath);
     if (![fileManager fileExistsAtPath:directionPath]) {
         [fileManager createDirectoryAtPath:directionPath withIntermediateDirectories:YES attributes:nil error:nil];
     }

     NSString *filePath = [directionPath stringByAppendingPathComponent:@"camera_movie.mov"];
     if ([fileManager fileExistsAtPath:filePath]) {
         [fileManager removeItemAtPath:filePath error:nil];
     }
     return [NSURL fileURLWithPath:filePath];
     
     return nil;
 }

 // 停止录制
 - (void)stopRecording {
     if ([self isRecording]) {
         [self.movieOutput stopRecording];
     }
 }

 // 验证录制状态
 - (BOOL)isRecording {
     return self.movieOutput.isRecording;
 }

 代理回调，拿到录制视频的地址
 #pragma mark -- AVCaptureFileOutputRecordingDelegate

 // 录制完成
 - (void)captureOutput:(AVCaptureFileOutput *)output didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections error:(NSError *)error
 {
     NSLog(@"capture output");
     if (error) {
         NSLog(@"record error :%@",error);
         [self.delegate mediaCaptureFailedWithError:error];
     } else {
         // 没有错误的话在存储响应的路径下已经完成视频录制，可以通过url访问该文件。
                     
     }
     self.outputURL = nil;
 }

 6、将图片和视频保存到相册
 将拍摄到的图片和视频可以通过这个系统库保存到相册。
 可以使用从iOS8.0支持的Photos/Photos.h库来实现图片和视频的保存。
 
 [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
         [PHAssetChangeRequest creationRequestForAssetFromImage:image];
     } completionHandler:^(BOOL success, NSError * _Nullable error) {
         NSLog(@"success :%d ,error :%@",success,error);
         if (success) {
                 // DO:
                 
         }
     }];

 [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
         [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:videoUrl];
 } completionHandler:^(BOOL success, NSError * _Nullable error) {
     if (success) {
         // DO：
         [self generateThumbnailForVideoAtURL:videoUrl];
     } else {
         [self.delegate asssetLibraryWriteFailedWithError:error];
         NSLog(@"video save error :%@",error);
     }
 }];

 7、关于闪光灯和手电筒的设置
 设备后面的LED灯，当拍摄静态图片时作为闪光灯，当拍摄视频时用作连续灯光(手电筒).捕捉设备的flashMode和torchMode。
 
 AVCapture(Flash|Torch)ModeAuto：基于周围环境光照情况自动关闭或打开
 AVCapture(Flash|Torch)ModeOff：总是关闭
 AVCapture(Flash|Torch)ModeOn：总是打开

 修改闪光灯或手电筒设置的时候，一定要先锁定设备再修改，否则会挂掉。
 
 - (BOOL)cameraHasFlash {
     return [[self activeCamera] hasFlash];
 }

 - (AVCaptureFlashMode)flashMode {
     return [[self activeCamera] flashMode];
 }

 - (void)setFlashMode:(AVCaptureFlashMode)flashMode {
     AVCaptureDevice *device = [self activeCamera];
     if ([device isFlashModeSupported:flashMode]) {
         NSError *error;
         if ([device lockForConfiguration:&error]) {
             device.flashMode = flashMode;
             [device unlockForConfiguration];
         } else {
             [self.delegate deviceConfigurationFailedWithError:error];
         }
     }
 }

 - (BOOL)cameraHasTorch {
     return [[self activeCamera] hasTorch];
 }

 - (AVCaptureTorchMode)torchMode {
     return [[self activeCamera] torchMode];
 }

 - (void)setTorchMode:(AVCaptureTorchMode)torchMode {
     AVCaptureDevice *device = [self activeCamera];
     if ([device isTorchModeSupported:torchMode]) {
         NSError *error;
         if ([device lockForConfiguration:&error]) {
             device.torchMode = torchMode;
             [device unlockForConfiguration];
         } else {
             [self.delegate deviceConfigurationFailedWithError:error];
         }
     }
 }

 8、其他一些设置
 还有许多可以设置的属性，比如聚焦、曝光等等，设置起来差不多，首先要检测设备(摄像头)是否支持相应功能，锁定设备，而后设置相关属性。
 // 询问激活中的摄像头是否支持兴趣点对焦
 - (BOOL)cameraSupportsTapToFocus {
     return [[self activeCamera] isFocusPointOfInterestSupported];
 }

 // 点的坐标已经从屏幕坐标转换为捕捉设备坐标。
 - (void)focusAtPoint:(CGPoint)point {
     AVCaptureDevice *device = [self activeCamera];
     if (device.isFocusPointOfInterestSupported && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
         // 确认是否支持兴趣点对焦并确认是否支持自动对焦模式。
         // 这一模式会使用单独扫描的自动对焦，并将focusMode设置为AVCaptureFocusModeLocked
         
         NSError *error;
         if ([device lockForConfiguration:&error]) {
             //锁定设备准备配置
             device.focusPointOfInterest = point;
             device.focusMode = AVCaptureFocusModeAutoFocus;
             [device unlockForConfiguration];
         } else {
             [self.delegate deviceConfigurationFailedWithError:error];
         }
     }
 }

 关于屏幕坐标与设备坐标的转换
 
 captureDevicePointOfInterestForPoint:--获取屏幕坐标系的CGPoint数据，返回转换得到的设备坐标系CGPoint数据
 pointForCaptureDevicePointOfInterest:--获取社小偷坐标系的CGPoint数据，返回转换得到的屏幕坐标系CGPoint数据
 
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AV6ViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
