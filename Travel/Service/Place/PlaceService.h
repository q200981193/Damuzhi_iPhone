//
//  PlaceSevice.h
//  Travel
//
//  Created by  on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"

@class PlaceManager;
@class PPViewController;
@class Place;

@protocol PlaceServiceDelegate <NSObject>

@optional
- (void)findRequestDone:(int)result dataList:(NSArray*)dataList;
- (void)filterAndSort;

- (void)finishAddFavourite:(NSNumber*)resultCode count:(int)count;
- (void)didGetPlaceData:(int)placeId count:(int)placeFavoriteCount;

@end

@interface PlaceService : CommonService

{
    PlaceManager    *_localPlaceManager;
    PlaceManager    *_onlinePlaceManager;
    
    int             _currentCityId;
}

@property (nonatomic, assign) int currentCityId;

+ (PlaceService*)defaultService;

- (void)findAllSpots:(PPViewController<PlaceServiceDelegate>*)viewController;
- (void)findAllPlaces:(PPViewController<PlaceServiceDelegate>*)viewController;
- (void)findAllHotels:(PPViewController<PlaceServiceDelegate>*)viewController;


- (void)findMyPlaces:(PPViewController<PlaceServiceDelegate>*)viewController;
- (void)findHistoryPlaces:(PPViewController<PlaceServiceDelegate>*)viewController;


- (void)addPlaceIntoFavorite:(PPViewController<PlaceServiceDelegate>*)viewController
                       place:(Place*)place;

- (void)getPlaceFavoriteCount:(PPViewController<PlaceServiceDelegate>*)viewController
                      placeId:(int)placeId;

- (BOOL)isPlaceInFavorite:(int)placeId;

@end
