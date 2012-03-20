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

@implementation SpotListFilter
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
    superView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"2menu_bg.png"]];
    
    CGRect frame1 = CGRectMake(0, 0, 58, 36);
    CGRect frame2 = CGRectMake(58, 0, 58, 36);
    
    UIButton *buttonCategory = [self createFilterButton:frame1 title:NSLS(@"分类") bgImageForNormalState:@"2menu_btn.png" bgImageForHeightlightState:@"2menu_btn_on.png"];
    
    UIButton *buttonSort = [self createFilterButton:frame2 title:NSLS(@"排序") bgImageForNormalState:@"2menu_btn.png" bgImageForHeightlightState:@"2menu_btn_on.png"];
    
    [buttonSort addTarget:commonPlaceController
                   action:@selector(clickSortButton:) 
         forControlEvents:UIControlEventTouchUpInside];
    
    [buttonCategory addTarget:commonPlaceController 
                       action:@selector(clickCategoryButton:) 
             forControlEvents:UIControlEventTouchUpInside];
    
    [superView addSubview:buttonCategory];
    [superView addSubview:buttonSort];

    self.controller = commonPlaceController;
    
}

+ (NSObject<PlaceListFilterProtocol>*)createFilter
{
    SpotListFilter* filter = [[[SpotListFilter alloc] init] autorelease];
    return filter;
}

- (void)findAllPlaces:(PPViewController<PlaceServiceDelegate>*)viewController
{
    return [[PlaceService defaultService] findAllSpots:viewController];
}

-(NSArray*)filterByCategoryIds:(NSArray*)list selectedCategoryIds:(NSArray*)selectedCategoryIds
{
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];    
    
    //filter by selectedCategoryId
    for (NSNumber *selectedCategoryId in selectedCategoryIds) {
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

-(NSInteger)ComparePlaceByRecommend:(id)place1 place2:(id)place2 context:(void *)context
{
    int rank1 = [place1 rank];
    int rank2 = [place2 rank];
    
    if (rank1 < rank2)
        return NSOrderedAscending;
    else  if (rank1 > rank2)
        return NSOrderedDescending;
    else return NSOrderedSame;
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

- (NSArray*)filterAndSotrPlaces:(NSArray*)placeList
            selectedCategoryIds:(NSArray*)selectedCategoryIds 
               selectedPriceIds:(NSArray*)selectedPriceIds 
                selectedAreaIds:(NSArray*)selectedAreaIds 
             selectedServiceIds:(NSArray*)selectedServiceIds
             selectedCuisineIds:(NSArray*)selectedCuisineIds
                         sortBy:(NSNumber*)selectedSortId;
{
    return [self sortBySelectedSortId:[self filterByCategoryIds:placeList selectedCategoryIds:selectedCategoryIds]selectedSortId:selectedSortId];
}

@end
