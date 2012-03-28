//
//  PlaceStorage.h
//  Travel
//
//  Created by  on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Place;
@class PlaceList;

@interface PlaceStorage : NSObject

@property (nonatomic, retain) NSString * fileName;
@property (nonatomic, retain) PlaceList* placeList;

+ (PlaceStorage*)favoriteManager;
+ (PlaceStorage*)historyManager;

- (id)initWithFileName:(NSString*)fileName;
- (NSArray*)loadPlaceList;
- (NSArray*)allPlaces;
- (void)addPlace:(Place*)place;
- (void)deletePlace:(Place*)place;

@end
