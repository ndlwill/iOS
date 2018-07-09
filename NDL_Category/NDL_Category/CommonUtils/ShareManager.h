//
//  ShareManager.h
//  NDL_Category
//
//  Created by dzcx on 2018/7/9.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareManager : NSObject

SINGLETON_FOR_HEADER(ShareManager)

- (void)registerAllPlatforms;

- (void)shareToPlatform:(SharePlatform)sharePlatform
                  image:(UIImage *)image
                 urlStr:(NSString *)urlStr
                content:(NSString *)content
             controller:(UIViewController *)controller;

@end
