//
//  CityManager.m
//  Travel
//
//  Created by 小涛 王 on 12-3-14.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "CityManager.h"

@implementation CityManager

static CityManager *_defaultCityManager = nil;

+ (id)defaultManager
{
    if (_defaultCityManager == nil){
        _defaultCityManager = [[CityManager alloc] init];
    }
    return _defaultCityManager;
}



@end
