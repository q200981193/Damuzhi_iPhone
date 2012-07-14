//
//  RouteStorage.m
//  Travel
//
//  Created by haodong qiu on 12年7月14日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "RouteStorage.h"
#import "AppUtils.h"
#import "TouristRoute.pb.h"
#import "LogUtil.h"
#import "TravelNetworkConstants.h"

@interface RouteStorage()

@property (assign, nonatomic) int routeType;

- (id)initWithType:(int)routeType;
- (NSString*)getFilePath;
- (void)writeToFileWithList:(NSArray*)newList;

@end


static RouteStorage *_packageFollowManager = nil;
static RouteStorage *_unpackageFollowManager = nil;

@implementation RouteStorage
@synthesize routeType = _routeType;

+ (RouteStorage *)packageFollowManager
{
    if (_packageFollowManager == nil) {
        _packageFollowManager = [[RouteStorage alloc] initWithType:OBJECT_LIST_ROUTE_PACKAGE_TOUR];
    }
    return _packageFollowManager;
}

+ (RouteStorage *)unpackageFollowManager
{
    if (_unpackageFollowManager == nil) {
        _unpackageFollowManager = [[RouteStorage alloc] initWithType:OBJECT_LIST_ROUTE_UNPACKAGE_TOUR];
    }
    return _unpackageFollowManager;
}

- (id)initWithType:(int)routeType
{
    self = [super init];
    if (self) {
        self.routeType = routeType;
    }
    return self;
}

- (NSArray*)findAllRoutes
{
    NSData* data = [NSData dataWithContentsOfFile:[self getFilePath]];
    TouristRouteList *list = nil;
    if (data != nil) {
        @try {
            list = [TouristRouteList parseFromData:data];
        }
        @catch (NSException *exception) {
            PPDebug(@"<RouteStorage> findAllRoutes Caught %@%@", [exception name], [exception reason]);
        }
    }
    
    return [list routesList];
}


- (void)addRoute:(TouristRoute *)route
{
    [self deleteRoute:route];
    
    NSMutableArray* mutableArray = [NSMutableArray arrayWithArray:[self findAllRoutes]];
    [mutableArray addObject:route];    
    [self writeToFileWithList:mutableArray];
}


- (void)deleteRoute:(TouristRoute *)route
{
    BOOL found = NO;
    NSMutableArray* mutableArray = [NSMutableArray arrayWithArray:[self findAllRoutes]];
    for (TouristRoute *routeTemp in mutableArray) {
        if (routeTemp.routeId == route.routeId) {
            [mutableArray removeObject:routeTemp];
            found = YES;
            break;
        }
    }
    
    if (found) {
        [self writeToFileWithList:mutableArray];
    }
}


- (NSString*)getFilePath
{
    return [AppUtils getFollowRoutesFilePath:_routeType];
}


- (void)writeToFileWithList:(NSArray*)newList
{
    TouristRouteList_Builder* builder = [[TouristRouteList_Builder alloc] init];    
    [builder addAllRoutes:newList];
    TouristRouteList *newTouristRouteList = [builder build];
    
    PPDebug(@"<RouteStorage> %@",[self getFilePath]);
    if (![[newTouristRouteList data] writeToFile:[self getFilePath]  atomically:YES]) {
        PPDebug(@"<RouteStorage> error");
    } 
    [builder release];
}

@end
