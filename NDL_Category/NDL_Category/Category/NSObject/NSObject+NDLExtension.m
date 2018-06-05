//
//  NSObject+NDLExtension.m
//  NDL_Category
//
//  Created by dzcx on 2018/5/23.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "NSObject+NDLExtension.h"
//#import <objc/runtime.h>

@implementation NSObject (NDLExtension)

- (NSDictionary *)ndl_model2Dictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (NSInteger i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char * cPropertyName = property_getName(property);
        NSString *objcPropertyName = [NSString stringWithUTF8String:cPropertyName];
        id objcPropertyValue = [self valueForKey:objcPropertyName];// kvc
        // dic的value不能为nil
        if (objcPropertyValue) {
            [dic setObject:objcPropertyValue forKey:objcPropertyName];
        }
    }
    
    free(properties);
    return [dic copy];
}

@end
