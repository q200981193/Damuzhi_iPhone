//
//  PlaceManager.m
//  Travel
//
//  Created by  on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlaceManager.h"
#import "Place.pb.h"

@implementation PlaceManager

static PlaceManager *_placeDefaultManager;
@synthesize city = _city;
@synthesize placeList = _placeList;

- (void)dealloc
{
    [_city release];
    [_placeList release];
    [super dealloc];
}

+ (PlaceManager*)defaultManager
{
    if (_placeDefaultManager == nil){
        _placeDefaultManager = [[PlaceManager alloc] init];
    }
    
    return _placeDefaultManager;
}


- (Place*)buildTestPlace:(NSString*)placeTag
{
    Place_Builder* builder = [[Place_Builder alloc] init];
    
    [builder setPlaceId:[@"PlaceId" stringByAppendingString:placeTag]];       
    [builder setCategoryId:PLACE_TYPE_SPOT];
    [builder release];
    
    return [builder build];
}

- (NSData*)readCityPlaceData:(NSString*)cityId
{
    // read from files later
    
    PlaceList_Builder* builder = [[PlaceList_Builder alloc] init];

    Place* place1 = [self buildTestPlace:@"1"];    
    Place* place2 = [self buildTestPlace:@"2"];    
    Place* place3 = [self buildTestPlace:@"3"];    
    
    [builder addList:place1];
    [builder addList:place2];
    [builder addList:place3];
    
    PlaceList* placeList = [builder build];
    
    [builder release];
    return [placeList data];
}

- (void)switchCity:(NSString*)newCity
{
    if ([_city isEqualToString:newCity]){
        return;
    }
    
    // set city and read data by new city
    self.city = newCity;
    
    NSData* data = [self readCityPlaceData:newCity];
    
    self.placeList = [[PlaceList parseFromData:data] listList];        
}

- (NSArray*)findAllSpots
{
    NSMutableArray* spotList = [[[NSMutableArray alloc] init] autorelease];
    
    for (Place* place in _placeList){
        if ([place categoryId] == PLACE_TYPE_SPOT){
            [spotList addObject:place];
        }
    }
    
    return spotList;
}

@end
