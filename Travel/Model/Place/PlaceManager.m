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
#import <CoreLocation/CoreLocation.h>

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

- (NSArray*)findPlacesNearby:(int)categoryId place:(Place*)place
{
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:place.latitude longitude:place.longitude];
    
    NSArray *list = [self findPlacesByCategory:categoryId];
    
    NSArray *sortedPlaceList = [list sortedArrayUsingComparator:^(id obj1, id obj2){
        if ([obj1 isKindOfClass:[Place class]] && [obj2 isKindOfClass:[Place class]]) {
            Place *place1 = (Place*)obj1;
            Place *place2 = (Place*)obj2;
            
            CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:place1.latitude longitude:place1.longitude];
            CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:place2.latitude longitude:place2.longitude];
            
            CLLocationDistance dis1 = [loc1 distanceFromLocation:loc];
            CLLocationDistance dis2 = [loc2 distanceFromLocation:loc];
            
            [loc1 release];
            [loc2 release];
            
            if (dis1 > dis2) {
                return (NSComparisonResult)NSOrderedAscending;
            } else if (dis1 < dis2) {
                return (NSComparisonResult)NSOrderedDescending;
            }
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    [loc release];
    
    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
    int count = [sortedPlaceList count];
    int loopCount = (count<5) ? count : 5;
    
    for (int i = 0; i < loopCount; i++)
    {
        [retArray addObject:[sortedPlaceList objectAtIndex:(loopCount - i -1)]];
    }
    return retArray;
}

- (NSArray*)findPlacesNearby:(int)categoryId place:(Place *)place distance:(double)distance
{
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:place.latitude longitude:place.longitude];
    
    NSArray *list = [self findPlacesByCategory:categoryId];
    
    NSMutableArray *retArray = [[NSMutableArray alloc] init];
    
    for (Place *place1 in list) {
        if (place1.placeId == place.placeId) {
            continue;
        }
        
        CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:place1.latitude longitude:place1.longitude];
        // Caculate distance between two places, unit is KM.
        CLLocationDistance dis = [loc1 distanceFromLocation:loc]/1000.0;
        [loc1 release];
        
        if (dis < distance) {
            [retArray addObject:place1];
        }
    }
    
    [loc release];
    
    return retArray;
}

@end
