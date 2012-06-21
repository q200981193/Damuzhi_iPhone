//
//  UserManager.m
//  Travel
//
//  Created by  on 12-3-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserManager.h"

#define KEY_USER_ID   @"KEY_USER_ID"

@interface UserManager ()

@property (assign, nonatomic) BOOL isLogin;
@property (assign, nonatomic) NSString *loginId;
@property (assign, nonatomic) NSString *token;

@end

@implementation UserManager

static UserManager* _defaultUserManager = nil;

@synthesize isLogin = _isLogin;
@synthesize loginId = _loginId;
@synthesize token = _token;

+ (id)defaultManager
{
    if (_defaultUserManager == nil){
        _defaultUserManager = [[UserManager alloc] init];
    }
    
    return _defaultUserManager;
}

- (NSString*)getUserId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_ID];
}

- (void)saveUserId:(NSString*)userId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userId forKey:KEY_USER_ID];
}

- (void)login:(NSString *)loginId token:(NSString *)token
{
    self.isLogin = YES;
    self.loginId = loginId;
    self.token = token;
}

- (void)logout
{
    self.isLogin = NO;
    self.loginId = nil;
    self.token = nil;
}

- (BOOL)isLogin
{
    return self.isLogin;
}

- (NSString *)loginId;
{
    return self.loginId;
}

- (NSString *)token
{
    return self.token;
}

@end
