//
//  PlaceStorage.m
//  Travel
//
//  Created by  on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlaceStorage.h"
#import "Place.pb.h"
#import "LogUtil.h"

#define FAVORITE_PLACE_FILE  @"favorite_place.dat"
#define HISTORY_PLACE_FILE   @"history_place.dat"

static PlaceStorage* _favoriteManager = nil;
static PlaceStorage* _historyManager = nil;

@implementation PlaceStorage

@synthesize fileName = _fileName;
@synthesize placeList = _placeList;

- (void)dealloc
{
    [_fileName release];
    [_placeList release];
    [super dealloc];
}

- (id)initWithFileName:(NSString*)fileName
{
    self = [super init];
    if (self) {
        self.fileName = fileName;
    }
    return self;
}

+ (PlaceStorage*)favoriteManager
{
    if (_favoriteManager == nil) {
        _favoriteManager = [[PlaceStorage alloc] initWithFileName:FAVORITE_PLACE_FILE];
    }
    return _favoriteManager;
}

+ (PlaceStorage*)historyManager
{
    if (_historyManager == nil) {
        _historyManager = [[PlaceStorage alloc] initWithFileName:HISTORY_PLACE_FILE];
    }
    return _historyManager;
}

- (NSArray*)allPlaces
{
    return [self.placeList listList];
}

- (NSArray*)loadPlaceList
{
    NSData* data = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:_fileName]];
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
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:_fileName];
    PPDebug(@"<loadPlaceList> filePath is :%@",filePath);
    if (![[newPlaceList data] writeToFile:filePath  atomically:YES]) {
        PPDebug(@"<loadPlaceList> wirteToFile error");
    } 
    [builder release];
    
    // update current list data
    self.placeList = newPlaceList;
}

- (void)deletePlace:(Place*)place
{
    
}


@end
