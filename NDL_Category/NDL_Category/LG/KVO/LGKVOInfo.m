//
//  LGKVOInfo.m
//  003---自定义KVO
//
//  Created by cooci on 2019/3/5.
//  Copyright © 2019 cooci. All rights reserved.
//

#import "LGKVOInfo.h"

@implementation LGKVOInfo
- (instancetype)initWitObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(LGKeyValueObservingOptions)options{
    self = [super init];
    if (self) {
        self.observer = observer;
        self.keyPath  = keyPath;
        self.options  = options;
    }
    return self;
}

@end
