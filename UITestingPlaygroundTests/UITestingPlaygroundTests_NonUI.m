//
//  UITestingPlaygroundTests.m
//  UITestingPlaygroundTests
//
//  Created by Ellen Shapiro (Vokal) on 1/31/14.
//  Copyright (c) 2014 Ellen Shapiro. All rights reserved.
//

#import "XCTAsyncTestCase.h"

#import "VIFakeAPI.h"

@interface UITestingPlaygroundTests_NonUI : XCTAsyncTestCase
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
    [self prepare];
    [self.fakeAPI loginWithUsername:VIValidLoginUserName password:VIValidLoginPassword completion:^(BOOL success, NSError *error) {
        XCTAssertTrue(success, @"Valid login not returning success!");
        XCTAssertNil(error, @"Valid login returning non-nil error!");
        [self notify:kXCTUnitWaitStatusSuccess];
    }];
    
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:VIAPITimeout];
}


- (void)testFakeAPIInvalidUserName
{
    [self prepare];
    [self.fakeAPI loginWithUsername:@"fake@fake.com" password:VIValidLoginPassword completion:^(BOOL success, NSError *error) {
        XCTAssertFalse(success, @"Invalid login returning success!");
        XCTAssertNotNil(error, @"Invalid login not returning error!");
        NSString *localizedDescription = error.userInfo[NSLocalizedDescriptionKey];
        XCTAssertTrue([localizedDescription isEqualToString:[VIFakeAPI invalidUsernameError]], @"Invalid password returning incorrect error!");
        [self notify:kXCTUnitWaitStatusSuccess];
    }];
    
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:VIAPITimeout];
}

- (void)testFakeAPIInvalidPassword
{
    [self prepare];
    [self.fakeAPI loginWithUsername:VIValidLoginUserName password:@"password" completion:^(BOOL success, NSError *error) {
        XCTAssertFalse(success, @"Invalid login returning success!");
        XCTAssertNotNil(error, @"Invalid login not returning error!");
        NSString *localizedDescription = error.userInfo[NSLocalizedDescriptionKey];
        XCTAssertTrue([localizedDescription isEqualToString:[VIFakeAPI invalidPasswordError]], @"Invalid password  returning incorrect error!");
        [self notify:kXCTUnitWaitStatusSuccess];
    }];
    
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:VIAPITimeout];
}

- (void)testFakeAPIInvalidUserNameAndPassword
{
    [self prepare];
    [self.fakeAPI loginWithUsername:@"nope@nope.com" password:@"noooooope" completion:^(BOOL success, NSError *error) {
        XCTAssertFalse(success, @"Invalid login returning success");
        XCTAssertNotNil(error, @"Invalid login not returning error!");
        NSString *localizedDescription = error.userInfo[NSLocalizedDescriptionKey];
        
        NSRange usernameErrorRange = [localizedDescription rangeOfString:[VIFakeAPI invalidUsernameError]];
        XCTAssertNotEqual(usernameErrorRange.location, NSNotFound, @"Error does not contain invalid username info!");
        
        NSRange passwordErrorRange = [localizedDescription rangeOfString:[VIFakeAPI invalidPasswordError]];
        XCTAssertNotEqual(passwordErrorRange.location, NSNotFound, @"Error does not contain invalid password info!");
        
        [self notify:kXCTUnitWaitStatusSuccess];
    }];
    
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:VIAPITimeout];
}


- (void)testFakeAPINetworkTimeout
{
    [self prepare];
    [self.fakeAPI networkFailureLoginWithUsername:VIValidLoginUserName password:VIValidLoginPassword completion:^(BOOL success, NSError *error) {
        XCTAssertFalse(success, @"Fake network failure not failing!");
        XCTAssertNotNil(error, @"Fake network failure not returning an error!");
        
        NSString *localizedDescription = error.userInfo[NSLocalizedDescriptionKey];
        XCTAssertTrue([localizedDescription isEqualToString:[VIFakeAPI networkFailError]], @"Error does not contain network fail info!");
        
        [self notify:kXCTUnitWaitStatusSuccess];
    }];
    
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:VIAPITimeout];
}

@end
