//
//  CoreTextView.m
//  NDL_Category
//
//  Created by dzcx on 2019/8/2.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "CoreTextView.h"

// https://my.oschina.net/FEEDFACF/blog/1857018
@interface CoreTextView ()
// ==============================================drawImage==============================================
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *imageFrames;

@end

@implementation CoreTextView

- (void)drawText
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    // 绘制区域
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    
    // 绘制的内容属性字符串
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18],
                                 NSForegroundColorAttributeName: [UIColor blueColor]
                                 };
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"我们是Gish 哎好烦开爱计算机四级计算机考试松岙送啊思考思考伤口快快堪萨斯卡上88372730kkjasiajsia手机啊手机啊可是卡手机卡时间啊时间啊看撒jsajskasj啊手机卡上ss" attributes:attributes];
    
    // 使用NSMutableAttributedString创建CTFrame
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrStr);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrStr.length), path, NULL);
    
    // 使用CTFrame在CGContextRef上下文上绘制
    CTFrameDraw(frame, context);
    
    CGPathRelease(path);
    CFRelease(framesetter);
    CFRelease(frame);
}

- (void)drawImage
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    CTFrameRef ctFrame = [self ctFrameWithAttributeString:[self attributeStringForDraw] frame:self.bounds];
    [self.images addObject:@"1024x1024"];
    [self calculateImagePositionWithCTFrame:ctFrame];
    
    CTFrameDraw(ctFrame, context);
    
    for (NSInteger i = 0; i < self.images.count; i++) {
        CGContextDrawImage(context, CGRectFromString(self.imageFrames[i]), [UIImage imageNamed:(NSString *)self.images[i]].CGImage);
    }
    
}

// 手动布局手动计算高度
// 需手动调用,拿到返回的size然后设置size
//- (CGSize)sizeThatFits:(CGSize)size
//{
//    NSLog(@"===sizeThatFits===");
//    return CGSizeMake(self.width, 400);
//}

// 自动布局会调用intrinsicContentSize方法获取内容的大小
//- (CGSize)intrinsicContentSize
//{
//
//}

- (void)drawRect:(CGRect)rect {
    NSLog(@"===drawRect===");
//    NSLog(@"rect = %@ self.bounds = %@", NSStringFromCGRect(rect), NSStringFromCGRect(self.bounds));
    
//    [self drawText];
    [self drawImage];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSLog(@"===layoutSubviews===");
}

// ==============================================drawImage==============================================
- (NSMutableArray *)images
{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (NSMutableArray *)imageFrames
{
    if (!_imageFrames) {
        _imageFrames = [NSMutableArray array];
    }
    return _imageFrames;
}

- (NSAttributedString *)attributeStringForDraw {
    NSMutableAttributedString *attributeString = [NSMutableAttributedString new];
    
    // 添加文字
    NSAttributedString *textAttributeString = [[NSAttributedString alloc] initWithString:@"-Hello world-" attributes:[self defaultTextAttributes]];
    [attributeString appendAttributedString:textAttributeString];
    
    textAttributeString = [[NSAttributedString alloc] initWithString:@"HelloWorld" attributes:[self boldHighlightedTextAttributes]];
    [attributeString appendAttributedString:textAttributeString];
    
    // 添加链接
    NSAttributedString *linkAttributeString = [[NSAttributedString alloc] initWithString:@"www.baidu.com" attributes:[self linkTextAttributes]];
    [attributeString appendAttributedString:linkAttributeString];
    
    // 添加图片
    [attributeString appendAttributedString:[self imageAttributeString]];
    
    // 添加文字
    textAttributeString = [[NSAttributedString alloc] initWithString:@"22Hello world Hello world Hello world Hello world Hello world Hello world22" attributes:[self defaultTextAttributes]];
    [attributeString appendAttributedString:textAttributeString];
    
    return attributeString;
}

- (NSDictionary *)defaultTextAttributes {
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18],
                                 NSForegroundColorAttributeName: [UIColor cyanColor],
                                 NSBackgroundColorAttributeName: [UIColor yellowColor]
                                 };
    return attributes;
}

- (NSDictionary *)defaultTextAttributes1 {
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18],
                                 NSForegroundColorAttributeName: [UIColor cyanColor],
                                 NSBackgroundColorAttributeName: [UIColor purpleColor]
                                 };
    return attributes;
}

- (NSDictionary *)boldHighlightedTextAttributes {
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:24],
                                 NSForegroundColorAttributeName: [UIColor redColor],
                                 NSBackgroundColorAttributeName: [UIColor greenColor]
                                 };
    return attributes;
}

- (NSDictionary *)linkTextAttributes {
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18],
                                 NSForegroundColorAttributeName: [UIColor blueColor],
                                 NSUnderlineStyleAttributeName: @(3),
                                 NSUnderlineColorAttributeName: [UIColor blueColor]
                                 };
    return attributes;
}

- (NSAttributedString *)imageAttributeString {
    // 1 创建CTRunDelegateCallbacks
    CTRunDelegateCallbacks callback;
    memset(&callback, 0, sizeof(CTRunDelegateCallbacks));
    callback.getAscent = getAscent;
    callback.getDescent = getDescent;
    callback.getWidth = getWidth;
    
    // 2 创建CTRunDelegateRef
    NSDictionary *metaData = @{@"width": @256, @"height": @256};
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&callback, (__bridge_retained void *)(metaData));
    
    // 3 设置占位使用的图片属性字符串
    // 参考：https://en.wikipedia.org/wiki/Specials_(Unicode_block)  U+FFFC ￼ OBJECT REPLACEMENT CHARACTER, placeholder in the text for another unspecified object, for example in a compound document.
    unichar objectReplacementChar = 0xFFFC;
    NSMutableAttributedString *imagePlaceHolderAttributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithCharacters:&objectReplacementChar length:1] attributes:[self defaultTextAttributes1]];
    
    // 4 设置RunDelegate代理
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)imagePlaceHolderAttributeString, CFRangeMake(0, 1), kCTRunDelegateAttributeName, runDelegate);
    CFRelease(runDelegate);
    return imagePlaceHolderAttributeString;
}

static CGFloat getAscent(void *ref) {
    float height = [(NSNumber *)[(__bridge NSDictionary *)ref objectForKey:@"height"] floatValue];
    return height;
}

static CGFloat getDescent(void *ref) {
    return 0;
}

static CGFloat getWidth(void *ref) {
    float width = [(NSNumber *)[(__bridge NSDictionary *)ref objectForKey:@"width"] floatValue];
    return width;
}

- (CTFrameRef)ctFrameWithAttributeString:(NSAttributedString *)attributeString frame:(CGRect)frame {
    // 绘制区域
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, (CGRect){{0, 0}, frame.size});
    
    // 使用NSMutableAttributedString创建CTFrame
    CTFramesetterRef ctFramesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributeString);
    CTFrameRef ctFrame = CTFramesetterCreateFrame(ctFramesetter, CFRangeMake(0, attributeString.length), path, NULL);
    
    CFRelease(ctFramesetter);
    CFRelease(path);
    
    return ctFrame;
}

- (void)calculateImagePositionWithCTFrame:(CTFrameRef)ctFrame
{
    int imageIndex = 0;
    if (imageIndex >= self.images.count) {
        return;
    }
    
    // CTFrameGetLines获取但CTFrame内容的行数
    NSArray *lines = (NSArray *)CTFrameGetLines(ctFrame);
    // CTFrameGetLineOrigins获取每一行的起始点，保存在lineOrigins数组中
    CGPoint lineOrigins[lines.count];
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), lineOrigins);
    for (int i = 0; i < lines.count; i++) {
        CTLineRef line = (__bridge CTLineRef)lines[i];
        
        NSArray *runs = (NSArray *)CTLineGetGlyphRuns(line);
        for (int j = 0; j < runs.count; j++) {
            CTRunRef run = (__bridge CTRunRef)(runs[j]);
            NSDictionary *attributes = (NSDictionary *)CTRunGetAttributes(run);
            if (!attributes) {
                continue;
            }
            // 从属性中获取到创建属性字符串使用CFAttributedStringSetAttribute设置的delegate值
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[attributes valueForKey:(id)kCTRunDelegateAttributeName];
            if (!delegate) {
                continue;
            }
            // CTRunDelegateGetRefCon方法从delegate中获取使用CTRunDelegateCreate初始时候设置的元数据
            NSDictionary *metaData = (NSDictionary *)CTRunDelegateGetRefCon(delegate);
            if (!metaData) {
                continue;
            }
            
            // 找到代理则开始计算图片位置信息
            CGFloat ascent;
            CGFloat desent;
            // 可以直接从metaData获取到图片的宽度和高度信息
            CGFloat width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &desent, NULL);
            
            // CTLineGetOffsetForStringIndex获取CTRun的起始位置
            CGFloat xOffset = lineOrigins[i].x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            CGFloat yOffset = lineOrigins[i].y;
            
            
            [self.imageFrames addObject:NSStringFromCGRect(CGRectMake(xOffset, yOffset, width, ascent + desent))];
            
            imageIndex ++;
            if (imageIndex >= self.images.count) {
                return;
            }
        }
    }
}

@end
