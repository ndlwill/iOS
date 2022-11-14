//
//  ViewController.m
//  TestOpenGLES
//
//  Created by youdun on 2022/10/25.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建一个OpenGL ES上下文，并将其分配给从故事板加载的视图
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
 
    // 设置动画帧速率
    self.preferredFramesPerSecond = 60;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
}


@end
