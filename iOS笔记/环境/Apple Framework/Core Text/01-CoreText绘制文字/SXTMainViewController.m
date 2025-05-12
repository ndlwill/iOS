//
//  ViewController.m
//  01-CoreText绘制文字
//
//  Created by andezhou on 16/4/10.
//  Copyright © 2016年 andezhou. All rights reserved.
//

#import "SXTMainViewController.h"
#import "ZYAttributedLabel.h"

#define kViewWidth [UIScreen mainScreen].bounds.size.width

@interface SXTMainViewController () <SXTAttributedLabelDelegate>

@property (strong, nonatomic) ZYAttributedLabel *attributedLabel;

@end

@implementation SXTMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UILabel *label = [[UILabel alloc] init];
//    label.backgroundColor = [UIColor redColor];
//    label.text = @"jdjQmark111";
//    UIFont *f = [UIFont systemFontOfSize:16.0];
//    label.font = f;
//    [self.view addSubview:label];
//    [label sizeToFit];
//    label.frame = CGRectMake(100, 500, label.frame.size.width, 15.0);
    NSString *str = @"今日下午，楚天都市报记者@大欢 来到解放公园内的征婚角，悬挂着上百张征婚启事，有很多市民或是帮子女，或是帮朋友找寻合适的对象(";
    NSLog(@"%ld", str.length);


    self.attributedLabel = [[ZYAttributedLabel alloc] init];
    self.attributedLabel.delegate = self;
    self.attributedLabel.backgroundColor = [UIColor yellowColor];
//    self.attributedLabel.imageSize = CGSizeMake(50, 50);

    [self.attributedLabel setText:@"今日下午，楚天都市报记者@大欢 来到解放公园内的征婚角，悬挂着上百张征婚启事，有很多市民或是帮子女，或是帮朋友找寻合适的对象(找对象上淘宝：www.taobao.com [/haha.gif])。记者找到了严先生觉得很奇葩的征婚[/haqian.gif]启事，在启事择偶要求一栏，征婚者胡先生要求女方“能生男孩”[/haha]。并且，在启事的最后，@胡先生还说明“#本人爸爸是局长#”"];
    [self.attributedLabel addCustomLink:@"最后"];
    
    [self.attributedLabel addCustomLink:@"严先生" linkColor:[UIColor orangeColor] linkFont:[UIFont systemFontOfSize:20]];
    self.attributedLabel.numberOfLines = 4;
    self.attributedLabel.linkFont = [UIFont systemFontOfSize:20];
    self.attributedLabel.linkColor = [UIColor redColor];

    
    
    [self.view addSubview:self.attributedLabel];
    CGSize size = [self.attributedLabel sizeThatFits:CGSizeMake(kViewWidth - 20, MAXFLOAT)];
    self.attributedLabel.frame = CGRectMake(10, 100, size.width, 300);
    
}

#pragma mark -
#pragma mark SXTAttributedLabelDelegate
- (void)attributedLabel:(ZYAttributedLabel *)label selectedLink:(ZYAttributedLink *)selectedLink
{
    NSLog(@"选中:%@", selectedLink.text);
}

- (void)attributedLabel:(ZYAttributedLabel *)label selectedImage:(ZYAttributedImage *)selectedImage
{
    NSLog(@"选中：%@", selectedImage.imageName);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
