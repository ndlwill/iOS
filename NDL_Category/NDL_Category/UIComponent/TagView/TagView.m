//
//  TagView.m
//  NDL_Category
//
//  Created by dzcx on 2018/9/13.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "TagView.h"
#import "InequilateralFlowLayout.h"
#import "TagCell.h"
#import "TagModel.h"

static NSString * const kTagCellID = @"TagCellID";

@interface TagView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray<NSString *> *dataSource;
@property (nonatomic, strong) NSMutableArray<TagModel *> *modelDataSourceArray;

@end

@implementation TagView

#pragma mark - lazy load
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        InequilateralFlowLayout *layout = [[InequilateralFlowLayout alloc] init];// 默认垂直方向滚动
        layout.delegate = self;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[TagCell class] forCellWithReuseIdentifier:kTagCellID];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        _collectionView.allowsSelection = self.selectionFlag;
        _collectionView.allowsMultipleSelection = self.multipleSelectionFlag;
    }
    return _collectionView;
}

- (NSMutableArray<NSString *> *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray<TagModel *> *)modelDataSourceArray
{
    if (!_modelDataSourceArray) {
        _modelDataSourceArray = [NSMutableArray array];
    }
    return _modelDataSourceArray;
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame initialDataSource:(NSArray<NSString *> *)initialDataSource
{
    if (self = [super initWithFrame:frame]) {
        [self _initialDataWithDataSource:initialDataSource];
        [self _initialConfiguration];
        [self _setupUI];
    }
    return self;
}

#pragma mark - private methods
- (void)_initialDataWithDataSource:(NSArray<NSString *> *)initialDataSource
{
    if (initialDataSource.count > 0) {
        [self.dataSource addObjectsFromArray:initialDataSource];
        // 创建模型
        [initialDataSource enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TagModel *model = [[TagModel alloc] init];
            model.tagTitle = obj;
            [self.modelDataSourceArray addObject:model];
        }];
    }
}

- (void)_initialConfiguration
{
    self.backgroundColor = [UIColor whiteColor];
    _contentInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    _tagInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    _tagBorderWidth = 0;
    
    _tagBgColor = [UIColor grayColor];
    _tagSelectedBgColor = [UIColor cyanColor];
    
    _tagFont = [UIFont systemFontOfSize:14.0];
    
    _tagTextColor = [UIColor blackColor];
    _tagSelectedTextColor = [UIColor whiteColor];
    
    _lineSpace = 10;
    _itemSpace = 5;
    
    // CGFLOAT_MAX
    
    _selectionFlag = YES;
    _multipleSelectionFlag = NO;
    _maxNumberOfSelection = NSIntegerMax;
}

- (void)_setupUI
{
    [self addSubview:self.collectionView];
    
    /*NSDictionaryOfVariableBindings(v1, v2, v3) is equivalent to [NSDictionary dictionaryWithObjectsAndKeys:v1, @"v1", v2, @"v2", v3, @"v3", nil];*/
}

- (void)_configureCell:(TagCell *)cell selectionFlag:(BOOL)selectionFlag
{
    if (selectionFlag) {// 选中状态
        cell.tagLabel.textColor = self.tagSelectedTextColor;
        cell.backgroundColor = self.tagSelectedBgColor;
        cell.layer.borderColor = self.tagSelectedBorderColor.CGColor;
    } else {
        cell.tagLabel.textColor = self.tagTextColor;
        cell.backgroundColor = self.tagBgColor;
        cell.layer.borderColor = self.tagBorderColor.CGColor;
    }
}

- (NSUInteger)indexOfTagTitle:(NSString *)tagTitle
{
    __block NSUInteger index = NSNotFound;
    [self.dataSource enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:tagTitle]) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}

- (TagCell *)_cellForItemAtIndex:(NSUInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    return (TagCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
}

#pragma mark - public methods
- (void)reloadData
{
    [self.collectionView reloadData];
}

- (void)addTagArray:(NSArray<NSString *> *)tagArray
{
    [self.dataSource addObjectsFromArray:tagArray];
    for (NSString *tagTitle in tagArray) {
        TagModel *model = [[TagModel alloc] init];
        model.tagTitle = tagTitle;
        [self.modelDataSourceArray addObject:model];
    }
    [self reloadData];
}

- (void)insertTag:(NSString *)tagTitle AtIndex:(NSUInteger)index
{
    if (index >= self.dataSource.count) {
        return;
    }
    
    [self.dataSource insertObject:tagTitle atIndex:index];
    TagModel *model = [[TagModel alloc] init];
    model.tagTitle = tagTitle;
    [self.modelDataSourceArray insertObject:model atIndex:index];
    [self reloadData];
}

- (void)removeTagTitle:(NSString *)tagTitle
{
    if (tagTitle && ![tagTitle isEqualToString:@""]) {
        return;
    }
//    [self.dataSource removeObject:tagTitle];// 还需移除model
    [self removeTagAtIndex:[self indexOfTagTitle:tagTitle]];
}

- (void)removeTagAtIndex:(NSUInteger)index
{
    if (index >= self.dataSource.count) {
        return;
    }
    
    [self.dataSource removeObjectAtIndex:index];
    [self.modelDataSourceArray removeObjectAtIndex:index];
    [self reloadData];
}

- (void)deselectAll
{
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems) {
        TagModel *model = self.modelDataSourceArray[indexPath.item];
        model.selectionFlag = NO;
        
        [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
        [self collectionView:self.collectionView didDeselectItemAtIndexPath:indexPath];
    }
}

- (void)selectTagAtIndex:(NSUInteger)index
{
    if (index >= self.dataSource.count) {
        return;
    }
    
    [self deselectAll];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
}

#pragma mark - setter
- (void)setMultipleSelectionFlag:(BOOL)multipleSelectionFlag
{
    _multipleSelectionFlag = multipleSelectionFlag;
    self.collectionView.allowsMultipleSelection = multipleSelectionFlag;
}

#pragma mark - getter
- (NSArray<NSString *> *)initialDataSource
{
    return [self.dataSource copy];
}

- (NSInteger)selectionIndex
{
    return self.collectionView.indexPathsForSelectedItems.firstObject.item;
}

- (NSString *)selectionStr
{
    return [self.dataSource objectAtIndex:self.collectionView.indexPathsForSelectedItems.firstObject.item];
}

- (NSArray<NSNumber *> *)selectionIndexArray
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems) {
        [array addObject:[NSNumber numberWithInteger:indexPath.item]];
    }
    return [array copy];
}

- (NSArray<NSString *> *)selectionStrArray
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems) {
        [array addObject:self.dataSource[indexPath.item]];
    }
    return [array copy];
}

#pragma mark - overrides
// 在tagView被add后才走这边
- (void)layoutSubviews
{
    [super layoutSubviews];
    NSLog(@"layoutSubviews");
    self.collectionView.frame = self.bounds;
}

// ###只适用于约束### 如果你没有为我指定大小，我就按照这个大小来
/*
 UILabel，UIImageView，UIButton等这些组件及某些包含它们的系统组件都有 Intrinsic Content Size 属性。
 也就是说，遇到这些组件，你只需要为其指定位置即可。大小就使用Intrinsic Content Size就行了
 
 上述系统控件都重写了UIView 中的 -(CGSize)intrinsicContentSize: 方法。
 并且在需要改变这个值的时候调用：invalidateIntrinsicContentSize 方法，通知系统这个值改变了
 
 所以当我们在编写继承自UIView的自定义组件时，也想要有Intrinsic Content Size的时候，就可以通过这种方法来轻松实现
 
 所有的view都有一个intrinsic content size， 如果设置了content size，就不用创建width 和 height 约束。
 UILabel的Intrinsic Content Size由font和text决定
 UIView默认的Intrinsic Content Size是UIViewNoIntrinsicMetric，表示的是没有大小
 
 可以让其中一个UIlabel使用Intrinsic Content Size，另一个label则自动占用剩余的空间。这时候就需要用到 Content Hugging 和 Content Compression Resistance不然会有“Intrinsic冲突”
 */
// 可在InequilateralFlowLayout添加contentSize属性,通过kvo监听调用invalidateIntrinsicContentSize
//- (CGSize)intrinsicContentSize
//{
//    CGSize size = self.collectionView.collectionViewLayout.collectionViewContentSize;
//    return CGSizeMake(UIViewNoIntrinsicMetric, size.height);
//}

#pragma mark - UICollectionViewDelegate
// willDisplayCell
//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"collectionView.subviews = %@", collectionView.subviews);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tagView:shouldSelectItemAtIndex:)]) {
        return [self.delegate tagView:self shouldSelectItemAtIndex:indexPath.item];
    }

    return _selectionFlag;
}

// 选择
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectItemAtIndexPath = %ld", indexPath.item);
    TagModel *model = self.modelDataSourceArray[indexPath.item];
    TagCell *cell = (TagCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (self.multipleSelectionFlag) {// 开启了多选
        // collectionView选中的item数组
        if (self.collectionView.indexPathsForSelectedItems.count >= self.maxNumberOfSelection) {
            if ([self.delegate respondsToSelector:@selector(exceedingTheUpperLimitOfSelectionForTagView:)]) {
                [self.delegate exceedingTheUpperLimitOfSelectionForTagView:self];
            }
            return;
        }
        
        model.selectionFlag = YES;
        // 走这边肯定选中
        [self _configureCell:cell selectionFlag:YES];
        
        return;
    }
    
    // 单选 扩展系统做法:item1被选中，再选择item1走item1的didSelect但设置item1为未选中状态
    if (model.selectionFlag) {// 原先被选中
//        cell.selected = NO;
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        [self collectionView:collectionView didDeselectItemAtIndexPath:indexPath];
        
        return;
    }
    
    model.selectionFlag = YES;
    [self _configureCell:cell selectionFlag:YES];
    
    if ([self.delegate respondsToSelector:@selector(tagView:didSelectItemAtIndex:)]) {
        [self.delegate tagView:self didSelectItemAtIndex:indexPath.item];
    }
}

// 取消选择
// 系统UICollectionView的做法
// 单选情况下:item1被选中然后选了item2，原先选中的item1会走didDeselect，item2走didSelect。item1被选中，再选择item1再走item1的didSelect
// 多选情况下选择了item1,item2再选择item1会走item1的Deselect
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didDeselectItemAtIndexPath = %ld", indexPath.item);
    
    TagModel *model = self.modelDataSourceArray[indexPath.item];
    TagCell *cell = (TagCell *)[collectionView cellForItemAtIndexPath:indexPath];
    model.selectionFlag = NO;
    [self _configureCell:cell selectionFlag:NO];
    
    if ([self.delegate respondsToSelector:@selector(tagView:didDeselectItemAtIndex:)]) {
        [self.delegate tagView:self didDeselectItemAtIndex:indexPath.item];
    }
}

#pragma mark - UICollectionViewDataSource
// 在tagView被add后才走这边,在layoutSubviews后面执行
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"numberOfItemsInSection");
    return self.modelDataSourceArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTagCellID forIndexPath:indexPath];
    
    TagModel *model = self.modelDataSourceArray[indexPath.item];
    
    cell.tagLabel.font = self.tagFont;
    cell.tagLabel.text = model.tagTitle;
    cell.contentInsets = self.tagInsets;
    
    cell.layer.borderWidth = self.tagBorderWidth;
    // 配置是否选中状态
    [self _configureCell:cell selectionFlag:model.selectionFlag];
    
    cell.layer.cornerRadius = self.tagCornerRadius;
    cell.layer.masksToBounds = (self.tagCornerRadius > 0);
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TagModel *model = self.modelDataSourceArray[indexPath.item];
    
    CGSize textSize = [model.tagTitle ndl_sizeForSingleLineStringWithFont:self.tagFont];
    
    CGFloat totalWidthInsets = self.tagInsets.left + self.tagInsets.right;
    CGFloat totalHeightInsets = self.tagInsets.top + self.tagInsets.bottom;
    
    return CGSizeMake(textSize.width + totalWidthInsets, textSize.height + totalHeightInsets);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return self.contentInsets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return self.lineSpace;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return self.itemSpace;
}


@end
