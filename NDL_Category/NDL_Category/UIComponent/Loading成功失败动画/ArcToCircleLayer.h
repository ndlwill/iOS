//
//  ArcToCircleLayer.h
//  NDL_Category
//
//  Created by dzcx on 2018/4/10.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

// 圆弧到圆
@interface ArcToCircleLayer : CALayer

@property (nonatomic, assign) CGFloat progress;// 0-1

@end

//动画执行时改变的是presentation Layer的值，model Layer的值不会变化，
//动画结束后会显示model Layer的值
