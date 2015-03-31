//
//  main.m
//  UITestingPlayground
//
//  Created by Ellen Shapiro (Vokal) on 1/31/14.
//  Copyright (c) 2014 Ellen Shapiro. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VIAppDelegate.h"
#import "VITestingApplicationDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        BOOL isRunningTests = (NSClassFromString(@"XCTestCase") != Nil);
        BOOL isRunningUITests = (NSClassFromString(@"KIFTestCase") != Nil);
        
        Class appDelegateClass = [VIAppDelegate class];
        if (isRunningTests && !isRunningUITests) { //We still want the normal app delegate for UI tests. 
            appDelegateClass = [VITestingApplicationDelegate class];
        }
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass(appDelegateClass));
    }
}
