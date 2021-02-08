//
//  TestQuartz2DViewController.h
//  NDL_Category
//
//  Created by youdone-ndl on 2021/1/14.
//  Copyright © 2021 ndl. All rights reserved.
//

// MARK: Quartz 2D
/**
 https://developer.apple.com/library/archive/documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/dq_overview/dq_overview.html#//apple_ref/doc/uid/TP30001066-CH202-TPXREF101
 
 我们使用Quartz 2D画的图是倒转的，我们要做以下处理才能得到我们想要的图片效果：
 1.画布延Y轴下移height
 2.对Y轴做垂直翻转
 CGContextTranslateCTM(context, 0, height);
 CGContextScaleCTM(context, 1.0, -1.0);
 
 - (void)drawRect:(CGRect)rect {
    CGContextRef context=UIGraphicsGetCurrentContext();
     CGContextSetRGBFillColor(context, 1, 0, 0, 1);
     CGContextFillRect(context, CGRectMake(0, 100, 100, 100));
     NSString *text=@"文字";
     UIFont *font=[UIFont systemFontOfSize:14];
     [text drawAtPoint:CGPointMake(0, 200) withAttributes:font.fontDescriptor.fontAttributes];
     UIImage *img=[UIImage imageNamed:@"gg.jpg"];
     [img drawInRect:CGRectMake(0, 300, 100, 100)];
 }
 
 -(id)initWithFrame:(CGRect)frame
 {
     if (self=[super initWithFrame:frame]) {
         
         [self setBackgroundColor:[UIColor redColor]];
         UIImageView *imgview=[[UIImageView alloc] initWithFrame:self.bounds];
         
         CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
         float width=self.bounds.size.width;
         float height=self.bounds.size.height;
         //256=10000000
         int bitsPerComponent=8;
         //RGBA*8*width
         int bytesPerRow=4*8*width;
         CGContextRef context=CGBitmapContextCreate(NULL, width, height, bitsPerComponent,  bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
         //翻转画布
         CGContextTranslateCTM(context, 0, height);
         CGContextScaleCTM(context, 1.0, -1.0);
         UIGraphicsPushContext(context);
         
         //画布透明
         //CGContextFillRect(context, self.bounds);
         CGContextSetRGBFillColor(context, 1, 0, 0, 1);
         CGContextSetRGBStrokeColor(context, 0, 1, 0, 1);
         CGContextFillRect(context, CGRectMake(0, 100, 100, 100));
         NSString *text=@"文字";
         UIFont *font=[UIFont systemFontOfSize:14];
         [text drawAtPoint:CGPointMake(0, 200) withAttributes:font.fontDescriptor.fontAttributes];
         UIImage *img=[UIImage imageNamed:@"gg.jpg"];
         [img drawInRect:CGRectMake(0, 300, 100, 100)];
         
         
         CGImageRef cgimg = CGBitmapContextCreateImage(context);
         UIImage *resultImg = [UIImage imageWithCGImage:cgimg];
         
         CGContextRelease(context);
         CGColorSpaceRelease(colorSpace);
         CGImageRelease(cgimg);
         
         imgview.image=resultImg;
         [self addSubview:imgview];
         
         
     }
     return self;
 }
 2段代码实现的效果一样，代码1并没有做翻转操作，那是因为UIKit在UIGraphicsGetCurrentContext()得到的画布已经帮我们适应好了UIKit的坐标体系。
 */


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestQuartz2DViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
