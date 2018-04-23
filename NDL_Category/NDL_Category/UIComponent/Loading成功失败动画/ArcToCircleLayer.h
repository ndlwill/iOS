//
//  ArcToCircleLayer.h
//  NDL_Category
//
//  Created by dzcx on 2018/4/10.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

// 写字动效
// https://github.com/ole/Animated-Paths

// 绘制的线宽
static CGFloat const kLineWidth = 6;

// 圆弧到圆
@interface ArcToCircleLayer : CALayer

@property (nonatomic, assign) CGFloat progress;// 0-1
@property (nonatomic, strong) UIColor *color;

@end

// 动画执行时改变的是presentation Layer的值，model Layer的值不会变化，
// 动画结束后会显示model Layer的值

/*
 访问View的属性实际上就是访问了其持有的那个layer对应的属性
 
 给一个UIView设置frame的时候，这个view首先调用自己layer的setFrame方法，
 而在layer的setFrame方法里实际上又调用了setBounds和setPosition，
 说明layer的frame这个属性实际上并没有实例变量，它的setter和getter仅仅是去调用其bounds和position的setter和getter而已，
 也就是说frame实际上是由bounds和position来决定的 实际上还有anchorPoint
 UIView的frame并没有调用UIView的center和bounds的setter和getter，它仅仅是去调用其持有的layer的frame的setter和getter而已
 
 对UIView的各种属性的操作实际上都是间接的操作了CALayer对应的属性
 
 presentationLayer（P）和 modelLayer（M）
 我们对CALayer的各种绘图属性进行赋值和访问实际上都是访问的M的属性
 presentationLayer负责绘制内容，而modelLayer负责如何绘制
 
 响应点击的是M
 
 P将在每一次屏幕刷新的时候回到M的状态
 一般情况下，任意时刻P都会回到M的状态。
 而当一个CAAnimation（以下称为A）加到了layer上面后，A就把M从P身上挤下去了。
 现在P背着的是A，P同样在每次屏幕刷新的时候去问他背着的那个家伙，A就指挥它从fromValue到toValue来改变值。
 而动画结束后，A会自动被移除，这时P没有了指挥，就只能大喊“M你在哪”，M说我还在原地没动呢，于是P就顺声回到M的位置了
 
 CAAnimation动画都可以通过设置modelLayer到动画结束的状态来实现P和M的同步
 
 ###
 在CABasicAnimation的文档中写了这样一句话：如果不设置toValue，则CABasicAnimation会从fromValue到M的值之间进行插值。
 也就是说，如果不设置toValue，则CABasicAnimation会把M的值作为toValue，所以我们就可以在加动画的时候只设置fromValue
 再手动修改M的值到你想要动画停止的那个状态就保持同步了
 可以通过设置M的值到动画结束的状态来保持P和M的同步
 */

/*
 // 隐式动画
 CALayer首先会判断此时有没有隐式动画被触发。
 它会让它的delegate（没错CALayer拥有一个属性叫做delegate）调用actionForLayer:forKey:来获取一个返回值，
 这个返回值在声明的时候是一个id对象，当然在运行时它可能是任何对象。这时CALayer拿到返回值，将进行判断：
 如果返回的对象是一个nil，则进行默认的隐式动画；
 如果返回的对象是一个[NSNull null] ，则CALayer不会做任何动画；
 如果是一个正确的实现了CAAction协议的对象，则CALayer用这个对象来生成一个CAAnimation，并加到自己身上进行动画
 
 - (void)setPosition:(CGPoint)position
 {
 //    [super setPosition:position];
 if ([self.delegate respondsToSelector:@selector(actionForLayer:forKey:)]) {
 id obj = [self.delegate actionForLayer:self forKey:@"position"];
 if (!obj) {
 // 隐式动画
 } else if ([obj isKindOfClass:[NSNull class]]) {
 // 直接重绘（无动画）
 } else {
 // 使用obj生成CAAnimation
 CAAnimation * animation;
 [self addAnimation:animation forKey:nil];
 }
 }
 // 隐式动画
 }
 
 如果这个CALayer被一个UIView所持有，那么这个CALayer的delegate就是持有它的那个UIView###
 
 返回一个NSNull（是尖括号的null，nil打印出来是圆括号的null）###
 
 UIViewAdditiveAnimationAction类的对象，这个类是一个私有类，遵循了苹果的命名规范： xxAction，一定就是一个实现了CAAction协议的对象了
 
 NSLog(@"%@",[view.layer.delegate actionForLayer:view.layer forKey:@"position"]);
 [UIView animateWithDuration:1.25 animations:^{
 NSLog(@"%@",[view.layer.delegate actionForLayer:view.layer forKey:@"position"]);
 }];
 
 [anination debugDescription];
 
 easeInEaseOut 淡入淡出效果
 */
