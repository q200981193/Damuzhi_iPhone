//
//  UserManager.m
//  Travel
//
//  Created by  on 12-3-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserManager.h"

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
    return nil;
}

- (void)saveUserId:(NSString*)userId
{
    
}

@end
