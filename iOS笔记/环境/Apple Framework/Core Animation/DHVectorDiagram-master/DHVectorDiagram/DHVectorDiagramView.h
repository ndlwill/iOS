//
//  DHVectorDiagramView.h
//  LunarLander
//
//  Created by DreamHack on 16-4-15.
//  Copyright (c) 2016年 DreamHack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHVectorDiagram.h"

@interface DHVectorDiagramView : UIView

@property (nonatomic, strong) DHVectorDiagram * vectorDiagram;

- (instancetype)initWithFrame:(CGRect)frame vectorDiagram:(DHVectorDiagram *)vectorDiagram;

@end
