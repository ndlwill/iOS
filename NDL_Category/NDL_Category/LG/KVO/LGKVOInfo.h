//
//  LGKVOInfo.h
//  003---自定义KVO
//
//  Created by cooci on 2019/3/5.
//  Copyright © 2019 cooci. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, LGKeyValueObservingOptions) {

    LGKeyValueObservingOptionNew = 0x01,
    LGKeyValueObservingOptionOld = 0x02,
};

@interface LGKVOInfo : NSObject
@property (nonatomic, weak) NSObject  *observer;
@property (nonatomic, copy) NSString    *keyPath;
@property (nonatomic, assign) LGKeyValueObservingOptions options;

- (instancetype)initWitObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(LGKeyValueObservingOptions)options;
@end

NS_ASSUME_NONNULL_END
