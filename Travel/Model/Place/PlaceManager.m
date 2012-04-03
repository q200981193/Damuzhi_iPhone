//
//  PlaceManager.m
//  Travel
//
//  Created by  on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlaceManager.h"
#import "Place.pb.h"
#import "LogUtil.h"
#import "AppManager.h"
#import "AppUtils.h"

@implementation PlaceManager

static PlaceManager *_placeDefaultManager;
@synthesize placeList = _placeList;

- (void)dealloc
{
    [_placeList release];
    [super dealloc];
}

+ (id)defaultManager
{
    if (_placeDefaultManager == nil){
        _placeDefaultManager = [[PlaceManager alloc] init];
        [_placeDefaultManager switchCity:[[AppManager defaultManager] getCurrentCityId]];
    }
    
    return _placeDefaultManager;
}

- (NSArray*)readCityPlaceData:(int)cityId
{
    // if there has no local city data
    if (![AppUtils hasLocalCityData:cityId]) {
        return nil;
    }
    
    NSMutableArray *placeList = [[[NSMutableArray alloc] init] autorelease];
    for (NSString *placeFilePath in [AppUtils getPlaceFilePathList:cityId]) {
//        PPDebug(@"placeFilePath = %@", placeFilePath);
        NSData *placeData = [NSData dataWithContentsOfFile:placeFilePath];
        PlaceList *places = [PlaceList parseFromData:placeData];
        //PPDebug(@"%d places read", [[places listList] count]);
        [placeList addObjectsFromArray:[places listList]];
    }
    
    return placeList;
}

- (void)switchCity:(int)newCityId
{
    if (newCityId == _cityId){
        return;
    }
    
    // set city and read data by new city
    _cityId = newCityId;
    self.placeList = [self readCityPlaceData:newCityId];
}

- (NSArray*)findPlacesByCategory:(int)categoryId
{
    if (categoryId == PLACE_TYPE_ALL) {
        return _placeList;
    }
    
    NSMutableArray* placeList = [[[NSMutableArray alloc] init] autorelease];
    for (Place* place in _placeList){
        if ([place categoryId] == categoryId){
            [placeList addObject:place];
        }
    }

    return placeList;
}

@end
