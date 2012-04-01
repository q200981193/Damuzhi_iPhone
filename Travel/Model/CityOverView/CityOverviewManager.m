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

@implementation CityOverViewManager

@synthesize cityId = _cityId;
@synthesize cityOverView = _cityOverView;

static CityOverViewManager *_defaultInstance = nil;

+ (id)defaultManager
{
    if (_defaultInstance == nil){
        _defaultInstance = [[CityOverViewManager alloc] init];
        [_defaultInstance switchCity:[[AppManager defaultManager] getCurrentCityId]];
    }
    
    return _defaultInstance;
}

- (void)dealloc
{
    [_cityOverView release];
    [super dealloc];
}

- (NSArray*)getCityBasicImageList
{
    return _cityOverView.cityBasic.imagesList;
}

- (NSString*)getCityBasicHtml
{
    PPDebug(@"CityBasicHtml: %@", _cityOverView.cityBasic.html);
    return _cityOverView.cityBasic.html;
}


- (NSString*)getTravelPreprationHtml
{
    return _cityOverView.travelPrepration.html;
}

- (NSString*)getTravelUtilityHtml;
{
    return _cityOverView.travelUtility.html;
}

- (NSString*)getTravelTransportationHtml
{
    return _cityOverView.travelTransportation.html;
}

- (NSArray*)getAreaList
{
    return _cityOverView.areaListList;
}

- (NSString*)getAreaName:(int)areaId
{
    NSString *areaName = @"";
    for (CityArea *area in _cityOverView.areaListList) {
        if (areaId == area.areaId) {
            areaName = area.areaName;
        }
    }
    
    return areaName;
}

- (NSString*)getCurrencySymbol
{
    if (!_cityOverView.currencySymbol){
        PPDebug(@"Warning, <getCurrencySymbol> but currencty symbol is null?");
        return @"";
    }
//    NSLog(@"currencySymbol = %@", _cityOverView.currencySymbol);
    
    return _cityOverView.currencySymbol;
}

- (NSString*)getCurrencyId;
{
    return _cityOverView.currencyId;
}

- (NSString*)getCurrencyName
{
    return _cityOverView.currencyName;
}

- (int)getPriceRank
{
    return _cityOverView.priceRank;
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

    self.cityOverView = [self readCityOverviewData:newCityId];
    
    NSLog(@"currencyId = %@, currencyName = %@, currencySymbol = %@", 
            _cityOverView.currencyId, _cityOverView.currencyName, _cityOverView.currencySymbol);
    
    for (CityArea *area in _cityOverView.areaListList) {
        NSLog(@"areaId = %d, areaName = %@", area.areaId, area.areaName);
    }
}

- (NSArray *)getWillSelectAreaList
{
    NSMutableArray *resultArray = [[[NSMutableArray alloc] init] autorelease];
    [resultArray addObject:[NSDictionary dictionaryWithObject:NSLS(@"全部")
                    forKey:[NSNumber numberWithInt:ALL_CATEGORY]]];
    
    NSArray *area = [self getAreaList];
    for (CityArea* cityArea in area) {
        [resultArray addObject:[NSDictionary dictionaryWithObject:cityArea.areaName
                                                           forKey:[NSNumber numberWithInt:cityArea.areaId]]];
    }
    return resultArray;
}

- (NSArray *)getWillSelectPriceList
{
    NSMutableArray *resultArray = [[[NSMutableArray alloc] init] autorelease];
    [resultArray addObject:[NSDictionary dictionaryWithObject:NSLS(@"全部")
                                                       forKey:[NSNumber numberWithInt:ALL_CATEGORY]]];
    
    for (int rank = 1; rank <= [_cityOverView priceRank]; rank ++) {
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

