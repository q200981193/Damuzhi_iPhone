//
//  CityManager.m
//  Travel
//
//  Created by 小涛 王 on 12-3-14.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "CityOverViewManager.h"

@implementation CityOverViewManager

@synthesize city = _city;
@synthesize cityOverView = _cityOverView;

static CityOverViewManager *_defaultCityOverViewManager = nil;

+ (id)defaultManager
{
    if (_defaultCityOverViewManager == nil){
        _defaultCityOverViewManager = [[CityOverViewManager alloc] init];
    }
    return _defaultCityOverViewManager;
}

- (NSString*)getCurrencySymbol
{
    return _cityOverView.currencySymbol;
}

- (NSArray*)getCityArea
{
    return _cityOverView.areaListList; 
}

- (BOOL)hasLocalCityData:(NSString*)cityId
{
    return NO;
}

- (void)switchCity:(NSString*)newCity
{
    if ([_city isEqualToString:newCity]){
        return;
    }
    
    // set city
    self.city = newCity;
    
    //TODO: read data by new city
}
@end

