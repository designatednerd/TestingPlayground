//
//  UITestingPlaygroundTests.m
//  UITestingPlaygroundTests
//
//  Created by Ellen Shapiro (Vokal) on 1/31/14.
//  Copyright (c) 2014 Ellen Shapiro. All rights reserved.
//

#import "VIFakeAPI.h"

@import XCTest;

@interface UITestingPlaygroundTests_NonUI : XCTestCase
@property (nonatomic, strong) VIFakeAPI *fakeAPI;
@end

NSTimeInterval const VIAPITimeout = 10;

@implementation UITestingPlaygroundTests_NonUI

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.fakeAPI = [[VIFakeAPI alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.fakeAPI = nil;
}

- (void)testFakeAPIValidLogin
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Valid login succeeded"];
    [self.fakeAPI loginWithUsername:VIValidLoginUserName password:VIValidLoginPassword completion:^(BOOL success, NSError *error) {
        XCTAssertTrue(success, @"Valid login not returning success!");
        XCTAssertNil(error, @"Valid login returning non-nil error!");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:VIAPITimeout handler:nil];
}


- (void)testFakeAPIInvalidUserName
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Invalid Username Failed"];
    [self.fakeAPI loginWithUsername:@"fake@fake.com" password:VIValidLoginPassword completion:^(BOOL success, NSError *error) {
        XCTAssertFalse(success, @"Invalid login returning success!");
        XCTAssertNotNil(error, @"Invalid login not returning error!");
        NSString *localizedDescription = error.userInfo[NSLocalizedDescriptionKey];
        XCTAssertTrue([localizedDescription isEqualToString:[VIFakeAPI invalidUsernameError]], @"Invalid password returning incorrect error!");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:VIAPITimeout handler:nil];
}

- (void)testFakeAPIInvalidPassword
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Invalid password failed"];
    [self.fakeAPI loginWithUsername:VIValidLoginUserName password:@"password" completion:^(BOOL success, NSError *error) {
        XCTAssertFalse(success, @"Invalid login returning success!");
        XCTAssertNotNil(error, @"Invalid login not returning error!");
        NSString *localizedDescription = error.userInfo[NSLocalizedDescriptionKey];
        XCTAssertTrue([localizedDescription isEqualToString:[VIFakeAPI invalidPasswordError]], @"Invalid password  returning incorrect error!");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:VIAPITimeout handler:nil];
}

- (void)testFakeAPIInvalidUserNameAndPassword
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Invalid both failed"];
    [self.fakeAPI loginWithUsername:@"nope@nope.com" password:@"noooooope" completion:^(BOOL success, NSError *error) {
        XCTAssertFalse(success, @"Invalid login returning success");
        XCTAssertNotNil(error, @"Invalid login not returning error!");
        NSString *localizedDescription = error.userInfo[NSLocalizedDescriptionKey];
        
        NSRange usernameErrorRange = [localizedDescription rangeOfString:[VIFakeAPI invalidUsernameError]];
        XCTAssertNotEqual(usernameErrorRange.location, NSNotFound, @"Error does not contain invalid username info!");
        
        NSRange passwordErrorRange = [localizedDescription rangeOfString:[VIFakeAPI invalidPasswordError]];
        XCTAssertNotEqual(passwordErrorRange.location, NSNotFound, @"Error does not contain invalid password info!");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:VIAPITimeout handler:nil];
}


- (void)testFakeAPINetworkTimeout
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fake network timed out"];
    [self.fakeAPI networkFailureLoginWithUsername:VIValidLoginUserName password:VIValidLoginPassword completion:^(BOOL success, NSError *error) {
        XCTAssertFalse(success, @"Fake network failure not failing!");
        XCTAssertNotNil(error, @"Fake network failure not returning an error!");
        
        NSString *localizedDescription = error.userInfo[NSLocalizedDescriptionKey];
        XCTAssertTrue([localizedDescription isEqualToString:[VIFakeAPI networkFailError]], @"Error does not contain network fail info!");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:VIAPITimeout handler:nil];
}

@end
