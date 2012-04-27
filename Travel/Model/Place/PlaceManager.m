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
    for (NSString *filePath in [AppUtils getPlaceFilePathList:cityId]) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        if (data != nil) {
            @try {
                PlaceList *places = [PlaceList parseFromData:data];
                [placeList addObjectsFromArray:[places listList]];
            }
            @catch (NSException *exception) {
                NSLog (@"<readCityPlaceData:%@> Caught %@%@", filePath, [exception name], [exception reason]);
            }
        }
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
    if (categoryId == PlaceCategoryTypePlaceAll) {
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

- (NSArray*)findPlacesNearby:(Place*)place num:(int)num
{
    return nil;
}

@end
