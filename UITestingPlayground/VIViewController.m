//
//  VIViewController.m
//  UITestingPlayground
//
//  Created by Ellen Shapiro (Vokal) on 1/31/14.
//  Copyright (c) 2014 Ellen Shapiro. All rights reserved.
//

#import "VIViewController.h"

#import "VIFakeAPI.h"

NSString * const VIAccessibilityUsernameTextField = @"Username Text Field";
NSString * const VIAccessibilityPasswordTextField = @"Password Text Field";
NSString * const VIAccessibilityUsernameErrorView = @"Username Error View";
NSString * const VIAccessibilityPasswordErrorView = @"Password Error View";
NSString * const VIAccessibilityLoginButton = @"Login Button";
NSString * const VIAccessibilityErrorTextLabel = @"Error Text Label";

NSInteger const VIPasswordMinCharacters = 6;

@interface VIViewController () <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UIView *usernameErrorView;
@property (nonatomic, weak) IBOutlet UIView *passwordErrorView;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UILabel *errorTextLabel;

@property (nonatomic, strong) VIFakeAPI *fakeAPI;
@end

@implementation VIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.fakeAPI = [[VIFakeAPI alloc] init];
    [self setupAccessibility];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup
- (void)setupAccessibility
{
    self.usernameTextField.accessibilityLabel = VIAccessibilityUsernameTextField;
    self.usernameErrorView.accessibilityLabel = VIAccessibilityUsernameErrorView;
    self.passwordTextField.accessibilityLabel = VIAccessibilityPasswordTextField;
    self.passwordErrorView.accessibilityLabel = VIAccessibilityPasswordErrorView;
    self.loginButton.accessibilityLabel = VIAccessibilityLoginButton;
    self.errorTextLabel.accessibilityLabel = VIAccessibilityErrorTextLabel;
}

#pragma mark - IBActions
- (IBAction)login
{
    NSString *errorString = [self inputErrorString];
    if (!errorString) {
        self.errorTextLabel.hidden = YES;
        [self.loginButton setTitle:NSLocalizedString(@"Logging In...", @"Logging in") forState:UIControlStateNormal];
        self.loginButton.enabled = NO;
        self.loginButton.backgroundColor = [self.loginButton.backgroundColor colorWithAlphaComponent:0.5];
        [self.fakeAPI loginWithUsername:self.usernameTextField.text password:self.passwordTextField.text completion:^(BOOL success, NSError *error) {
            if (success) {
                [self loginSuccess];
            } else {
                [self loginFailedWithErrorDescription:error.localizedDescription];
            }
        }];
    } else {
        self.errorTextLabel.text = errorString;
        self.errorTextLabel.hidden = NO;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.usernameTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [self.view endEditing:YES];
    }
    
    return NO;
}

#pragma mark - Error handling
- (NSString *)inputErrorString
{
    NSMutableString *errorString = [NSMutableString string];
    NSString *usernameErrorString = [self usernameErrorString];
    if (usernameErrorString) {
        [errorString appendString:[self usernameErrorString]];
        [errorString appendString:@"\n"];
    }
    
    NSString *passwordErrorString = [self passwordErrorString];
    
    if (passwordErrorString) {
        [errorString appendString:passwordErrorString];

    }
    
    if (errorString.length > 0) {
        return errorString;
    } else {
        return nil;
    }
}

+ (NSString *)errorUsernameNotEmpty
{
    return NSLocalizedString(@"Username must not be empty.", @"Username must not be empty");
}

+ (NSString *)errorUsernameMustBeEmail
{
    return NSLocalizedString(@"Username must be an email address.", @"Username must be an email address");
}

- (NSString *)usernameErrorString
{
    NSMutableString *errorString = [NSMutableString string];
    NSString *username = self.usernameTextField.text;
    
    if (username.length == 0) {
        [errorString appendString:[VIViewController errorUsernameNotEmpty]];
    }
    
    //This should normally be some sort of regex.
    NSRange atRange = [username rangeOfString:@"@"];
    if (atRange.location == NSNotFound) {
        if (errorString.length > 0) {
            [errorString appendString:@"\n"];
        }
        [errorString appendString:[VIViewController errorUsernameMustBeEmail]];
    }
    
    if (errorString.length > 0) {
        self.usernameErrorView.hidden = NO;
        return errorString;
    } else {
        self.usernameErrorView.hidden = YES;
        return nil;
    }
}

+ (NSString *)errorPasswordTooShort
{
    return [NSString stringWithFormat:NSLocalizedString(@"Password must be at least %d characters.", @"Password length request"), VIPasswordMinCharacters];
}

- (NSString *)passwordErrorString
{
    NSMutableString *errorString = [NSMutableString string];

    NSString *password = self.passwordTextField.text;
    if (password.length < VIPasswordMinCharacters) {
        [errorString appendString:[VIViewController errorPasswordTooShort]];
    }

    if (errorString.length > 0) {
        self.passwordErrorView.hidden = NO;
        return errorString;
    } else {
        self.passwordErrorView.hidden = YES;
        return nil;
    }
}

#pragma mark - Login handling
- (void)loginSuccess
{
    self.passwordErrorView.hidden = YES;
    self.usernameErrorView.hidden = YES;
    self.errorTextLabel.hidden = YES;
    [self.loginButton setTitle:@"Success!" forState:UIControlStateNormal];
    
    //Reset for testing
    [self performSelector:@selector(resetLoginButton) withObject:nil afterDelay:3];
}

- (void)resetLoginButton
{
    self.loginButton.enabled = YES;
    self.loginButton.backgroundColor = [self.loginButton.backgroundColor colorWithAlphaComponent:1];
    [self.loginButton setTitle:NSLocalizedString(@"GO!", @"login text") forState:UIControlStateNormal];
}

- (void)loginFailedWithErrorDescription:(NSString *)localizedDescription
{
    self.errorTextLabel.hidden = NO;
    if (localizedDescription) {
        self.errorTextLabel.text = localizedDescription;
        
        NSRange usernameRange = [localizedDescription rangeOfString:[VIFakeAPI invalidUsernameError]];
        if (usernameRange.location != NSNotFound) {
            self.usernameErrorView.hidden = NO;
        } else {
            self.usernameErrorView.hidden = YES;
        }
        
        NSRange passwordRange = [localizedDescription rangeOfString:[VIFakeAPI invalidPasswordError]];
        if (passwordRange.location != NSNotFound) {
            self.passwordErrorView.hidden = NO;
        } else {
            self.passwordErrorView.hidden = YES;
        }
    }
    
    [self resetLoginButton];
}

@end
