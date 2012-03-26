//
//  HoteListFilter.m
//  Travel
//
//  Created by 小涛 王 on 12-3-12.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "HotelListFilter.h"
#import "PlaceManager.h"
#import "PlaceService.h"
#import "LogUtil.h"

@implementation HotelListFilter
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

-(NSArray*)sortBySelectedSortId:(NSArray*)placeList selectedSortId:(NSNumber*)selectedSortId
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
            ;
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

-(NSArray*)filterByCategoryIdList:(NSArray*)list selectedCategoryIdList:(NSArray*)selectedCategoryIdList
{
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];    
    
    //filter by selectedCategoryId
    for (NSNumber *selectedCategoryId in selectedCategoryIdList) {
        if ([selectedCategoryId intValue] == -1) {
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


#pragma Protocol Implementations

#define FILTER_BUTTON_WIDTH 58
#define FILTER_BUTTON_HEIGHT 36
- (void)createFilterButtons:(UIView*)superView controller:(PPTableViewController *)commonPlaceController
{
    superView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"2menu_bg.png"]];
    
    CGRect frame1 = CGRectMake(0, 0, FILTER_BUTTON_WIDTH, FILTER_BUTTON_HEIGHT);
    CGRect frame2 = CGRectMake(FILTER_BUTTON_WIDTH, 0, FILTER_BUTTON_WIDTH, FILTER_BUTTON_HEIGHT);
    CGRect frame3 = CGRectMake(FILTER_BUTTON_WIDTH*2, 0, FILTER_BUTTON_WIDTH, FILTER_BUTTON_HEIGHT);
    CGRect frame4 = CGRectMake(FILTER_BUTTON_WIDTH*3, 0, FILTER_BUTTON_WIDTH, FILTER_BUTTON_HEIGHT);
    
    
    UIButton *buttonPrice = [self createFilterButton:frame1 title:@"价格" bgImageForNormalState:@"2menu_btn.png" bgImageForHeightlightState:@"2menu_btn_on.png"];
    UIButton *buttonArea = [self createFilterButton:frame2 title:@"区域" bgImageForNormalState:@"2menu_btn.png" bgImageForHeightlightState:@"2menu_btn_on.png"];
    UIButton *buttonService = [self createFilterButton:frame3 title:@"服务" bgImageForNormalState:@"2menu_btn.png" bgImageForHeightlightState:@"2menu_btn_on.png"];
    UIButton *buttonSort = [self createFilterButton:frame4 title:@"排序" bgImageForNormalState:@"2menu_btn.png" bgImageForHeightlightState:@"2menu_btn_on.png"];
    
    [buttonPrice addTarget:commonPlaceController
                   action:@selector(clickPrice:) 
         forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [superView addSubview:buttonPrice];
    [superView addSubview:buttonArea];
    [superView addSubview:buttonService];
    [superView addSubview:buttonSort];
    
    self.controller = commonPlaceController;
}

- (void)findAllPlaces:(PPViewController<PlaceServiceDelegate>*)viewController
{
    return [[PlaceService defaultService] findAllHotels:viewController];
}

+ (NSObject<PlaceListFilterProtocol>*)createFilter
{
    HotelListFilter* filter = [[[HotelListFilter alloc] init] autorelease];
    return filter;
}

- (int)getCategoryId
{
    return PLACE_TYPE_HOTEL; 
}

- (NSString*)getCategoryName
{
    return NSLS(@"酒店");
}

- (BOOL)hasNumberInArrary:(NSArray *)array NumberIntValue:(int)keyInt
{
    for (NSNumber *number in array) {
        if ([number intValue] == keyInt) {
            return YES;
        }
    }
     
    return NO;
}

-(NSArray*)filterByPriceList:(NSArray*)placeList selectedPriceList:(NSArray*)selectedPriceList
{
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];    

    
    for (NSNumber *selectedPriceId in selectedPriceList)
    {
        PPDebug(@"selectedPriceList:%d",[selectedPriceId intValue]);
        if ([selectedPriceId intValue] == PRICE_ALL) {
            return placeList;
        }
    }

    for (Place *place in placeList) {
        if ([place.price intValue] < 500 && [self hasNumberInArrary:selectedPriceList NumberIntValue:PRICE_BELOW_500]) {
            [array addObject:place];
        }
        
        else if ([place.price intValue] >= 500 && [place.price intValue] < 1000 && [self hasNumberInArrary:selectedPriceList NumberIntValue:PRICE_500_1000]){
            [array addObject:place];
        }
        
        else if ([place.price intValue] >= 1000 && [place.price intValue] < 1500 && [self hasNumberInArrary:selectedPriceList NumberIntValue:PRICE_1000_1500]){
            [array addObject:place];
        }
        
        else if ([place.price intValue] >= 1500 && [self hasNumberInArrary:selectedPriceList NumberIntValue:PRICE_MORE_THAN_1500]){
            [array addObject:place];
        }
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
{
    //return [self sortBySelectedSortId:[self filterByCategoryIdList:placeList selectedCategoryIdList:selectedCategoryIdList] selectedSortId:selectedSortId];
    
    return [self sortBySelectedSortId:[self filterByPriceList:placeList selectedPriceList:selectedPriceIdList] selectedSortId:selectedSortId];
}

@end
