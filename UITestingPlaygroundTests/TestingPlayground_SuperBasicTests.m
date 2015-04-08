//
//  TestingPlayground_SuperBasicTests.m
//  TestingPlayground
//
//  Created by Ellen Shapiro on 4/8/15.
//  Copyright (c) 2015 Ellen Shapiro. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "VILocalizedStrings.h"
#import "VIViewController.h"

@interface TestingPlayground_SuperBasicTests : XCTestCase
@property (nonatomic) NSInteger basicTestNumber;
@end

@implementation TestingPlayground_SuperBasicTests

#pragma mark - Class Setup/Teardown

static BOOL classSetupFired;
static BOOL classTeardownFired;

+ (void)setUp
{
    [super setUp];
    classSetupFired = YES;
    classTeardownFired = NO;
}

+ (void)tearDown
{
    classTeardownFired = YES;
    [super tearDown];
}

#pragma mark - Instance Setup/Teardown

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.basicTestNumber = 4;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.basicTestNumber = -1;
    [super tearDown];
}

#pragma mark - Helper methods

- (void)failHard
{
    XCTFail(@"D'oh!");
}

- (void)checkClassSetupFiredButNotTearDown
{
    XCTAssertTrue(classSetupFired, @"Class setup did not fire when it should have!");
    XCTAssertFalse(classTeardownFired, @"Class teardown fired when it shouldn't have!");
}

#pragma mark - Tests!

//- (void)testCallingGuaranteedFailureMethod
//{
//    [self failHard];
//}

- (void)testSettingTestNumberWorked
{
    //Direct equality comparison
    XCTAssertEqual(self.basicTestNumber, 4, @"Basic test number not set properly!");
    
    //Direct inequality comparison.
    XCTAssertNotEqual(self.basicTestNumber, -1, @"Basic test number not reset properly!");
    
    //Floating point equality comparison
    XCTAssertNotEqual(self.basicTestNumber, 3.999999f, @"Floating point difference didn't fail!");
    XCTAssertEqualWithAccuracy(self.basicTestNumber, 3.999999f, 0.001f, @"Floating point accuracy no bueno!");
    
    [self checkClassSetupFiredButNotTearDown];
}

- (void)testEqualityOfObjects
{
    /**
     * When testing equality of objects, that object's `isEqual:` method is used.
     * Make sure you're aware of what will cause that to return YES and NO for whatever
     * object you're testing if you want to use `XCTAssertEqual` or `XCTAssertNotEqual`.
     */
    
    //String equality
    NSString *string1 = @"Hello";
    NSString *string2 = @"Hello";
    NSString *string3 = @"HELLO";
    XCTAssertEqual(string1, string2, @"Strings with the same content are not equal!");
    XCTAssertNotEqual(string1, string3, @"Strings with different caps are not equal!");
    XCTAssertTrue(([string1 caseInsensitiveCompare:string3] == NSOrderedSame),
                  @"Case insensitive comparison did not return ordered same!");
    
    //VC equality
    VIViewController *vc1 = [[VIViewController alloc] init];
    VIViewController *vc2 = [[VIViewController alloc] init];
    XCTAssertNotEqual(vc1, vc2, @"Two different view controllers are equal!");
    
    [self checkClassSetupFiredButNotTearDown];
}

@end
