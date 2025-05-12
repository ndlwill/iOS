//
//  SXTAttributedLabel.m
//  CoreText绘制文字
//
//  Created by YanZhang on 15/4/10.
//  Copyright © 2015年 YanZhang. All rights reserved.
//

#import "ZYAttributedLabel.h"
#import "NSMutableAttributedString+Attribute.h"
#import "NSMutableAttributedString+FrameRef.h"
#import "NSMutableAttributedString+Link.h"
#import "NSMutableAttributedString+Image.h"
#import "ZYAttributedLabel+Utils.h"
#import "ZYAttributedLabel+Draw.h"
#import "UIView+frameAdjust.h"

@interface ZYAttributedLabel ()

@property (nonatomic, strong) NSString *array;
/**
 * 用来展示的属性字符串
 */
@property (nonatomic, strong) NSMutableAttributedString *attributedString;

/**
 * 存放link数据模型的数组
 */
@property (nonatomic, strong) NSMutableArray *linkArr;

/**
 * 存放图片数据模型的数组
 */
@property (nonatomic, strong) NSMutableArray *imageArr;

/**
 * frameRef
 */
@property (nonatomic, assign) CTFrameRef frameRef;

/**
 * 选中超文本的数据模型
 */
@property (nonatomic, strong) ZYAttributedLink *selectedLink;

/**
 * 选中图片的数据模型
 */
@property (nonatomic, strong) ZYAttributedImage *selectedImage;

@end

@implementation ZYAttributedLabel

#pragma mark -
#pragma mark lifecycle
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configSettings];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configSettings];
    }
    return self;
}

/**
 * 设置默认设置信息
 */
- (void)configSettings
{
    // 设置字体大小
    self.font = [UIFont systemFontOfSize:16];
    // 设置超文本字体大小
    self.linkFont = [UIFont systemFontOfSize:16];
    
    // 设置字体颜色
    self.textColor = [UIColor blackColor];
    // 设置超文本字体颜色
    self.linkColor = [UIColor cyanColor];
    // 设置超文本选中背景颜色
    self.highlightColor = [UIColor redColor];

    // 初始化属性字符串
    self.attributedString = [[NSMutableAttributedString alloc] init];
    // 初始化存放link数据模型的数组
    self.linkArr = [NSMutableArray array];
    // 初始化存放图片数据模型的数组
    self.imageArr = [NSMutableArray array];
}

#pragma mark -
#pragma mark 设置显示文本
/**
 * 设置显示普通文本
 */
- (void)setText:(NSString *)text
{
    // 根据设置的文字，获得带属性的字符串
    NSAttributedString *attString = [NSMutableAttributedString attributedString:text textColor:self.textColor font:self.font];
    // 在设置属性文本继续处理属性字符串
    [self setAttributedText:attString];
}

/**
 * 设置属性文本
 */
- (void)setAttributedText:(NSAttributedString *)attributedText
{
    // 把设置好的属性字符串赋值给全局字符串
    self.attributedString = [attributedText mutableCopy];
    
    // 自定检查图片，并处理图片相关信息 -> 存放图片数据模型的数组
    self.imageArr = [[self.attributedString setImageWithImageSize:self.imageSize font:self.font] mutableCopy];
    
    // 自动检查link，并设置link的字体和颜色 -> 存放Link数据模型的数组
    self.linkArr = [[self.attributedString setLinkWithLinkColor:self.linkColor linkFont:self.linkFont] mutableCopy];
    
    // 刷新视图
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark 添加自定义链接
- (void)addCustomLink:(NSString *)link
{
    [self addCustomLink:link linkColor:self.linkColor linkFont:self.linkFont];
}

- (void)addCustomLink:(NSString *)link
            linkColor:(UIColor *)linkColor
             linkFont:(UIFont *)linkFont
{
    // 1.检查自定义链接和linkArr中的是否重复
    // 1.1谓词查询是否有重复
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"text CONTAINS %@", link];
    NSArray *resultArr = [self.linkArr filteredArrayUsingPredicate:predicate];
    // 1.2如果重复直接返回
    if (resultArr.count) return;
    
    // 2.设置超文本属性并获取满足条件的link对象
    NSArray *linkArr = [self.attributedString setCustomLink:link linkColor:linkColor linkFont:linkFont];
    
    // 3.添加进入数组
    [self.linkArr addObjectsFromArray:linkArr];
    
    // 4.刷新
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark 设置属性
- (void)setFont:(UIFont *)font
{
    _font = font;
    _linkFont = font;
    
    // 设置属性字体
    [self.attributedString setFont:font];
    // 刷新
    [self setNeedsDisplay];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    _linkColor = textColor;
    
    // 设置颜色
    [self.attributedString setTextColor:textColor];
    // 刷新
    [self setNeedsDisplay];
}

- (void)setLinkFont:(UIFont *)linkFont
{
    _linkFont = linkFont;
    
    // 设置超文本字体
    [self.attributedString setFont:linkFont links:self.linkArr];
}

- (void)setLinkColor:(UIColor *)linkColor
{
    _linkColor = linkColor;
    
    // 设置超文本颜色
    [self.attributedString setTextColor:linkColor links:self.linkArr];
}

/** 
 * 重写frameRef的setter方法
 * 此处需要我们手动管理内存
 */
- (void)setFrameRef:(CTFrameRef)frameRef
{
    if (_frameRef != frameRef) {
        if (_frameRef != nil) {
            CFRelease(_frameRef);
        }
        CFRetain(frameRef);
        _frameRef = frameRef;
    }
}

/**
 * 手动释放_frameRef内存
 */
- (void)dealloc
{
    if (_frameRef != nil) {
        CFRelease(_frameRef);
        _frameRef = nil;
    }
}

#pragma mark -
#pragma mark 触摸事件响应
// 开始触摸
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    // 1.获取手指点中的坐标
    CGPoint position = [[touches anyObject] locationInView:self];
    
    // 2.根据点中的坐标，寻找对应文字的索引
    // 2.1此处返回SXTAttributedLink对象，返回信息都在里面
    ZYAttributedLink *selectedLink = [self touchLinkWithPosition:position];
    
    // 2.2判断是否选中，选中的selectedLink != nil
    if (selectedLink) {
        // 3.1设置selectedLink为全局，方便后面使用
        self.selectedLink = selectedLink;
        // 3.2刷新
        [self setNeedsDisplay];
        
        return;
    }
    
    // 3.根据点中的坐标，寻找对应图片的索引
    // 3.1此处返回SXTAttributedImage对象，返回信息都在里面
    ZYAttributedImage *selectedImage = [self touchContentOffWithPosition:position];

    // 2.2判断是否选中，选中的selectedImage != nil
    if (selectedImage) {
        // 3.1设置selectedLink为全局，方便后面使用
        self.selectedImage = selectedImage;
    }
}

// 手指移动
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    // 0.获取手指点中的坐标
    CGPoint position = [[touches anyObject] locationInView:self];
    
    // 1.判断开始触碰的时候是否选中超文本
    if (self.selectedLink) {
        // 1.1获取当前手指选中的超文本
        ZYAttributedLink *selectedLink = [self touchLinkWithPosition:position];
        // 1.2如果当前选中的超文本和触碰开始时选中的超文本不一致
        // -> 取消当前选中
        if (selectedLink != self.selectedLink) {
            // 1.2.1取消当前选中
            self.selectedLink = nil;
            // 1.2.2刷新
            [self setNeedsDisplay];
        }
    }
    
    // 2.判断开始触碰的时候是否选图片
    if (self.selectedImage) {
        // 1.1获取当前手指选中的图片
        ZYAttributedImage *selectedImage = [self touchContentOffWithPosition:position];
        // 1.2.如果当前选中的图片和触碰开始时选中的图片不一致
        // -> 取消当前选中
        if (selectedImage != self.selectedImage) {
            // 4.1取消当前选中
            self.selectedImage = nil;
        }
    }
}

// 结束触摸
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    // 1.判断结束触摸时是否还选中超文本
    if (self.selectedLink) {
        // 1.1代理回调通知控制器
        if ([self.delegate respondsToSelector:@selector(attributedLabel:selectedLink:)]) {
            [self.delegate attributedLabel:self selectedLink:self.selectedLink];
        }
        // 2.2取消选中
        self.selectedLink = nil;
        // 2.3刷新
        [self setNeedsDisplay];
    }
    
    
    // 2.判断结束触摸时是否还选中超文本
    if (self.selectedImage) {
        // 2.1.代理回调通知控制器
        if ([self.delegate respondsToSelector:@selector(attributedLabel:selectedImage:)]) {
            [self.delegate attributedLabel:self selectedImage:self.selectedImage];
        }
        // 2.2.取消选中
        self.selectedImage = nil;
    }
}

#pragma mark -
#pragma mark 根据文本计算size大小
- (CGSize)sizeThatFits:(CGSize)size
{
    // 根据文本计算size大小
    CGSize newSize = [self.attributedString sizeWithWidth:size.width numberOfLines:self.numberOfLines];
   
    // 返回自适应的size
    return newSize;
}

#pragma mark - drawRect
- (void)drawRect:(CGRect)rect
{
    // 1.获取图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 2.翻转坐标系
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(0, rect.size.height), 1.f, -1.f);
    CGContextConcatCTM(context, transform);
    
    // 3.获取CTFrameRef
    self.frameRef = [self.attributedString prepareFrameRefWithRect:rect];
    
    // 4.绘制高亮背景颜色
    [self drawHighlightedColor];
    
    // 5.一行一行的绘制文字
    [self frameLineDraw];
    
    // 6.绘制图片
    [self drawImages];
}

@end
