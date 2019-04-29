//
//  TestProtocol.h
//  NDL_Category
//
//  Created by dzcx on 2019/4/28.
//  Copyright © 2019 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TestProtocol <NSObject>

@required
@property (nonatomic, copy) NSString *testName;

@end

NS_ASSUME_NONNULL_END
