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


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
//    [DrawUtils drawClockInContext:UIGraphicsGetCurrentContext() lineWidth:1 lineStrokeColor:[UIColor redColor].CGColor radius:10 centerPoint:CGPointMake(10, 10) hourHandLength:5 hourHandValue:3 minuteHandLength:8 minuteHandValue:12];
    
//    [DrawUtils drawDeletePatternInContext:UIGraphicsGetCurrentContext() lineWidth:1 lineStrokeColor:[UIColor redColor].CGColor radius:10 centerPoint:CGPointMake(10, 10)];
    
//    [DrawUtils drawDotInContext:UIGraphicsGetCurrentContext() fillColor:[UIColor blueColor].CGColor centerPoint:CGPointMake(20, 20) radius:10];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextBeginPath(context);
    // 绘制圆点
    CGContextAddArc(context, 20, 20, 10, 0, M_PI, 1);
    CGContextFillPath(context);
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
    NSLog(@"MyTestView");
}

@end
