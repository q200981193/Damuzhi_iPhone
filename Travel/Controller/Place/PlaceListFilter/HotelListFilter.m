//
//  HoteListFilter.m
//  Travel
//
//  Created by 小涛 王 on 12-3-12.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "HotelListFilter.h"
#import "CommonPlace.h"
#import "PlaceService.h"
#import "LogUtil.h"
#import "CommonListFilter.h"
#import "App.pb.h"
#import "AppService.h"

@implementation HotelListFilter
@synthesize controller;

- (void)dealloc
{
    [controller release];
    [super dealloc];
}

#pragma - mark PlaceListFilterProtocol
- (void)createFilterButtons:(UIView*)superView controller:(PPTableViewController*)commonPlaceController
{
    CGRect frame = CGRectMake(0, superView.frame.size.height/2-HEIGHT_OF_FILTER_BUTTON/2, WIDTH_OF_FILTER_BUTTON, HEIGHT_OF_FILTER_BUTTON);
    
    frame.origin.x += 10;
    UIButton *button1 = [CommonListFilter createFilterButton:frame title:NSLS(@"价格")];
    [button1 addTarget:commonPlaceController action:@selector(clickPrice:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:button1];

    frame.origin.x += WIDTH_OF_FILTER_BUTTON+DISTANCE_BETWEEN_BUTTONS;
    UIButton *button2 = [CommonListFilter createFilterButton:frame title:NSLS(@"区域")];
    [button2 addTarget:commonPlaceController action:@selector(clickArea:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:button2];
    
    frame.origin.x += WIDTH_OF_FILTER_BUTTON+DISTANCE_BETWEEN_BUTTONS;
    UIButton *button3 = [CommonListFilter createFilterButton:frame title:NSLS(@"服务")];
    [button3 addTarget:commonPlaceController action:@selector(clickService:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:button3];

    frame.origin.x += WIDTH_OF_FILTER_BUTTON+DISTANCE_BETWEEN_BUTTONS;
    UIButton *button4 = [CommonListFilter createFilterButton:frame title:NSLS(@"排序")];
    [button4 addTarget:commonPlaceController action:@selector(clickSortButton:) forControlEvents:UIControlEventTouchUpInside];
    button4.tag = SORT_BUTTON_TAG;
    [superView addSubview:button4];
    
    self.controller = commonPlaceController;
}

- (void)findAllPlaces:(PPViewController<PlaceServiceDelegate>*)viewController
{
    return [[PlaceService defaultService] findPlaces:[self getCategoryId]  viewController:viewController];
}

+ (NSObject<PlaceListFilterProtocol>*)createFilter
{
    HotelListFilter* filter = [[[HotelListFilter alloc] init] autorelease];
    return filter;
}

- (int)getCategoryId
{
    return PlaceCategoryTypePlaceHotel;
}

- (NSString*)getCategoryName
{
    return NSLS(@"酒店");
}

- (NSArray*)filterAndSotrPlaceList:(NSArray*)placeList selectedItems:(SelectedItems *)selectedItems
{
    CLLocation *currentLocation = [[AppService defaultService] currentLocation];
    
    NSArray *afterPriceFilter = [CommonListFilter filterBySelectedPriceIdList:placeList selectedPriceIdList:selectedItems.selectedPriceIdList];
    NSArray *afterAreaFilter = [CommonListFilter filterBySelectedAreaIdList:afterPriceFilter selectedAreaIdList:selectedItems.selectedAreaIdList];
    NSArray *afterServiceFilter = [CommonListFilter filterBySelectedServiceIdList:afterAreaFilter selectedServiceIdList:selectedItems.selectedServiceIdList];
    NSArray *resultList = [CommonListFilter sortBySelectedSortId:afterServiceFilter selectedSortId:[selectedItems.selectedSortIdList objectAtIndex:0] currentLocation:currentLocation];
    return resultList;
}

@end
