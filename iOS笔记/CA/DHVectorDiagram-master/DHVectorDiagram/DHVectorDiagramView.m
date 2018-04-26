//
//  DHVectorDiagramView.m
//  LunarLander
//
//  Created by DreamHack on 16-4-15.
//  Copyright (c) 2016年 DreamHack. All rights reserved.
//

#import "DHVectorDiagramView.h"

@interface DHVectorDiagramView ()

@end

@implementation DHVectorDiagramView

- (instancetype)initWithFrame:(CGRect)frame vectorDiagram:(DHVectorDiagram *)vectorDiagram
{
    self = [super initWithFrame:frame];
    if (self) {
        self.vectorDiagram = vectorDiagram;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setVectorDiagram:(DHVectorDiagram *)vectorDiagram
{
    _vectorDiagram = vectorDiagram;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.vectorDiagram renderInContext:context];
}

@end
