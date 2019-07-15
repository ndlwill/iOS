//
//  DataTransform.h
//  NDL_Category
//
//  Created by dzcx on 2019/6/11.
//  Copyright © 2019 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

// https://casatwy.com/iosying-yong-jia-gou-tan-wang-luo-ceng-she-ji-fang-an.html
// 去model化
NS_ASSUME_NONNULL_BEGIN

@protocol DataTransform <NSObject>

- (NSDictionary *)transformOriginData:(NSDictionary *)originData;

@end

NS_ASSUME_NONNULL_END
