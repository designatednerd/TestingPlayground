//
//  UITestingPlaygroundTests.m
//  UITestingPlaygroundTests
//
//  Created by Ellen Shapiro (Vokal) on 1/31/14.
//  Copyright (c) 2014 Ellen Shapiro. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "VIFakeAPI.h"

@interface UITestingPlaygroundTests_NonUI : XCTestCase
@end

@implementation UITestingPlaygroundTests_NonUI

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFakeAPIValidLogin
{
    VIFakeAPI *fakeAPI = [[VIFakeAPI alloc] init];
    
}



@end
