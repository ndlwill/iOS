//
//  FiveViewController.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/20.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "FiveViewController.h"
#import "SixViewController.h"
#import "CommonCollectionCell.h"

#import "MagicMoveTransitionAnimator.h"

@interface FiveViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIView *animationSnapshotView;// window坐标
@property (nonatomic, weak) UIView *animationOriginView;// 本地坐标

@end

@implementation FiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Five self.view = %@", self.view);
    
    self.view.backgroundColor = [UIColor purpleColor];
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemW = NDLScreenW / 2 - 50;
    layout.itemSize = CGSizeMake(itemW, itemW + 60);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 10.0;
    layout.minimumInteritemSpacing = 0.0;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, TopExtendedLayoutH, NDLScreenW, NDLScreenH - TopExtendedLayoutH) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor redColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CommonCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:kCommonCollectionCellID];
    [self.view addSubview:collectionView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.delegate = self;
    NSLog(@"viewDidAppear frame = %@", NSStringFromCGRect(self.view.frame));// frame = {{0, 64}, {375, 603}}
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CommonCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCommonCollectionCellID forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"selectedItems = %@", [collectionView indexPathsForSelectedItems]);
    if (indexPath.item == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    CommonCollectionCell *selectedCell = (CommonCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *selectedImageView = selectedCell.imageView;
    self.animationOriginView = selectedImageView;
    CGRect rectInWindow = [selectedCell convertRect:selectedImageView.frame toView:KeyWindow];
    self.animationSnapshotView = [selectedImageView snapshotViewAfterScreenUpdates:NO];
    self.animationSnapshotView.frame = rectInWindow;
    
    SixViewController *sixVC = [[SixViewController alloc] init];
    sixVC.animationSnapshotView = self.animationSnapshotView;
    sixVC.animationOriginView = self.animationOriginView;
    NSLog(@"Five before push");// 1.
    [self.navigationController pushViewController:sixVC animated:YES];// 2.
    NSLog(@"Five after push");// 4. 这个执行完后面执行Six viewDidLoad
}

- (void)dealloc
{
    NSLog(@"===Five Dealloc===");
}


// TODO:============================我是分割线============================
#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {// push
        NSLog(@"===Five Push ===");// 3.
        MagicMoveTransitionAnimator *animator = [[MagicMoveTransitionAnimator alloc] init];
        animator.transitionDuration = 0.5;
        animator.isPushFlag = YES;
        animator.animationTempView = self.animationSnapshotView;
        animator.animationOriginView = self.animationOriginView;
        NSLog(@"Five animator = %@", animator);
        return animator;
    }

    return nil;// 返回nil表示默认转场动画
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"Five willShowViewController = %@", viewController);// 6.-SixVC
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"Five didShowViewController = %@", viewController);// Six viewDidAppear 后执行 这边7.-SixVC
}

@end
