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

//- (void)switchCity:(int)newCityId
//{
//    if (newCityId == _cityId){
//        return;
//    }
//    
//    // set city and read data by new city
//    _cityId = newCityId;
//    self.guideList = [self readTipsData:]
//    [self readTravelTipsData:newCityId];
//}
//
//- (TravelTips*)readTravelTipsData:cityId
//{
//    
//    return 
//}
//
//- (NSArray*)getTravelGuideList
//{
//    return nil;
//}
//
//- (NSArray*)getTravelRouteList
//{
//    return nil;
//}
//
//- (NSArray*)getTravelGuideHtml:(int)guideId
//{
//    return nil;
//}
//
//- (NSArray*)getTravelRouteHtml:(int)guideId
//{
//    return nil;
//}

@end
