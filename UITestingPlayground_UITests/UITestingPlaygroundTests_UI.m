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
#import "VIAccessibilityStrings.h"
#import "VILocalizedStrings.h"

@interface UITestingPlaygroundTests_UI : KIFTestCase

@end

@implementation UITestingPlaygroundTests_UI

- (void)beforeEach
{
    [super beforeEach];
    
    //Reset the login and password views before restarting.
    [tester waitForViewWithAccessibilityLabel:[VIAccessibilityStrings usernameTextField]];
    [tester clearTextFromViewWithAccessibilityLabel:[VIAccessibilityStrings usernameTextField]];
    [tester clearTextFromViewWithAccessibilityLabel:[VIAccessibilityStrings passwordTextField]];
}

#pragma mark - Convenience methods

- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password
{
    [tester enterText:username intoViewWithAccessibilityLabel:[VIAccessibilityStrings usernameTextField]];
    [tester enterText:password intoViewWithAccessibilityLabel:[VIAccessibilityStrings passwordTextField]];
    [tester tapViewWithAccessibilityLabel:[VILocalizedStrings loginGoText]];
}

#pragma mark - Error String Checkers

- (BOOL)errorTextLabel:(UILabel *)errorTextLabel hasText:(NSString *)textToCheckFor
{
    NSRange textRange = [errorTextLabel.text rangeOfString:textToCheckFor];
    return textRange.location != NSNotFound;
}

-(BOOL)errorTextLabelHasPasswordTooShortError:(UILabel *)errorTextLabel
{
    return [self errorTextLabel:errorTextLabel hasText:[VILocalizedStrings errorPasswordTooShort:VIPasswordMinCharacters]];
}

- (BOOL)errorTextLabelHasMustBeEmailError:(UILabel *)errorTextLabel
{
    return [self errorTextLabel:errorTextLabel hasText:[VILocalizedStrings errorUsernameMustBeEmail]];
}

- (BOOL)errorTextLabelHasEmailEmptyError:(UILabel *)errorTextLabel
{
    return [self errorTextLabel:errorTextLabel hasText:[VILocalizedStrings errorUsernameNotEmpty]];
}

- (BOOL)errorTestLabelHasInvalidUsernameErrorFromAPI:(UILabel *)errorTextLabel
{
    return [self errorTextLabel:errorTextLabel hasText:[VILocalizedStrings errorInvalidUsername]];
}

- (BOOL)errorTestLabelHasInvalidPasswordErrorFromAPI:(UILabel *)errorTextLabel
{
    return [self errorTextLabel:errorTextLabel hasText:[VILocalizedStrings errorWrongPassword]];
}

#pragma mark - UI tests
- (void)testEmptyLogin
{
    [self loginWithUsername:@"" andPassword:@""];
    
    //Test that the error text label shows up with the correct errors
    UIView *view = [tester waitForViewWithAccessibilityLabel:[VIAccessibilityStrings errorTextLabel]];
    XCTAssertTrue([view isKindOfClass:[UILabel class]], @"View is not a UILabel!");
    
    UILabel *errorTextLabel = (UILabel *)view;
    XCTAssertTrue([self errorTextLabelHasPasswordTooShortError:errorTextLabel], @"Too short password error not displaying with empty password!");
    XCTAssertTrue([self errorTextLabelHasMustBeEmailError:errorTextLabel], @"Username must be an email error not displaying with empty email!");
    XCTAssertTrue([self errorTextLabelHasEmailEmptyError:errorTextLabel], @"Username must not be empty error not displaying with empty email!");
    XCTAssertFalse([self errorTestLabelHasInvalidUsernameErrorFromAPI:errorTextLabel], @"Test that should bomb out before hitting API showing bad username from API error!");
    XCTAssertFalse([self errorTestLabelHasInvalidPasswordErrorFromAPI:errorTextLabel], @"Test that should bomb out before hitting API showing bad password from API error!");
    
    //Test that both error views show up.
    [tester waitForViewWithAccessibilityLabel:[VIAccessibilityStrings usernameErrorView]];
    [tester waitForViewWithAccessibilityLabel:[VIAccessibilityStrings passwordErrorView]];
    
    //Test that the login button re-enables after local failure.
    XCTAssertTrue(((UIButton *)[tester waitForViewWithAccessibilityLabel:[VILocalizedStrings loginGoText]]).enabled, @"Button disabled after local failure!");
}

- (void)testTooShortPassword
{
    [self loginWithUsername:VIValidLoginUserName andPassword:@"12345"];
    
    //Test that the error label shows up with the correct error message.
    UIView *view = [tester waitForViewWithAccessibilityLabel:[VIAccessibilityStrings errorTextLabel]];
    XCTAssertTrue([view isKindOfClass:[UILabel class]], @"View is not a UILabel!");
    
    UILabel *errorTextLabel = (UILabel *)view;
    XCTAssertTrue([self errorTextLabelHasPasswordTooShortError:errorTextLabel], @"Too short error not displaying with too-short password!");
    XCTAssertFalse([self errorTextLabelHasMustBeEmailError:errorTextLabel], @"Username must be email is displaying with valid email!");
    XCTAssertFalse([self errorTextLabelHasEmailEmptyError:errorTextLabel], @"Username must not be empty is displaying with valid email!");
    XCTAssertFalse([self errorTestLabelHasInvalidUsernameErrorFromAPI:errorTextLabel], @"Test that should bomb out before hitting API showing bad username from API error!");
    XCTAssertFalse([self errorTestLabelHasInvalidPasswordErrorFromAPI:errorTextLabel], @"Test that should bomb out before hitting API showing bad password from API error!");
    
    //Only the password error view shows up
    [tester waitForViewWithAccessibilityLabel:[VIAccessibilityStrings passwordErrorView]];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:[VIAccessibilityStrings usernameErrorView]];
    
    //Login button re-enables after local failure.
    XCTAssertTrue(((UIButton *)[tester waitForViewWithAccessibilityLabel:[VILocalizedStrings loginGoText]]).enabled, @"Button disabled after local failure!");
}

- (void)testInvalidUsername
{
    [self loginWithUsername:@"Nope" andPassword:VIValidLoginPassword];
    
    //Test that the error label shows up with the correct error message
    UIView *view = [tester waitForViewWithAccessibilityLabel:[VIAccessibilityStrings errorTextLabel]];
    XCTAssertTrue([view isKindOfClass:[UILabel class]], @"View is not a UILabel!");
    
    UILabel *errorTextLabel = (UILabel *)view;
    XCTAssertTrue([self errorTextLabelHasMustBeEmailError:errorTextLabel], @"Invalid username not displaying error!");
    XCTAssertFalse([self errorTextLabelHasEmailEmptyError:errorTextLabel], @"Non-empty username displaying user must not be empty error!");
    XCTAssertFalse([self errorTextLabelHasPasswordTooShortError:errorTextLabel], @"Too short error displaying with password of sufficient length!");
    XCTAssertFalse([self errorTestLabelHasInvalidUsernameErrorFromAPI:errorTextLabel], @"Test that should bomb out before hitting API showing bad username from API error!");
    XCTAssertFalse([self errorTestLabelHasInvalidPasswordErrorFromAPI:errorTextLabel], @"Test that should bomb out before hitting API showing bad password from API error!");
    
    //Test that only the username error view shows up
    [tester waitForViewWithAccessibilityLabel:[VIAccessibilityStrings usernameErrorView]];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:[VIAccessibilityStrings passwordErrorView]];
    
    //Test that the login button re-enables after local failure.
    XCTAssertTrue(((UIButton *)[tester waitForViewWithAccessibilityLabel:[VILocalizedStrings loginGoText]]).enabled, @"Button disabled after local failure!");
}

- (void)testWrongUsernameAndPassword
{
    [self loginWithUsername:@"lol@no.com" andPassword:@"noooooope"];
    XCTAssertFalse(((UIButton *)[tester waitForViewWithAccessibilityLabel:[VILocalizedStrings loggingInText]]).enabled, @"Login enabled while logging in with API!");
    
    //Test that the error label shows up with the correct message
    UIView *view = [tester waitForViewWithAccessibilityLabel:[VIAccessibilityStrings errorTextLabel]];
    XCTAssertTrue([view isKindOfClass:[UILabel class]], @"View is not a UILabel!");
    
    UILabel *errorTextLabel = (UILabel *)view;
    XCTAssertFalse([self errorTextLabelHasMustBeEmailError:errorTextLabel], @"Test that should go to API displaying local email error!");
    XCTAssertFalse([self errorTextLabelHasEmailEmptyError:errorTextLabel], @"Test that should go to API displaying user must not be empty error!");
    XCTAssertFalse([self errorTextLabelHasPasswordTooShortError:errorTextLabel], @"Test that should go to API displaying with password of sufficient length!");
    XCTAssertTrue([self errorTestLabelHasInvalidUsernameErrorFromAPI:errorTextLabel], @"Invalid username not displaying an error from API!");
    XCTAssertTrue([self errorTestLabelHasInvalidPasswordErrorFromAPI:errorTextLabel], @"Invalid password not displaying an error from API!");
    
    //Test that both username and password error views are showing
    [tester waitForViewWithAccessibilityLabel:[VIAccessibilityStrings usernameErrorView]];
    [tester waitForViewWithAccessibilityLabel:[VIAccessibilityStrings passwordErrorView]];
    
    //Test that the login button re-enables after API failure.
    XCTAssertTrue(((UIButton *)[tester waitForViewWithAccessibilityLabel:[VILocalizedStrings loginGoText]]).enabled, @"Button disabled after API failure!");}

- (void)testWrongUsername
{
    [self loginWithUsername:@"fake@fake.com" andPassword:VIValidLoginPassword];
    
    //Test that the login button disables while logging in
    XCTAssertFalse(((UIButton *)[tester waitForViewWithAccessibilityLabel:[VILocalizedStrings loggingInText]]).enabled, @"Login button enabled while logging in with API!");
    
    //Test that the error label shows up with the correct message
    UIView *view = [tester waitForViewWithAccessibilityLabel:[VIAccessibilityStrings errorTextLabel]];
    XCTAssertTrue([view isKindOfClass:[UILabel class]], @"View is not a UILabel!");

    UILabel *errorTextLabel = (UILabel *)view;
    XCTAssertFalse([self errorTextLabelHasMustBeEmailError:errorTextLabel], @"Test that should go to API displaying local email error!");
    XCTAssertFalse([self errorTextLabelHasEmailEmptyError:errorTextLabel], @"Test that should go to API displaying user must not be empty error!");
    XCTAssertFalse([self errorTextLabelHasPasswordTooShortError:errorTextLabel], @"Test that should go to API displaying with password of sufficient length!");
    XCTAssertTrue([self errorTestLabelHasInvalidUsernameErrorFromAPI:errorTextLabel], @"Invalid username not displaying an error from API!");
    XCTAssertFalse([self errorTestLabelHasInvalidPasswordErrorFromAPI:errorTextLabel], @"Valid password displaying an error from API!");
    
    //Test that only the username error view shows up
    [tester waitForViewWithAccessibilityLabel:[VIAccessibilityStrings usernameErrorView]];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:[VIAccessibilityStrings passwordErrorView]];
    
    //Test that the login button re-enables after API failure.
    XCTAssertTrue(((UIButton *)[tester waitForViewWithAccessibilityLabel:[VILocalizedStrings loginGoText]]).enabled, @"Login button disabled after API failure!");
}

- (void)testWrongPassword
{
    [self loginWithUsername:VIValidLoginUserName andPassword:@"password"];
    
    //Test that the login button disables while logging in
    XCTAssertFalse(((UIButton *)[tester waitForViewWithAccessibilityLabel:[VILocalizedStrings loggingInText]]).enabled, @"Login button enabled while logging in with API!");
    
    //Test that the error label shows up with the correct message
    UIView *view = [tester waitForViewWithAccessibilityLabel:[VIAccessibilityStrings errorTextLabel]];
    XCTAssertTrue([view isKindOfClass:[UILabel class]], @"View is not a UILabel!");
    
    UILabel *errorTextLabel = (UILabel *)view;
    XCTAssertFalse([self errorTextLabelHasMustBeEmailError:errorTextLabel], @"Test that should go to API displaying local email error!");
    XCTAssertFalse([self errorTextLabelHasEmailEmptyError:errorTextLabel], @"Test that should go to API displaying user must not be empty error!");
    XCTAssertFalse([self errorTextLabelHasPasswordTooShortError:errorTextLabel], @"Test that should go to API displaying with password of sufficient length!");
    XCTAssertFalse([self errorTestLabelHasInvalidUsernameErrorFromAPI:errorTextLabel], @"Valid username displaying an error from API!");
    XCTAssertTrue([self errorTestLabelHasInvalidPasswordErrorFromAPI:errorTextLabel], @"Invalid password not displaying an error from API!");
    
    //Test that only the password error view shows up
    [tester waitForViewWithAccessibilityLabel:[VIAccessibilityStrings passwordErrorView]];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:[VIAccessibilityStrings usernameErrorView]];
    
    //Test that the login button re-enables after API failure.
    XCTAssertTrue(((UIButton *)[tester waitForViewWithAccessibilityLabel:[VILocalizedStrings loginGoText]]).enabled, @"Login button disabled after API failure!");
}

- (void)testValidCredentials
{
    [self loginWithUsername:VIValidLoginUserName andPassword:VIValidLoginPassword];

    //Test that the login button disables while logging in
    XCTAssertFalse(((UIButton *)[tester waitForViewWithAccessibilityLabel:[VILocalizedStrings loggingInText]]).enabled, @"Login button enabled while logging in with API!");
    
    //Test that all error views are hidden
    [tester waitForAbsenceOfViewWithAccessibilityLabel:[VIAccessibilityStrings passwordErrorView]];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:[VIAccessibilityStrings usernameErrorView]];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:[VIAccessibilityStrings errorTextLabel]];
    
    //Test that the login button does not re-enable after API success.
    XCTAssertFalse(((UIButton *)[tester waitForViewWithAccessibilityLabel:[VILocalizedStrings loginSuccessText]]).enabled, @"Login button disabled after API failure!");
}

@end
