//
//  TestCategory.h
//  NDL_Category
//
//  Created by dzcx on 2019/8/23.
//  Copyright © 2019 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestCategory : NSObject

- (void)test;
- (void)test1;
//- (void)testAddMethod;

- (void)newTestAddMethod;

- (void)testReplaceMethod;
- (void)testReplaceImp;
- (void)beReplacedMethod;

@end

NS_ASSUME_NONNULL_END
