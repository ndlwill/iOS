//
//  ImageCell.m
//  NDL_Category
//
//  Created by dzcx on 2018/11/22.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "ImageCell.h"

@implementation ImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.masksToBounds = YES;
}

@end
