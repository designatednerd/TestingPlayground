//
//  UITestingPlaygroundTests_Localization.m
//  UITestingPlayground
//
//  Created by Ellen Shapiro (Vokal) on 2/4/14.
//  Copyright (c) 2014 Ellen Shapiro. All rights reserved.
//

#import <KIF/KIF.h>

#import "VILocalizedStringKeys.h"
#import "VIViewController.h"

@interface UITestingPlaygroundTests_Localization : KIFTestCase
@property (nonatomic, strong) NSBundle *localeBundle;
@property (nonatomic, strong) NSString *locale;
@end

@implementation UITestingPlaygroundTests_Localization

-(void)beforeEach
{
    [super beforeEach];
    
    self.locale = [NSLocale preferredLanguages][0];
    NSString *localeBundePath = [[NSBundle mainBundle] pathForResource:self.locale ofType:@"lproj"];
    
    self.localeBundle = [NSBundle bundleWithPath:localeBundePath];
}

- (void)afterEach
{
    [super afterEach];
}

#pragma mark - Getting specific localized strings

- (NSString *)currentLocaleStringForKey:(NSString *)key
{
    //Ganked from http://learning-ios.blogspot.com/2011/04/advance-localization-in-ios-apps.html
    NSString *currentLocaleStringForKey = [self.localeBundle localizedStringForKey:key value:@"" table:nil];
    XCTAssertNotNil(currentLocaleStringForKey, @"Localized string not found in Localizable.strings for key %@", key);
    
    return currentLocaleStringForKey;    
}

- (void)testLoginButtonLocalized
{
    UIView *buttonView = [tester waitForViewWithAccessibilityLabel:VIAccessibilityLoginButton];
    XCTAssertTrue([buttonView isKindOfClass:[UIButton class]], @"Retrieved class is not a button!");
    
    UIButton *button = (UIButton *)buttonView;
    NSString *localizedLoginGo = [self currentLocaleStringForKey:VI_LOGIN_GO_TEXT];
    XCTAssertTrue([button.titleLabel.text isEqualToString:localizedLoginGo], @"Login button text not localized for %@!", self.locale);
}

- (UITextField *)textFieldForAccessibilityLabel:(NSString *)accessibilityLabel
{
    UIView *textFieldView = [tester waitForViewWithAccessibilityLabel:accessibilityLabel];
    XCTAssertTrue([textFieldView isKindOfClass:[UITextField class]], @"Retrieved class is not a text field!");
    
   return (UITextField *)textFieldView;
}

- (void)testPasswordPlaceholderLocalized
{
    UITextField *textField = [self textFieldForAccessibilityLabel:VIAccessibilityPasswordTextField];
    NSString *localizedPasswordPlaceholder = [self currentLocaleStringForKey:VI_LOGIN_PASSWORD_PLACEHOLDER];
    XCTAssertTrue([textField.placeholder isEqualToString:localizedPasswordPlaceholder], @"Login password placeholder not localized for %@!", self.locale);
}

- (void)testUsernamePlaceholderLocalized
{
    UITextField *textField = [self textFieldForAccessibilityLabel:VIAccessibilityUsernameTextField];
    NSString *localizedUsernamePlaceholder = [self currentLocaleStringForKey:VI_LOGIN_USERNAME_PLACEHOLDER];
    XCTAssertTrue([textField.placeholder isEqualToString:localizedUsernamePlaceholder], @"Login username placeholder not localized for %@!", self.locale);
}

- (void)testLoginTitleLocalized
{
    UIView *labelView = [tester waitForViewWithAccessibilityLabel:VIAccessibilityLoginTitleLabel];
    XCTAssertTrue([labelView isKindOfClass:[UILabel class]], @"Requested field is not a label!");
    
    UILabel *label = (UILabel *)labelView;
    NSString *localizedLoginTitle = [self currentLocaleStringForKey:VI_LOGIN_TITLE];
    XCTAssertTrue([label.text isEqualToString:localizedLoginTitle], @"Login title not localized for %@!", self.locale);
}

@end
