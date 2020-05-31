//
//  NDL_CategoryTests.m
//  NDL_CategoryTests
//
//  Created by dzcx on 2019/2/13.
//  Copyright © 2019 ndl. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface NDL_CategoryTests : XCTestCase

@end

@implementation NDL_CategoryTests

// MARK: 每一个测试用例都会执行setUp && tearDown
- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSLog(@"===setUp===");
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    NSLog(@"===tearDown===");
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSLog(@"===testExample===");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    NSLog(@"===testPerformanceExample===");
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
