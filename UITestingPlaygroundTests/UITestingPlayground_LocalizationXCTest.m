//
//  UITestingPlayground_LocalizationXCTest.m
//  UITestingPlayground
//
//  Created by Ellen Shapiro (Vokal) on 2/27/14.
//  Copyright (c) 2014 Ellen Shapiro. All rights reserved.
//

#import "XCTestCase+DNSiOSLocalization.h"

static NSString * const DEVELOPER_LANGUAGE = @"en";

@interface UITestingPlayground_LocalizationXCTest : XCTestCase

@end

@implementation UITestingPlayground_LocalizationXCTest

- (void)setUp
{
    [super setUp];
    
    NSString *errorString = [self dns_checkSimOrDeviceIsRunningPassedInLanguage];
    XCTAssertNil(errorString, @"Error with sim language: %@", errorString);
}

- (void)testAllKeysAreLocalized
{
    NSArray *errorStrings = [self dns_checkAllKeysInLocalizableStringsAreLocalizedWithDeveloperLanguageCode:DEVELOPER_LANGUAGE                                                                                       knownIdenticalValues:nil];
    XCTAssertNil(errorStrings, @"Errors with localization: %@", errorStrings);
}

- (void)testDisplayNameLocalized
{
    XCTAssertTrue([self dns_isInfoPlistKeyValueLocalized:@"CFBundleDisplayName"], @"Bundle display name is not localized!");
}

@end
