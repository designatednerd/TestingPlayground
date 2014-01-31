//
//  VIFakeAPI.m
//  UITestingPlayground
//
//  Created by Ellen Shapiro (Vokal) on 1/31/14.
//  Copyright (c) 2014 Ellen Shapiro. All rights reserved.
//

#import "VIFakeAPI.h"

NSString * const VIValidLoginUserName = @"valid@username.com";
NSString * const VIValidLoginPassword = @"p@ssw0rd";
NSString * const VIFakeAPIErrorDoman = @"VIFakeAPIErrorDomain";

NSTimeInterval const VIResponseDelay = 2.0f;

@interface VIFakeAPI()
@property (nonatomic, copy) VIFakeAPICompletion completion;
@end

@implementation VIFakeAPI

#pragma mark - Public methods

- (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(VIFakeAPICompletion)completion
{
    self.completion = completion;
    if ([self isUsernameValid:username] //Valid username
        && [self isPasswordValid:password]) { //and valid password
        [self performSelector:@selector(loginSuccess) withObject:nil afterDelay:VIResponseDelay];
    } else if ([self isUsernameValid:username] //Valid username
               && ![self isPasswordValid:password]) { //and invalid password
        [self performSelector:@selector(loginFailure:) withObject:[self invalidPasswordError] afterDelay:VIResponseDelay];
    } else if ([self isPasswordValid:password] //Valid password
               && ![self isUsernameValid:username]) { //and invalid username
        [self performSelector:@selector(loginFailure:) withObject:[self invalidUsernameError] afterDelay:VIResponseDelay];
    } else if (![self isPasswordValid:password] //Invalid password
               && ![self isUsernameValid:username]) { //and invalid username
        NSString *bothFailures = [NSString stringWithFormat:@"%@\n%@", [self invalidUsernameError], [self invalidPasswordError]];
        [self performSelector:@selector(loginFailure:) withObject:bothFailures afterDelay:VIResponseDelay];
    } else {
        NSAssert(NO, @"Unexpected fall-through in %@: UN: %@ PW: %@", NSStringFromSelector(_cmd), username, password);
    }
}

- (void)networkFailureLoginWithUsername:(NSString *)username password:(NSString *)password completion:(VIFakeAPICompletion)completion
{
    self.completion = completion;
    
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

#pragma mark - Error strings
- (NSString *)invalidPasswordError
{
    return NSLocalizedString(@"Your password was incorrect, please try again", @"Incorrect password error message");
}

- (NSString *)invalidUsernameError
{
    return NSLocalizedString(@"Your username was incorrect, please try again", @"Incorrect username error");
}

- (NSString *)networkFailError
{
    return NSLocalizedString(@"Could not reach the server", @"Network failure error");
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
    self.completion(NO, [NSError errorWithDomain:VIFakeAPIErrorDoman code:0 userInfo:userInfo]);
    self.completion = nil;
}


@end
