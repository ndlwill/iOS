//
//  ImageViewer.m
//  NDL_Category
//
//  Created by dzcx on 2018/11/19.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "ImageViewer.h"
#import "ImageItemCell.h"
#import "ImageViewerToolBar.h"

static CGFloat const ToolBarHeight = 35.0;

@interface ImageViewer () <UICollectionViewDelegate, UICollectionViewDataSource>
{
    // 是否来自缩略图
    BOOL _thumbnailFlag;
    // 外界第一次选择的index
    NSUInteger _firstSelectionIndex;
    // 第一次选择 缩略图作动画的标记
    BOOL _firstSelectionFlag;
    // 第一次选择的原图是否已经缓存标记
    BOOL _firstSelectionImageExistFlag;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ImageViewerToolBar *toolBar;

@end

@implementation ImageViewer

#pragma mark - init
- (instancetype)init
{
    if (self = [super init]) {
        [self _initializeConfiguration];
        [self _setupUI];
    }
    return self;
}

#pragma mark - life cycle
- (void)dealloc
{
    NSLog(@"===ImageViewer Dealloc===");
}

#pragma mark - public methods
// 这个方法只被调用1次
- (void)show
{
    NSLog(@"===show===");
    _firstSelectionIndex = _curIndex;
    
    StartTime
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    _firstSelectionImageExistFlag = [imageCache diskImageDataExistsWithKey:[self.originalImageUrls objectAtIndex:_curIndex]];
    EndTime
    /*
     调用reloadData刷新时界面闪烁:
     主要是因为CALayer有一个隐式动画，只要在调用reloadData刷新时，关闭隐式动画就可以避免了.
     
     [CATransaction setDisableActions:YES];
     [self.collectionView reloadData];
     [CATransaction commit];
     */
    
    // 可以省略
//    [self.collectionView reloadData];// 重新加载所有可见的cell
    
    // 会调用scrollViewDidScroll （也会调用numberOfItemsInSection，cellForItemAtIndexPath）
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_curIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    [KeyWindow addSubview:self];
    
    // ###通过cellForItemAtIndexPath这个函数仅仅能获取到可见cell,如果该cell不可见是获取不到的，如果要获取到，就需要先将该cell移动到可见范围，再进行获取###
    // reloadDada之后，拿到的cell都为nil
//    NSLog(@"cell = %@", [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_curIndex inSection:0]]);// cell = (null)
    
    // 解决方案如下
//    [self.collectionView layoutIfNeeded];
//    [self.collectionView cellForItemAtIndexPath:nil];
    // 或者
    [self.collectionView performBatchUpdates:nil completion:^(BOOL finished) {
        // 表示cell已经显示,可以拿到
        ImageItemCell *cell = (ImageItemCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.curIndex inSection:0]];
        
        if (self->_firstSelectionFlag) {
            [self _configCell:cell atIndex:self.curIndex firstSelectionFlag:self->_firstSelectionFlag firstSelectionImageExistFlag:self->_firstSelectionImageExistFlag];
            // 显示动画
            [cell executeInitialAnimation];
            self->_firstSelectionFlag = NO;
        }
    }];
    
    // 批量操作 + completion
//    [self.collectionView performBatchUpdates:^{
//        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
//    } completion:^(BOOL finished) {
//
//    }];
    
    /*
performBatchUpdates:completion: 这个方法可以用来对collectionView中的元素进行批量的插入，删除，移动等操作，同时将触发collectionView所对应的layout的对应的动画。相应的动画由layout中的下列四个方法来定义：
     
initialLayoutAttributesForAppearingItemAtIndexPath:
initialLayoutAttributesForAppearingDecorationElementOfKind:atIndexPath:
finalLayoutAttributesForDisappearingItemAtIndexPath:
finalLayoutAttributesForDisappearingDecorationElementOfKind:atIndexPath:

调用这个方法会将布局代理方法全部调用一遍，所以如果想动态更改布局，可以在先做个标记然后再调用该方法，在布局代理方法里根据标记不同设置不同的值
     */

    // 选择第一个，不会走scrollViewDidScroll，所以这边得设置
    self.toolBar.indexLabel.text = [NSString stringWithFormat:@"%ld/%ld", (_curIndex + 1), self.originalImageUrls.count];
    // 动画显示toolBar
    [self.toolBar showWithAnimationDuration:0.3];
}

#pragma mark - private methods
- (void)_initializeConfiguration
{
    // frame
    self.frame = [UIScreen mainScreen].bounds;
    
    _thumbnailFlag = NO;
    _firstSelectionFlag = YES;
    _firstSelectionImageExistFlag = NO;
}

- (void)_setupUI
{
//    self.backgroundColor = [UIColor clearColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.width, self.height);
    layout.minimumInteritemSpacing = 0;
    // 下面两个配合使用 Horizontal->设置minimumLineSpacing
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // collectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
//    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView registerClass:[ImageItemCell class] forCellWithReuseIdentifier:ImageItemCellID];
    [self addSubview:self.collectionView];
    
    // toolBar 默认alpha等于0
    self.toolBar = [[ImageViewerToolBar alloc] initWithFrame:CGRectMake(0, self.height - ToolBarHeight, self.width, ToolBarHeight)];
    WEAK_REF(self)
    // 保存图片到系统相册
    self.toolBar.saveBlock = ^{
        STRONG_REF(self)
        ImageItemCell *curCell = (ImageItemCell *)[strong_self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:strong_self.curIndex inSection:0]];
        [curCell saveImage];
    };
    [self addSubview:self.toolBar];
}

- (void)_configCell:(ImageItemCell *)cell atIndex:(NSInteger)index firstSelectionFlag:(BOOL)firstSelectionFlag firstSelectionImageExistFlag:(BOOL)firstSelectionImageExistFlag
{
    cell.collectionView = self.collectionView;
    cell.firstSelectionFlag = firstSelectionFlag;
    cell.firstSelectionImageExistFlag = firstSelectionImageExistFlag;
    
    UIView *thumbnailReferenceView = [self.thumbnailReferenceViews objectAtIndex:index];
    cell.thumbnailImageRect = [thumbnailReferenceView convertRect:thumbnailReferenceView.bounds toCoordinateSpace:self];
    
    cell.thumbnailImagePath = [self.thumbnailImageUrls objectAtIndex:index];
    cell.originalImagePath = [self.originalImageUrls objectAtIndex:index];
    WEAK_REF(self)
    if (!cell.noImageDismissBlock) {
        cell.noImageDismissBlock = ^{
            STRONG_REF(self)
            [UIView animateWithDuration:0.3 animations:^{
                strong_self.alpha = 0.0;
            } completion:^(BOOL finished) {
                [strong_self removeFromSuperview];
            }];
        };
    }
    
    if (!cell.executeDismissBlock) {
        cell.executeDismissBlock = ^{
            STRONG_REF(self)
            [strong_self removeFromSuperview];
        };
    }
    
    if (!cell.hasImageWillDismissBlock) {
        cell.hasImageWillDismissBlock = ^{
            STRONG_REF(self)
            [strong_self.toolBar hideWithAnimationDuration:0.0];
        };
    }
    
    if (!cell.imageViewRestoreFinishedBlock) {
        STRONG_REF(self)
        cell.imageViewRestoreFinishedBlock = ^{
            [strong_self.toolBar showWithAnimationDuration:0.0];
        };
    }
}

#pragma mark - setter
- (void)setThumbnailImageUrls:(NSArray<NSString *> *)thumbnailImageUrls
{
    if (thumbnailImageUrls) {
        _thumbnailImageUrls = thumbnailImageUrls;
        
        _thumbnailFlag = YES;
    }
}

//- (void)setCurIndex:(NSUInteger)curIndex
//{
//    _curIndex = curIndex;
//
//    _firstSelectionIndex = curIndex;
//}

#pragma mark - UICollectionViewDelegate
// eg:滚动到下一个cell完全显示，上一个cell调didEndDisplayingCell
//- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"didEndDisplayingCell index = %ld", indexPath.item);
//}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"numberOfItemsInSection count = %ld", self.originalImageUrls.count);
    return self.originalImageUrls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellForItemAtIndexPath index = %ld", indexPath.item);
    
    // dequeueReusableCellWithReuseIdentifier如果复用cell，会调用cell的prepareForReuse
    ImageItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageItemCellID forIndexPath:indexPath];
    
    if (!_firstSelectionFlag) {
        NSLog(@"after collectionView dequeueReusableCellWithReuseIdentifier:");
        
        NSInteger itemIndex = indexPath.item;
        [self _configCell:cell atIndex:itemIndex firstSelectionFlag:_firstSelectionFlag firstSelectionImageExistFlag:NO];
    }
    
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"collectionView scrollViewDidScroll offset = %@", NSStringFromCGPoint(scrollView.contentOffset));
    _curIndex = scrollView.contentOffset.x / scrollView.width;
    self.toolBar.indexLabel.text = [NSString stringWithFormat:@"%ld/%ld", (_curIndex + 1), self.originalImageUrls.count];
}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    NSLog(@"scrollViewDidEndDragging");
//}


//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    NSLog(@"scrollViewDidEndDecelerating");
//    _curIndex = scrollView.contentOffset.x / scrollView.width;
    // 连续滚动 下标更新不实时
//    self.toolBar.indexLabel.text = [NSString stringWithFormat:@"%ld / %ld", (_curIndex + 1), self.originalImageUrls.count];
//}

// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
//{
//    NSLog(@"scrollViewDidEndScrollingAnimation");
//}

@end
