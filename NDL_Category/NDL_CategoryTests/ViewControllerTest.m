//
//  ViewControllerTest.m
//  NDL_CategoryTests
//
//  Created by ndl on 2020/5/24.
//  Copyright © 2020 ndl. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"


@interface ViewControllerTest : XCTestCase

@property (nonatomic, strong) ViewController *vc;
@end

@implementation ViewControllerTest

- (void)setUp {
    self.vc = [[ViewController alloc] init];
}

- (void)tearDown {
    self.vc = nil;
}

// 逻辑测试
- (void)testExample {
    // give
    int num1 = 10;
    int num2 = 20;
    // when
    int num3 = [self.vc getPlus:num1 num2:num2];
    // then
    XCTAssertEqual(num3, 30, @"getPlus assert");
}

// 异步测试
- (void)testAsync{
    XCTestExpectation *ec = [self expectationWithDescription:@"testAsync expectDes"];
    [self.vc loadData:^(id data) {
        XCTAssertNotNil(data);
        [ec fulfill];
    }];
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        NSLog(@"error = %@",error);
    }];
    
}

// 性能测试
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        [self.vc openCamera];
    }];
}

- (void)testPerformance{
    
    [self measureMetrics:@[XCTPerformanceMetric_WallClockTime] automaticallyStartMeasuring:NO forBlock:^{
        [self.vc openCamera];//提供条件
        
        [self startMeasuring];
        [self.vc openCamera];//局部测试
        [self stopMeasuring];
    }];
}

@end
