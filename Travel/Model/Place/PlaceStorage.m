//
//  PlaceStorage.m
//  Travel
//
//  Created by  on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlaceStorage.h"
#import "Place.pb.h"

@implementation PlaceStorage

@synthesize placeList = _placeList;

- (void)dealloc
{
    [_placeList release];
    [super dealloc];
}

- (id)initWithFileName:(NSString*)fileName
{
    self = [super init];
    return self;
}


- (NSArray*)allPlaces
{
    return [self.placeList listList];
}

- (NSArray*)loadPlaceList
{
    NSData* data = [NSData dataWithContentsOfFile:@""];
    self.placeList = [PlaceList parseFromData:data];
    return [_placeList listList];
}

- (void)addPlace:(Place*)place
{    
    // generate new list by adding place into existing place list
    NSMutableArray* newList = [NSMutableArray arrayWithArray:[self allPlaces]];
    [newList addObject:place];    

    // build data again
    PlaceList_Builder* builder = [[PlaceList_Builder alloc] init];    
    [builder setCityId:0];    
    [builder addAllList:newList];
    PlaceList* newPlaceList = [builder build];

    // save to files
    [[newPlaceList data] writeToFile:@"" atomically:YES];    
    [builder release];
    
    // update current list data
    self.placeList = newPlaceList;
}

- (void)deletePlace:(Place*)place
{
    
}


@end
