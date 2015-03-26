//
//  VIFakeAPI.m
//  UITestingPlayground
//
//  Created by Ellen Shapiro (Vokal) on 1/31/14.
//  Copyright (c) 2014 Ellen Shapiro. All rights reserved.
//

#import "VIFakeAPI.h"

#import "VILocalizedStrings.h"

NSString * const VIValidLoginUserName = @"valid@username.com";
NSString * const VIValidLoginPassword = @"p@ssw0rd";
NSString * const VIFakeAPIErrorDoman = @"VIFakeAPIErrorDomain";

NSTimeInterval const VIResponseDelay = 1.5f;

@interface VIFakeAPI()
@property (nonatomic, copy) VIFakeAPICompletion completion;
@end

@implementation VIFakeAPI

- (instancetype)init
{
    if (self = [super init]) {
        _reachability = [Reachability reachabilityForInternetConnection];
    }
    
    return self;
}

#pragma mark - Public methods

- (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(VIFakeAPICompletion)completion
{
    self.completion = completion;

    if (![self.reachability isReachable]) {
        //We cannot has internets! Bail out!
        [self loginFailure:[VILocalizedStrings errorNoInternet]];
        return;
    }
    
    if ([self isUsernameValid:username] //Valid username
        && [self isPasswordValid:password]) { //and valid password
        [self performSelector:@selector(loginSuccess)
                   withObject:nil
                   afterDelay:VIResponseDelay];
    } else if ([self isUsernameValid:username] //Valid username
               && ![self isPasswordValid:password]) { //and invalid password
        [self performSelector:@selector(loginFailure:)
                   withObject:[VILocalizedStrings errorWrongPassword]
                   afterDelay:VIResponseDelay];
    } else if ([self isPasswordValid:password] //Valid password
               && ![self isUsernameValid:username]) { //and invalid username
        [self performSelector:@selector(loginFailure:)
                   withObject:[VILocalizedStrings errorInvalidUsername]
                   afterDelay:VIResponseDelay];
    } else if (![self isPasswordValid:password] //Invalid password
               && ![self isUsernameValid:username]) { //and invalid username
        NSString *bothFailures = [NSString stringWithFormat:@"%@\n%@",
                                  [VILocalizedStrings errorInvalidUsername],
                                  [VILocalizedStrings errorWrongPassword]];
        [self performSelector:@selector(loginFailure:)
                   withObject:bothFailures
                   afterDelay:VIResponseDelay];
    } else {
        NSAssert(NO, @"Unexpected fall-through in %@: UN: %@ PW: %@", NSStringFromSelector(_cmd), username, password);
    }
}

- (void)networkFailureLoginWithUsername:(NSString *)username password:(NSString *)password completion:(VIFakeAPICompletion)completion
{
    self.completion = completion;
    [self performSelector:@selector(loginFailure:)
               withObject:[VILocalizedStrings errorNetworkFail]
               afterDelay:VIResponseDelay * 3];
}

#pragma mark - Validation
- (BOOL)isUsernameValid:(NSString *)username
{
    return [username isEqualToString:VIValidLoginUserName];
}

- (BOOL)isPasswordValid:(NSString *)password
{
    return [password isEqualToString:VIValidLoginPassword];
}

#pragma mark - Success/failure calls
- (void)loginSuccess
{
    self.completion(YES, nil);
    self.completion = nil;
}

- (void)loginFailure:(NSString *)localizedDescription
{
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : localizedDescription };
    self.completion(NO, [NSError errorWithDomain:VIFakeAPIErrorDoman
                                            code:0
                                        userInfo:userInfo]);
    self.completion = nil;
}


@end
