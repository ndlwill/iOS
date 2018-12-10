//
//  TestCollectionViewController.m
//  NDL_Category
//
//  Created by dzcx on 2018/9/20.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "TestCollectionViewController.h"
#import "DraggableCollectionView.h"
#import "TitleCell.h"

#import <AudioToolbox/AudioToolbox.h>

@interface TestCollectionViewController () <DraggableCollectionViewDelegate, DraggableCollectionViewDataSource>

@property (nonatomic, weak) DraggableCollectionView *draggableCollectionView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@end

@implementation TestCollectionViewController

- (NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
        
        // 设置j可b改变section
        for (NSInteger j = 0; j < 1; j++) {
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NSInteger i = 0; i < 20; i++) {
                NSString *str = [NSString stringWithFormat:@"%ld-%ld", j, i];
                [tempArray addObject:str];
            }
            [_dataSourceArray addObject:[tempArray copy]];
        }
    }
    return _dataSourceArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.minimumInteritemSpacing = 10;
    NSInteger column = 3;
    CGFloat itemWH = (self.view.width - 10 * 2 - 10 * (column - 1)) / column;
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    
    // DraggableCollectionView
    DraggableCollectionView *draggableCollectionView = [[DraggableCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height / 2.0) collectionViewLayout:layout];
    draggableCollectionView.backgroundColor = [UIColor yellowColor];
//    draggableCollectionView.draggableDelegate = self;
//    draggableCollectionView.draggableDataSource = self;
    draggableCollectionView.delegate = self;
    draggableCollectionView.dataSource = self;
    [draggableCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TitleCell class]) bundle:nil] forCellWithReuseIdentifier:@"CellID"];
    [self.view addSubview:draggableCollectionView];
    self.draggableCollectionView = draggableCollectionView;
    
    UIButton *soundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [soundBtn setTitle:@"PlaySystemSound" forState:UIControlStateNormal];
    soundBtn.backgroundColor = [UIColor blackColor];
    soundBtn.frame = CGRectMake(10, self.view.height / 2.0 + 20, 60, 40);
    [self.view addSubview:soundBtn];
    [soundBtn addTarget:self action:@selector(soundBtnDidClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Button Actions
- (void)soundBtnDidClicked
{
    // iOS10.0
//    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleLight];
//    [generator prepare];
//    [generator impactOccurred];
    
    // 长震
//    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//    AudioServicesPlaySystemSound(1007);
    
    // 可能是###private methods###
    // 普通短震，3D Touch 中 Peek 震动反馈
//    AudioServicesPlaySystemSound(1519);
    // 普通短震，3D Touch 中 Pop 震动反馈
//    AudioServicesPlaySystemSound(1520);
    // 连续三次短震
//    AudioServicesPlaySystemSound(1521);
}

// test for editingModel
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//    // editingModel
//    [_draggableCollectionView enterEditingModel];
//}

#pragma mark - DraggableCollectionViewDelegate
- (NSArray<NSIndexPath *> *)excludeIndexPathInDraggableCollectionView:(DraggableCollectionView *)collectionView
{
    // 每个section的最后一个cell都不能交换
    NSMutableArray *excludeIndexPathArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 3; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:20 - 1 inSection:i];
        [excludeIndexPathArray addObject:indexPath];
    }
    return excludeIndexPathArray;
}

- (void)draggableCollectionView:(DraggableCollectionView *)collectionView updatedDataSourceArray:(NSArray *)updatedDataSourceArray
{
    self.dataSourceArray = [updatedDataSourceArray mutableCopy];
    
    // test for 不嵌套数组
    NSLog(@"=====start log=====");
    for (NSString *str in self.dataSourceArray) {
        NSLog(@"=====str = %@=====", str);
    }
    NSLog(@"=====end log=====");
}

#pragma mark - DraggableCollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSourceArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *subArray = self.dataSourceArray[section];
    return subArray.count;
}

- (NSArray *)dataSourceArrayOfCollectionView:(DraggableCollectionView *)collectionView
{
    return self.dataSourceArray;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellID" forIndexPath:indexPath];

    NSArray *subArray = self.dataSourceArray[indexPath.section];
    cell.titleLabel.text = subArray[indexPath.item];
    
    if (indexPath.section == 0) {
        cell.backgroundColor = [UIColor blueColor];
    } else if (indexPath.section == 1) {
        cell.backgroundColor = [UIColor greenColor];
    } else if (indexPath.section == 2) {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

@end
