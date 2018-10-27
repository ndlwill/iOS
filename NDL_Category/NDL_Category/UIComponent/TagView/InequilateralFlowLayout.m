//
//  InequilateralFlowLayout.m
//  NDL_Category
//
//  Created by dzcx on 2018/9/13.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "InequilateralFlowLayout.h"

@interface InequilateralFlowLayout ()

/** 存放所有cell的布局属性 */
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attrsArray;
/** 内容的高度 */
@property (nonatomic, assign) CGFloat contentHeight;

@property (nonatomic, assign) CGFloat nextX;
@property (nonatomic, assign) CGFloat nextY;

@end

@implementation InequilateralFlowLayout

#pragma mark - lazy load
- (NSMutableArray<UICollectionViewLayoutAttributes *> *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

#pragma mark - init
- (instancetype)init
{
    if (self = [super init]) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        self.minimumLineSpacing = 10;
        self.minimumInteritemSpacing = 5;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return self;
}

#pragma mark - private methods
- (CGFloat)minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        return [self.delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
    }
    return self.minimumLineSpacing;
}

- (CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        return [self.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
    }
    return self.minimumInteritemSpacing;
}

- (UIEdgeInsets)insetForSectionAtIndex:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        return [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    }
    return self.sectionInset;
}

#pragma mark - overrides
//reloadData   刷新的时候，重新调这个方法
- (void)prepareLayout
{
    [super prepareLayout];
    
    // reset
    self.contentHeight = 0;
    UIEdgeInsets sectionInset = [self insetForSectionAtIndex:0];// 第一个section的inset
    self.nextX = sectionInset.left;
    self.nextY = sectionInset.top;
    [self.attrsArray removeAllObjects];
    
    // 开始创建每一个cell对应的布局属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i++) {
        // 创建位置
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        // 获取indexPath位置cell对应的布局属性
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    NSLog(@"===shouldInvalidateLayoutForBoundsChange===");
    if (!CGSizeEqualToSize(newBounds.size, self.collectionView.bounds.size)) {
        return YES;
    }
    return NO;
}

/**
 * 决定cell的排布
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // 数组过滤
//    [self.attrsArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
//        
//    }]];
    
    return self.attrsArray;
}

/**
 * 返回indexPath位置cell对应的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    // collectionView的宽度
    CGFloat collectionViewWidth = self.collectionView.width;
    
    CGFloat minimumInteritemSpacing = [self minimumInteritemSpacingForSectionAtIndex:0];
    CGFloat minimumLineSpacing = [self minimumLineSpacingForSectionAtIndex:0];
    // itemSize包括tagInsets 每个itemSize的高相同
    CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    // sectionInset
    UIEdgeInsets sectionInset = [self insetForSectionAtIndex:0];
    
    // 考虑极限值
    if (self.nextX + itemSize.width + minimumInteritemSpacing > collectionViewWidth - sectionInset.right) {// 换行
        self.nextY += (minimumLineSpacing + itemSize.height);
        attrs.frame = CGRectMake(sectionInset.left, self.nextY, itemSize.width, itemSize.height);
        self.nextX = (sectionInset.left + itemSize.width + minimumInteritemSpacing);
    } else {
        attrs.frame = CGRectMake(self.nextX, self.nextY, itemSize.width, itemSize.height);
        self.nextX += (itemSize.width + minimumInteritemSpacing);
    }
    
    self.contentHeight = self.nextY + itemSize.height + sectionInset.bottom;
    
    return attrs;
}

- (CGSize)collectionViewContentSize
{
    CGSize contentSize = CGSizeMake(self.collectionView.width, self.contentHeight);
    // 改变collectionView.height根据contentSize.height
    
    self.collectionView.height = contentSize.height;
    self.collectionView.superview.height = contentSize.height;
    // 或者
//    self.collectionView.superview.height = contentSize.height;
//    [self.collectionView.superview setNeedsLayout];// 调用layoutSubviews改变collectionView.height
    
    return contentSize;
}

@end
