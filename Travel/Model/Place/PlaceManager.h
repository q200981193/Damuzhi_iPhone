//
//  PlaceManager.h
//  Travel
//
//  Created by  on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"
#import "Place.pb.h"

enum{
    PLACE_TYPE_SPOT = 1
    
};

@interface PlaceManager : NSObject<CommonManagerProtocol>
{
    NSString*       _city;
    NSArray*        _placeList; 
}

@property (nonatomic, retain) NSString* city;
@property (nonatomic, retain) NSArray*  placeList;

- (void)switchCity:(NSString*)newCity;

- (NSArray*)findAllPlaces;
- (NSArray*)findAllSpots;

- (BOOL)hasLocalCityData:(NSString*)cityId;

@end
