//
//  VIFakeAPI.h
//  UITestingPlayground
//
//  Created by Ellen Shapiro (Vokal) on 1/31/14.
//  Copyright (c) 2014 Ellen Shapiro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

typedef void (^VIFakeAPICompletion)(BOOL success, NSError *error);

FOUNDATION_EXPORT NSString * const VIValidLoginUserName;
FOUNDATION_EXPORT NSString * const VIValidLoginPassword;

@interface VIFakeAPI : NSObject

///Exposed so reachability can be mocked by tests. 
@property (nonatomic) Reachability *reachability;

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
               completion:(VIFakeAPICompletion)completion;

- (void)fakeAPITimeoutLoginWithUsername:(NSString *)username
                               password:(NSString *)password
                             completion:(VIFakeAPICompletion)completion;

@end
