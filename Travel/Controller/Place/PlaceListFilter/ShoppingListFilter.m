//
//  ShoppingListFilter.m
//  Travel
//
//  Created by haodong qiu on 12年3月30日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "ShoppingListFilter.h"
#import "PlaceManager.h"
#import "PlaceService.h"
#import "LogUtil.h"
#import "CommonListFilter.h"

@implementation ShoppingListFilter
@synthesize controller;

- (void)dealloc
{
    [controller release];
    [super dealloc];
}

#pragma - mark PlaceListFilterProtocol
#define FILTER_BUTTON_WIDTH 58
#define FILTER_BUTTON_HEIGHT 36
- (void)createFilterButtons:(UIView*)superView controller:(PPTableViewController*)commonPlaceController
{
    superView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"2menu_bg.png"]];
    
    CGRect frame1 = CGRectMake(0, 0, FILTER_BUTTON_WIDTH, FILTER_BUTTON_HEIGHT);
    CGRect frame2 = CGRectMake(FILTER_BUTTON_WIDTH, 0, FILTER_BUTTON_WIDTH, FILTER_BUTTON_HEIGHT);

    UIButton *button1 = [CommonListFilter createFilterButton:frame1 title:NSLS(@"区域")];
    UIButton *button2 = [CommonListFilter createFilterButton:frame2 title:NSLS(@"排序")];
        
    [button1 addTarget:commonPlaceController action:@selector(clickArea:) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:commonPlaceController action:@selector(clickSortButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [superView addSubview:button1];
    [superView addSubview:button2];
    
    self.controller = commonPlaceController;
}

- (void)findAllPlaces:(PPViewController<PlaceServiceDelegate>*)viewController
{
    return [[PlaceService defaultService] findPlacesByCategoryId:viewController categoryId:[self getCategoryId]];
}

+ (NSObject<PlaceListFilterProtocol>*)createFilter
{
    ShoppingListFilter* filter = [[[ShoppingListFilter alloc] init] autorelease];
    return filter;
}

- (int)getCategoryId
{
    return PLACE_TYPE_SHOPPING;
}

- (NSString*)getCategoryName
{
    return NSLS(@"购物");
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
    NSArray *afterAreaFilter = [CommonListFilter filterByAreaList:placeList selectedPriceList:selectedAreaIdList];
    NSArray *resultList = [CommonListFilter sortBySelectedSortId:afterAreaFilter selectedSortId:selectedSortId currentLocation:currentLocation];
    return resultList;
}

@end
