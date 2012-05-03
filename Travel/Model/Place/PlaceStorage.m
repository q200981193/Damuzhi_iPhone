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
#import "FileUtil.h"
#import "AppManager.h"

#define FAVORITE_PLACE_FILE         @"favorite_place.dat"
#define HISTORY_PLACE_FILE          @"history_place.dat"
#define PLACE_STORAGE_DEFAULT_DIR   @"save_place_data"

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
        [FileUtil createDir:[FileUtil getFileFullPath:PLACE_STORAGE_DEFAULT_DIR]];
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

- (NSString*)getFilePath
{
    NSString* fileWithDir = [NSString stringWithFormat:@"%@/%d_%@", PLACE_STORAGE_DEFAULT_DIR, [[AppManager defaultManager] getCurrentCityId], _fileName];
    NSString *filePath = [FileUtil getFileFullPath:fileWithDir];
    return filePath;
}

- (void)loadPlaceList
{
    NSData* data = [NSData dataWithContentsOfFile:[self getFilePath]];
    if (data != nil) {
        @try {
            self.placeList = [PlaceList parseFromData:data];
        }
        @catch (NSException *exception) {
            PPDebug(@"<loadPlaceList> Caught %@%@", [exception name], [exception reason]);
        }
    }
}

- (NSArray*)allPlaces
{
    [self loadPlaceList];
    return [self.placeList listList];
}

- (void)writeToFileWithList:(NSArray*)newList
{
    PlaceList_Builder* builder = [[PlaceList_Builder alloc] init];    
    [builder setCityId:0];    
    [builder addAllList:newList];
    PlaceList* newPlaceList = [builder build];
    
    // save to files        
    PPDebug(@"<writeToFileWithList> filePath is :%@",[self getFilePath]);
    if (![[newPlaceList data] writeToFile:[self getFilePath]  atomically:YES]) {
        PPDebug(@"<writeToFileWithList> wirteToFile error");
    } 
    [builder release];
    
    // update current list data
    self.placeList = newPlaceList;
}

- (void)addPlace:(Place*)place
{
    [self deletePlace:place];
    
    // generate new list by adding place into existing place list
    NSMutableArray* newList = [NSMutableArray arrayWithArray:[self allPlaces]];
    [newList addObject:place];    
    
    [self writeToFileWithList:newList];
}

- (void)deletePlace:(Place*)place
{
    BOOL found = NO;
    NSMutableArray* newList = [NSMutableArray arrayWithArray:[self allPlaces]];
    for (Place *placeTemp in newList) {
        if (placeTemp.placeId == place.placeId) {
            [newList removeObject:placeTemp];
            found = YES;
            break;
        }
    }
    
    if (found) {
        [self writeToFileWithList:newList];
    }
}

- (void)deleteAllPlaces
{
    [self writeToFileWithList:nil];
}

- (BOOL)isPlaceInFavorite:(int)placeId
{
    [self loadPlaceList];
    NSArray *arrary = [self allPlaces];
    for (Place *place in arrary) {
        if (place.placeId == placeId) {
            return YES;
        }
    }
    return NO;
}

@end
