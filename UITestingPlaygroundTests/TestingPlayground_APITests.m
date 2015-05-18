//
//  UITestingPlaygroundTests.m
//  UITestingPlaygroundTests
//
//  Created by Ellen Shapiro (Vokal) on 1/31/14.
//  Copyright (c) 2014 Ellen Shapiro. All rights reserved.
//

#import "VIFakeAPI.h"
#import "VILocalizedStrings.h"

@import XCTest;

@interface TestingPlayground_APITests : XCTestCase
@property (nonatomic, strong) VIFakeAPI *api;
@end

NSTimeInterval const VIAPITimeout = 10;

@implementation TestingPlayground_APITests

- (void)setUp
{
    [super setUp];
    self.api = [[VIFakeAPI alloc] init];
}

- (void)tearDown
{
    self.api = nil;
    [super tearDown];
}

#pragma mark - Actual Tests

- (void)testValidLogin
{
    //GIVEN: A user wants to log in.
    XCTestExpectation *expectation = [self expectationWithDescription:@"Valid login succeeded"];
    
    //WHEN: User attempts login with a valid username and password
    [self.api loginWithUsername:VIValidLoginUserName
        password:VIValidLoginPassword
        completion:^(BOOL success, NSError *error) {

        //THEN: Login should succeed.
        XCTAssertTrue(success, @"Valid login not returning success!");
        XCTAssertNil(error, @"Valid login returning non-nil error!");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:VIAPITimeout handler:nil];
}


- (void)testInvalidUserName
{
    //GIVEN: A user wants to log in.
    XCTestExpectation *expectation = [self expectationWithDescription:@"Invalid Username Failed"];
    
    //WHEN: The user enters an invalid username
    [self.api loginWithUsername:@"fake@fake.com" password:VIValidLoginPassword completion:^(BOOL success, NSError *error) {
        
        //THEN: The login should fail with an error indicating an invalid username.
        XCTAssertFalse(success, @"Invalid login returning success!");
        XCTAssertNotNil(error, @"Invalid login not returning error!");
        NSString *localizedDescription = error.userInfo[NSLocalizedDescriptionKey];
        XCTAssertTrue([localizedDescription isEqualToString:[VILocalizedStrings errorInvalidUsername]], @"Invalid password returning incorrect error!");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:VIAPITimeout handler:nil];
}

- (void)testInvalidPassword
{
    //GIVEN: A user wants to log in.
    XCTestExpectation *expectation = [self expectationWithDescription:@"Invalid password failed"];
    
    //WHEN: The user inputs a valid username but an invalid password
    [self.api loginWithUsername:VIValidLoginUserName password:@"password"
        completion:^(BOOL success, NSError *error) {
            
        //THEN: The login should fail and an error about an invalid password should be returned.
        XCTAssertFalse(success, @"Invalid login returning success!");
        XCTAssertNotNil(error, @"Invalid login not returning error!");
        NSString *localizedDescription = error.userInfo[NSLocalizedDescriptionKey];
        XCTAssertTrue([localizedDescription isEqualToString:[VILocalizedStrings errorWrongPassword]], @"Invalid password  returning incorrect error!");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:VIAPITimeout handler:nil];
}

- (void)testAPITimeout
{
    //GIVEN: A user wants to log in
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fake network timed out"];
    
    //WHEN: The user attempts to log in with valid credentials but the network times out
    [self.api fakeAPITimeoutLoginWithUsername:VIValidLoginUserName
        password:VIValidLoginPassword
        completion:^(BOOL success, NSError *error) {
            
        //THEN: The login attempt should fail and return an error about a network failure.
        XCTAssertFalse(success, @"Fake network failure not failing!");
        XCTAssertNotNil(error, @"Fake network failure not returning an error!");
        
        NSString *localizedDescription = error.userInfo[NSLocalizedDescriptionKey];
        XCTAssertTrue([localizedDescription isEqualToString:[VILocalizedStrings errorNetworkFail]], @"Error does not contain network fail info!");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:VIAPITimeout handler:nil];
}


@end
