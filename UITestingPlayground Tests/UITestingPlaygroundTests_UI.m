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
    
    //Reset the login and password views before restarting.
    [tester clearTextFromViewWithAccessibilityLabel:VIAccessibilityPasswordTextField];
    [tester clearTextFromViewWithAccessibilityLabel:VIAccessibilityUsernameTextField];
}

- (void)afterEach
{
    [super afterEach];
}

#pragma mark - Convenience methods
- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password
{
    [tester enterText:username intoViewWithAccessibilityLabel:VIAccessibilityUsernameTextField];
    [tester enterText:password intoViewWithAccessibilityLabel:VIAccessibilityPasswordTextField];
    [tester tapViewWithAccessibilityLabel:VIAccessibilityLoginButton];

}

#pragma mark - Error String Checkers
- (BOOL)errorTextLabel:(UILabel *)errorTextLabel hasText:(NSString *)textToCheckFor
{
    NSRange textRange = [errorTextLabel.text rangeOfString:textToCheckFor];
    return textRange.location != NSNotFound;
}

-(BOOL)errorTextLabelHasPasswordTooShortError:(UILabel *)errorTextLabel
{
    return [self errorTextLabel:errorTextLabel hasText:[VIViewController errorPasswordTooShort]];
}

- (BOOL)errorTextLabelHasMustBeEmailError:(UILabel *)errorTextLabel
{
    return [self errorTextLabel:errorTextLabel hasText:[VIViewController errorUsernameMustBeEmail]];
}

- (BOOL)errorTextLabelHasEmailEmptyError:(UILabel *)errorTextLabel
{
    return [self errorTextLabel:errorTextLabel hasText:[VIViewController errorUsernameNotEmpty]];
}

- (BOOL)errorTestLabelHasInvalidUsernameErrorFromAPI:(UILabel *)errorTextLabel
{
    return [self errorTextLabel:errorTextLabel hasText:[VIFakeAPI invalidUsernameError]];
}

- (BOOL)errorTestLabelHasInvalidPasswordErrorFromAPI:(UILabel *)errorTextLabel
{
    return [self errorTextLabel:errorTextLabel hasText:[VIFakeAPI invalidPasswordError]];
}

#pragma mark - UI tests
- (void)testEmptyLogin
{
    [self loginWithUsername:@"" andPassword:@""];
    
    //Test that the error text label shows up with the correct errors
    UIView *view = [tester waitForViewWithAccessibilityLabel:VIAccessibilityErrorTextLabel];
    STAssertTrue([view isKindOfClass:[UILabel class]], @"View is not a UILabel!");
    
    UILabel *errorTextLabel = (UILabel *)view;
    STAssertTrue([self errorTextLabelHasPasswordTooShortError:errorTextLabel], @"Too short password error not displaying with empty password!");
    STAssertTrue([self errorTextLabelHasMustBeEmailError:errorTextLabel], @"Username must be an email error not displaying with empty email!");
    STAssertTrue([self errorTextLabelHasEmailEmptyError:errorTextLabel], @"Username must not be empty error not displaying with empty email!");
    STAssertFalse([self errorTestLabelHasInvalidUsernameErrorFromAPI:errorTextLabel], @"Test that should bomb out before hitting API showing bad username from API error!");
    STAssertFalse([self errorTestLabelHasInvalidPasswordErrorFromAPI:errorTextLabel], @"Test that should bomb out before hitting API showing bad password from API error!");
    
    //Test that both error views show up.
    [tester waitForViewWithAccessibilityLabel:VIAccessibilityPasswordErrorView];
    [tester waitForViewWithAccessibilityLabel:VIAccessibilityUsernameErrorView];
    
    //Test that the login button re-enables after local failure.
    STAssertTrue(((UIButton *)[tester waitForViewWithAccessibilityLabel:VIAccessibilityLoginButton]).enabled, @"Button disabled after local failure!");
}

- (void)testTooShortPassword
{
    [self loginWithUsername:VIValidLoginUserName andPassword:@"12345"];
    
    //Test that the error label shows up with the correct error message.
    UIView *view = [tester waitForViewWithAccessibilityLabel:VIAccessibilityErrorTextLabel];
    STAssertTrue([view isKindOfClass:[UILabel class]], @"View is not a UILabel!");
    
    UILabel *errorTextLabel = (UILabel *)view;
    STAssertTrue([self errorTextLabelHasPasswordTooShortError:errorTextLabel], @"Too short error not displaying with too-short password!");
    STAssertFalse([self errorTextLabelHasMustBeEmailError:errorTextLabel], @"Username must be email is displaying with valid email!");
    STAssertFalse([self errorTextLabelHasEmailEmptyError:errorTextLabel], @"Username must not be empty is displaying with valid email!");
    STAssertFalse([self errorTestLabelHasInvalidUsernameErrorFromAPI:errorTextLabel], @"Test that should bomb out before hitting API showing bad username from API error!");
    STAssertFalse([self errorTestLabelHasInvalidPasswordErrorFromAPI:errorTextLabel], @"Test that should bomb out before hitting API showing bad password from API error!");
    
    //Test that only the password error view shows up
    [tester waitForViewWithAccessibilityLabel:VIAccessibilityPasswordErrorView];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:VIAccessibilityUsernameErrorView];
    
    //Test that the login button re-enables after local failure.
    STAssertTrue(((UIButton *)[tester waitForViewWithAccessibilityLabel:VIAccessibilityLoginButton]).enabled, @"Button disabled after local failure!");
}

- (void)testInvalidUsername
{
    [self loginWithUsername:@"Nope" andPassword:VIValidLoginPassword];
    
    //Test that the error label shows up with the correct error message
    UIView *view = [tester waitForViewWithAccessibilityLabel:VIAccessibilityErrorTextLabel];
    STAssertTrue([view isKindOfClass:[UILabel class]], @"View is not a UILabel!");
    
    UILabel *errorTextLabel = (UILabel *)view;
    STAssertTrue([self errorTextLabelHasMustBeEmailError:errorTextLabel], @"Invalid username not displaying error!");
    STAssertFalse([self errorTextLabelHasEmailEmptyError:errorTextLabel], @"Non-empty username displaying user must not be empty error!");
    STAssertFalse([self errorTextLabelHasPasswordTooShortError:errorTextLabel], @"Too short error displaying with password of sufficient length!");
    STAssertFalse([self errorTestLabelHasInvalidUsernameErrorFromAPI:errorTextLabel], @"Test that should bomb out before hitting API showing bad username from API error!");
    STAssertFalse([self errorTestLabelHasInvalidPasswordErrorFromAPI:errorTextLabel], @"Test that should bomb out before hitting API showing bad password from API error!");
    
    //Test that only the username error view shows up
    [tester waitForViewWithAccessibilityLabel:VIAccessibilityUsernameErrorView];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:VIAccessibilityPasswordErrorView];
    
    //Test that the login button re-enables after local failure.
    STAssertTrue(((UIButton *)[tester waitForViewWithAccessibilityLabel:VIAccessibilityLoginButton]).enabled, @"Button disabled after local failure!");
}

- (void)testWrongUsernameAndPassword
{
    [self loginWithUsername:@"lol@no.com" andPassword:@"noooooope"];
    STAssertFalse(((UIButton *)[tester waitForViewWithAccessibilityLabel:VIAccessibilityLoginButton]).enabled, @"Login enabled while logging in with API!");
    
    //Test that the error label shows up with the correct message
    UIView *view = [tester waitForViewWithAccessibilityLabel:VIAccessibilityErrorTextLabel];
    STAssertTrue([view isKindOfClass:[UILabel class]], @"View is not a UILabel!");
    
    UILabel *errorTextLabel = (UILabel *)view;
    STAssertFalse([self errorTextLabelHasMustBeEmailError:errorTextLabel], @"Test that should go to API displaying local email error!");
    STAssertFalse([self errorTextLabelHasEmailEmptyError:errorTextLabel], @"Test that should go to API displaying user must not be empty error!");
    STAssertFalse([self errorTextLabelHasPasswordTooShortError:errorTextLabel], @"Test that should go to API displaying with password of sufficient length!");
    STAssertTrue([self errorTestLabelHasInvalidUsernameErrorFromAPI:errorTextLabel], @"Invalid username not displaying an error from API!");
    STAssertTrue([self errorTestLabelHasInvalidPasswordErrorFromAPI:errorTextLabel], @"Invalid password not displaying an error from API!");
    
    //Test that both username and password error views are showing
    [tester waitForViewWithAccessibilityLabel:VIAccessibilityUsernameErrorView];
    [tester waitForViewWithAccessibilityLabel:VIAccessibilityPasswordErrorView];
    
    //Test that the login button re-enables after API failure.
    STAssertTrue(((UIButton *)[tester waitForViewWithAccessibilityLabel:VIAccessibilityLoginButton]).enabled, @"Button disabled after API failure!");}

- (void)testWrongUsername
{
    [self loginWithUsername:@"fake@fake.com" andPassword:VIValidLoginPassword];
    
    //Test that the login button disables while logging in
    STAssertFalse(((UIButton *)[tester waitForViewWithAccessibilityLabel:VIAccessibilityLoginButton]).enabled, @"Login button enabled while logging in with API!");
    
    //Test that the error label shows up with the correct message
    UIView *view = [tester waitForViewWithAccessibilityLabel:VIAccessibilityErrorTextLabel];
    STAssertTrue([view isKindOfClass:[UILabel class]], @"View is not a UILabel!");

    UILabel *errorTextLabel = (UILabel *)view;
    STAssertFalse([self errorTextLabelHasMustBeEmailError:errorTextLabel], @"Test that should go to API displaying local email error!");
    STAssertFalse([self errorTextLabelHasEmailEmptyError:errorTextLabel], @"Test that should go to API displaying user must not be empty error!");
    STAssertFalse([self errorTextLabelHasPasswordTooShortError:errorTextLabel], @"Test that should go to API displaying with password of sufficient length!");
    STAssertTrue([self errorTestLabelHasInvalidUsernameErrorFromAPI:errorTextLabel], @"Invalid username not displaying an error from API!");
    STAssertFalse([self errorTestLabelHasInvalidPasswordErrorFromAPI:errorTextLabel], @"Valid password displaying an error from API!");
    
    //Test that only the username error view shows up
    [tester waitForViewWithAccessibilityLabel:VIAccessibilityUsernameErrorView];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:VIAccessibilityPasswordErrorView];
    
    //Test that the login button re-enables after API failure.
    STAssertTrue(((UIButton *)[tester waitForViewWithAccessibilityLabel:VIAccessibilityLoginButton]).enabled, @"Login button disabled after API failure!");
}

- (void)testWrongPassword
{
    [self loginWithUsername:VIValidLoginUserName andPassword:@"password"];
    
    //Test that the login button disables while logging in
    STAssertFalse(((UIButton *)[tester waitForViewWithAccessibilityLabel:VIAccessibilityLoginButton]).enabled, @"Login button enabled while logging in with API!");
    
    //Test that the error label shows up with the correct message
    UIView *view = [tester waitForViewWithAccessibilityLabel:VIAccessibilityErrorTextLabel];
    STAssertTrue([view isKindOfClass:[UILabel class]], @"View is not a UILabel!");
    
    UILabel *errorTextLabel = (UILabel *)view;
    STAssertFalse([self errorTextLabelHasMustBeEmailError:errorTextLabel], @"Test that should go to API displaying local email error!");
    STAssertFalse([self errorTextLabelHasEmailEmptyError:errorTextLabel], @"Test that should go to API displaying user must not be empty error!");
    STAssertFalse([self errorTextLabelHasPasswordTooShortError:errorTextLabel], @"Test that should go to API displaying with password of sufficient length!");
    STAssertFalse([self errorTestLabelHasInvalidUsernameErrorFromAPI:errorTextLabel], @"Valid username displaying an error from API!");
    STAssertTrue([self errorTestLabelHasInvalidPasswordErrorFromAPI:errorTextLabel], @"Invalid password not displaying an error from API!");
    
    //Test that only the password error view shows up
    [tester waitForViewWithAccessibilityLabel:VIAccessibilityPasswordErrorView];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:VIAccessibilityUsernameErrorView];
    
    //Test that the login button re-enables after API failure.
    STAssertTrue(((UIButton *)[tester waitForViewWithAccessibilityLabel:VIAccessibilityLoginButton]).enabled, @"Login button disabled after API failure!");
}

- (void)testValidCredentials
{
    [self loginWithUsername:VIValidLoginUserName andPassword:VIValidLoginPassword];

    //Test that the login button disables while logging in
    STAssertFalse(((UIButton *)[tester waitForViewWithAccessibilityLabel:VIAccessibilityLoginButton]).enabled, @"Login button enabled while logging in with API!");
    
    //Test that all error views are hidden
    [tester waitForAbsenceOfViewWithAccessibilityLabel:VIAccessibilityUsernameErrorView];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:VIAccessibilityPasswordErrorView];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:VIAccessibilityErrorTextLabel];
    
    //Test that the login button does not re-enable after API success.
    STAssertFalse(((UIButton *)[tester waitForViewWithAccessibilityLabel:VIAccessibilityLoginButton]).enabled, @"Login button disabled after API failure!");
}

@end
