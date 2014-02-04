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
- (NSString *)currentLocaleStringForInfoPlistKey:(NSString *)infoPlistKey
{
    NSString *currentLocaleStringForInfoPlistKey = [self.localeBundle localizedStringForKey:infoPlistKey value:@"" table:@"InfoPlist"];
    
    STAssertNotNil(currentLocaleStringForInfoPlistKey, @"Localized string not found in InfoPlist.strings for key %@", infoPlistKey);
    
    return currentLocaleStringForInfoPlistKey;
}

- (NSString *)currentLocaleStringForKey:(NSString *)key
{
    //Ganked from http://learning-ios.blogspot.com/2011/04/advance-localization-in-ios-apps.html
    NSString *currentLocaleStringForKey = [self.localeBundle localizedStringForKey:key value:@"" table:nil];
    STAssertNotNil(currentLocaleStringForKey, @"Localized string not found in Localizable.strings for key %@", key);
    
    return currentLocaleStringForKey;    
}


- (void)testDisplayNameLocalized
{
    NSString *bundleDisplayName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    
    NSString *bundleDisplayForCurrentLocale = [self currentLocaleStringForInfoPlistKey:@"CFBundleDisplayName"];
    
    STAssertTrue([bundleDisplayName isEqualToString:bundleDisplayForCurrentLocale], @"Bundle display name is not localized!");
}

- (void)testLoginButtonLocalized
{
    UIView *buttonView = [tester waitForViewWithAccessibilityLabel:VIAccessibilityLoginButton];
    STAssertTrue([buttonView isKindOfClass:[UIButton class]], @"Retrieved class is not a button!");
    
    UIButton *button = (UIButton *)buttonView;
    NSString *localizedLoginGo = [self currentLocaleStringForKey:VI_LOGIN_GO_TEXT];
    STAssertTrue([button.titleLabel.text isEqualToString:localizedLoginGo], @"Login button text not localized for %@!", self.locale);
}

@end
