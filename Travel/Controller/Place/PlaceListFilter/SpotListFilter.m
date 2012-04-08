//
//  SpotListFilter.m
//  Travel
//
//  Created by  on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SpotListFilter.h"
#import "PlaceManager.h"
#import "PlaceService.h"
#import "AppManager.h"
#import "Place.pb.h"
#import "CityOverviewService.h"
#import "ImageName.h"
#import "UIImageUtil.h"
#import "CommonListFilter.h"

@implementation SpotListFilter
@synthesize controller;

- (void)dealloc
{
    [controller release];
    [super dealloc];
}

#pragma Protocol Implementations

- (int)getCategoryId
{
    return PLACE_TYPE_SPOT; // TODO change to constants
}

- (NSString*)getCategoryName
{
    return NSLS(@"景点");
}

- (void)createFilterButtons:(UIView*)superView controller:(PPTableViewController *)commonPlaceController
{    
    CGRect frame = CGRectMake(0, superView.frame.size.height/2-HEIGHT_OF_FILTER_BUTTON/2, WIDTH_OF_FILTER_BUTTON, HEIGHT_OF_FILTER_BUTTON);
    
    frame.origin.x += 10;
    UIButton *button1 = [CommonListFilter createFilterButton:frame title:NSLS(@"分类")];
    [button1 addTarget:commonPlaceController action:@selector(clickCategoryButton:) forControlEvents:UIControlEventTouchUpInside];
    button1.tag = 1;
    [superView addSubview:button1];
    
    frame.origin.x += WIDTH_OF_FILTER_BUTTON+DISTANCE_BETWEEN_BUTTONS;
    UIButton *button2 = [CommonListFilter createFilterButton:frame title:NSLS(@"排序")];
    [button2 addTarget:commonPlaceController action:@selector(clickSortButton:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:button2];

    self.controller = commonPlaceController;
}

+ (NSObject<PlaceListFilterProtocol>*)createFilter
{
    SpotListFilter* filter = [[[SpotListFilter alloc] init] autorelease];
    return filter;
}

- (void)findAllPlaces:(PPViewController<PlaceServiceDelegate>*)viewController
{
    return [[PlaceService defaultService] findPlaces:[self getCategoryId]  viewController:viewController];
}


-(NSArray*)filterBySubCategoryIdList:(NSArray*)list selectedSubCategoryIdList:(NSArray*)selectedCategoryIdList
{
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];    
    
    //filter by selectedCategoryId
    for (NSNumber *selectedCategoryId in selectedCategoryIdList) {
        if ([selectedCategoryId intValue] == ALL_CATEGORY) {
            return list;
        }
        
        for (Place *place in list) {
            if ([selectedCategoryId intValue] == [place subCategoryId])
            {
                [array addObject:place];
            }
        }
    }
    
    return array;
}

-(NSArray*)sortBySelectedSortId:(NSArray*)placeList selectedSortId:(NSNumber*)selectedSortId currentLocation:(CLLocation*)currentLocation
{
    NSArray *array = nil;
    switch ([selectedSortId intValue]) {
        case SORT_BY_RECOMMEND:
             array = [placeList sortedArrayUsingComparator:^NSComparisonResult(id place1, id place2){
                 int rank1 = [place1 rank];
                 int rank2 = [place2 rank];
                 
                 if (rank1 < rank2)
                     return NSOrderedDescending;
                 else  if (rank1 > rank2)
                     return NSOrderedAscending;
                 else return NSOrderedSame;
             }];
            //TODO: sort and put sorted result into array
            break;
            
        case SORT_BY_DESTANCE_FROM_NEAR_TO_FAR:
            //TODO: sort and put sorted result into array
            array = [placeList sortedArrayUsingComparator:^NSComparisonResult(id place1, id place2){
                CLLocation *place1Location = [[CLLocation alloc] initWithLatitude:[place1 latitude] longitude:[place1 longitude]];
                CLLocation *place2Location = [[CLLocation alloc] initWithLatitude:[place2 latitude] longitude:[place2 longitude]];
                CLLocationDistance distance1 = [currentLocation distanceFromLocation:place1Location];
                CLLocationDistance distance2 = [currentLocation distanceFromLocation:place2Location];
                [place1Location release];
                [place2Location release];
                
                if (distance1 < distance2)
                    return NSOrderedAscending;
                else  if (distance1 > distance2)
                    return NSOrderedDescending;
                else return NSOrderedSame;
            }];
            break;
            
        case SORT_BY_PRICE_FORM_EXPENSIVE_TO_CHEAP:
            array = [placeList sortedArrayUsingComparator:^NSComparisonResult(id place1, id place2){
                int price1 = [[place1 price] floatValue];
                int price2 = [[place2 price] floatValue] ;
                
                if (price1 < price2)
                    return NSOrderedDescending;
                else  if (price1 > price2)
                    return NSOrderedAscending;
                else return NSOrderedSame;
            }];
            break;
            
        default:
            break;
    }

    return array;
}

- (NSArray*)filterAndSotrPlaceList:(NSArray*)placeList
         selectedSubCategoryIdList:(NSArray*)selectedSubCategoryIdList 
               selectedPriceIdList:(NSArray*)selectedPriceIdList 
                selectedAreaIdList:(NSArray*)selectedAreaIdList 
             selectedServiceIdList:(NSArray*)selectedServiceIdList
             selectedCuisineIdList:(NSArray*)selectedCuisineIdList
                            sortBy:(NSNumber*)selectedSortId
                   currentLocation:(CLLocation*)currentLocation
{
    return [self sortBySelectedSortId:[self filterBySubCategoryIdList:placeList selectedSubCategoryIdList:selectedSubCategoryIdList] selectedSortId:selectedSortId currentLocation:currentLocation];
}

@end
