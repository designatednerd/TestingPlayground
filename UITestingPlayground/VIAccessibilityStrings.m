//
//  VIAccessibilityStrings.m
//  UITestingPlayground
//
//  Created by Ellen Shapiro on 3/21/15.
//  Copyright (c) 2015 Ellen Shapiro. All rights reserved.
//

#import "VIAccessibilityStrings.h"

@implementation VIAccessibilityStrings

+ (NSString *)usernameTextField
{
    return NSLocalizedString(@"Username Text Field", @"Username text field accessibility label");
}

+ (NSString *)passwordTextField
{
    return NSLocalizedString(@"Password Text Field", @"Password text field accessibility label");
}

+ (NSString *)usernameErrorView
{
    return NSLocalizedString(@"Username Error View", @"Username error view accessibility label");
}

+ (NSString *)passwordErrorView
{
    return NSLocalizedString(@"Password Error View", @"Password error view accessibility label");
}

+ (NSString *)errorTextLabel
{
    return NSLocalizedString(@"Error Text Label", @"Error text label accessibility label");
}

@end
