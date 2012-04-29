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

- (double)distanceBetween:(Place*)place1 place2:(Place*)place2
{
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:place1.latitude longitude:place1.longitude];
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:place2.latitude longitude:place2.longitude];
    
    CLLocationDistance distance = [location1 distanceFromLocation:location2];
    
    [location1 release];
    [location2 release];
    
    return distance;
}

- (double)distanceBetween:(Place*)place location:(CLLocation*)location
{
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:place.latitude longitude:place.longitude];
    
    CLLocationDistance distance = [loc distanceFromLocation:location];
    
    [loc release];
    
    return distance;
}

#define NUM_OF_PLACE_NEARBY 5
- (NSArray*)findPlacesNearby:(int)categoryId place:(Place*)place
{
    NSArray *list = [self findPlacesByCategory:categoryId];

    NSArray *sortedPlaceList = [self sortPlacesFromNearToFar:place placeList:list];
    
//    for (Place *pl in sortedPlaceList) {
//        CLLocationDistance dis1 = [self distanceBetween:pl place2:place];
//        PPDebug(@"place name = %@, distance = %f", pl.name, dis1);
//    }
    
    int sortedListCount = [sortedPlaceList count];
    
    NSRange range;
    range.location = 0;
    range.length = (sortedListCount >= NUM_OF_PLACE_NEARBY) ? NUM_OF_PLACE_NEARBY : sortedListCount;
    
    return [sortedPlaceList subarrayWithRange:range];
}

- (NSArray*)sortPlacesFromNearToFar:(Place*)place placeList:(NSArray*)placeList
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:place.latitude longitude:place.longitude];

    NSMutableArray *list = [[[NSMutableArray alloc] init] autorelease];

    for (Place *pl in placeList) {
        if (pl.placeId == place.placeId) {
            continue;
        }
        [list addObject:pl];
    }

    NSArray *sortedList = [list sortedArrayUsingComparator:^(id obj1, id obj2){
        Place *place1 = (Place*)obj1;
        Place *place2 = (Place*)obj2;
        
        CLLocationDistance dis1 = [self distanceBetween:place1 location:location];
        CLLocationDistance dis2 = [self distanceBetween:place2 location:location];
        
//        PPDebug(@"place1: %@, dis1 = %f, place2: %@ dis2 = %f", place1.name, dis1, place2.name, dis2);
        
        if (dis1 < dis2) {
            return NSOrderedAscending;
        } 
        else if (dis1 > dis2) {
            return NSOrderedDescending;
        }
        else {
            return NSOrderedSame;
        }
    }];
    
    [location release];
    
    return sortedList;
}

- (NSArray*)findPlacesNearby:(int)categoryId place:(Place *)place distance:(double)distance
{    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:place.latitude longitude:place.longitude];
    NSArray *list = [self findPlacesByCategory:categoryId];
    
    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
    for (Place *place1 in list) {
        if(place.placeId == place1.placeId)
        {
            continue;
        }
        
        double dis = [self distanceBetween:place1 location:location];
        
        if (dis < distance*1000.0) {
//            PPDebug(@"place = %@, distance = %f", place1.name, dis);
            [retArray addObject:place1];
        }
    }
    
    [location release];
    
    return retArray;
}




@end
