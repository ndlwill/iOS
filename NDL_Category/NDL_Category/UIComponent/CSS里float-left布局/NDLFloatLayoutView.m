//
//  NDLFloatLayoutView.m
//  NDL_Category
//
//  Created by ndl on 2018/1/30.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "NDLFloatLayoutView.h"
#import "UIView+NDLExtension.h"
#import "CommonDefines.h"

#define NDLValueSwitchAlignLeftOrRight(valueLeft, valueRight) ([self isAlignLeft] ? valueLeft : valueRight)

@implementation NDLFloatLayoutView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self didInitialized];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self didInitialized];
    }
    return self;
}

- (void)didInitialized
{
    self.padding = UIEdgeInsetsZero;
    self.contentMode = UIViewContentModeLeft;
}

#pragma mark - Override
// 设置self.frame会调用layoutSubviews
- (void)layoutSubviews
{
    NSLog(@"NDLFloatLayoutView-layoutSubviews");
    [super layoutSubviews];
    [self layoutSubviewsWithSize:self.bounds.size shouldLayout:YES];
}


// - (void)sizeToFit;  calls sizeThatFits: with current view bounds
// 需要调用[self.floatLayoutView sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)]计算高度
- (CGSize)sizeThatFits:(CGSize)size
{
    NSLog(@"NDLFloatLayoutView-sizeThatFits:size = %@", NSStringFromCGSize(size));
    return [self layoutSubviewsWithSize:size shouldLayout:NO];
}


// viewDidLayoutSubviews->sizeThatFits(确定view宽高)->layoutSubviews
#pragma mark - Private Methods
- (CGSize)layoutSubviewsWithSize:(CGSize)size shouldLayout:(BOOL)shouldLayout {
    NSArray<UIView *> *visibleSubViews = [self ndl_visibleSubViews];
    
    if (visibleSubViews.count == 0) {
        return CGSizeMake(UIEdgeInsetsGetHorizontalValue(self.padding), UIEdgeInsetsGetVerticalValue(self.padding));
    }
    
    // item的origin
    CGPoint itemViewOrigin = CGPointMake(NDLValueSwitchAlignLeftOrRight(self.padding.left, size.width - self.padding.right), self.padding.top);
    // rowMaxY
    CGFloat curRowMaxY = itemViewOrigin.y;
    
    // item最大的宽高
    CGSize maxItemSize = CGSizeMake(size.width - UIEdgeInsetsGetHorizontalValue(self.padding), size.height - UIEdgeInsetsGetVerticalValue(self.padding));
    
    for (NSInteger i = 0, length = visibleSubViews.count; i < length; i++) {
        // item
        UIView *itemView = visibleSubViews[i];
        
        //itemSize
        CGSize itemViewSize = [itemView sizeThatFits:maxItemSize];
        NSLog(@"itemViewSize = %@", NSStringFromCGSize(itemViewSize));
        itemViewSize.width = fmin(itemViewSize.width, maxItemSize.width);
        itemViewSize.height = fmin(itemViewSize.height, maxItemSize.height);
        
        // 判断是否需要换行
        BOOL shouldNewLine = (i == 0 ? YES : NDLValueSwitchAlignLeftOrRight(itemViewOrigin.x + self.itemMargins.left + itemViewSize.width + self.padding.right > size.width, itemViewOrigin.x - self.itemMargins.right - itemViewSize.width - self.padding.left < 0));
        
        
        if (shouldNewLine) {
            // 换行 每一行第一个item不考虑itemMargins.left 第一行第一个item不考虑itemMargins.left
            if (shouldLayout) {
                // 布局每行的第一个item
                itemView.frame = CGRectMake(NDLValueSwitchAlignLeftOrRight(self.padding.left, size.width - self.padding.right - itemViewSize.width), curRowMaxY + self.itemMargins.top, itemViewSize.width, itemViewSize.height);
            }
            
            // 计算下一个item的origin
            itemViewOrigin.x = NDLValueSwitchAlignLeftOrRight(self.padding.left + itemViewSize.width + self.itemMargins.right, size.width - self.padding.right - itemViewSize.width - self.itemMargins.left);
            itemViewOrigin.y = curRowMaxY;
        } else {
            // 不换行
            if (shouldLayout) {
                itemView.frame = CGRectMake(NDLValueSwitchAlignLeftOrRight(itemViewOrigin.x + self.itemMargins.left, itemViewOrigin.x - self.itemMargins.right - itemViewSize.width), itemViewOrigin.y + self.itemMargins.top, itemViewSize.width, itemViewSize.height);
            }
            
            // 计算下一个item的origin
            itemViewOrigin.x = NDLValueSwitchAlignLeftOrRight(itemViewOrigin.x + UIEdgeInsetsGetHorizontalValue(self.itemMargins) + itemViewSize.width, itemViewOrigin.x - itemViewSize.width - UIEdgeInsetsGetHorizontalValue(self.itemMargins));
        }
        
        // 计算maxY
        curRowMaxY = fmax(curRowMaxY, itemViewOrigin.y + UIEdgeInsetsGetVerticalValue(self.itemMargins) + itemViewSize.height);
    }
    
    // 最后一行不需要考虑itemMarins.bottom
    curRowMaxY -= self.itemMargins.bottom;
    
    CGSize resultSize = CGSizeMake(size.width, curRowMaxY + self.padding.bottom);
    return resultSize;
}

- (BOOL)isAlignLeft
{
    return self.contentMode == UIViewContentModeLeft;
}

@end
