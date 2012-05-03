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
    }
    
    return _instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self switchCity:[[AppManager defaultManager] getCurrentCityId]];
    }
    
    return self;
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
        if (data != nil) {
            @try {
                CommonTravelTip *tip = [CommonTravelTip parseFromData:data];
                [list addObject:tip];
            }
            @catch (NSException *exception) {
                PPDebug(@"<readTipDataFromFile:%@> Caught %@%@", filePath, [exception name], [exception reason]);
            }
        }
    }
    
    return list; 
}

- (NSArray*)getTravelTipList:(TravelTipType)type
{
    NSArray *array = nil;
    
    switch (type) {
        case TravelTipTypeGuide:
            array = _guideList;
            break;
            
        case TravelTipTypeRoute:
            array = _routeList;
            break;
            
        default:
            break;
    }
    
    return array;
}

- (CommonTravelTip*)getTravelTip:(TravelTipType)type tipId:(int)tipId
{
    for (CommonTravelTip *tip in [self getTravelTipList:type]) {
        if (tip.tipId == tipId) {
            return tip;
        }
    }
    
    return nil;
}


@end
