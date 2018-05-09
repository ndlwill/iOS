//
//  PhotoCell.m
//  NDL_Category
//
//  Created by dzcx on 2018/4/27.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "PhotoCell.h"

@interface PhotoCell ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation PhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setText:(NSString *)text
{
    _text = [text copy];
    self.label.text = [@"我是图片-" stringByAppendingString:text];
}

@end
