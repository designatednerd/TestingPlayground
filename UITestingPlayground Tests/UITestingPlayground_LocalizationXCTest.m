//
//  UITestingPlayground_LocalizationXCTest.m
//  UITestingPlayground
//
//  Created by Ellen Shapiro (Vokal) on 2/27/14.
//  Copyright (c) 2014 Ellen Shapiro. All rights reserved.
//

#import <XCTest/XCTest.h>

static NSString * const DEVELOPER_LANGUAGE = @"en";

@interface UITestingPlayground_LocalizationXCTest : XCTestCase

@end

@implementation UITestingPlayground_LocalizationXCTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (NSBundle *)bundleForLanguage:(NSString *)language
{
    NSString *languageBundePath = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    return [NSBundle bundleWithPath:languageBundePath];
}

- (NSBundle *)bundleForCurrentLocale
{
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSBundle *localeBundle = [self bundleForLanguage:language];
    XCTAssertNotNil(localeBundle, @"Bundle nil for current locale %@!", language);
    return localeBundle;
}


/**
 * This test assumes you have added -AppleLanguages and ([two-letter language code]) 
 * to your build scheme's Test Arguments Passed On Launch to force the sim to launch in a
 * specific language.
 * Further details about this technique: https://coderwall.com/p/te63dg
 */
- (void)testSimIsRunningExpectedLanguage
{
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    //Get the arguments passed from the scheme
    NSArray *arguments = [[NSProcessInfo processInfo] arguments];
    NSString *expectedLanguageArgument = arguments[2];
    
    //Should be 4 characters including parens
    XCTAssertEqual(expectedLanguageArgument.length, (NSUInteger)4, @"Double Check Your Language argument. Position 2 returning %@", expectedLanguageArgument);
    
    //Strip the parentheses
    NSString *argumentNoParens = [expectedLanguageArgument stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()"]];
    
    //should be 2 characters stripped of parens
    XCTAssertEqual(argumentNoParens.length, (NSUInteger)2, @"Double check your language argument. Position 2 stripped of parentheses returing %@", argumentNoParens);
    
    //OK, is this actually the requested language?
    XCTAssertTrue([language isEqualToString:argumentNoParens], @"Sim language %@ not expected language %@!", language, argumentNoParens);
}

//Added underscore to prevent test from being called directly by the testing framework.
- (NSString *)_testCurrentLocaleStringForKey:(NSString *)key
{
    //Ganked from http://learning-ios.blogspot.com/2011/04/advance-localization-in-ios-apps.html
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSBundle *languageBundle = [self bundleForLanguage:language];
    XCTAssertNotNil(languageBundle, @"Language bundle for %@ was nil!", language);
    
    NSString *currentLocaleStringForKey = [languageBundle localizedStringForKey:key value:@"" table:nil];
    
    if (![language isEqualToString:DEVELOPER_LANGUAGE]) {
        XCTAssertFalse([currentLocaleStringForKey isEqualToString:key], @"Key %@ returning itself rather than a localized string - check the translation !", key);
    }

    return currentLocaleStringForKey;
}

- (void)testAllKeysAreLocalized
{
    NSString *devLanguagePath = [[NSBundle mainBundle] pathForResource:@"Localizable"ofType:@"strings" inDirectory:nil forLocalization:DEVELOPER_LANGUAGE];
    
    //Localizable.strings files compile down to a .plist, so you can bring it in as a dict.
    NSDictionary *devLanguageDict = [NSDictionary dictionaryWithContentsOfFile:devLanguagePath];
    
    //Go through all the keys and make sure that you have a localization
    [devLanguageDict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        [self _testCurrentLocaleStringForKey:key];
    }];
}

- (NSString *)currentLocaleStringForInfoPlistKey:(NSString *)infoPlistKey
{
    NSBundle *localeBundle = [self bundleForCurrentLocale];
    NSString *currentLocaleStringForInfoPlistKey = [localeBundle localizedStringForKey:infoPlistKey value:@"" table:@"InfoPlist"];
    
    XCTAssertNotNil(currentLocaleStringForInfoPlistKey, @"Localized string not found in InfoPlist.strings for key %@", infoPlistKey);
    
    return currentLocaleStringForInfoPlistKey;
}

- (void)testDisplayNameLocalized
{
    NSString *bundleDisplayName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    
    NSString *bundleDisplayForCurrentLocale = [self currentLocaleStringForInfoPlistKey:@"CFBundleDisplayName"];
    
    XCTAssertTrue([bundleDisplayName isEqualToString:bundleDisplayForCurrentLocale], @"Bundle display name is not localized!");
}

@end
