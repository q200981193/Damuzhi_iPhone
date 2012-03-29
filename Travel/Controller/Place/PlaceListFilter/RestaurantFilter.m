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
    
    
    UIButton *buttonPrice = [self createFilterButton:frame1 title:NSLS(@"菜系") bgImageForNormalState:@"2menu_btn.png" bgImageForHeightlightState:@"2menu_btn_on.png"];
    UIButton *buttonArea = [self createFilterButton:frame2 title:NSLS(@"区域") bgImageForNormalState:@"2menu_btn.png" bgImageForHeightlightState:@"2menu_btn_on.png"];
    UIButton *buttonService = [self createFilterButton:frame3 title:NSLS(@"服务") bgImageForNormalState:@"2menu_btn.png" bgImageForHeightlightState:@"2menu_btn_on.png"];
    UIButton *buttonSort = [self createFilterButton:frame4 title:NSLS(@"排序") bgImageForNormalState:@"2menu_btn.png" bgImageForHeightlightState:@"2menu_btn_on.png"];
    
//    [buttonPrice addTarget:commonPlaceController
//                    action:nil
//          forControlEvents:UIControlEventTouchUpInside];
//    
//    [buttonArea addTarget:commonPlaceController
//                   action:nil
//         forControlEvents:UIControlEventTouchUpInside];
//    
//    [buttonService addTarget:commonPlaceController
//                      action:nil
//            forControlEvents:UIControlEventTouchUpInside];
//    
//    [buttonSort addTarget:commonPlaceController
//                   action:nil
//         forControlEvents:UIControlEventTouchUpInside];
    
    
    [superView addSubview:buttonPrice];
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

- (NSArray*)filterAndSotrPlaceList:(NSArray*)placeList
selectedCategoryIdList:(NSArray*)selectedCategoryIdList 
selectedPriceIdList:(NSArray*)selectedPriceIdList 
selectedAreaIdList:(NSArray*)selectedAreaIdList 
selectedServiceIdList:(NSArray*)selectedServiceIdList
selectedCuisineIdList:(NSArray*)selectedCuisineIdList
sortBy:(NSNumber*)selectedSortId
currentLocation:(CLLocation*)currentLocation
{
    return placeList;
}

@end
