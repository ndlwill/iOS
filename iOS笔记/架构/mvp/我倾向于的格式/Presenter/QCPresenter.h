//
//  QCPresenter.h
//  QCMVP
//
//  Created by EricZhang on 2018/5/31.
//  Copyright © 2018年 BYX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QCViewProtocal.h"

/*
 QCPresenter 可以拿到实现了协议的对象View，并且调用View中已经实现的协议
 */


@interface QCPresenter : NSObject

//和已经实现了协议的view建立联系，以便在本类调用实现的协议
-(void)attatchView:(id<QCTestProtocal>)view;

//从model拿到数据，交给view的协议方法
-(void)exchangeData;


@end
