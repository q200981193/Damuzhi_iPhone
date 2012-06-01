//
//  UserManager.m
//  Travel
//
//  Created by  on 12-3-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserManager.h"

#define KEY_USER_ID   @"KEY_USER_ID"

@implementation UserManager

static UserManager* _defaultUserManager = nil;

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


@end
