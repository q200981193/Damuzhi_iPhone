//
//  CityOverViewCity.m
//  Travel
//
//  Created by 小涛 王 on 12-3-17.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "CityOverViewService.h"

#import "PPViewController.h"
#import "LogUtil.h"
#import "TravelNetworkRequest.h"
#import "Package.pb.h"
#import "CityOverViewManager.h"
#import "TravelNetworkConstants.h"
#import "AppManager.h"

#define SERACH_WORKING_QUEUE1    @"SERACH_WORKING_QUEUE1"

@implementation CityOverViewService

@synthesize currentCityId = _currentCityId;

static CityOverViewService *_cityOverViewService = nil;

+ (CityOverViewService*)defaultService
{
    if (_cityOverViewService == nil) {
        _cityOverViewService = [[CityOverViewService alloc] init];
    }
    
    return _cityOverViewService;
}

- (id)init
{
    self = [super init];
    _localCityOverViewManager = [[CityOverViewManager alloc] init];
    _onlineCityOverViewManager = [[CityOverViewManager alloc] init];
    self.currentCityId = [NSString stringWithFormat:@"%d",[[AppManager defaultManager] getCurrentCityId]];
    return self;
}

- (void)dealloc
{
    [_localCityOverViewManager release];
    [_onlineCityOverViewManager release];
    [super dealloc];
}



@end
