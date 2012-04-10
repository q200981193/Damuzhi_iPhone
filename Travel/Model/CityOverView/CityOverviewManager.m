//
//  CityManager.m
//  Travel
//
//  Created by 小涛 王 on 12-3-14.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "CityOverViewManager.h"
#import "AppUtils.h"
#import "PPDebug.h"
#import "AppManager.h"
#import "PPDebug.h"
#import "LocaleUtils.h"
#import "CommonPlace.h"
#import "AppConstants.h"

@implementation CityOverViewManager

@synthesize cityId = _cityId;
@synthesize cityBasic = _cityBasic;
@synthesize travelPrepration = _travelPrepration;
@synthesize travelUtility = _travelUtility;
@synthesize travelTransportation = _travelTransportation;

static CityOverViewManager *_defaultInstance = nil;

+ (id)defaultManager
{
    if (_defaultInstance == nil){
        _defaultInstance = [[CityOverViewManager alloc] init];
    }
    
    [_defaultInstance switchCity:[[AppManager defaultManager] getCurrentCityId]];
    return _defaultInstance;
}

- (void)dealloc
{
    [_cityBasic release];
    [_travelPrepration release];
    [_travelUtility release];
    [_travelTransportation release];
    [super dealloc];
}

- (CityOverview*)readCityOverviewData:(int)cityId
{
    // if there has no local city data
    if (![AppUtils hasLocalCityData:cityId]) {
        return nil;
    }
    
    NSString *cityOverviewFilePath = [AppUtils getCityoverViewFilePath:cityId];
    NSData *cityOverviewData = [NSData dataWithContentsOfFile:cityOverviewFilePath];
    
    return [CityOverview parseFromData:cityOverviewData];
}

- (void)switchCity:(int)newCityId
{
    if (_cityId == newCityId){
        return;
    }
    
    self.cityId = newCityId;

    CityOverview *cityOverView = [self readCityOverviewData:newCityId];
    
    self.cityBasic = cityOverView.cityBasic; 
    self.travelPrepration = cityOverView.travelPrepration;          
    self.travelUtility = cityOverView.travelUtility;              
    self.travelTransportation = cityOverView.travelTransportation;       
}

@end

