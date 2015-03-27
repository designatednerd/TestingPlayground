//
//  XCTestCase+DNSiOSLocalization.m
//  XCTestLocalization
//
//  Created by Ellen Shapiro on 3/21/15.
//  Copyright (c) 2015 Designated Nerd Software. All rights reserved.
//

#import "XCTestCase+DNSiOSLocalization.h"

static NSString * const BASE_LOCALIZATION_NAME = @"Base";

@implementation XCTestCase (DNSiOSLocalization)

- (NSBundle *)dns_bundleForLanguage:(NSString *)language
{
    NSString *languageBundePath = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    if (!languageBundePath) {
        NSString *devLanguage = [[NSBundle mainBundle] objectForInfoDictionaryKey:(__bridge NSString *)kCFBundleDevelopmentRegionKey];
        if ([language isEqualToString:devLanguage]) {
            //Grab the base localization
            languageBundePath = [[NSBundle mainBundle] pathForResource:BASE_LOCALIZATION_NAME ofType:@"lproj"];
        }
    }

    return [NSBundle bundleWithPath:languageBundePath];
}

- (NSBundle *)dns_bundleForCurrentLanguage
{
    NSString *language = [self dns_currentDeviceOrSimLanguage];
    NSBundle *languageBundle = [self dns_bundleForLanguage:language];
    XCTAssertNotNil(languageBundle, @"Bundle nil for current locale %@!", language);
    return languageBundle;
}

- (NSString *)dns_localizedStringPathForLanguage:(NSString *)language
{
    return [[NSBundle mainBundle] pathForResource:@"Localizable"
                                           ofType:@"strings"
                                      inDirectory:nil
                                  forLocalization:language];
}

- (BOOL)dns_areWeInTheDeveloperLanguage:(NSString *)developerLanguageCode
{
    NSString *currentLanguage = [self dns_currentDeviceOrSimLanguage];
    if (developerLanguageCode) {
        return [developerLanguageCode isEqualToString:currentLanguage];
    } else {
        NSString *baseLanguage = [[NSBundle mainBundle] objectForInfoDictionaryKey:(__bridge NSString *)kCFBundleDevelopmentRegionKey];
        if (baseLanguage) {
            return [baseLanguage isEqualToString:currentLanguage];
        }
    }

    return NO;
}

- (NSString *)dns_checkCurrentLocaleStringForKey:(NSString *)key
                 withDeveloperLanguageCode:(NSString *)developerLanguageCode
                      knownIdenticalValues:(NSArray *)knownIdenticalValues
{
    if (![self dns_areWeInTheDeveloperLanguage:developerLanguageCode]) {
        //Inspired by http://learning-ios.blogspot.com/2011/04/advance-localization-in-ios-apps.html
        NSBundle *currentLanguageBundle = [self dns_bundleForCurrentLanguage];
        if (!currentLanguageBundle) {
            return [NSString stringWithFormat:@"Language bundle for current language %@ was nil!", [self dns_currentDeviceOrSimLanguage]];
        }
        
        NSBundle *developerLanguageBundle;
        
        if (!developerLanguageCode) {
            //Try the base localization
            developerLanguageBundle = [self dns_bundleForLanguage:BASE_LOCALIZATION_NAME];
            if (!developerLanguageBundle) {
                return @"Language bundle for Base localization is nil! Please pass in a language or check your base localization.";
            }
        } else {
            //Use the passed-in developer language
            developerLanguageBundle = [self dns_bundleForLanguage:developerLanguageCode];
            if (!developerLanguageBundle) {
                return [NSString stringWithFormat:@"Language bundle for developer language %@ is nil", developerLanguageCode];
            }
        }
        
        NSString *currentLanguageStringForKey = [currentLanguageBundle localizedStringForKey:key
                                                                                       value:@""
                                                                                       table:nil];
        
        NSString *developerLanguageStringForKey = [developerLanguageBundle localizedStringForKey:key
                                                                                           value:@""
                                                                                           table:nil];
        
        if ([currentLanguageStringForKey isEqualToString:developerLanguageStringForKey]) {
            if (![knownIdenticalValues containsObject:currentLanguageStringForKey]) {
                return [NSString stringWithFormat:@"Key %@ returning the developer language rather than a localized string - check the translation!", key];
            }
        }
    }
    
    //If we got here, we're good.
    return nil;
}

- (NSString *)dns_currentDeviceOrSimLanguage
{
    return [[NSLocale preferredLanguages] objectAtIndex:0];
}

/**
 * This test assumes you have added -AppleLanguages and ([two-letter language code]) as
 * the first two arguments in your build scheme's Test Arguments Passed On Launch to force
 * the sim to launch in a specific language.
 * Further details about this technique: https://coderwall.com/p/te63dg
 */
- (NSString *)dns_checkSimOrDeviceIsRunningPassedInLanguage
{
    //Get the arguments passed from the scheme
    NSArray *arguments = [[NSProcessInfo processInfo] arguments];
    NSString *expectedLanguageArgument = arguments[2];
    
    //Should be 4 characters including parens
    if (expectedLanguageArgument.length != 4) {
        return [NSString stringWithFormat:@"Double Check Your Language argument. Position 2 returning %@", expectedLanguageArgument];
    }
    
    //Strip the parentheses
    NSString *argumentNoParens = [expectedLanguageArgument stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()"]];
    
    //should be 2 characters stripped of parens
    if (argumentNoParens.length != 2) {
        return [NSString stringWithFormat:@"Double check your language argument. Position 2 stripped of parentheses returing %@", argumentNoParens];
    }
    
    NSString *deviceOrSimLanguage = [self dns_currentDeviceOrSimLanguage];
    //OK, is this actually the requested language?
    XCTAssertTrue([deviceOrSimLanguage isEqualToString:argumentNoParens],
                  @"Sim language %@ not expected language %@!", deviceOrSimLanguage, argumentNoParens);
    
    return nil;
}

- (NSArray *)dns_checkAllKeysInLocalizableStringsAreLocalizedWithDeveloperLanguageCode:(NSString *)developerLanguageCode
                                              knownIdenticalValues:(NSArray *)knownIdenticalValues
{
    NSString *devLanguagePath;
    
    if (developerLanguageCode) {
        devLanguagePath = [self dns_localizedStringPathForLanguage:developerLanguageCode];
    } else {
        devLanguagePath = [self dns_localizedStringPathForLanguage:BASE_LOCALIZATION_NAME];
    }
    
    //Localizable.strings files compile down to a .plist, so you can bring it in as a dict.
    NSDictionary *devLanguageDict = [NSDictionary dictionaryWithContentsOfFile:devLanguagePath];
    
    if (!devLanguagePath) {
        return @[@"Could not load dev language dictionary!"];
    }
    
    NSMutableArray *errorStrings = [NSMutableArray array];
    //Go through all the keys and make sure that you have a localization
    [devLanguageDict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        NSString *errorString = [self dns_checkCurrentLocaleStringForKey:key
                                               withDeveloperLanguageCode:developerLanguageCode
                                                    knownIdenticalValues:knownIdenticalValues];
        if (errorString) {
            [errorStrings addObject:errorString];
        }
    }];
    
    if (errorStrings.count == 0) {
        //No errors were found - return nil.
        return nil;
    } else {
        //Return the errors which were found.
        return errorStrings;
    }
}

- (NSString *)dns_currentLocaleStringForInfoPlistKey:(NSString *)infoPlistKey
{
    NSBundle *localeBundle = [self dns_bundleForCurrentLanguage];
    return [localeBundle localizedStringForKey:infoPlistKey
                                         value:@""
                                         table:@"InfoPlist"];
}

- (BOOL)dns_isInfoPlistKeyValueLocalized:(NSString *)infoPlistKey
{
    NSString *plistValue = [[NSBundle mainBundle] objectForInfoDictionaryKey:infoPlistKey];
    NSString *plistValueForCurrentLocale = [self dns_currentLocaleStringForInfoPlistKey:infoPlistKey];
    return [plistValue isEqualToString:plistValueForCurrentLocale];
}


@end
