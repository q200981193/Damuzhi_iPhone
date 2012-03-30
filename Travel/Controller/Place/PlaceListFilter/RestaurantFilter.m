//
//  RestaurantFilter.m
//  Travel
//
//  Created by haodong qiu on 12年3月29日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "RestaurantFilter.h"
#import "PlaceManager.h"
#import "PlaceService.h"
#import "LogUtil.h"

@implementation RestaurantFilter
@synthesize controller;

- (void)dealloc
{
    [controller release];
    [super dealloc];
}

- (UIButton*)createFilterButton:(CGRect)frame title:(NSString*)title bgImageForNormalState:(NSString*)bgImageForNormalState bgImageForHeightlightState:(NSString*)bgImageForHeightlightState 
{
    UIImage *bgImageForNormal = [UIImage imageNamed:bgImageForNormalState];
    UIImage *bgImageForHeightlight = [UIImage imageNamed:bgImageForHeightlightState];
    
    UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundImage:bgImageForNormal forState:UIControlStateNormal];
    [button setBackgroundImage:bgImageForHeightlight forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize: 15];
    
    return button;
}

#pragma - mark PlaceListFilterProtocol
#define FILTER_BUTTON_WIDTH 58
#define FILTER_BUTTON_HEIGHT 36
- (void)createFilterButtons:(UIView*)superView controller:(PPTableViewController*)commonPlaceController
{
    superView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"2menu_bg.png"]];
    
    CGRect frame1 = CGRectMake(0, 0, FILTER_BUTTON_WIDTH, FILTER_BUTTON_HEIGHT);
    CGRect frame2 = CGRectMake(FILTER_BUTTON_WIDTH, 0, FILTER_BUTTON_WIDTH, FILTER_BUTTON_HEIGHT);
    CGRect frame3 = CGRectMake(FILTER_BUTTON_WIDTH*2, 0, FILTER_BUTTON_WIDTH, FILTER_BUTTON_HEIGHT);
    CGRect frame4 = CGRectMake(FILTER_BUTTON_WIDTH*3, 0, FILTER_BUTTON_WIDTH, FILTER_BUTTON_HEIGHT);
    
    
    UIButton *buttonCuisine = [self createFilterButton:frame1 title:NSLS(@"菜系") bgImageForNormalState:@"2menu_btn.png" bgImageForHeightlightState:@"2menu_btn_on.png"];
    UIButton *buttonArea = [self createFilterButton:frame2 title:NSLS(@"区域") bgImageForNormalState:@"2menu_btn.png" bgImageForHeightlightState:@"2menu_btn_on.png"];
    UIButton *buttonService = [self createFilterButton:frame3 title:NSLS(@"服务") bgImageForNormalState:@"2menu_btn.png" bgImageForHeightlightState:@"2menu_btn_on.png"];
    UIButton *buttonSort = [self createFilterButton:frame4 title:NSLS(@"排序") bgImageForNormalState:@"2menu_btn.png" bgImageForHeightlightState:@"2menu_btn_on.png"];
    
    [buttonCuisine addTarget:commonPlaceController
                    action:@selector(clickCategoryButton:)
          forControlEvents:UIControlEventTouchUpInside];
    
    [buttonArea addTarget:commonPlaceController
                   action:@selector(clickArea:)
         forControlEvents:UIControlEventTouchUpInside];
    
    [buttonService addTarget:commonPlaceController
                      action:@selector(clickService:)
            forControlEvents:UIControlEventTouchUpInside];
    
    [buttonSort addTarget:commonPlaceController
                   action:@selector(clickSortButton:)
         forControlEvents:UIControlEventTouchUpInside];
    
    
    [superView addSubview:buttonCuisine];
    [superView addSubview:buttonArea];
    [superView addSubview:buttonService];
    [superView addSubview:buttonSort];
    
    self.controller = commonPlaceController;
}
- (void)findAllPlaces:(PPViewController<PlaceServiceDelegate>*)viewController
{
    return [[PlaceService defaultService] findPlacesByCategoryId:viewController categoryId:[self getCategoryId]];
    //return [[PlaceService defaultService] findAllRestaurants:viewController];
}

+ (NSObject<PlaceListFilterProtocol>*)createFilter
{
    RestaurantFilter* filter = [[[RestaurantFilter alloc] init] autorelease];
    return filter;
}

- (int)getCategoryId
{
    return PLACE_TYPE_RESTAURANT;
}

- (NSString*)getCategoryName
{
    return NSLS(@"餐馆");
}


#pragma -mark filter
- (NSArray*)filterByCategoryIdList:(NSArray*)list selectedCategoryIdList:(NSArray*)selectedCategoryIdList
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

-(NSArray*)filterByAreaList:(NSArray*)placeList selectedPriceList:(NSArray*)selectedAreaIdList
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

-(NSArray*)filterByServiceList:(NSArray*)placeList selectedServiceIdList:(NSArray*)selectedServiceIdList
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
            
        case SORT_BY_PRICE_FORM_CHEAP_TO_EXPENSIVE:
            array = [placeList sortedArrayUsingComparator:^NSComparisonResult(id place1, id place2){
                int price1 = [[place1 price] floatValue];
                int price2 = [[place2 price] floatValue] ;
                
                if (price1 < price2)
                    return NSOrderedAscending;
                else  if (price1 > price2)
                    return NSOrderedDescending;
                else return NSOrderedSame;
            }];
            break;
            
        case SORT_BY_DESTANCE_FROM_NEAR_TO_FAR:
            array = [placeList sortedArrayUsingComparator:^NSComparisonResult(id place1, id place2){
                CLLocation *place1Location = [[CLLocation alloc] initWithLatitude:[place1 latitude] longitude:[place1 longitude]];
                CLLocation *place2Location = [[CLLocation alloc] initWithLatitude:[place2 latitude] longitude:[place2 longitude]];
                CLLocationDistance distance1 = [currentLocation distanceFromLocation:place1Location];
                CLLocationDistance distance2 = [currentLocation distanceFromLocation:place2Location];
                [place1Location release];
                [place2Location release];
                
                if (distance1 < distance2)
                    return NSOrderedDescending;
                else  if (distance1 > distance2)
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
selectedCategoryIdList:(NSArray*)selectedCategoryIdList 
selectedPriceIdList:(NSArray*)selectedPriceIdList 
selectedAreaIdList:(NSArray*)selectedAreaIdList 
selectedServiceIdList:(NSArray*)selectedServiceIdList
selectedCuisineIdList:(NSArray*)selectedCuisineIdList
sortBy:(NSNumber*)selectedSortId
currentLocation:(CLLocation*)currentLocation
{


    NSArray *afterCategoryFilter = [self filterByCategoryIdList:placeList selectedCategoryIdList:selectedCategoryIdList];
    NSArray *afterAreaFilter = [self filterByAreaList:afterCategoryFilter selectedPriceList:selectedAreaIdList];
    NSArray *afterServiceFilter = [self filterByServiceList:afterAreaFilter selectedServiceIdList:selectedServiceIdList];
   NSArray *resultList = [self sortBySelectedSortId:afterServiceFilter selectedSortId:selectedSortId currentLocation:currentLocation];
    
    return resultList;
}

@end
