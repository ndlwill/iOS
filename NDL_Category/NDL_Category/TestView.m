//
//  TestView.m
//  NDL_Category
//
//  Created by ndl on 2017/11/27.
//  Copyright © 2017年 ndl. All rights reserved.
//

#import "TestView.h"
#import "DrawUtils.h"

@implementation TestView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL flag = [super pointInside:point withEvent:event];
    NSLog(@"===TestView pointInside point = %@", NSStringFromCGPoint(point));
    NSLog(@"===TestView pointInside flag = %ld===", [[NSNumber numberWithBool:flag] integerValue]);
    
    return flag;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    [DrawUtils drawCouponBackgroundInContext:UIGraphicsGetCurrentContext() rect:rect cornerRadius:10 separateShape:CouponBackgroundSeparateShape_SemiCircle separateShapeCenterXRatio:0.4 separateShapeVerticalHeight:5 separateShapeHorizontalWidth:5 lineWidth:2 lineStrokeColor:[UIColor blueColor].CGColor fillColor:[UIColor yellowColor].CGColor shadowBlur:10.0 shadowColor:[[UIColor redColor] colorWithAlphaComponent:0.8].CGColor shadowOffset:CGSizeZero];
    
    
//    [DrawUtils drawClockInContext:UIGraphicsGetCurrentContext() lineWidth:1 lineStrokeColor:[UIColor redColor].CGColor radius:10 centerPoint:CGPointMake(10, 10) hourHandLength:5 hourHandValue:3 minuteHandLength:8 minuteHandValue:12];
    
//    [DrawUtils drawDeletePatternInContext:UIGraphicsGetCurrentContext() lineWidth:1 lineStrokeColor:[UIColor redColor].CGColor radius:10 centerPoint:CGPointMake(10, 10)];
    
//    [DrawUtils drawDotInContext:UIGraphicsGetCurrentContext() fillColor:[UIColor blueColor].CGColor centerPoint:CGPointMake(20, 20) radius:10];
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
//    CGContextBeginPath(context);
//    // 绘制圆点
//    CGContextAddArc(context, 20, 20, 10, 0, M_PI, 1);
//    CGContextFillPath(context);
    
    //绘制气泡
//    [DrawUtils drawBubbleFrameWithTriangleInContext:UIGraphicsGetCurrentContext() rect:rect lineWidth:6.0 lineStrokeColor:[UIColor orangeColor].CGColor fillColor:NULL cornerRadius:2.0 arrowDirection:BubbleFrameArrowDirection_Left arrowHeight:10.0 controlPoint:CGPointMake(0, CGRectGetMaxY(rect) - 10.0) controlPointOffsetLeft:12.0 controlPointOffsetRight:0.0];
    
    
    
    
    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    
//    
////    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
//    
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path addArcWithCenter:CGPointMake(50, 50) radius:40 startAngle:(3.0 / 2 * M_PI) endAngle:(M_PI) clockwise:NO];
//    
//    CGContextBeginPath(ctx);
//    CGContextAddPath(ctx, path.CGPath);
//    
//    CGContextSetLineWidth(ctx, 3);
//    CGContextSetStrokeColorWithColor(ctx, [UIColor greenColor].CGColor);
//    
//    CGContextStrokePath(ctx);
}




//苹果官方建议：添加/更新约束在这个方法（updateConstraints）内
//- (void)updateConstraints {
//    //更新约束
//    [self.btn updateConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self);
//        
//        make.width.equalTo(@(self.buttonSize.width)).priorityLow();
//        make.height.equalTo(@(self.buttonSize.height)).priorityLow();
//        
//        make.width.lessThanOrEqualTo(self);
//        make.height.lessThanOrEqualTo(self);
//    }];
//    
//    //according to apple super should be called at end of method
//    //最后必须调用父类的更新约束
//    [super updateConstraints];
//}


//+ (BOOL)requiresConstraintBasedLayout
//{
//return YES ; //重写这个方法 若视图基于自动布局的
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //[super touchesBegan:touches withEvent:event];
    NSLog(@"===MyTestView===");
}

@end
