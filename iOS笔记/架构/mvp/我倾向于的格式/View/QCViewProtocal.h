//
//  QCViewProtocal.h
//  QCMVP
//
//  Created by EricZhang on 2018/5/31.
//  Copyright © 2018年 BYX. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
ViewController 和View 统称为V，是被委托方，Presenter是协议委托方，委托方调用，被委托方实现，之间要建立链接
*/
 
@protocol QCTestProtocal <NSObject>

//实现此协议是为了绑定P里边调用协议方法时，传进来的数据
-(void)bindDataSurce:(NSArray *)data;

//改变背景颜色
-(void)changeBgColor;


@end


