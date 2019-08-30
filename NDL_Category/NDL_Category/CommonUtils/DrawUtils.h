//
//  DrawUtils.h
//  NDL_Category
//
//  Created by dzcx on 2018/3/26.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NDLConstants.h"

/*
 https://www.jianshu.com/u/c68741efc396
 预乘透明度（Premultiplied Alpha）
 比如常规的半透明半纯红色图像RGBA归一化值为(0.5, 0, 0, 0.5)，由预乘透明度图像方式存储则RGBA值为(0.25, 0, 0, 0.5).即每个颜色分量都乘以alpha通道值作为结果值
 
 CGImageAlphaInfo包含以下信息:
 1.是否包含 alpha ；
 2.如果包含 alpha ，那么 alpha 信息所处的位置，在像素的最低有效位，比如 RGBA ，还是最高有效位，比如 ARGB ；
 3.如果包含 alpha ，那么每个颜色分量是否已经乘以 alpha 的值，这种做法可以加速图片的渲染时间，因为它避免了渲染时的额外乘法运算。比如，对于 RGB 颜色空间，用已经乘以 alpha 的数据来渲染图片，每个像素都可以避免 3 次乘法运算，红色乘以 alpha ，绿色乘以 alpha 和蓝色乘以 alpha
 
 解压缩图片的时候应该使用UIGraphicsBeginImageContextWithOptions
 You use this function to configure the drawing environment for rendering into a bitmap
 The format for the bitmap is a ARGB 32-bit integer pixel format using host-byte order. If the opaque parameter is YES, the alpha channel is ignored and the bitmap is treated as fully opaque (kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Host). Otherwise, each pixel uses a premultipled ARGB format (kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host)
 当图片不包含 alpha 的时候使用 kCGImageAlphaNoneSkipFirst ，否则使用 kCGImageAlphaPremultipliedFirst
 
 如果没有 alhpa 分量，那就是 kCGImageAlphaNone
 kCGImageAlphaOnly只有 alpha 值，没有颜色值
 带有 Premultiplied，说明在图片解码压缩的时候，就将 alpha 通道的值分别乘到了颜色分量上，我们知道 alpha 就会影响颜色的透明度，我们如果在压缩的时候就将这步做掉了，那么渲染的时候就不必再处理 alpha 通道了，这样可以提高渲染速度
 First 和 Last的区别就是 alpha 分量是在像素存储的哪一边。例如一个像素点32位，表示4个分量，那么从左到右，如果是 ARGB，就表示 alpha 分量在 first，RGBA 就表示 alpha 分量在 last
 
 kCGImageAlphaPremultipliedLast提前把alpha信息和RGB做了相乘已经把计算结果计算好了，这样在显示位图的时候直接显示就行了，这样就提高了性能，而kCGImageAlphaLast没有计算alpha的值，这样的话在显示位图的时候就需要计算alpha信息，导致性能低下
 
 PNG是一种使用RGBA的图像格式
 */

@interface DrawUtils : NSObject

// 绘制虚线 还可以通过CAShapeLayer
+ (void)drawDashedLineInContext:(CGContextRef)context
                      lineWidth:(CGFloat)lineWidth // 线的粗细
                        lineCap:(CGLineCap)lineCap
                lineDashPattern:(CGFloat *)lengthArray
                lineStrokeColor:(CGColorRef)lineStrokeColor
                 lineBeginPoint:(CGPoint)lineBeginPoint
                   lineEndPoint:(CGPoint)lineEndPoint;

// 绘制闹钟
+ (void)drawClockInContext:(CGContextRef)context
                 lineWidth:(CGFloat)lineWidth
           lineStrokeColor:(CGColorRef)lineStrokeColor
                    radius:(CGFloat)radius
               centerPoint:(CGPoint)centerPoint
            hourHandLength:(CGFloat)hourHandLength// 时针长度
             hourHandValue:(CGFloat)hourHandValue// 时针数值 1-12
          minuteHandLength:(CGFloat)minuteHandLength
           minuteHandValue:(CGFloat)minuteHandValue;

// 绘制delete图案
+ (void)drawDeletePatternInContext:(CGContextRef)context
                         lineWidth:(CGFloat)lineWidth
                   lineStrokeColor:(CGColorRef)lineStrokeColor
                            radius:(CGFloat)radius
                       centerPoint:(CGPoint)centerPoint;

// 绘制圆点
+ (void)drawDotInContext:(CGContextRef)context
               fillColor:(CGColorRef)fillColor
             centerPoint:(CGPoint)centerPoint
                  radius:(CGFloat)radius;

// 绘制气泡框(三角)
+ (void)drawBubbleFrameWithTriangleInContext:(CGContextRef)context
                                        rect:(CGRect)rect
                                   lineWidth:(CGFloat)lineWidth
                             lineStrokeColor:(CGColorRef)lineStrokeColor
                                   fillColor:(CGColorRef)fillColor
                                cornerRadius:(CGFloat)cornerRadius
                              arrowDirection:(BubbleFrameArrowDirection)arrowDirection
                                 arrowHeight:(CGFloat)arrowHeight
                                controlPoint:(CGPoint)controlPoint
                      controlPointOffsetLeft:(CGFloat)controlPointOffsetLeft
                     controlPointOffsetRight:(CGFloat)controlPointOffsetRight;

// 绘制直角气泡框
+ (void)drawRightAngleBubbleFrameInContext:(CGContextRef)context
                                    inRect:(CGRect)inRect
                                 lineWidth:(CGFloat)lineWidth
                           lineStrokeColor:(CGColorRef)lineStrokeColor
                                 fillColor:(CGColorRef)fillColor
                              cornerRadius:(CGFloat)cornerRadius
                        rightAnglePosition:(BubbleFrameRightAnglePosition)rightAnglePosition;


// 绘制优惠券背景
+ (void)drawCouponBackgroundInContext:(CGContextRef)context
                                 rect:(CGRect)rect
//                         marginToEdgeInsets:(UIEdgeInsets)marginToEdgeInsets// 优惠券背景 MarginTo Rect(Edge)//
                         cornerRadius:(CGFloat)cornerRadius
                        separateShape:(CouponBackgroundSeparateShape)separateShape// 位于上下边
                  separateShapeCenterXRatio:(CGFloat)separateShapeCenterXRatio// x相对于rect宽度的比例 (生成center中心点 y位于rect的上下边)
                  separateShapeVerticalHeight:(CGFloat)separateShapeVerticalHeight// 以center为参照
         separateShapeHorizontalWidth:(CGFloat)separateShapeHorizontalWidth // 以center为参照
                            lineWidth:(CGFloat)lineWidth
                      lineStrokeColor:(CGColorRef)lineStrokeColor
                            fillColor:(CGColorRef)fillColor
                           shadowBlur:(CGFloat)shadowBlur
                          shadowColor:(CGColorRef)shadowColor
                         shadowOffset:(CGSize)shadowOffset;// UIOffset



@end

/*
 定义一个指针：
 C ：
 int *a = malloc(sizeof(int));
 *a = 42;
 printf("a's value: %d", *a);
 free(a)
 
 Swift :
 let a = UnsafeMutablePointer<Int>.allocate(capacity: 1)
 a.pointee = 42
 print("a's value: \(a.pointee)") // 42
 a.deallocate(capacity: 1)
 pointee可理解为解引(dereference)，即用 *符号获得指针指向内存区域的值
 
 取址方式一致，使用 &获得变量的内存地址：
 var a = 42
 function AcceptVariableAddress(&a) // 这里函数接受一个类型为 UnsafeMutablePointer<Int> 传参
 */

/*
 MARK:###https://www.csdn.net/gather_2c/MtjaEgzsNzg2Ni1ibG9n.html###
 位图（Bitmap），又称栅格图（英语：Raster graphics）或点阵图，是使用像素阵列(Pixel-array/Dot-matrix点阵)来表示的图像
 对于一个32位RGBA图像来说，则每个元素包含着三个颜色组件(R,G,B)和一个Alpha组件，每一个组件占8位（8bite = 1byte = 32 / 4）。这些像素集合起来就可以表示出一张图片
 
 Bitmap的数据由CGImageRef封装
 
 如果要使用bitmap对图片进行各种处理，则需要先创建位图上下文。（CGBitmapContextCreate，Swift中则是CGContext）
 let w = Int(image.size.width)
 let h = Int(image.size.height)
 let bitsPerComponent = 8
 let bytesPerRow = w * 4
 let colorSpace = CGColorSpaceCreateDeviceRGB()
 let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
 let bufferData = UnsafeMutablePointer<UInt32>.allocate(capacity: w * h)
 bufferData.initialize(repeating: 0, count: w * h)
 let cxt = CGContext(data: bufferData,
 width: w,
 height: h,
 bitsPerComponent: bitsPerComponent,
 bytesPerRow: bytesPerRow,
 space: colorSpace,
 bitmapInfo: bitmapInfo)
 
 data:
 用于存放位图的点阵数据，当生成上下文并调用 CGContextDrawImage 方法将指定图片绘制进上下文之后，data里面就会有该图片的位图像素信息，可以当做一个数组指针来使用。
 我们可以对这个data里面的内容进行操作，然后以这个data为主要参数通过生成 CGDataProvider 实例并调用 CGImageCreate 方法来重新生成一个CGImage。
 
 width 和 height：
 位图的宽和高。
 如width = 10，height = 20则代表每一行有10个像素，每一列有20个像素。
 
 bitsPerComponent：
 颜色组件或者alpha组件占的bite数。
 以32位图像为例：bitsPerComponent = 8
 
 bytesPerRow：
 位图的每一行占的字节数。
 以32位图像为例：一个像素有4byte（rgba），
 那么bytesPerRow = width * 4
 
 space：
 颜色空间，是RGBA、CMYK还是灰度值。
 RGBA : CGColorSpaceCreateDeviceRGB( )
 CMYK : CGColorSpaceCreateDeviceCMYK( )
 灰度值 : CGColorSpaceCreateDeviceGray( )
 
 bitmapInfo：
 一个常量，描述这个位图上下文所对应的位图的基本信息。
 通常是多个枚举值做或运算的最终值（CGBitmapInfo 和 CGImageAlphaInfo）。
 比如可以置顶是否具有alpha通道，alpha通道的位置（是RGBA还是ARGB），字节排列的顺序等等

 那么如果我不想预乘透明度，只想获取原始的rgb颜色色值。使用 .noneSkipLast 或者 .noneSkipFirst。
 "noneSkip" 代表有 alpha 分量，但是忽略该值，相当于透明度不起作用
 
 -(void)imageDump:(NSString*)file
 {
 UIImage* image = [UIImage imageNamed:file];
 CGImageRef cgimage = image.CGImage;
 size_t width  = CGImageGetWidth(cgimage);
 size_t height = CGImageGetHeight(cgimage);
 size_t bpr = CGImageGetBytesPerRow(cgimage);
 size_t bpp = CGImageGetBitsPerPixel(cgimage);
 size_t bpc = CGImageGetBitsPerComponent(cgimage);
 size_t bytes_per_pixel = bpp / bpc;
 CGBitmapInfo info = CGImageGetBitmapInfo(cgimage);
 
 NSLog(
 @"\n"
 "===== %@ =====\n"
 "CGImageGetHeight: %d\n"
 "CGImageGetWidth:  %d\n"
 "CGImageGetColorSpace: %@\n"
 "CGImageGetBitsPerPixel:     %d\n"
 "CGImageGetBitsPerComponent: %d\n"
 "CGImageGetBytesPerRow:      %d\n"
 "CGImageGetBitmapInfo: 0x%.8X\n"
 "  kCGBitmapAlphaInfoMask     = %s\n"
 "  kCGBitmapFloatComponents   = %s\n"
 "  kCGBitmapByteOrderMask     = %s\n"
 "  kCGBitmapByteOrderDefault  = %s\n"
 "  kCGBitmapByteOrder16Little = %s\n"
 "  kCGBitmapByteOrder32Little = %s\n"
 "  kCGBitmapByteOrder16Big    = %s\n"
 "  kCGBitmapByteOrder32Big    = %s\n",
 file,
 (int)width,
 (int)height,
 CGImageGetColorSpace(cgimage),
 (int)bpp,
 (int)bpc,
 (int)bpr,
 (unsigned)info,
 (info & kCGBitmapAlphaInfoMask)     ? "YES" : "NO",
 (info & kCGBitmapFloatComponents)   ? "YES" : "NO",
 (info & kCGBitmapByteOrderMask)     ? "YES" : "NO",
 (info & kCGBitmapByteOrderDefault)  ? "YES" : "NO",
 (info & kCGBitmapByteOrder16Little) ? "YES" : "NO",
 (info & kCGBitmapByteOrder32Little) ? "YES" : "NO",
 (info & kCGBitmapByteOrder16Big)    ? "YES" : "NO",
 (info & kCGBitmapByteOrder32Big)    ? "YES" : "NO"
 );
 
 CGDataProviderRef provider = CGImageGetDataProvider(cgimage);
 NSData* data = (id)CGDataProviderCopyData(provider);
 [data autorelease];
 const uint8_t* bytes = [data bytes];
 
 printf("Pixel Data:\n");
 for(size_t row = 0; row < height; row++)
 {
 for(size_t col = 0; col < width; col++)
 {
 const uint8_t* pixel =
 &bytes[row * bpr + col * bytes_per_pixel];
 
 printf("(");
 for(size_t x = 0; x < bytes_per_pixel; x++)
 {
 printf("%.2X", pixel[x]);
 if( x < bytes_per_pixel - 1 )
 printf(",");
 }
 
 printf(")");
 if( col < width - 1 )
 printf(", ");
 }
 
 printf("\n");
 }
 }

 属性    结果
 .premultipliedFirst + .byteOrder32Big    A R G B
 .premultipliedLast + .byteOrder32Big    R G B A
 .premultipliedFirst + .byteOrder32Little    R G B A
 .premultipliedLast + .byteOrder32Little    A R G B
 */

// public struct CGBitmapInfo : OptionSet {
// public init(rawValue: UInt32)
// public static var alphaInfoMask: CGBitmapInfo { get }
// public static var floatInfoMask: CGBitmapInfo { get }
// public static var floatComponents: CGBitmapInfo { get }
// public static var byteOrderMask: CGBitmapInfo { get }
// public static var byteOrder16Little: CGBitmapInfo { get }
// public static var byteOrder32Little: CGBitmapInfo { get }
// public static var byteOrder16Big: CGBitmapInfo { get }
// public static var byteOrder32Big: CGBitmapInfo { get }
// }
// public enum CGImageAlphaInfo : UInt32 {
// case none /* For example, RGB. */
//case premultipliedLast /* For example, premultiplied RGBA */
//case premultipliedFirst /* For example, premultiplied ARGB */
//case last /* For example, non-premultiplied RGBA */
//case first /* For example, non-premultiplied ARGB */
//case noneSkipLast /* For example, RBGX. */
//case noneSkipFirst /* For example, XRGB. */
//case alphaOnly /* No color data, alpha data only */
//}

/*
 获取图片中点击位置的颜色:
 extension UIImageView {
 
 func color(forPoint p : CGPoint) -> UIColor? {
 guard let pixels = self.pixels else {
 return nil
 }
 guard let index = pixelIndex(for: p) else {
 return nil
 }
 let color = self.color(forPixel: pixels[index])
 return color
 }
 
 // 获取图像的像素数据（getPixelsData）是耗时操作.在实际使用时应该在获取之后进行缓存，以备之后重复使用
var pixels : [UInt32]? {
    return self.getPixelsData(inRect: self.bounds)
}

 根据坐标点获取该点对应的像素所在数组中的索引
 - p : 置顶的坐标点
func pixelIndex(for p : CGPoint) -> Int? {
    let size = self.bounds.size
    guard p.x > 0 && p.x <= size.width && p.y > 0 && p.y < size.height else {
        return nil
    }
    // 相当于 height * bytesPerRow + x
    let floatIndex = Int(size.width * p.y + p.x)
    let intIndex = Int(size.width) * Int(p.y) + Int(p.x)
    print("float index : \(floatIndex), intIndex : \(intIndex)")
    // 这里一定要都转换成Int类型再求值，否则最后算出来的index会有偏差
    return Int(size.width) * Int(p.y) + Int(p.x)
    }
    
    func color(forPixel pixel: UInt32) -> UIColor {
        // 创建位图上下文的时候，可以指定两种bitmapInfo
        // 如果指定了premultipliedFirst，说明颜色组件是以 alpha red green blue 的顺序排列的
        // 如果指定了premultipliedLast，说明颜色组件是以 red green blue alpha 的顺序排列的
        // 那么下面解析r,g,b,a四个值的时候的顺序就会有所差别。
        let r = CGFloat((pixel >> 0)  & 0xff) / 255.0
        let g = CGFloat((pixel >> 8)  & 0xff) / 255.0
        let b = CGFloat((pixel >> 16) & 0xff) / 255.0
        let a = CGFloat((pixel >> 24) & 0xff) / 255.0
        print("r : \(r), g : \(g), b : \(b), a : \(a)")
        let color = UIColor(displayP3Red: r, green: g, blue: b, alpha: 1)
        return color
    }
    
 
     获取图片中指定范围内的位图数据（rgba数组）
     - rect : 置顶要获取像素数组的范围
     生成rect范围内的像素数据，较为耗时，所以在真正使用的时候最好有缓存策略。
 
    func getPixelsData(inRect rect : CGRect) -> [UInt32]? {
        
        guard let img = self.image, let cgImg = img.cgImage else {
            return nil
        }
 
         不能直接以image的宽高作为绘制的宽高，因为image的size可能会比控件的size大很多。
         所以在生成bitmapContext的时候需要以实际的控件宽高为准
 
        let w = Int(rect.size.width)
        let h = Int(rect.size.height)
        let bitsPerComponent = 8 // 32位的图像，所以每个颜色组件包含8bit
        let bytesPerRow = w * 4  // 1 byte = 8 bit, 32位图像的话，每个像素包含4个byte
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue // RGBA
        // let bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue // ARGB
        // 因为是32位图像，RGBA各占8位 8*4=32，所以像素数据的数组的元素类型应该是UInt32。
        var bufferData = Array<UInt32>(repeating: 0, count: w * h)
        guard let cxt = CGContext(data: &bufferData, width: w, height: h, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            return nil
        }
        // 将图像绘制进上下文中
        cxt.draw(cgImg, in: rect)
        return bufferData
    }
    }
 */

/*
 另一种思路获取点击位置的颜色。上面的getPixelsData需要获取整张图片的像素数据，
 对于只想要取得某一个点位置的颜色来说，效率较低。所以只生成容纳一个像素的bitmap，
 然后直接根据bufferData中像素数据生成颜色并返回
 */
// 生成只获取容纳一个像素的 BitmapContex。
// 根据 p 点的位置对 BitmapContext 进行平移变换，使 BitmapContext 的绘制原点位于 p 点。（默认渲染原点是在左上角）
//func getColor(fromPoint p : CGPoint) -> UIColor? {
//
//    let w = 1
//    let h = 1
//    let bitsPerComponent = 8
//    let bytesPerRow = w * 4
//    let colorSpace = CGColorSpaceCreateDeviceRGB()
//    let bitmapInfo = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.noneSkipLast.rawValue // RGBA
//    // 可以声明为一个有1个元素的UInt32数组
//    var bufferData = Array<UInt32>(repeating: 0, count: 1)
//    // 或者为一个有4个元素的UInt8数组
//    // var bufferData = Array<UInt8>(repeating: 0, count: 4)
//
//    guard let cxt = CGContext(data: &bufferData, width: w, height: h, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
//        return nil
//    }
//    /*
//     这里需要注意，由于上边生成的位图上下文只包含一个像素数据，相当于一个点。
//     而这个位图上下文的默认渲染原点是图片的左上角，也就是(0,0)的位置，如果直接从bufferData获取的话，其实是图片左上角第一个像素的颜色。
//     所以这里需要将位图上下文做一个反方向的平移变换，使p点成为位图上下文的渲染原点
//     */
//    cxt.translateBy(x: -p.x, y: -p.y)
//
//    /*
//     将图像渲染到上下文中，这里需要注意的是，需要在平移之后才渲染，否则获取到的颜色不正确。
//     */
//    layer.render(in: cxt)
//
//    // 只包含一个UInt32像素数据
//    let component = bufferData.first!
//    let r = CGFloat((component >> 0)  & 0xff) / 255.0
//    let g = CGFloat((component >> 8)  & 0xff) / 255.0
//    let b = CGFloat((component >> 16) & 0xff) / 255.0
//    let a = CGFloat((component >> 24) & 0xff) / 255.0
//
//    // 包含四个UInt8(每一个元素代表RGBA中的一个)元素的数组
//    // let r = CGFloat(bufferData[0]) / 255.0
//    // let g = CGFloat(bufferData[1]) / 255.0
//    // let b = CGFloat(bufferData[2]) / 255.0
//    // let a = CGFloat(bufferData[3]) / 255.0
//
//    let color = UIColor(displayP3Red: r, green: g, blue: b, alpha: a)
//    return color
//    }
