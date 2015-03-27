//
//  UITestingPlaygroundMockTests.m
//  UITestingPlayground
//
//  Created by Ellen Shapiro (Vokal) on 3/26/15.
//  Copyright (c) 2015 Ellen Shapiro. All rights reserved.
//

@import XCTest;

#import "VIFakeAPI.h"
#import "VILocalizedStrings.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface TestingPlayground_MockTests : XCTestCase
@property (nonatomic) VIFakeAPI *fakeAPI;
@end

@implementation TestingPlayground_MockTests

- (void)setUp
{
    [super setUp];
    self.fakeAPI = [[VIFakeAPI alloc] init];
    [self mockInternetIsFine];
}

- (void)tearDown
{
    self.fakeAPI = nil;
    [super tearDown];
}

#pragma mark - Mockery!

- (void)mockInternetIsFine
{
    //Create a "mock" object of the class you wish to use.
    Reachability *reachableMock = mock([Reachability class]);
    
    //Dictate the behavior of the method or methods which will be called
    //by the thing you're testing
    [given([reachableMock isReachable]) willReturnBool:YES];
    
    //Set it on the actual object you're trying to test.
    self.fakeAPI.reachability = reachableMock;
}

- (void)mockInternetNotWorking
{
    Reachability *unreachableMock = mock([Reachability class]);
    [given([unreachableMock isReachable]) willReturnBool:NO];
    self.fakeAPI.reachability = unreachableMock;
}

#pragma mark - Actual Tests

- (void)testAppropriateErrorIsReturnedWhenNotConectedToInternet
{
    [self mockInternetNotWorking];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"YOU CANNOT HAS INTERNETS"];
    [self.fakeAPI loginWithUsername:VIValidLoginUserName password:VIValidLoginPassword completion:^(BOOL success, NSError *error) {
        XCTAssertFalse(success, @"Fake no internet not failing!");
        XCTAssertNotNil(error, @"Fake no internet not returning an error!");
        
        NSString *localizedDescription = error.userInfo[NSLocalizedDescriptionKey];
        XCTAssertTrue([localizedDescription isEqualToString:[VILocalizedStrings errorNoInternet]], @"Wrong error detail returned!");
        [expectation fulfill];
    }];
    
    //This should return roughly immediately, but we still need
    //to wait a smidge to allow the block to execute.
    [self waitForExpectationsWithTimeout:5 handler:nil];
}


@end
