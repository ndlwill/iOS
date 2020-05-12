//
//  TestEqualPerson.h
//  NDL_Category
//
//  Created by ndl on 2020/5/8.
//  Copyright © 2020 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestEqualPerson : NSObject

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, strong) NSString *name;

- (instancetype)initWithID:(NSInteger)uid name:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
