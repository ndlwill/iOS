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

// main函数之前执行
__attribute__((constructor)) static void ndl_inject(void) {
    
}

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

- (id)ndl_performSelector:(SEL)selector withObjects:(NSArray<id> *)objects
{
    // 1. 创建方法签名
    // 根据方法来初始化NSMethodSignature
    NSMethodSignature *methodSignature = [[self class] instanceMethodSignatureForSelector:selector];
    if (!methodSignature) { // 没有该方法
        return self;
    }
    // 2. 创建invocation对象（包装方法）
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    // 3. 设置相关属性
    // 调用者
    invocation.target = self;
    // 调用方法
    invocation.selector = selector;
    // 获取除self、_cmd的参数个数
    NSInteger paramsCount = methodSignature.numberOfArguments - 2;
    // 取最少的，防止越界
    NSInteger count = MIN(paramsCount, objects.count);
    // 用于dictionary的拷贝(用于保住objCopy，避免非法内存访问)
    NSMutableDictionary *objCopy = nil;
    // 设置参数
    // https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1
    for (int i = 0; i < count; i++) {
        // 取出参数对象
        id obj = objects[i];
        
        // 判断需要设置的参数是否是NSNull, 如果是就设置为nil
        if ([obj isKindOfClass:[NSNull class]]) {
            obj = nil;
        }
        
        
        // 获取参数类型
        const char *argumentType = [methodSignature getArgumentTypeAtIndex:i + 2];
        // 判断参数类型 根据类型转化数据类型（如果有必要）
        NSString *argumentTypeString = [NSString stringWithUTF8String:argumentType];
        
        if ([argumentTypeString isEqualToString:@"@"]) { // id
            // 如果是dictionary
            if ([obj isKindOfClass:[NSDictionary class]]) { // NSDictionary
                objCopy = [obj mutableCopy];
                // 取出所有键
                NSArray *keys = [objCopy allKeys];
                for (NSString *key in keys) {
                    // 取出值
                    id value = objCopy[key];
                    if ([value isKindOfClass:[NSString class]]) {
                        
                    }
                }
                [invocation setArgument:&objCopy atIndex:i + 2];
            } else { // 其他
                [invocation setArgument:&obj atIndex:i + 2];
            }
        }  else if ([argumentTypeString isEqualToString:@"B"]) { // bool
            bool objVaule = [obj boolValue];
            [invocation setArgument:&objVaule atIndex:i + 2];
        } else if ([argumentTypeString isEqualToString:@"f"]) { // float
            float objVaule = [obj floatValue];
            [invocation setArgument:&objVaule atIndex:i + 2];
        } else if ([argumentTypeString isEqualToString:@"d"]) { // double
            double objVaule = [obj doubleValue];
            [invocation setArgument:&objVaule atIndex:i + 2];
        } else if ([argumentTypeString isEqualToString:@"c"]) { // char
            char objVaule = [obj charValue];
            [invocation setArgument:&objVaule atIndex:i + 2];
        } else if ([argumentTypeString isEqualToString:@"i"]) { // int
            int objVaule = [obj intValue];
            [invocation setArgument:&objVaule atIndex:i + 2];
        } else if ([argumentTypeString isEqualToString:@"I"]) { // unsigned int
            unsigned int objVaule = [obj unsignedIntValue];
            [invocation setArgument:&objVaule atIndex:i + 2];
        } else if ([argumentTypeString isEqualToString:@"S"]) { // unsigned short
            unsigned short objVaule = [obj unsignedShortValue];
            [invocation setArgument:&objVaule atIndex:i + 2];
        } else if ([argumentTypeString isEqualToString:@"L"]) { // unsigned long
            unsigned long objVaule = [obj unsignedLongValue];
            [invocation setArgument:&objVaule atIndex:i + 2];
        } else if ([argumentTypeString isEqualToString:@"s"]) { // shrot
            short objVaule = [obj shortValue];
            [invocation setArgument:&objVaule atIndex:i + 2];
        } else if ([argumentTypeString isEqualToString:@"l"]) { // long
            long objVaule = [obj longValue];
            [invocation setArgument:&objVaule atIndex:i + 2];
        } else if ([argumentTypeString isEqualToString:@"q"]) { // long long
            long long objVaule = [obj longLongValue];
            [invocation setArgument:&objVaule atIndex:i + 2];
        } else if ([argumentTypeString isEqualToString:@"C"]) { // unsigned char
            unsigned char objVaule = [obj unsignedCharValue];
            [invocation setArgument:&objVaule atIndex:i + 2];
        } else if ([argumentTypeString isEqualToString:@"Q"]) { // unsigned long long
            unsigned long long objVaule = [obj unsignedLongLongValue];
            [invocation setArgument:&objVaule atIndex:i + 2];
        } else if ([argumentTypeString isEqualToString:@"{CGRect={CGPoint=dd}{CGSize=dd}}"]) { // CGRect
            CGRect objVaule = [obj CGRectValue];
            [invocation setArgument:&objVaule atIndex:i + 2];
        } else if ([argumentTypeString isEqualToString:@"{UIEdgeInsets=dddd}"]) { // UIEdgeInsets
            UIEdgeInsets objVaule = [obj UIEdgeInsetsValue];
            [invocation setArgument:&objVaule atIndex:i + 2];
        }
    }
    // 4.调用方法
    [invocation invoke];
    // 5. 设置返回值
    id returnValue = nil;
    if (methodSignature.methodReturnLength != 0) { // 有返回值
        // 将返回值赋值给returnValue
        [invocation getReturnValue:&returnValue];
    }
    return returnValue;
}


@end
