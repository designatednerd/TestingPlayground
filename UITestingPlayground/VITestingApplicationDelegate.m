//
//  VITestingApplicationDelegate.m
//  UITestingPlayground
//
//  Created by Ellen Shapiro (Vokal) on 3/26/15.
//  Copyright (c) 2015 Ellen Shapiro. All rights reserved.
//

#import "VITestingApplicationDelegate.h"

@implementation VITestingApplicationDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIViewController *testViewController = [[UIViewController alloc] init];
    testViewController.view.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    
    UILabel *testLabel = [[UILabel alloc] init];
    testLabel.translatesAutoresizingMaskIntoConstraints = NO;
    testLabel.text = @"TESTING WITHOUT UI!";
    [testViewController.view addSubview:testLabel];
    [testViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:testLabel
                                                                       attribute:NSLayoutAttributeCenterX
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:testViewController.view
                                                                       attribute:NSLayoutAttributeCenterX
                                                                      multiplier:1
                                                                        constant:0]];
    
    [testViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:testLabel
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:testViewController.view
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1
                                                                         constant:0]];
    
    self.window = [[UIWindow alloc] init];
    self.window.rootViewController = testViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
