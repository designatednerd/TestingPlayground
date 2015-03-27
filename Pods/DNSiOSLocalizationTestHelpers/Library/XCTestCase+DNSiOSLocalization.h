//
//  XCTestCase+DNSiOSLocalization.h
//  XCTestLocalization
//
//  Created by Ellen Shapiro on 3/21/15.
//  Copyright (c) 2015 Designated Nerd Software. All rights reserved.
//

#import <XCTest/XCTest.h>

/**
 * Helpful category methods on XCTest for testing localization of strings.
 */
@interface XCTestCase (DNSiOSLocalization)

/**
 * Checks to make sure the sim or device is running in the language you've passed in using the build scheme.
 *
 * This test assumes you have added -AppleLanguages and ([two-letter language code]) as
 * the first two arguments in your build scheme's Test Arguments Passed On Launch to force
 * the sim to launch in a specific language.
 *
 * Further details about this technique: https://coderwall.com/p/te63dg
 * @return An error string describing the error found, or nil if everyting was fine.
 */
- (NSString *)dns_checkSimOrDeviceIsRunningPassedInLanguage;

/**
 * Checks to make sure that all keys are localized in the current language, with the given developer
 * language code. If the sim's current language is the developer language, this test does nothing.
 *
 * @param developerLanguageCode - The two-letter code for your language. For example, en for English. Pass in nil to use the Base localization. 
 * @param knownIdenticalValues - An array of strings which are known to have identical values in the base or passed-in localization
 * @return An array of error strings describing any errors found, or nil if everything was fine.
 */
- (NSArray *)dns_checkAllKeysInLocalizableStringsAreLocalizedWithDeveloperLanguageCode:(NSString *)developerLanguageCode                                          knownIdenticalValues:(NSArray *)knownIdenticalValues;

/**
 * @return the two-letter code of the current device or simulator.
 */
- (NSString *)dns_currentDeviceOrSimLanguage;

/**
 * @return True if the value is localized, false if it is not.
 */
- (BOOL)dns_isInfoPlistKeyValueLocalized:(NSString *)infoPlistKey;

@end
 