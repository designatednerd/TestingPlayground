//
//  VIAccessibilityStrings.h
//  UITestingPlayground
//
//  Created by Ellen Shapiro on 3/21/15.
//  Copyright (c) 2015 Ellen Shapiro. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A class to centralize accessibility strings that are not displayed to most users,
 * but which will be read aloud to visually imparied users in addition to being used 
 * by KIF for UI Tests. 
 */
@interface VIAccessibilityStrings : NSObject

+ (NSString *)usernameTextField;
+ (NSString *)passwordTextField;
+ (NSString *)usernameErrorView;
+ (NSString *)passwordErrorView;
+ (NSString *)errorTextLabel;

@end
