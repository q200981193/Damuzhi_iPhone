//
//  TravelTips.m
//  Travel
//
//  Created by 小涛 王 on 12-4-10.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "TravelTipsManager.h"
#import "AppManager.h"
#import "AppUtils.h"
#import "PPDebug.h"

@implementation TravelTipsManager

@synthesize cityId = _cityId;
@synthesize guideList = _guideList;
@synthesize routeList = _routeList;

static TravelTipsManager * _instance = nil;

+ (id)defaultManager
{
    if (_instance == nil) {
        _instance = [[TravelTipsManager alloc] init];
        [_instance switchCity:[[AppManager defaultManager] getCurrentCityId]];
    }
    return _instance;
}

- (void)dealloc
{
    [_guideList release];
    [_routeList release];
    [super dealloc];
}

- (void)switchCity:(int)newCityId
{
    if (newCityId == _cityId){
        return;
    }
    
    // set city and read data by new city
    _cityId = newCityId;
    self.guideList = [self readGuideData];
    self.routeList = [self readRouteData];
}

- (NSArray*)readGuideData
{
    // if there has no local city data
    if (![AppUtils hasLocalCityData:_cityId]) {
        return nil;
    }
    
    return [self readTipDataFromFile:[AppUtils getGuideFilePathList:_cityId]]; 
}

- (NSArray*)readRouteData
{
    // if there has no local city data
    if (![AppUtils hasLocalCityData:_cityId]) {
        return nil;
    }
    
    return [self readTipDataFromFile:[AppUtils getRouteFilePathList:_cityId]]; 
}

- (NSArray*)readTipDataFromFile:(NSArray*)filePathList
{
    NSMutableArray *list = [[[NSMutableArray alloc] init] autorelease];
    for (NSString *filePath in filePathList) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        CommonTravelTip *tip = [CommonTravelTip parseFromData:data];
        [list addObject:tip];
    }
    
    return list; 
}


- (NSArray*)getTravelGuideList
{
    return _guideList;
}

- (NSArray*)getTravelRouteList
{
    return _routeList;
}

- (NSString*)getTravelGuideHtml:(int)guideId
{
    for (CommonTravelTip *tip in _guideList) {
        if (tip.tipId == guideId) {
            return tip.html;
        }
    }
    
    return nil;
}

- (NSString*)getTravelRouteHtml:(int)routeId
{
    for (CommonTravelTip *tip in _guideList) {
        if (tip.tipId == routeId) {
            return tip.html;
        }
    }
    
    return nil;
}

@end
