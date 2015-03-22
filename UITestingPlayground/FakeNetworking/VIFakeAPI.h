//
//  VIFakeAPI.h
//  UITestingPlayground
//
//  Created by Ellen Shapiro (Vokal) on 1/31/14.
//  Copyright (c) 2014 Ellen Shapiro. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^VIFakeAPICompletion)(BOOL success, NSError *error);

FOUNDATION_EXPORT NSString * const VIValidLoginUserName;
FOUNDATION_EXPORT NSString * const VIValidLoginPassword;

@interface VIFakeAPI : NSObject

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
               completion:(VIFakeAPICompletion)completion;

- (void)networkFailureLoginWithUsername:(NSString *)username
                               password:(NSString *)password
                             completion:(VIFakeAPICompletion)completion;

@end
