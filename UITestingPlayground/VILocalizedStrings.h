//
//  VILocalizedStrings.h
//  UITestingPlayground
//
//  Created by Ellen Shapiro on 3/21/15.
//  Copyright (c) 2015 Ellen Shapiro. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A class to centralize use and access of localized strings. 
 */
@interface VILocalizedStrings : NSObject

#pragma mark - Login Screen
#pragma mark Labels
+ (NSString *)loginScreenTitle;

#pragma mark Placeholders
+ (NSString *)loginUsernamePlaceholder;
+ (NSString *)loginPasswordPlaceholder;

#pragma mark Buttons
+ (NSString *)loginGoText;
+ (NSString *)loggingInText;
+ (NSString *)loginSuccessText;

#pragma mark Errors
+ (NSString *)errorUsernameNotEmpty;
+ (NSString *)errorUsernameMustBeEmail;
+ (NSString *)errorPasswordTooShort:(NSInteger)minimumCharacters;
+ (NSString *)errorWrongPassword;
+ (NSString *)errorNetworkFail;
+ (NSString *)errorInvalidUsername;
+ (NSString *)errorNoInternet;

@end
