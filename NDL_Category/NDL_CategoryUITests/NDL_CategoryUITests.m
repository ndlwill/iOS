//
//  NDL_CategoryUITests.m
//  NDL_CategoryUITests
//
//  Created by dzcx on 2019/2/2.
//  Copyright © 2019 ndl. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface NDL_CategoryUITests : XCTestCase

@end

@implementation NDL_CategoryUITests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [[[[[app.otherElements containingType:XCUIElementTypeStaticText identifier:@"sjhdgdgjk"] childrenMatchingType:XCUIElementTypeButton] matchingIdentifier:@"Button"] elementBoundByIndex:0] tap];
    [app.buttons[@"Four"] tap];
    [app.navigationBars[@"FourView"].buttons[@"Test"] tap];
    
    XCUIElement *element = [[[[[[[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element;
    [element tap];
    [element tap];
    [element tap];
    [element tap];
    
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

@end
