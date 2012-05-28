//
//  CommonListFilter.m
//  Travel
//
//  Created by haodong qiu on 12年3月30日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "CommonListFilter.h"
#import "Place.pb.h"
#import "CommonPlace.h"
#import "PlaceService.h"
#import "LogUtil.h"
#import "LocaleUtils.h"
#import "ImageName.h"
#import "PlaceUtils.h"

@implementation CommonListFilter

+ (UIButton*)createFilterButton:(CGRect)frame title:(NSString*)title
{
    UIImage *bgImageForNormal = [UIImage imageNamed:IMAGE_SELECT_DOWN];
    UIImage *bgImageForHeightlight = [UIImage imageNamed:IMAGE_SELECT_DOWN];
    
    UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundImage:bgImageForNormal forState:UIControlStateNormal];
    [button setBackgroundImage:bgImageForHeightlight forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont systemFontOfSize: 12];
    [button.titleLabel setFont:[UIFont systemFontOfSize: 12]];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    
    return button;
}

+ (NSArray*)filterBySelectedSubCategoryIdList:(NSArray*)list selectedSubCategoryIdList:(NSArray*)selectedSubCategoryIdList
{
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];    
    
    //filter by selectedCategoryId
    for (NSNumber *selectedSubCategoryId in selectedSubCategoryIdList) {
        if ([selectedSubCategoryId intValue] == ALL_CATEGORY) {
            return list;
        }
        
        for (Place *place in list) {
            if ([selectedSubCategoryId intValue] == [place subCategoryId])
            {
                [array addObject:place];
            }
        }
    }
    
    return array;
}

+ (NSArray*)filterBySelectedPriceIdList:(NSArray*)placeList selectedPriceIdList:(NSArray*)selectedPriceIdList
{
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];    
    
    for (NSNumber *selectedPriceId in selectedPriceIdList)
    {
        PPDebug(@"selectedPriceList:%d",[selectedPriceId intValue]);
        if ([selectedPriceId intValue] == ALL_CATEGORY) {
            return placeList;
        }
    }
    
    for (Place *place in placeList) {
        PPDebug(@"place priceRank:%d",place.priceRank);
        for (NSNumber *number in selectedPriceIdList) {
            if (place.priceRank == number.intValue) {
                [array addObject:place];
                break;
            }
        }
    }

    return array;
}

+ (NSArray*)filterBySelectedAreaIdList:(NSArray*)placeList selectedAreaIdList:(NSArray*)selectedAreaIdList
{
    for (NSNumber *selectedAreaId in selectedAreaIdList)
    {
        if ([selectedAreaId intValue] == ALL_CATEGORY) {
            return placeList;
        }
    }
    
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    for (Place *place in placeList) {
        for (NSNumber *number in selectedAreaIdList) {
            if (number.intValue == place.areaId) {
                [array addObject:place];
                break;
            }
        }
    }
    return array;
}

+ (NSArray*)filterBySelectedServiceIdList:(NSArray*)placeList selectedServiceIdList:(NSArray*)selectedServiceIdList
{
    for (NSNumber *selectedServiceId in selectedServiceIdList)
    {
        if ([selectedServiceId intValue] == ALL_CATEGORY) {
            return placeList;
        }
    }
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    BOOL found = NO;
    for (Place *place in placeList) {
        for (NSNumber *selectedNumber in selectedServiceIdList) {
            for (NSNumber *placeServiceId in place.providedServiceIdList) {
                if (selectedNumber.intValue == placeServiceId.intValue) {
                    [array addObject:place];
                    found = YES;
                    break;
                }
            }
            if (found) {
                break;
            }
        }
    }
    
    return array;
}

+ (NSArray*)sortBySelectedSortId:(NSArray*)placeList selectedSortId:(NSNumber*)selectedSortId currentLocation:(CLLocation*)currentLocation
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
            break;
            
        case SORT_BY_PRICE_FORM_EXPENSIVE_TO_CHEAP:
            array = [placeList sortedArrayUsingComparator:^NSComparisonResult(id place1, id place2){
                float price1 = [[place1 price] floatValue];
                float price2 = [[place2 price] floatValue] ;
                
                if (price1 < price2)
                    return NSOrderedDescending;
                else  if (price1 > price2)
                    return NSOrderedAscending;
                else return NSOrderedSame;
            }];
            break;
            
        case SORT_BY_PRICE_FORM_CHEAP_TO_EXPENSIVE:
            array = [placeList sortedArrayUsingComparator:^NSComparisonResult(id place1, id place2){
                float price1 = [[place1 price] floatValue];
                float price2 = [[place2 price] floatValue] ;
                
                if (price1 < price2)
                    return NSOrderedAscending;
                else  if (price1 > price2)
                    return NSOrderedDescending;
                else return NSOrderedSame;
            }];
            break;
            
        case SORT_BY_DESTANCE_FROM_NEAR_TO_FAR:
            array = [PlaceUtils sortedByDistance:currentLocation array:placeList type:[selectedSortId intValue]];
            
//            [placeList sortedArrayUsingComparator:^NSComparisonResult(id place1, id place2){
//                CLLocation *place1Location = [[CLLocation alloc] initWithLatitude:[place1 latitude] longitude:[place1 longitude]];
//                CLLocation *place2Location = [[CLLocation alloc] initWithLatitude:[place2 latitude] longitude:[place2 longitude]];
//                CLLocationDistance distance1 = [currentLocation distanceFromLocation:place1Location];
//                CLLocationDistance distance2 = [currentLocation distanceFromLocation:place2Location];
//                [place1Location release];
//                [place2Location release];
//                
//                if (distance1 < distance2)
//                    return NSOrderedAscending;
//                else  if (distance1 > distance2)
//                    return NSOrderedDescending;
//                else return NSOrderedSame;
//            }];
            break;
            
        case SORT_BY_STARTS:
            array = [placeList sortedArrayUsingComparator:^NSComparisonResult(id place1, id place2){
                int rank1 = [place1 hotelStar];
                int rank2 = [place2 hotelStar];
                
                if (rank1 < rank2)
                    return NSOrderedDescending;
                else  if (rank1 > rank2)
                    return NSOrderedAscending;
                else return NSOrderedSame;
            }];
            break;
            
        default:
            break;
    }
    
    return array;
}

@end
