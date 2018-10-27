//
//  DraggableCollectionView.h
//  NDL_Category
//
//  Created by dzcx on 2018/9/20.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DraggableCollectionView;

@protocol DraggableCollectionViewDataSource <UICollectionViewDataSource>

@required
// 必须实现
- (NSArray *)dataSourceArrayOfCollectionView:(DraggableCollectionView *)collectionView;

@end

@protocol DraggableCollectionViewDelegate <UICollectionViewDelegate>

@required
// 更新后的数据源
- (void)draggableCollectionView:(DraggableCollectionView *)collectionView updatedDataSourceArray:(NSArray *)updatedDataSourceArray;

@optional

/**
 某些indexPaths是不需要交换和晃动的，常见的比如添加按钮等
 */
- (NSArray<NSIndexPath *> *)excludeIndexPathInDraggableCollectionView:(DraggableCollectionView *)collectionView;

- (void)draggableCollectionView:(DraggableCollectionView *)collectionView cellWillBeginMoveAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  某个cell正在移动的时候 每次change都会调用
 */
- (void)draggableCollectionViewCellWhenMoving:(DraggableCollectionView *)collectionView;

- (void)draggableCollectionViewCellWhenMoveEnded:(DraggableCollectionView *)collectionView;

// 交换indexPath时
- (void)draggableCollectionView:(DraggableCollectionView *)collectionView moveCellFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

@end

@interface DraggableCollectionView : UICollectionView

/*
 在最开始的时候，我们在代码中写了@property对应的就要写一个@sythesize
 在苹果使用了 LLVM 作为编译器以后，如果我们没有写 @sythesize，编译器就会为我们自动的生成一个 @sythesize property = _property。
 这个特性叫做Auto property synthesize
 */

// 不写后面@dynamic 编译器自动给属性delegate合成getter和setter的时候将会在它的父类上实现
// 覆盖父类的delegate dataSource
@property (nonatomic, weak) id<DraggableCollectionViewDelegate> delegate;
@property (nonatomic, weak) id<DraggableCollectionViewDataSource> dataSource;

// default: 1.0
@property (nonatomic, assign) NSTimeInterval pressDuration;

// 是否抖动
@property (nonatomic, assign) BOOL shakeFlag;
// 1.0-10.0 default: 4.0
@property (nonatomic, assign) CGFloat shakeLevel;

// 是否处于编辑模式(抖动) // 调用enterEditingModel，leaveEditingModel会改变这个值
@property (nonatomic, assign, readonly, getter=isEditing) BOOL editing;// YES: 表示不通过长按事件触发，通过enterEditingModel

- (void)enterEditingModel;// 进入编辑模式
- (void)leaveEditingModel;// 离开编辑模式

@end

NS_ASSUME_NONNULL_END
