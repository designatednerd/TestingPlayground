//
//  UITestingPlayground_Tests.m
//  UITestingPlayground Tests
//
//  Created by Ellen Shapiro (Vokal) on 2/3/14.
//  Copyright (c) 2014 Ellen Shapiro. All rights reserved.
//

#import <KIF/KIF.h>

#import "VIViewController.h"
#import "VIFakeAPI.h"

@interface UITestingPlayground_Tests : KIFTestCase

@end

@implementation UITestingPlayground_Tests

- (void)beforeEach
{
    [super beforeEach];
    [tester clearTextFromViewWithAccessibilityLabel:VIAccessibilityPasswordTextField];
    [tester clearTextFromViewWithAccessibilityLabel:VIAccessibilityUsernameTextField];

}

- (void)afterEach
{
    [super afterEach];
}

- (void)testEmptyLogin
{
    [tester enterText:@"" intoViewWithAccessibilityLabel:VIAccessibilityUsernameTextField];
    [tester enterText:@"" intoViewWithAccessibilityLabel:VIAccessibilityPasswordTextField];
    [tester tapViewWithAccessibilityLabel:VIAccessibilityLoginButton];
    
    [tester waitForViewWithAccessibilityLabel:VIAccessibilityErrorTextLabel];
    [tester waitForViewWithAccessibilityLabel:VIAccessibilityPasswordErrorView];
    [tester waitForViewWithAccessibilityLabel:VIAccessibilityUsernameErrorView];
}

- (void)testTooShortPassword
{
    [tester enterText:VIValidLoginUserName intoViewWithAccessibilityLabel:VIAccessibilityUsernameTextField];
    [tester enterText:@"12345" intoViewWithAccessibilityLabel:VIAccessibilityPasswordTextField];
    [tester tapViewWithAccessibilityLabel:VIAccessibilityLoginButton];
    
    [tester waitForViewWithAccessibilityLabel:VIAccessibilityErrorTextLabel];
    [tester waitForViewWithAccessibilityLabel:VIAccessibilityPasswordErrorView];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:VIAccessibilityUsernameErrorView];
}

- (void)testInvalidUsername
{
    [tester enterText:@"Nope" intoViewWithAccessibilityLabel:VIAccessibilityUsernameTextField];
    [tester enterText:VIValidLoginPassword intoViewWithAccessibilityLabel:VIAccessibilityPasswordTextField];
    [tester tapViewWithAccessibilityLabel:VIAccessibilityLoginButton];
    
    [tester waitForViewWithAccessibilityLabel:VIAccessibilityErrorTextLabel];
    [tester waitForViewWithAccessibilityLabel:VIAccessibilityUsernameErrorView];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:VIAccessibilityPasswordErrorView];
}

@end
