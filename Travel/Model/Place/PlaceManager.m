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
        [_placeDefaultManager switchCity:@""];
    }
    
    return _placeDefaultManager;
}


- (Place*)buildTestPlace:(NSString*)placeTag
{
    Place_Builder* builder = [[[Place_Builder alloc] init] autorelease];
    
    [builder setPlaceId:[@"PlaceId" stringByAppendingString:placeTag]];       
    [builder setCategoryId:PLACE_TYPE_SPOT];
    [builder setSubCategoryId:1];
    [builder setRank:1];
    [builder setIntroduction:@"简介信息，待完善"];
    [builder setIcon:@"spot.png"];
    [builder setAvgPrice:@"100"];
    [builder setOpenTime:@"早上10点到晚上10点"];
    [builder setLatitude:233.0f];
    [builder setLongitude:119.0f];
    [builder setName:@"杜莎夫人蜡像馆"];
    [builder setPlaceFavoriteCount:12];
    [builder setPrice:@"50"];
    [builder setPriceDescription:@"儿童免票，成人100元"];
    [builder setTips:@"缆车车费：单程HK$20"];
    [builder setTransportation:@"乘地铁从上环站到中环站"];
    [builder setWebsite:@"http://www.madametussauds.com"];
    [builder addTelephone:@"00852-28496966"];
    [builder addAddress:@"香港山顶道128号凌霄阁"];
    
    return [builder build];
}

- (NSData*)readCityPlaceData:(NSString*)cityId
{
    // read from files later
    
    PlaceList_Builder* builder = [[[PlaceList_Builder alloc] init] autorelease];

    Place* place1 = [self buildTestPlace:@"1"];    
    Place* place2 = [self buildTestPlace:@"2"];    
    Place* place3 = [self buildTestPlace:@"3"];    
    
    [builder addList:place1];
    [builder addList:place2];
    [builder addList:place3];
    
    PlaceList* placeList = [builder build];
    
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

- (NSArray*)findAllPlaces
{
    return _placeList;
}

- (BOOL)hasLocalCityData:(NSString*)cityId
{
    return YES;
}

@end
