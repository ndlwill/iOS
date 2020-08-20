//
//  HorizontalLinearMiddleScaleLayout.m
//  NDL_Category
//
//  Created by dzcx on 2018/4/27.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "HorizontalLinearMiddleScaleLayout.h"

/**
 1.cell的放大和缩小
 2.停止滚动时：cell的居中
 */
@implementation HorizontalLinearMiddleScaleLayout

/**
 * 当collectionView的显示范围发生改变的时候，是否需要重新刷新布局
 * 一旦重新刷新布局，就会重新调用下面的方法：
 1.prepareLayout
 2.layoutAttributesForElementsInRect:方法
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    NSLog(@"===shouldInvalidateLayoutForBoundsChange===");
    return YES;
}

/**
 * 用来做布局的初始化操作（不建议在init方法中进行布局的初始化操作）
 * 一定要调用[super prepareLayout]
 */
- (void)prepareLayout
{
    [super prepareLayout];
    NSLog(@"=====prepareLayout 在collectionView添加到父视图后调用=====");
    
    // 水平滚动
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 设置内边距 第一个显示在中间
    CGFloat inset = (self.collectionView.frame.size.width - self.itemSize.width) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
}

/**
 UICollectionViewLayoutAttributes *attrs;
 1.一个cell对应一个UICollectionViewLayoutAttributes对象
 2.UICollectionViewLayoutAttributes对象决定了cell的frame
 */
/**
 *
 * 这个方法的返回值是一个数组（数组里面存放着rect范围内所有元素的布局属性）  这个数组中存放的都是UICollectionViewLayoutAttributes对象
 * 这个方法的返回值决定了rect范围内所有元素的排布（frame）
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSLog(@"===layoutAttributesForElementsInRect===");
    // 获得super已经计算好的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    // 计算collectionView最中心点的x值
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    // 在原有布局属性的基础上，进行微调
    for (UICollectionViewLayoutAttributes *attrs in array) {
        // cell的中心点x 和 collectionView最中心点的x值 的间距
        CGFloat delta = ABS(attrs.center.x - centerX);
        
        // 根据间距值 计算 cell的缩放比例
        CGFloat scale = 1 - delta / self.collectionView.frame.size.width;
        NSLog(@"scale = %f", scale);
        
        // 设置缩放比例
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
    }
    
    return array;
}


/**
 * 这个方法的返回值，就决定了collectionView停止滚动时的偏移量  （contentOffset）
 * proposedContentOffset本应该停留的位置
 */
//proposedContentOffset：原本情况下，collectionView停止滚动时最终的偏移量
//velocity：滚动速率，通过这个参数可以了解滚动的方向
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    NSLog(@"proposedContentOffset = %@ velocity = %@", NSStringFromCGPoint(proposedContentOffset), NSStringFromCGPoint(velocity));
    // 计算出最终显示的矩形框
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;
    rect.size = self.collectionView.frame.size;

    // 获得super已经计算好的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect];

    // 计算collectionView最中心点的x值
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;

    // 存放最小的间距值
    CGFloat minDelta = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (ABS(minDelta) > ABS(attrs.center.x - centerX)) {
            minDelta = attrs.center.x - centerX;
        }
    }

    // 修改原有的偏移量
    proposedContentOffset.x += minDelta;
    NSLog(@"after proposedContentOffset = %@", NSStringFromCGPoint(proposedContentOffset));
    return proposedContentOffset;
}


@end
