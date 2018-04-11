//
//  PopoverView.m
//  NDL_Category
//
//  Created by dzcx on 2018/3/14.
//  Copyright © 2018年 ndl. All rights reserved.
//

#define kItemCount 3
#define kItemSpace 10

#import "PopoverView.h"
#import "UIView+NDLExtension.h"

@interface PopoverView ()
{
    CGFloat _superViewRightPointX;
    NSArray *_titles;
    NSArray *_subTitles;
    NSArray *_images;
}

@property (nonatomic, weak) UIView *wrapperView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) NSMutableArray *imageViewArray;

@property (nonatomic, assign) BOOL isAnimating;

@end

@implementation PopoverView

#pragma mark - Lazy Load
- (NSMutableArray *)imageViewArray
{
    if (!_imageViewArray) {
        _imageViewArray = [NSMutableArray array];
    }
    return _imageViewArray;
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame superViewRightPointX:(CGFloat)pointX titles:(NSArray *)titles subTitles:(NSArray *)subTitles images:(NSArray *)images
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _superViewRightPointX = pointX;
        _titles = titles;
        _subTitles = subTitles;
        _images = images;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    // wrapperView
    UIView *wrapperView = [[UIView alloc] initWithFrame:CGRectMake(20, 8, self.width - 40, self.height - 16 - 2 * kSmallCircleRadius - kBigCircleRadius)];
    [self addSubview:wrapperView];
    self.wrapperView = wrapperView;
    
    // bottomView
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, wrapperView.height / 2, wrapperView.width, wrapperView.height / 2)];
//    self.bottomView.backgroundColor = [UIColor whiteColor];
    [wrapperView addSubview:self.bottomView];
    
    self.bottomView.layer.anchorPoint = CGPointMake(1, 1);
    self.bottomView.layer.position = CGPointMake(wrapperView.width, wrapperView.height);
    
    
    
    //
    CGFloat itemW = (wrapperView.width - (kItemCount - 1) * kItemSpace) / kItemCount;
    // corner = 9
    for (NSInteger i = 0; i < kItemCount; i++) {
        // tap
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(kItemSpace * i + itemW * i, 0, itemW, wrapperView.height)];
        //tapView.hidden = YES;
        tapView.tag = i;
        //tapView.backgroundColor = [UIColor lightGrayColor];
        tapView.layer.cornerRadius = 9;
        [wrapperView addSubview:tapView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemDidTapped:)];
        [tapView addGestureRecognizer:tap];
        
        // titleLabel
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = _titles[i];
        titleLabel.textColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0];
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        [self.bottomView addSubview:titleLabel];
        [titleLabel sizeToFit];
        titleLabel.centerX = tapView.centerX;
        titleLabel.y = 0;
        
        // subTitles
        UILabel *subTitles = [[UILabel alloc] init];
        subTitles.text = _subTitles[i];
        subTitles.textColor = [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1.0];
        subTitles.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [self.bottomView addSubview:subTitles];
        [subTitles sizeToFit];
        subTitles.centerX = tapView.centerX;
        subTitles.y = titleLabel.height + 1.0;
        
        // images
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_images[i]]];
        [wrapperView addSubview:imageView];
        [imageView sizeToFit];
        imageView.centerX = tapView.centerX;
        imageView.centerY = wrapperView.height / 4;
        [self.imageViewArray addObject:imageView];
    }
    
    
    
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    NSLog(@"layoutSubviews");
}

#pragma mark - GestureRecognizer
- (void)itemDidTapped:(UIGestureRecognizer *)gesture
{
    UIView *tempView = gesture.view;
    tempView.backgroundColor = [UIColor colorWithRed:237/255.0 green:238/255.0 blue:244/255.0 alpha:1.0];
//    tempView.backgroundColor = [UIColor clearColor];
    
    [self.wrapperView insertSubview:self.bottomView aboveSubview:tempView];
    NSLog(@"===itemDidTapped index = %ld===", tempView.tag);
}

#pragma mark - draw rect
- (void)drawRect:(CGRect)rect
{
    NSLog(@"drawRect");
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    // 阴影
//    self.layer.shadowColor = [[UIColor redColor] CGColor];
//    self.layer.shadowOpacity = 1.0;
//    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}

- (void)drawInContext:(CGContextRef)context
{
    // 设置参数
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor cyanColor].CGColor);
    
    // 绘制Popover Path
    [self drawPopoverPath:context];
    
    // 填充Path
    //CGContextFillPath(context);
}



- (void)drawPopoverPath:(CGContextRef)context
{
    CGRect rect = self.bounds;
    
    // x
    CGFloat minx = CGRectGetMinX(rect),
    maxx = CGRectGetMaxX(rect),
    startX = _superViewRightPointX + 2 * kSmallCircleRadius + kBigCircleRadius;// 大圆中心点
    
    // y
    CGFloat miny = CGRectGetMinY(rect),
    maxy = CGRectGetMaxY(rect) - 2 * kSmallCircleRadius - kBigCircleRadius;
    

    
//    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
//    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
//    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
    
    //CGContextMoveToPoint(context, startX, maxy);
    
    
    CGContextAddArc(context, startX, maxy, kBigCircleRadius, 0, M_PI, 0);
    

    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, kRectCorner);
//    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
//    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
//    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, miny, maxx, miny, kRectCorner);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxy, kRectCorner);
    CGContextAddArcToPoint(context, maxx, maxy, minx, maxy, kRectCorner);
    
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    // 小圆
    CGContextAddArc(context, _superViewRightPointX + kSmallCircleRadius, CGRectGetMaxY(rect) - kSmallCircleRadius, kSmallCircleRadius, 0, 2 * M_PI, 0);
    CGContextFillPath(context);
    
    //CGContextAddEllipseInRect
}

- (void)startAnimation
{
    self.isAnimating = YES;
    
    self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
    
    self.bottomView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.5 delay:0.1 options:kNilOptions animations:^{
        self.bottomView.transform = CGAffineTransformIdentity;
    } completion:nil];

    
    for (NSInteger i = 0; i < self.imageViewArray.count; i++) {
        UIImageView *imageView = self.imageViewArray[i];
        imageView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        
        // scale = 1.0  0.2s    scale = 1.1  0.3s
        // delay1 = 0.3 delay2 = 0.5
        [UIView animateWithDuration:0.3 delay:(0.3 + 0.2 * i) options:kNilOptions animations:^{
            imageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                imageView.transform = CGAffineTransformMakeScale(0.9, 0.9);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    imageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.1 animations:^{
                        imageView.transform = CGAffineTransformMakeScale(0.9, 0.9);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.1 animations:^{
                            imageView.transform = CGAffineTransformIdentity;
                        } completion:^(BOOL finished) {
                            if (i == self.imageViewArray.count - 1) {
                                self.isAnimating = NO;
                            }
                            
                        }];
                    }];
                }];
            }];
        }];

        
    }
}

@end
