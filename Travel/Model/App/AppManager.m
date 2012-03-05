//
//  AppManager.m
//  Travel
//
//  Created by  on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppManager.h"

@implementation AppManager

static AppManager* _defaultAppManager = nil;

+ (id)defaultManager
{
    if (_defaultAppManager == nil){
        _defaultAppManager = [[AppManager alloc] init];
    }
    return _defaultAppManager;
}

@end
