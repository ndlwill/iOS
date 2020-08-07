//
//  TestEventView.m
//  NDL_Category
//
//  Created by youdone-ndl on 2020/8/7.
//  Copyright © 2020 ndl. All rights reserved.
//

#import "TestEventView.h"

@implementation TestEventView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // TestEventView不写[super touchesBegan:touches withEvent:event];表示拦截事件，不向上传递
    /**
     如果控制器重写了touchesBegan
     super touchesBegan写在NSLog前面则控制器执行完再执行这边的NSLog
     super touchesBegan写在NSLog后面则自己先执行处理完再执行控制器的touchesBegan
     */
    // [super touchesBegan:touches withEvent:event];
    NSLog(@"TestEventView touchesBegan");
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"TestEventView touchesMoved");
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"TestEventView touchesEnded");
}

@end
