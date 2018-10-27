//
//  TagView.h
//  NDL_Category
//
//  Created by dzcx on 2018/9/13.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TagViewDelegate;

// 不需要设置height，自动计算
@interface TagView : UIView

@property (nonatomic, weak) id<TagViewDelegate> delegate;

@property (nonatomic, assign) UIEdgeInsets contentInsets;// insets default: (10, 10, 10, 10)
@property (nonatomic, assign) CGFloat lineSpace;// 行间距 default: 10
@property (nonatomic, assign) CGFloat itemSpace;// item间距 default: 5

// =====tag property=====
@property (nonatomic, assign) UIEdgeInsets tagInsets;// tagInsets default: (5, 5, 5, 5)
// border
@property (nonatomic, assign) CGFloat tagBorderWidth;// default: 0
@property (nonatomic, strong) UIColor *tagBorderColor;
@property (nonatomic, strong) UIColor *tagSelectedBorderColor;
// corner radius
@property (nonatomic, assign) CGFloat tagCornerRadius;// default: 0
// background
@property (nonatomic, strong) UIColor *tagBgColor;//
@property (nonatomic, strong) UIColor *tagSelectedBgColor;
// font
@property (nonatomic, strong) UIFont *tagFont;
// text
@property (nonatomic, strong) UIColor *tagTextColor;//
@property (nonatomic, strong) UIColor *tagSelectedTextColor;

// 单选
@property (nonatomic, assign) BOOL selectionFlag;// 是否允许选择 default: YES
@property (nonatomic, assign, readonly) NSInteger selectionIndex;// 只针对单选
@property (nonatomic, copy, readonly) NSString *selectionStr;

// 多选
// multipleSelectionFlag为YES，selectionFlag还是YES 多选优先级>单选
@property (nonatomic, assign) BOOL multipleSelectionFlag;// 是否允许多选 default: NO
@property (nonatomic, assign) NSInteger maxNumberOfSelection;// 多选上限
@property (nonatomic, copy, readonly) NSArray<NSNumber *> *selectionIndexArray;
@property (nonatomic, copy, readonly) NSArray<NSString *> *selectionStrArray;


// =====edit=====
// add
- (void)addTagArray:(NSArray<NSString *> *)tagArray;
- (void)insertTag:(NSString *)tagTitle AtIndex:(NSUInteger)index;
// remove
- (void)removeTagTitle:(NSString *)tagTitle;
- (void)removeTagAtIndex:(NSUInteger)index;

// deselect
- (void)deselectAll;
// select 
- (void)selectTagAtIndex:(NSUInteger)index;

// 重新加载数据
- (void)reloadData;
// init
- (instancetype)initWithFrame:(CGRect)frame initialDataSource:(NSArray<NSString *> *)initialDataSource;

@end

@protocol TagViewDelegate <NSObject>

@optional
- (BOOL)tagView:(TagView *)tagView shouldSelectItemAtIndex:(NSUInteger)index;

// for 单选
- (void)tagView:(TagView *)tagView didSelectItemAtIndex:(NSUInteger)index;
- (void)tagView:(TagView *)tagView didDeselectItemAtIndex:(NSUInteger)index;

// 超过选择上限调用
- (void)exceedingTheUpperLimitOfSelectionForTagView:(TagView *)tagView;

@end
