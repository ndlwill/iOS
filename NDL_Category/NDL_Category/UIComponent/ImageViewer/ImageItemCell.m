//
//  ImageItemCell.m
//  NDL_Category
//
//  Created by dzcx on 2018/11/19.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "ImageItemCell.h"
#import "FLAnimatedImageView.h"
#import "ImageLoadingView.h"

#import "DALabeledCircularProgressView.h"

static CGFloat const minZoomScale = 1.0f;// scrollView default也是这个
static CGFloat const maxZoomScale = 2.5f;

static CGFloat const minImageScale = 0.2f;

@interface ImageItemCell () <UIScrollViewDelegate>

// 加载完成标记
@property (nonatomic, assign) BOOL loadFinishedFlag;// 如果imageView有placeholder，需要使用这个

@property (nonatomic, assign) BOOL verticalPanFlag;// 不需要
@property (nonatomic, assign) CGPoint panBeginPoint;// 不需要 pan手势可以用translationInView:

//@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) FLAnimatedImageView *imageView;

@property (nonatomic, strong) UIImageView *thumbnailImageView;

// 
@property (nonatomic, strong) ImageLoadingView *loadingView;
//@property (nonatomic, strong) DACircularProgressView *progressView;

@end

@implementation ImageItemCell

#pragma mark - lazy load
- (UIImageView *)thumbnailImageView
{
    if (!_thumbnailImageView) {
        _thumbnailImageView = [[UIImageView alloc] init];
        _thumbnailImageView.contentMode = UIViewContentModeScaleAspectFill;
        _thumbnailImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_thumbnailImageView];
    }
    return _thumbnailImageView;
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _setupUI];
    }
    return self;
}

#pragma mark - overrides
- (void)prepareForReuse
{
    [super prepareForReuse];
    NSLog(@"prepareForReuse");
    
    // 复用问题（for imageView - placeholderImage）
//    self.imageView.image = nil;
//    self.imageView.frame = CGRectMake(0, 0, self.width, self.width * 9 / 16);
//    self.imageView.centerY = self.height / 2.0;
    
    // =====reset=====
    // 缩略图 reset
    self.thumbnailImageView.image = nil;
    self.thumbnailImageView.hidden = NO;
    // loadingView reset
    self.loadingView.progress = 0.0;
    self.loadingView.hidden = NO;
    
    self.scrollView.zoomScale = minZoomScale;
    
    self.panBeginPoint = CGPointZero;
}

#pragma mark - setter
- (void)setThumbnailImagePath:(NSString *)thumbnailImagePath
{
    if (thumbnailImagePath && thumbnailImagePath.length > 0) {
        _thumbnailImagePath = thumbnailImagePath;
        
        [self.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:thumbnailImagePath]];
    }
}

- (void)setOriginalImagePath:(NSString *)originalImagePath
{
    if (originalImagePath && originalImagePath.length > 0) {
        _originalImagePath = originalImagePath;
        
//        self.scrollView.zoomScale = minZoomScale;
        
        // 本地图片
//        [UIImage imageWithContentsOfFile:@""];
        
        if (!self.firstSelectionFlag) {
            [self _loadOriginalImage];
        }
    }
}

- (void)setThumbnailImageRect:(CGRect)thumbnailImageRect
{
    _thumbnailImageRect = thumbnailImageRect;
    
    // 缓存了原图的 不需要显示缩略图
    if (!self.firstSelectionImageExistFlag) {
        self.thumbnailImageView.size = thumbnailImageRect.size;
        self.thumbnailImageView.center = CGPointMake(self.contentView.width / 2.0, self.contentView.height / 2.0);
    }
}

#pragma mark - private methods
- (void)_setupUI
{
    self.panBeginPoint = CGPointZero;
    
    // bgView
//    self.bgView = [[UIView alloc] initWithFrame:self.bounds];
//    self.bgView.backgroundColor = [UIColor blackColor];
//    [self.contentView addSubview:self.bgView];
    
    // scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];// 透明色
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = minZoomScale;
    self.scrollView.maximumZoomScale = maxZoomScale;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    // 滚动减速速率
    self.scrollView.decelerationRate = 0.1;
    
    // ###手势移除ImageViewer动画只针对size在{375, 667}范围内的图片###
    [self.scrollView.panGestureRecognizer addTarget:self action:@selector(scrollViewWhenPan:)];
//    self.scrollView.panGestureRecognizer
//    self.scrollView.pinchGestureRecognizer
    //    self.scrollView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.scrollView];
    
    // loadingView
    self.loadingView = [ImageLoadingView showInView:self];
    
    // 双击
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfDidDoubleTapped:)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
    // 单击
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfDidSingleTapped:)];
    [self addGestureRecognizer:singleTap];
    // 解决单击和双击手势冲突
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    // imageView
    self.imageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width * 9 / 16)];
//    self.imageView.userInteractionEnabled = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.centerY = self.height / 2.0;
    [self.scrollView addSubview:self.imageView];
}

- (void)_updateImageViewFrameWithImage:(UIImage *)image
{
    CGSize imageSize = image.size;
    
    CGFloat imageViewHeight = self.width * imageSize.height / imageSize.width;
    NSLog(@"imageViewHeight = %lf", imageViewHeight);
    self.imageView.size = CGSizeMake(self.width, imageViewHeight);
    // 设置y
    if (imageViewHeight < self.height) {
        self.imageView.y = (self.height - imageViewHeight) / 2.0;
        // 设置滚动区域（contentSize）
//        self.scrollView.contentSize = self.scrollView.size;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.scrollView.height + 1.0);// 为了走self.scrollView.panGestureRecognizer
        NSLog(@"imageViewFrame = %@", NSStringFromCGRect(self.imageView.frame));
        NSLog(@"< contentSize = %@", NSStringFromCGSize(self.scrollView.contentSize));
    } else {
        self.imageView.y = 0.0;
        // 设置滚动区域（contentSize）
        self.scrollView.contentSize = self.imageView.size;
        NSLog(@"imageViewFrame = %@", NSStringFromCGRect(self.imageView.frame));
        NSLog(@"> contentSize = %@", NSStringFromCGSize(self.scrollView.contentSize));
    }
}

- (void)_updateImageViewFrameWhenZoom
{
    // 系统会自动缩放contentSize（根据- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView这个方法的view的size）
    
    CGFloat imageViewHeight = self.imageView.height;
    CGFloat scrollViewHeight = self.scrollView.height;
    // imageView缩放后(或者缩小)的高度 与 scrollView的高比较
    if (imageViewHeight < scrollViewHeight) {
        self.imageView.y = (scrollViewHeight - imageViewHeight) / 2.0;
        
        // 这个情况需要调整contentSize
        self.scrollView.contentSize = CGSizeMake(self.imageView.width, scrollViewHeight);
    } else {
        self.imageView.y = 0.0;
        // 这种情况下,缩放前imageView和contentSize的size一样，缩放后不需要调整contentSize
    }
}

- (void)_loadOriginalImage
{
    // 显示原图
    // SDWebImageProgressiveDownload逐渐显示图片
    // placeholader: [UIImage ndl_imageWithColor:[UIColor lightGrayColor] size:CGSizeMake(1, 1)] 设置placeholderImage其实就是设置self.imageView的image
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_originalImagePath] placeholderImage:nil options:(SDWebImageRetryFailed | SDWebImageLowPriority) progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        // 已经缓存的图片，再显示，不走progress
        
        // 在主线程设置UI
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"image = %@", self.imageView.image);
            self.loadingView.progress = fabs((1.0 * receivedSize / expectedSize));
        });
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            NSLog(@"===has image===");
            self.thumbnailImageView.hidden = YES;
            self.loadingView.hidden = YES;
            [self _updateImageViewFrameWithImage:image];
        }
    }];
}

// 勾股定理-Pythagorean theorem 斜边-hypotenuse
- (CGFloat)_lineLengthFromOnePoint:(CGPoint)onePoint otherPoint:(CGPoint)otherPoint
{
    CGFloat length = 0.0;
    CGFloat xDelta = otherPoint.x - onePoint.x;
    CGFloat yDelta = otherPoint.y - onePoint.y;
    length = [self _lineLengthFromDeltaPoint:CGPointMake(xDelta, yDelta)];
    return length;
}

- (CGFloat)_lineLengthFromDeltaPoint:(CGPoint)deltaPoint
{
    CGFloat length = 0.0;
    length = sqrt(pow(deltaPoint.x, 2) + pow(deltaPoint.y, 2));
    return length;
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        return;
    }
    
    // 图片存储成功
}

#pragma mark - public methods
- (void)executeInitialAnimation
{
    if (self.firstSelectionImageExistFlag) {
        UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:self.originalImagePath];
        self.imageView.image = image;
        [self _updateImageViewFrameWithImage:image];
        CGRect endFrame = self.imageView.frame;
        self.imageView.frame = self.thumbnailImageRect;
        self.loadingView.hidden = YES;
        
        [UIView animateWithDuration:0.2 animations:^{
            self.imageView.frame = endFrame;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        CGRect endFrame = self.thumbnailImageView.frame;
        self.thumbnailImageView.frame = self.thumbnailImageRect;
        self.loadingView.hidden = YES;
        
        [UIView animateWithDuration:0.2 animations:^{
            self.thumbnailImageView.frame = endFrame;
        } completion:^(BOOL finished) {
            // 做完frame动画，再显示loadingView，开始加载图片
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.loadingView.hidden = NO;
                [self _loadOriginalImage];
            });
        }];
    }
}

- (void)saveImage
{
    if (!self.imageView.image) {
        return;
    }
    
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"#####scrollViewDidScroll imageViewSize = %@", NSStringFromCGSize(self.imageView.size));
}

// 一旦zoom有变化就调用
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    // 两个手指缩放会调用多次，双击缩放只调用1次
    NSLog(@"===scrollViewDidZoom===");
    
    [self _updateImageViewFrameWhenZoom];
    
    // 375 * 667
//    NSLog(@"scrollView frame = %@", NSStringFromCGRect(scrollView.frame));
    
    // {937.5 = imageView.width(375) * 2.5, 1216.1726804123714 = imageView.height(第一张图片486.469) * 2.5}
//    NSLog(@"contentSize = %@", NSStringFromCGSize(scrollView.contentSize));
    
    // 缩放后contentOffset发生了改变,为了居中显示图片
//    NSLog(@"contentOffset = %@", NSStringFromCGPoint(scrollView.contentOffset));
}

// scale between minimum and maximum. called after any 'bounce' animations
// 都只调用1次
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale
//{
//    // 双击放大后的
//    // view = <FLAnimatedImageView: 0x7f9bdcd8bf20; baseClass = UIImageView; frame = (0 90.2655; 937.5 1216.17); transform = [2.5, 0, 0, 2.5, 0, 0]; opaque = NO; userInteractionEnabled = NO; layer = <CALayer: 0x600003bcae00>>
//    NSLog(@"===scrollViewDidZoom withView scale = %lf view = %@=== contentSize = %@ scrollViewFrame = %@", scale, view, NSStringFromCGSize(scrollView.contentSize), NSStringFromCGRect(scrollView.frame));// 系统会自动缩放contentSize（根据- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView这个方法的view的size） scrollViewFrame不变
//}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

#pragma mark - gesture
- (void)selfDidDoubleTapped:(UIGestureRecognizer *)gesture
{
    NSLog(@"selfDidDoubleTapped");
    if (!self.imageView.image) {
        return;
    }
    
    CGFloat zoomScale = (self.scrollView.zoomScale == minZoomScale) ? maxZoomScale : minZoomScale;
    [self.scrollView setZoomScale:zoomScale animated:YES];
}

// 移除ImageViewer
- (void)selfDidSingleTapped:(UIGestureRecognizer *)gesture
{
    NSLog(@"selfDidSingleTapped");
    // test for longImage   originalImage = {375, 3390.340909090909}
    // imageViewFrame = {{0, 0}, {937.5, 8475.8522727272721}} contentOffset = {281.5, ###500.5###} contentSize = {937.5, 8475.8522727272721}
    NSLog(@"imageViewFrame = %@ contentOffset = %@ contentSize = %@", NSStringFromCGRect(self.imageView.frame), NSStringFromCGPoint(self.scrollView.contentOffset), NSStringFromCGSize(self.scrollView.contentSize));
    
    if (self.imageView.image) {// 图片加载完了，作frame动画
        if (self.hasImageWillDismissBlock) {
            self.hasImageWillDismissBlock();
        }
        
        // imageView Size > scrollView Size
        if (self.imageView.width >= self.scrollView.width && self.imageView.height >= self.scrollView.height) {
            
            // 超长图
            if (self.imageView.height > (self.scrollView.height * maxZoomScale)) {
                self.scrollView.contentOffset = CGPointZero;
                self.imageView.frame = self.scrollView.bounds;
            } else {
                // 没有缩放的状态下
                if (self.scrollView.zoomScale == minZoomScale) {// 原图就是长图
                    // TODO:图片居中显示
                } else {
                    // contentSize不变
                    // 调整scrollView.contentOffset到zero并且图片居中显示，不然做动画会有显示bug
                    self.imageView.origin = CGPointMake(-self.scrollView.contentOffset.x, -self.scrollView.contentOffset.y);
                    self.scrollView.contentOffset = CGPointZero;// ###
                    
                    // 或者
                    //            self.imageView.origin = CGPointMake(-self.scrollView.contentOffset.x, -self.scrollView.contentOffset.y);
                    //            [self.contentView addSubview:self.imageView];
                }
            }
        }

        NSLog(@"===frame动画===");
        [UIView animateWithDuration:0.3 animations:^{
//            self.bgView.alpha = 0.0;
            self.collectionView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
            self.imageView.frame = self.thumbnailImageRect;
        } completion:^(BOOL finished) {
            if (self.executeDismissBlock) {
                self.executeDismissBlock();
            }
        }];
    } else {// 如果图片还没加载完，渐变消失动画
        NSLog(@"===渐变消失动画===");
        if (self.noImageDismissBlock) {
            self.noImageDismissBlock();
        }
    }
}

- (void)scrollViewWhenPan:(UIPanGestureRecognizer *)gesture
{
    // 因为设计的时候，图片的宽度等于屏幕的宽度，所以水平拖拽绝对不会走这边
//    NSLog(@"===scrollViewWhenPan gesture.view = scrollView===");
    // 放大的情况下不处理
    if (self.scrollView.zoomScale > minZoomScale) {
        return;
    }
    
    if (self.imageView.height > self.height) {
        return;
    }
    // 暂时没有考虑minZoomScale下的长图 TODO:
    
    UIView *gestureView = gesture.view;
    CGPoint locationPoint = [gesture locationInView:gestureView];
    CGPoint translation = [gesture translationInView:gestureView];// 和panBeginPoint的delta
    
    NSLog(@"locationPoint = %@ translation = %@", NSStringFromCGPoint(locationPoint), NSStringFromCGPoint(translation));
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSLog(@"UIGestureRecognizerStateBegan");
            self.panBeginPoint = locationPoint;
            // 隐藏toolBar
            if (self.hasImageWillDismissBlock) {
                self.hasImageWillDismissBlock();
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            NSLog(@"UIGestureRecognizerStateChanged");
            CGFloat scale = minImageScale;
            CGFloat tempScale = 1.0;
            CGFloat panLength = [self _lineLengthFromDeltaPoint:translation];
            CGFloat maxPanLength = NDLScreenH / 2.0;
            if (panLength < maxPanLength) {
                tempScale = (panLength / maxPanLength);
                scale = (1 - (1 - minImageScale) * tempScale);
            }
            CGFloat dismissPanLength = NDLScreenH / 4.0;
            CGFloat bgColorAlpha = 0.0;
            if (panLength < dismissPanLength) {
                bgColorAlpha = (1 - (panLength / dismissPanLength));
            }
            self.collectionView.backgroundColor = [UIColor colorWithWhite:0 alpha:bgColorAlpha];
            self.imageView.transform = CGAffineTransformMake(scale, 0, 0, scale, translation.x, translation.y);
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            NSLog(@"UIGestureRecognizerStateEnded");
//            CGRect imageViewFrame = self.imageView.frame;
//            self.imageView.transform = CGAffineTransformIdentity;
//            self.imageView.frame = imageViewFrame;
            if (ABS(translation.y) >= (NDLScreenH / 4.0)) {// dismiss消失
                [UIView animateWithDuration:0.3 animations:^{
                    self.imageView.frame = self.thumbnailImageRect;
                } completion:^(BOOL finished) {
                    if (self.executeDismissBlock) {
                        self.executeDismissBlock();
                    }
                }];
            } else {// restore恢复
                [UIView animateWithDuration:0.3 animations:^{
                    self.imageView.transform = CGAffineTransformIdentity;
                    self.collectionView.backgroundColor = [UIColor colorWithWhite:0 alpha:1.0];
                } completion:^(BOOL finished) {
                    if (self.imageViewRestoreFinishedBlock) {
                        self.imageViewRestoreFinishedBlock();
                    }
                }];
            }
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - UIGestureRecognizerDelegate
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    NSLog(@"gestureRecognizer = %@ otherGestureRecognizer = %@", gestureRecognizer, otherGestureRecognizer);
//
//    return YES;// YES表示同时触发
//}

@end
