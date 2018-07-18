//
//  GradientView.m
//  NDL_Category
//
//  Created by dzcx on 2018/7/18.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView

- (instancetype)initWithFrame:(CGRect)frame colors:(NSArray *)colors gradientDirection:(GradientDirection)gradientDirection
{
    if (self = [super initWithFrame:frame]) {
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        if (colors) {
            NSMutableArray *cgColors = [NSMutableArray array];
            for (UIColor *color in colors) {
                [cgColors addObject:(__bridge id)color.CGColor];
            }
            gradientLayer.colors = cgColors;
        }
        
        switch (gradientDirection) {
            case GradientDirection_TopToBottom:
                gradientLayer.startPoint = CGPointMake(0.5, 0);
                gradientLayer.endPoint = CGPointMake(0.5, 1);
                break;
            case GradientDirection_BottomToTop:
                gradientLayer.startPoint = CGPointMake(0.5, 1);
                gradientLayer.endPoint = CGPointMake(0.5, 0);
                break;
            case GradientDirection_LeftToRight:
                gradientLayer.startPoint = CGPointMake(0, 0.5);
                gradientLayer.endPoint = CGPointMake(1, 0.5);
                break;
            case GradientDirection_RightToLeft:
                gradientLayer.startPoint = CGPointMake(1, 0.5);
                gradientLayer.endPoint = CGPointMake(0, 0.5);
                break;
            case GradientDirection_LeftTopToRightBottom:
                gradientLayer.startPoint = CGPointMake(0, 0);
                gradientLayer.endPoint = CGPointMake(1, 1);
                break;
            case GradientDirection_RightBottomToLeftTop:
                gradientLayer.startPoint = CGPointMake(1, 1);
                gradientLayer.endPoint = CGPointMake(0, 0);
                break;
            case GradientDirection_LeftBottomToRightTop:
                gradientLayer.startPoint = CGPointMake(0, 1);
                gradientLayer.endPoint = CGPointMake(1, 0);
                break;
            case GradientDirection_RightTopToLeftBottom:
                gradientLayer.startPoint = CGPointMake(1, 0);
                gradientLayer.endPoint = CGPointMake(0, 1);
                break;
            default:
                break;
        }
        
        [self.layer addSublayer:gradientLayer];
    }
    return self;
}

@end
