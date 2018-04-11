//
//  NSBundle+NDLExtension.h
//  NDL_Category
//
//  Created by ndl on 2018/1/31.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSBundle (NDLExtension)

// bundleName = XXX.bundle
+ (NSBundle *)ndl_vendorBundleWithName:(NSString *)bundleName;

// 加载指定bundle里面的资源图片
+ (UIImage *)ndl_imageNamed:(NSString *)imageName bundleName:(NSString *)bundleName;

+ (NSString *)ndl_localizedStringForKey:(NSString *)key bundleName:(NSString *)bundleName;

@end
