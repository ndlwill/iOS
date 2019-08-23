//
//  TestCategory+Extension.m
//  NDL_Category
//
//  Created by dzcx on 2019/8/23.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "TestCategory+Extension.h"

@implementation TestCategory (Extension)

// _dyld_start -> call_load_methods 调用load方法
+ (void)load
{
    ReplaceMethod([self class], @selector(test1), @selector(swizzle_test1));
    ReplaceMethod([self class], @selector(oldTestAddMethod), @selector(newTestAddMethod));
}

- (void)swizzle_test1
{
    NSLog(@"TestCategory Extension teswizzle_test1");
}

// Category is implementing a method which will also be implemented by its primary class
- (void)test
{
    NSLog(@"TestCategory Extension test");
    
    // 调用主类的同名原方法
//    [self invokeOriginalMethod:self selector:_cmd];
}

- (void)invokeOriginalMethod:(id)target selector:(SEL)selector
{
    uint count;
    /*
     struct objc_method {
     SEL _Nonnull method_name                                 OBJC2_UNAVAILABLE;
     char * _Nullable method_types                            OBJC2_UNAVAILABLE;
     IMP _Nonnull method_imp                                  OBJC2_UNAVAILABLE;
     } 
     */
    Method *methods = class_copyMethodList([target class], &count);

    // 原来的方法在方法列表的后面，所以逆向遍历
    for (int i = count - 1; i >= 0; i--) {
        Method method = methods[i];
        SEL name = method_getName(method);
        IMP imp = method_getImplementation(method);
        if (name == selector) {
            ((void (*)(id, SEL))imp)(target, name);// 调用原方法
            break;
        }
    }
    free(methods);
}

@end
