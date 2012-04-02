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
@synthesize cityConfig = _cityConfig;

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
    [_cityConfig release];
    [super dealloc];
}

- (NSString*)getAreaName:(int)areaId
{
    NSString *areaName = @"";
    for (CityArea *area in _cityConfig.areaListList) {
        if (areaId == area.areaId) {
            areaName = area.areaName;
        }
    }
    
    return areaName;
}

- (NSString*)getCurrencySymbol
{
    if (!_cityConfig.currencySymbol){
        PPDebug(@"Warning, <getCurrencySymbol> but currencty symbol is null?");
        return @"";
    }
    
    return _cityConfig.currencySymbol;
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
    self.cityConfig = cityOverView.cityConfig; 
    
//    PPDebug(@"currencyId = %@, currencyName = %@, currencySymbol = %@", 
//            _cityConfig.currencyId, _cityConfig.currencyName, _cityConfig.currencySymbol);
//    
//    for (CityArea *area in _cityConfig.areaListList) {
//        PPDebug(@"areaId = %d, areaName = %@", area.areaId, area.areaName);
//    }
}

- (NSArray *)getSelectAreaList
{
    NSMutableArray *resultArray = [[[NSMutableArray alloc] init] autorelease];
    [resultArray addObject:[NSDictionary dictionaryWithObject:NSLS(@"全部")
                    forKey:[NSNumber numberWithInt:ALL_CATEGORY]]];
    
    NSArray *area = _cityConfig.areaListList;
    for (CityArea* cityArea in area) {
        [resultArray addObject:[NSDictionary dictionaryWithObject:cityArea.areaName
                                                           forKey:[NSNumber numberWithInt:cityArea.areaId]]];
    }
    return resultArray;
}

- (NSArray *)getSelectPriceList
{
    NSMutableArray *resultArray = [[[NSMutableArray alloc] init] autorelease];
    [resultArray addObject:[NSDictionary dictionaryWithObject:NSLS(@"全部")
                                                       forKey:[NSNumber numberWithInt:ALL_CATEGORY]]];
    
    for (int rank = 1; rank <= _cityConfig.priceRank; rank ++) {
        NSString *rankString = nil;
        switch (rank) {
            case 1:
                rankString = @"$";
                break;
            case 2:
                rankString = @"$$";
                break;
            case 3:
                rankString = @"$$$";
                break;
            case 4:
                rankString = @"$$$$";
                break;
                
            default:
                break;
        }
        [resultArray addObject:[NSDictionary dictionaryWithObject:rankString
                                                           forKey:[NSNumber numberWithInt:rank]]];
    }
    
    return resultArray;
}

@end

