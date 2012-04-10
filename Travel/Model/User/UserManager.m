//
//  UserManager.m
//  Travel
//
//  Created by  on 12-3-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserManager.h"

#define KEY_USER_ID   @"KEY_USER_ID"
#define KEY_IS_SHOW_IMAGE   @"KEY_IS_SHOW_IMAGE"

@implementation UserManager

static UserManager* _defaultUserManager = nil;

+ (id)defaultManager
{
    if (_defaultUserManager == nil){
        _defaultUserManager = [[UserManager alloc] init];
    }
    return _defaultUserManager;
}

- (NSString*)userId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_ID];
}

- (void)saveUserId:(NSString*)userId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userId forKey:KEY_USER_ID];
}

- (BOOL)isShowImage
{
    //default return YES
    if (nil == [[NSUserDefaults standardUserDefaults] objectForKey:KEY_IS_SHOW_IMAGE]) {
        return YES;
    }
    return [[NSUserDefaults standardUserDefaults] boolForKey:KEY_IS_SHOW_IMAGE];
}

- (void)saveIsShowImage:(BOOL)isShow
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isShow forKey:KEY_IS_SHOW_IMAGE];
}

@end
