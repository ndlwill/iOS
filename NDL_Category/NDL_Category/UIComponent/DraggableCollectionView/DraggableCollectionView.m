//
//  DraggableCollectionView.m
//  NDL_Category
//
//  Created by dzcx on 2018/9/20.
//  Copyright © 2018年 ndl. All rights reserved.
//

#define AnimationKey @"shakeAnimation"

#import "DraggableCollectionView.h"

typedef NS_ENUM(NSInteger, CellScrollDirection) {
    CellScrollDirection_None = 0,
    CellScrollDirection_Left,
    CellScrollDirection_Bottom,
    CellScrollDirection_Right,
    CellScrollDirection_Top
};

static CGFloat const kMoveStep = 4.0;

@interface DraggableCollectionView ()

@property (nonatomic, strong) CADisplayLink *edgeTimer;

@property (nonatomic, strong) UIView *tempView;
@property (nonatomic, strong) NSIndexPath *touchIndexPath;// 选中的indexPath
@property (nonatomic, strong) NSIndexPath *targetIndexPath;

@property (nonatomic, weak) UILongPressGestureRecognizer *longPress;
//@property (nonatomic, weak) UICollectionViewCell *originalCell;

@property (nonatomic, assign) CGFloat originPressDuration;
@property (nonatomic, assign) CellScrollDirection scrollDirection;
@property (nonatomic, assign) BOOL isPanning;// tempView是否正在被拖拽
@property (nonatomic, assign) CGPoint previousGesturePoint;

@end

@implementation DraggableCollectionView

// @dynamic告诉编译器这个属性是动态的,动态的意思是等你编译的时候就知道了它只在本类合成
@dynamic delegate;
@dynamic dataSource;

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self _initializeConfiguration];
        [self _addLongPressGesture];
        [self _addContentOffsetObserver];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"contentOffset"];
    [NotificationCenter removeObserver:self];
}

#pragma mark - overrides
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    NSLog(@"===hitTest===");
    // 没点到item不触发长按手势
    self.longPress.enabled = [self indexPathForItemAtPoint:point];
    return [super hitTest:point withEvent:event];
}

#pragma mark - private methods
- (void)_initializeConfiguration
{
    _pressDuration = 1.0;
    _shakeFlag = YES;
    _shakeLevel = 4.0;
}

- (void)_addLongPressGesture
{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(selfDidLongPressed:)];
    self.longPress = longPress;
    longPress.minimumPressDuration = _pressDuration;
    [self addGestureRecognizer:longPress];
}

- (void)_addContentOffsetObserver
{
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

// began
- (void)_gestureBegan:(UILongPressGestureRecognizer *)gesture
{
    NSLog(@"===_gestureBegan===");
    CGPoint touchPoint = [gesture locationInView:gesture.view];
    // 获取began的touch indexPath
    self.touchIndexPath = [self indexPathForItemAtPoint:touchPoint];
    // 没有indexPath被选中
    if (!self.touchIndexPath) {
        return;
    }
    // 判断是否被排除
    if ([self _checkIndexPathIsExcluded:self.touchIndexPath]) {
        return;
    }
    
    _isPanning = YES;
    
    // 选中了cell
    UICollectionViewCell *cell = [self cellForItemAtIndexPath:self.touchIndexPath];
    cell.hidden = YES;// 最后需要恢复显示
    
    // 创建tempView
    self.tempView = [cell snapshotViewAfterScreenUpdates:NO];
    self.tempView.frame = cell.frame;// 设置origin
    [self addSubview:self.tempView];
    self.tempView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    
    // 开启定时器
    [self _startEdgeTimer];
    
    if (!_editing) {
        // 执行抖动动画
        [self _startShakeVisibleCells];
    } else {
        // 编辑模式下self.tempView执行动画
//        [self.tempView.layer addAnimation:[self _shakeAnimation] forKey:AnimationKey];
    }
    
    _previousGesturePoint = touchPoint;
    
    // execute delegate
    if ([self.delegate respondsToSelector:@selector(draggableCollectionView:cellWillBeginMoveAtIndexPath:)]) {
        [self.delegate draggableCollectionView:self cellWillBeginMoveAtIndexPath:self.touchIndexPath];
    }
}

// changed
- (void)_gestureChanged:(UILongPressGestureRecognizer *)gesture
{
//    NSLog(@"===_gestureChanged===");
    
    if ([self.delegate respondsToSelector:@selector(draggableCollectionViewCellWhenMoving:)]) {
        [self.delegate draggableCollectionViewCellWhenMoving:self];
    }
    
    // 体验不太好
    // tempView中心点始终处于movePoint
//    CGPoint movePoint = [gesture locationInView:gesture.view];
//    self.tempView.center = movePoint;
    
    // begin点在cell上的点始终在那里
    CGPoint curPoint = [gesture locationInView:gesture.view];
    self.tempView.center = CGPointApplyAffineTransform(self.tempView.center, CGAffineTransformMakeTranslation(curPoint.x - _previousGesturePoint.x, curPoint.y - _previousGesturePoint.y));
    self.previousGesturePoint = curPoint;
    
    // 移动cell
    [self _moveCellWithCurPoint:curPoint];
}

// ended
- (void)_gestureEnded:(UILongPressGestureRecognizer *)gesture
{
    UICollectionViewCell *endCell = [self cellForItemAtIndexPath:_touchIndexPath];
    CGRect endCellFrame = endCell.frame;
    
    self.userInteractionEnabled = NO;
    _isPanning = NO;
    [self _stopEdgeTimer];
    [self.tempView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tempView.frame = endCellFrame;
    } completion:^(BOOL finished) {
        [self _stopShakeVisibleCells];
        
        endCell.hidden = NO;
        [self.tempView removeFromSuperview];
        
        self.touchIndexPath = nil;
        self.userInteractionEnabled = YES;
        
        if ([self.delegate respondsToSelector:@selector(draggableCollectionViewCellWhenMoveEnded:)]) {
            [self.delegate draggableCollectionViewCellWhenMoveEnded:self];
        }
    }];
}

// 检查indexPath是否被exclude（排除，不包括）
- (BOOL)_checkIndexPathIsExcluded:(NSIndexPath *)indexPath
{
    if (![self.delegate respondsToSelector:@selector(excludeIndexPathInDraggableCollectionView:)]) {
        return NO;
    }
    
    NSArray<NSIndexPath *> *excludeIndexPathArray = [self.delegate excludeIndexPathInDraggableCollectionView:self];
    __block BOOL flag = NO;
    [excludeIndexPathArray enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.section == indexPath.section && obj.item == indexPath.item) {
            flag = YES;
            *stop = YES;
        }
    }];
    return flag;
}

// 判断滚动方向
- (void)_judgeScrollDirection
{
    _scrollDirection = CellScrollDirection_None;
    
    // cell向下移动 (self向上滚动 - self.contentOffset.y > 0)
    if (self.height + self.contentOffset.y - self.tempView.centerY < self.tempView.height / 2.0 && self.height + self.contentOffset.y < self.contentSize.height) {
        _scrollDirection = CellScrollDirection_Bottom;
    }
    
    // cell向上移动
    if (self.tempView.centerY - self.contentOffset.y < self.tempView.height / 2.0 && self.contentOffset.y > 0) {
        _scrollDirection = CellScrollDirection_Top;
    }
    
    // cell向右移动
    if (self.width + self.contentOffset.x - self.tempView.centerX < self.tempView.width / 2.0 && self.width + self.contentOffset.x < self.contentSize.width) {
        _scrollDirection = CellScrollDirection_Right;
    }
    
    // cell向左移动
    if (self.tempView.centerX - self.contentOffset.x < self.tempView.width / 2.0 && self.contentOffset.x > 0) {
        _scrollDirection = CellScrollDirection_Left;
    }
}

- (NSIndexPath *)_targetIndexPathFromPoint:(CGPoint)point
{
    NSIndexPath *targetIndexPath = nil;
    // 遍历可见cell的indexPath
    for (NSIndexPath *indexPath in [self indexPathsForVisibleItems]) {
        // 是自己 || 是被排除的cell -> 跳过
        if (indexPath == _touchIndexPath || [self _checkIndexPathIsExcluded:indexPath]) {
            continue;
        }
        // 下面也可以
//        if ([indexPath isEqual:_touchIndexPath]) {
//            continue;
//        }
        
        // cell.frame包含tempView中心点 表示找到
        if (CGRectContainsPoint([self cellForItemAtIndexPath:indexPath].frame, self.tempView.center)) {
            targetIndexPath = indexPath;
            NSLog(@"targetIndexPath = %@", targetIndexPath);
            break;
        }
    }
    
    return targetIndexPath;
}

- (void)_startEdgeTimer
{
    if (!_edgeTimer) {
        _edgeTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(edgeScroll)];
        [_edgeTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)_stopEdgeTimer
{
    if (_edgeTimer) {
        [_edgeTimer invalidate];
        _edgeTimer = nil;
    }
}

// 抖动可见cells
- (void)_startShakeVisibleCells
{
    if (!_shakeFlag) {
        // 不执行抖动
        NSArray *visibleCellArray = [self visibleCells];
        
        for (UICollectionViewCell *cell in visibleCellArray) {
            // cell复用问题
            NSIndexPath *cellIndexPath = [self indexPathForCell:cell];
            BOOL hiddenFlag = (self.touchIndexPath && cellIndexPath.item == _touchIndexPath.item && cellIndexPath.section == _touchIndexPath.section);
            cell.hidden = hiddenFlag;
        }
        
        return;
    }
    
    // 执行抖动
    CAKeyframeAnimation *shakeAnim = [CAKeyframeAnimation animation];
    shakeAnim.keyPath = @"transform.rotation";
    shakeAnim.values = @[@(0), @(DEGREE2RADIAN(-_shakeLevel)), @(0), @(DEGREE2RADIAN(_shakeLevel))];
    shakeAnim.repeatCount = MAXFLOAT;
    shakeAnim.duration = 0.2;
    NSArray *visibleCellArray = [self visibleCells];
    
    for (UICollectionViewCell *cell in visibleCellArray) {
        if ([self _checkIndexPathIsExcluded:[self indexPathForCell:cell]]) {
            // 表示被排除，不执行动画
            continue;
        }
        
        if (![cell.layer animationForKey:AnimationKey]) {
            [cell.layer addAnimation:shakeAnim forKey:AnimationKey];
        }
        
        // cell复用问题
        // for 监听contentOffset改变调用_startShakeVisibleCells
        NSIndexPath *cellIndexPath = [self indexPathForCell:cell];
        BOOL hiddenFlag = (self.touchIndexPath && cellIndexPath.item == _touchIndexPath.item && cellIndexPath.section == _touchIndexPath.section);
        cell.hidden = hiddenFlag;
    }
    
    if (![self.tempView.layer animationForKey:AnimationKey]) {
        [self.tempView.layer addAnimation:shakeAnim forKey:AnimationKey];
    }
}

// 停止抖动动画
- (void)_stopShakeVisibleCells
{
    if (_editing || !_shakeFlag) {
        return;
    }
    
    NSArray *visibleCellArray = [self visibleCells];
    for (UICollectionViewCell *cell in visibleCellArray) {
        [cell.layer removeAllAnimations];
    }
    [self.tempView.layer removeAllAnimations];
}

- (void)_moveCellWithCurPoint:(CGPoint)point
{
    self.targetIndexPath = [self _targetIndexPathFromPoint:point];
    if (self.targetIndexPath) {
        
        [self _updateDataSource];
        
        [self moveItemAtIndexPath:_touchIndexPath toIndexPath:_targetIndexPath];
//        [CATransaction begin];
//        [CATransaction setCompletionBlock:^{
//            NSLog(@"move动画完成");
//        }];
//        [self moveItemAtIndexPath:_touchIndexPath toIndexPath:_targetIndexPath];
//        [CATransaction commit];
        
        if ([self.delegate respondsToSelector:@selector(draggableCollectionView:moveCellFromIndexPath:toIndexPath:)]) {
            [self.delegate draggableCollectionView:self moveCellFromIndexPath:_touchIndexPath toIndexPath:_targetIndexPath];
        }
        _touchIndexPath = _targetIndexPath;
    }
}

- (CAKeyframeAnimation *)_shakeAnimation
{
    CAKeyframeAnimation *shakeAnim = [CAKeyframeAnimation animation];
    shakeAnim.keyPath = @"transform.rotation";
    shakeAnim.values = @[@(0), @(DEGREE2RADIAN(-_shakeLevel)), @(0), @(DEGREE2RADIAN(_shakeLevel))];
    shakeAnim.repeatCount = MAXFLOAT;
    shakeAnim.duration = 0.2;
    return shakeAnim;
}

// 更新数据源
- (void)_updateDataSource
{
    // 原始数据源
    NSMutableArray *tempArray = @[].mutableCopy;//[NSMutableArray array];
    
    if ([self.dataSource respondsToSelector:@selector(dataSourceArrayOfCollectionView:)]) {
        [tempArray addObjectsFromArray:[self.dataSource dataSourceArrayOfCollectionView:self]];
    }
    
    // 是否是嵌套数组
    BOOL nestFlag = ([self numberOfSections] > 1 || ([self numberOfSections] == 1 && [tempArray.firstObject isKindOfClass:[NSArray class]]));
    if (nestFlag) {
        // 把不可变数组替换为可变数组
        for (NSInteger i = 0; i < tempArray.count; i++) {
            [tempArray replaceObjectAtIndex:i withObject:[tempArray[i] mutableCopy]];
        }
    }
    
    // 同一个section
    if (_targetIndexPath.section == _touchIndexPath.section) {
        NSMutableArray *sectionArray = nestFlag ? tempArray[_touchIndexPath.section] : tempArray;
        // ###是移动不是交换###
        id obj = [sectionArray objectAtIndex:_touchIndexPath.item];
        [sectionArray removeObject:obj];
        [sectionArray insertObject:obj atIndex:_targetIndexPath.item];
    } else { // 不同section
        NSMutableArray *touchSectionArray = tempArray[_touchIndexPath.section];
        NSMutableArray *targetSectionArray = tempArray[_targetIndexPath.section];
        
        id obj = touchSectionArray[_touchIndexPath.item];
        [targetSectionArray insertObject:obj atIndex:_targetIndexPath.item];
        [touchSectionArray removeObject:obj];
    }
    
    // 代理回调
    if ([self.delegate respondsToSelector:@selector(draggableCollectionView:updatedDataSourceArray:)]) {
        [self.delegate draggableCollectionView:self updatedDataSourceArray:tempArray.copy];
    }
}



#pragma mark - public methods
- (void)enterEditingModel
{
    _editing = YES;
    _originPressDuration = self.longPress.minimumPressDuration;
    self.longPress.minimumPressDuration = 0;// 处于编辑状态，触摸直接选中
    
    if (self.shakeFlag) {
        // 默认拖动cell的时候，其他cell还是抖动的
        [self _startShakeVisibleCells];
        
        [NotificationCenter addObserver:self selector:@selector(appWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
}

- (void)leaveEditingModel
{
//    self.editing = NO;// 赋值给只读属性报错 1.要么用_editing 2.要么.m写属性
    _editing = NO;
    
    self.longPress.minimumPressDuration = _originPressDuration;
    
    [self _stopShakeVisibleCells];
    
    [NotificationCenter removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark - Gesture
- (void)selfDidLongPressed:(UILongPressGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self _gestureBegan:gesture];
            break;
        case UIGestureRecognizerStateChanged:
            [self _gestureChanged:gesture];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            [self _gestureEnded:gesture];
            break;
            
        default:
            break;
    }
}

#pragma mark - displayLink
// 边缘滚动
// ===每帧执行===
- (void)edgeScroll
{
    [self _judgeScrollDirection];
    
    switch (_scrollDirection) {
        case CellScrollDirection_Left:
        {
            [self setContentOffset:CGPointMake(self.contentOffset.x - kMoveStep, self.contentOffset.y) animated:NO];
            self.tempView.centerX -= kMoveStep;
            _previousGesturePoint.x -= kMoveStep;
        }
            break;
        case CellScrollDirection_Right:
        {
            [self setContentOffset:CGPointMake(self.contentOffset.x + kMoveStep, self.contentOffset.y) animated:NO];
            self.tempView.centerX += kMoveStep;
            _previousGesturePoint.x += kMoveStep;
        }
            break;
        case CellScrollDirection_Top:
        {
            [self setContentOffset:CGPointMake(self.contentOffset.x, self.contentOffset.y - kMoveStep) animated:NO];
            self.tempView.centerY -= kMoveStep;
            _previousGesturePoint.y -= kMoveStep;
        }
            break;
        case CellScrollDirection_Bottom:
        {
            [self setContentOffset:CGPointMake(self.contentOffset.x, self.contentOffset.y + kMoveStep) animated:NO];
            self.tempView.centerY += kMoveStep;
            _previousGesturePoint.y += kMoveStep;
        }
            break;
        default:
            break;
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
//        CGPoint contentOffset = [change[NSKeyValueChangeNewKey] CGPointValue];
        
        // 代码触发 || 长按手势触发 两种情况
        if (_editing || _isPanning) {
            [self _startShakeVisibleCells];
        }
    }
}

#pragma mark - setter
- (void)setPressDuration:(NSTimeInterval)pressDuration
{
    _pressDuration = pressDuration;
    self.longPress.minimumPressDuration = pressDuration;
}

- (void)setShakeLevel:(CGFloat)shakeLevel
{
    CGFloat level = MAX(shakeLevel, 1.0);
    _shakeLevel = MIN(level, 10.0);
}

#pragma mark - Notification
- (void)appWillEnterForeground
{
#if DEBUG
    // 进入后台后，原先的动画都被系统移除了，进入前台，这边都是空
    NSArray<UICollectionViewCell *> *visibleCells = [self visibleCells];
    NSLog(@"=====debug start=====");
    for (UICollectionViewCell *cell in visibleCells) {
        NSLog(@"%@", [cell.layer animationForKey:AnimationKey]);
    }
    NSLog(@"=====debug end=====");
#endif
    
    // 执行动画
    if (_editing) {
        [self _startShakeVisibleCells];
    }
}

@end
