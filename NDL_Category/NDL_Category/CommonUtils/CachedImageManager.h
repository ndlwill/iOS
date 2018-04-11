//
//  CachedImageManager.h
//  NDL_Category
//
//  Created by ndl on 2018/2/26.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CachedImageManager : NSObject

+ (UIImage *)sdCachedImageWithURL:(NSURL *)url;

@end
