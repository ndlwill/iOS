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
    [app.buttons[@"collectionView"] tap];
    
    XCUIElementQuery *cellsQuery = app.collectionViews.cells;
    /*@START_MENU_TOKEN@*/[[cellsQuery.otherElements containingType:XCUIElementTypeStaticText identifier:@"0-4"].element pressForDuration:1.7];/*[["[","cellsQuery.otherElements containingType:XCUIElementTypeStaticText identifier:@\"0-4\"].element"," tap];"," pressForDuration:1.7];"],[[[0,1,1]],[[0,3],[0,2]]],[0,0]]@END_MENU_TOKEN@*/
    
    XCUIElement *element = [cellsQuery.otherElements containingType:XCUIElementTypeStaticText identifier:@"0-5"].element;
    /*@START_MENU_TOKEN@*/[element pressForDuration:1.7];/*[["element","["," tap];"," pressForDuration:1.7];"],[[[-1,0,1]],[[1,3],[1,2]]],[0,0]]@END_MENU_TOKEN@*/
    [app.buttons[@"close"] tap];
    /*@START_MENU_TOKEN@*/[element pressForDuration:1.6];/*[["element","["," tap];"," pressForDuration:1.6];"],[[[-1,0,1]],[[1,3],[1,2]]],[0,0]]@END_MENU_TOKEN@*/
    [[cellsQuery.otherElements containingType:XCUIElementTypeStaticText identifier:@"0-7"].element swipeUp];
    [[cellsQuery.otherElements containingType:XCUIElementTypeStaticText identifier:@"0-16"].element swipeRight];
    
}

@end
