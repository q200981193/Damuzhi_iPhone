//
//  RouteStorage.h
//  Travel
//
//  Created by haodong qiu on 12年7月14日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TouristRoute;
@interface RouteStorage : NSObject

+ (RouteStorage *)packageFollowManager;
+ (RouteStorage *)unpackageFollowManager;
- (NSArray*)findAllRoutes;
- (void)addRoute:(TouristRoute *)route;
- (void)deleteRoute:(TouristRoute *)route;

@end
