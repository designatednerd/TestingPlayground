//
//  VIViewController.h
//  UITestingPlayground
//
//  Created by Ellen Shapiro (Vokal) on 1/31/14.
//  Copyright (c) 2014 Ellen Shapiro. All rights reserved.
//

#import <UIKit/UIKit.h>

//Exposed externally for UI testing
FOUNDATION_EXPORT NSString * const VIAccessibilityUsernameTextField;
FOUNDATION_EXPORT NSString * const VIAccessibilityPasswordTextField;
FOUNDATION_EXPORT NSString * const VIAccessibilityUsernameErrorView;
FOUNDATION_EXPORT NSString * const VIAccessibilityPasswordErrorView;
FOUNDATION_EXPORT NSString * const VIAccessibilityLoginButton;
FOUNDATION_EXPORT NSString * const VIAccessibilityErrorTextLabel;


@interface VIViewController : UIViewController


//For unit testing
+ (NSString *)errorUsernameNotEmpty;
+ (NSString *)errorUsernameMustBeEmail;
+ (NSString *)errorPasswordTooShort;

@end
