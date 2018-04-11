//
//  CachedImageManager.m
//  NDL_Category
//
//  Created by ndl on 2018/2/26.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "CachedImageManager.h"
#import <SDWebImageManager.h>
#import <YYWebImageManager.h>

@implementation CachedImageManager

+ (UIImage *)sdCachedImageWithURL:(NSURL *)url
{
    if (url == nil) {
        return nil;
    }
    
    // YY
//    YYWebImageManager *yyManager = [YYWebImageManager sharedManager];
//    return [yyManager.cache getImageForKey:[yyManager cacheKeyForURL:url]];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString *key = [manager cacheKeyForURL:url];
    // First check the in-memory cache...
    return [[SDImageCache sharedImageCache] imageFromCacheForKey:key];
}

@end
