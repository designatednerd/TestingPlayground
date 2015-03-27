//
//  VILocalizedStrings.m
//  UITestingPlayground
//
//  Created by Ellen Shapiro on 3/21/15.
//  Copyright (c) 2015 Ellen Shapiro. All rights reserved.
//

#import "VILocalizedStrings.h"

@implementation VILocalizedStrings

#pragma mark - Login Screen

#pragma mark Labels

+ (NSString *)loginScreenTitle
{
    return NSLocalizedString(@"Login", @"Login Title");
}

#pragma mark Placeholders

+ (NSString *)loginUsernamePlaceholder
{
    return NSLocalizedString(@"Username", @"Username Placeholder");
}

+ (NSString *)loginPasswordPlaceholder
{
    return NSLocalizedString(@"Password", @"Password Placeholder");
}

#pragma mark Buttons

+ (NSString *)loginGoText
{
    return NSLocalizedString(@"GO!", @"login text");
}

+ (NSString *)loggingInText
{
    return NSLocalizedString(@"logging_in_ellipsis", @"Logging in");
}

+ (NSString *)loginSuccessText
{
    return NSLocalizedString(@"Success!", @"Successful Login");
}

#pragma mark Errors 

+ (NSString *)errorUsernameNotEmpty
{
    return NSLocalizedString(@"Username must not be empty.", @"Username must not be empty");
}

+ (NSString *)errorUsernameMustBeEmail
{
    return NSLocalizedString(@"Username must be an email address.", @"Username must be an email address");
}

+ (NSString *)errorPasswordTooShort:(NSInteger)minimumCharacters
{
    return [NSString stringWithFormat:NSLocalizedString(@"Password must be at least %@ characters.", @"Password length too short (must have a %@ placeholder)"), @(minimumCharacters)];
}

+ (NSString *)errorWrongPassword
{
    return NSLocalizedString(@"Your password was incorrect, please try again", @"Incorrect password error message");
}

+ (NSString *)errorInvalidUsername
{
    return NSLocalizedString(@"Your username was incorrect, please try again", @"Incorrect username error");
}

+ (NSString *)errorNetworkFail
{
    return NSLocalizedString(@"Could not reach the server", @"Network failure error");
}

+ (NSString *)errorNoInternet
{
    return NSLocalizedString(@"You are not connected to the internet. Please reconnect and try again.", @"No Internet error");
}

@end
