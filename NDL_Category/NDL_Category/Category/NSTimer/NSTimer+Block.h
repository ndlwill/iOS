//
//  NSTimer+Block.h
//  NDL_Category
//
//  Created by dzcx on 2019/8/25.
//  Copyright © 2019 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (Block)

+ (NSTimer *)ndl_blockScheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)(void))block repeats:(BOOL)repeats;

@end

NS_ASSUME_NONNULL_END
