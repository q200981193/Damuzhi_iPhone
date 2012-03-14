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

@protocol PlaceServiceDelegate <NSObject>

- (void)findRequestDone:(int)result dataList:(NSArray*)dataList;

@end

@interface PlaceService : CommonService

{
    PlaceManager    *_localPlaceManager;
    PlaceManager    *_onlinePlaceManager;
    
    NSString        *_currentCityId;
}

@property (nonatomic, retain) NSString *currentCityId;

+ (PlaceService*)defaultService;

- (void)findAllSpots:(PPViewController<PlaceServiceDelegate>*)viewController;
- (void)findAllPlaces:(PPViewController<PlaceServiceDelegate>*)viewController;
- (void)findAllHotels:(PPViewController<PlaceServiceDelegate>*)viewController;

@end
