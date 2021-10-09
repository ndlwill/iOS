//
//  LGTimerWapper.m
//  003---强引用问题
//
//  Created by cooci on 2019/1/16.
//  Copyright © 2019 cooci. All rights reserved.
//

#import "LGTimerWapper.h"

@interface LGTimerWapper()
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL aSelector;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation LGTimerWapper

- (instancetype)lg_initWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo{
    if (self == [super init]) {
        self.target     = aTarget;
        self.aSelector  = aSelector;
        self.timer      = [NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(fireHome) userInfo:userInfo repeats:yesOrNo];
    }
    return self;
}

- (void)fireHome{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    // 让编译器出栈，恢复状态，继续编译后续的代码！
    if ([self.target respondsToSelector:self.aSelector]) {
        [self.target performSelector:self.aSelector];
    }
#pragma clang diagnostic pop
}

- (void)lg_invalidate{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)dealloc{
  
    NSLog(@"%s",__func__);
}

@end
