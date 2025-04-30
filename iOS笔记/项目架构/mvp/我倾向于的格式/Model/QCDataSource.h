//
//  QCDataSource.h
//  QCMVP
//
//  Created by EricZhang on 2018/5/31.
//  Copyright © 2018年 BYX. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 这个相当于Model，我们可以在Model里边完成数据的请求，然后在Presenter中调用
 */

typedef void(^Success)(NSDictionary *dic);
typedef void(^Failure)(NSDictionary *dic);

@interface QCDataSource : NSObject

//获取数据，成功失败
-(void)getDataSuccess:(Success)success AndFailure:(Failure)failure;


@end
