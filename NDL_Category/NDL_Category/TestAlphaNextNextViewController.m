//
//  TestAlphaNextNextViewController.m
//  NDL_Category
//
//  Created by dzcx on 2018/11/12.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "TestAlphaNextNextViewController.h"
#import "UIViewController+NavigationBarExtension.h"

#import "ImageViewer.h"
#import "UIView+NDLTapGesture.h"

#import "ImageCell.h"

#import "TestGestureViewController.h"

@interface TestAlphaNextNextViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *thumbnailImageUrls;
@property (nonatomic, strong) NSMutableArray *originalImageUrls;

@end

@implementation TestAlphaNextNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"NextNextViewController";
    
    // file:///Users/dzcx/Library/Developer/CoreSimulator/Devices/FB2DB6F6-36E9-4832-9EB3-486541FF9348/data/Containers/Bundle/Application/AF89985D-ED6A-4084-9F31-351231CD176F/NDL_Category.app/girl.jpeg
    NSLog(@"girl path = %@", [NSURL fileURLWithPath:[MainBundle pathForResource:@"girl" ofType:@"jpeg"]]);
    
    // 带gif
    NSArray *imageUrls = @[
                           @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/1.png",
                           @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/2.png",
                           @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/3.png",// dog
                           @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/4.png",
                           @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/5.png",
                           @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/6.png",
                           @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/7.png",
                           @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/8.png",
                           @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/9.png",
                           @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/10.png",
                           @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/11.png",
                           @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/12.png",
                           @"https://raw.githubusercontent.com/mengxianliang/XLPlayButton/master/GIF/1.gif"];
    
    
    
    // 1. 创建图片链接数组
    NSMutableArray *thumbnailImageUrls = [NSMutableArray array];
    // 添加图片(缩略图)链接
    [thumbnailImageUrls addObject:@"http://ww3.sinaimg.cn/thumbnail/006ka0Iygw1f6bqm7zukpj30g60kzdi2.jpg"];
    [thumbnailImageUrls addObject:@"http://ww1.sinaimg.cn/thumbnail/61b69811gw1f6bqb1bfd2j20b4095dfy.jpg"];
    [thumbnailImageUrls addObject:@"http://ww1.sinaimg.cn/thumbnail/54477ddfgw1f6bqkbanqoj20ku0rsn4d.jpg"];
    [thumbnailImageUrls addObject:@"http://ww4.sinaimg.cn/thumbnail/006ka0Iygw1f6b8gpwr2tj30bc0bqmyz.jpg"];
    [thumbnailImageUrls addObject:@"http://ww2.sinaimg.cn/thumbnail/9c2b5f31jw1f6bqtinmpyj20dw0ae76e.jpg"];
    [thumbnailImageUrls addObject:@"http://ww1.sinaimg.cn/thumbnail/536e7093jw1f6bqdj3lpjj20va134ana.jpg"];
    [thumbnailImageUrls addObject:@"http://ww1.sinaimg.cn/thumbnail/75b1a75fjw1f6bqn35ij6j20ck0g8jtf.jpg"];
    [thumbnailImageUrls addObject:@"http://ww4.sinaimg.cn/bmiddle/406ef017jw1ec40av2nscj20ip4p0b29.jpg"];
    [thumbnailImageUrls addObject:@"http://ww1.sinaimg.cn/thumbnail/86afb21egw1f6bq3lq0itj20gg0c2myt.jpg"];
    self.thumbnailImageUrls = thumbnailImageUrls;
    
    // 1.2 创建图片原图链接数组
    NSMutableArray *originalImageUrls = [NSMutableArray array];
    // 添加图片(原图)链接
    [originalImageUrls addObject:@"http://ww3.sinaimg.cn/large/006ka0Iygw1f6bqm7zukpj30g60kzdi2.jpg"];
    [originalImageUrls addObject:@"http://ww1.sinaimg.cn/large/61b69811gw1f6bqb1bfd2j20b4095dfy.jpg"];
    [originalImageUrls addObject:@"http://ww1.sinaimg.cn/large/54477ddfgw1f6bqkbanqoj20ku0rsn4d.jpg"];
    [originalImageUrls addObject:@"http://ww4.sinaimg.cn/large/006ka0Iygw1f6b8gpwr2tj30bc0bqmyz.jpg"];
    [originalImageUrls addObject:@"http://ww2.sinaimg.cn/large/9c2b5f31jw1f6bqtinmpyj20dw0ae76e.jpg"];
    [originalImageUrls addObject:@"http://ww1.sinaimg.cn/large/536e7093jw1f6bqdj3lpjj20va134ana.jpg"];
    [originalImageUrls addObject:@"http://ww1.sinaimg.cn/large/75b1a75fjw1f6bqn35ij6j20ck0g8jtf.jpg"];
    [originalImageUrls addObject:@"http://ww4.sinaimg.cn/bmiddle/406ef017jw1ec40av2nscj20ip4p0b29.jpg"];
    [originalImageUrls addObject:@"http://ww1.sinaimg.cn/large/86afb21egw1f6bq3lq0itj20gg0c2myt.jpg"];
    self.originalImageUrls = originalImageUrls;
    
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(40, 120, 200, 100)];
    testView.backgroundColor = [UIColor redColor];
    [self.view addSubview:testView];
//    [testView ndl_viewByRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomRight) cornerRadii:CGSizeMake(30, 30)];
    
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(40, 64, 0, 0)];
    sw.backgroundColor = [UIColor blueColor];
    sw.tintColor = [UIColor blueColor];
    sw.onTintColor = [UIColor redColor];
    sw.layer.cornerRadius = sw.height / 2.0;
    sw.layer.masksToBounds = YES;
    [self.view addSubview:sw];
//    sw.transform = CGAffineTransformMakeScale(0.8, 0.8);
    
    // sw先从self.view移除，再被添加到testView
    [testView addSubview:sw];
    NSLog(@"sw.superView = %@", sw.superview);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.view.width - 60, 120, 60, 40);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(btnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemWH = (self.view.width - 10 * 2) / 3;
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 280, self.view.width, self.view.width) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor cyanColor];
    collectionView.centerX = self.view.width / 2.0;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ImageCell class]) bundle:nil] forCellWithReuseIdentifier:@"ImageCellID"];
    [self.view addSubview:collectionView];
    
    
    
    // digupicon_review_press.gif
    // [UIImage imageNamed:@"digupicon_review_press"]这么写什么也不显示
//    UIImage *image = [UIImage imageWithContentsOfFile:[MainBundle pathForResource:@"digupicon_review_press" ofType:@"gif"]];// 显示第一针
//    UIImageView *gifView = [[UIImageView alloc] initWithImage:image];
//    gifView.backgroundColor = [UIColor yellowColor];
//    gifView.frame = CGRectMake(0, self.view.height - 80, 80, 80);
//    [self.view addSubview:gifView];
    
//    [UIImage imageNamed:@""];// imageNamed的优点是当加载时会缓存图片
    // imageWithContentsOfFile：仅加载图片，图像数据不会缓存
    
    
    /// imageView
//    UIImageView *imageView = [[UIImageView alloc] init];
//    NSString *index2Str = [thumbnailImageUrls objectAtIndex:4];
//    [imageView sd_setImageWithURL:[NSURL URLWithString:index2Str] placeholderImage:[UIImage ndl_imageWithColor:[UIColor redColor] size:CGSizeMake(1, 1)]];
//    [self.view addSubview:imageView];
//    imageView.size = CGSizeMake(80, 80);
//    imageView.center = self.view.center;
//    // 转成世界坐标
//    NSLog(@"imageViewRectInCoordinateSpace = %@", NSStringFromCGRect([imageView convertRect:imageView.bounds toCoordinateSpace:self.view]));
//    NSLog(@"InCoordinateSpace = %@", NSStringFromCGRect([self.view convertRect:imageView.frame toCoordinateSpace:self.view]));
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        NSLog(@"#####clearDiskOnCompletion#####");
    }];
    
    self.navItemTintColor = [UIColor cyanColor];
    self.navBarTintColor = [UIColor blueColor];
    self.navBarAlpha = 0.0;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.thumbnailImageUrls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"show 9 indexItem = %ld", indexPath.item);
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCellID" forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.thumbnailImageUrls[indexPath.item]] placeholderImage:[UIImage ndl_imageWithColor:[UIColor redColor] size:CGSizeMake(1, 1)]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = indexPath.item;
    NSLog(@"===select index = %ld===", index);
    
    ImageViewer *imageViewer = [[ImageViewer alloc] init];
    imageViewer.curIndex = index;
    imageViewer.thumbnailImageUrls = self.thumbnailImageUrls;
    imageViewer.originalImageUrls = self.originalImageUrls;
    // 得到的是乱序，不准确
//    imageViewer.thumbnailReferenceViews = [collectionView visibleCells];
    imageViewer.thumbnailReferenceViews = collectionView.subviews;
    [imageViewer show];
//    NSLog(@"visibleCells = %@", [collectionView visibleCells]);
    
    // 带两个ScrollIndicator，collectionView如果设置了不显示则不带 就全是cell
//    NSLog(@"subViews = %@", collectionView.subviews);
}


// digupicon_review_press.gif传digupicon_review_press
- (NSArray<UIImage *> *)imageFromGifFileName:(NSString *)gifFileName
{
    StartTime
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)[MainBundle URLForResource:gifFileName withExtension:@"gif"], NULL);
    // 这样也行
//    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:[MainBundle pathForResource:@"digupicon_review_press" ofType:@"gif"]], NULL);
    size_t imageCount = CGImageSourceGetCount(gifSource);
    NSMutableArray<UIImage *> *imageFrames = [NSMutableArray array];
    for (size_t i = 0; i < imageCount; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        [imageFrames addObject:image];
        CGImageRelease(imageRef);
    }
    EndTime
    return [imageFrames copy];
}

- (void)btnDidClicked:(UIButton *)pSender
{
    [self.navigationController pushViewController:[TestGestureViewController new] animated:YES];
}

@end
