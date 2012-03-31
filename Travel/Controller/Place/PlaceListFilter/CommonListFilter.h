//
//  CommonListFilter.h
//  Travel
//
//  Created by haodong qiu on 12年3月30日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonPlaceListController.h"

@interface CommonListFilter : NSObject

+ (UIButton*)createFilterButton:(CGRect)frame title:(NSString*)title;

+ (NSArray*)filterByCategoryIdList:(NSArray*)list selectedCategoryIdList:(NSArray*)selectedCategoryIdList;
+ (NSArray*)filterByPriceList:(NSArray*)placeList selectedPriceList:(NSArray*)selectedPriceList;
+ (NSArray*)filterByAreaList:(NSArray*)placeList selectedPriceList:(NSArray*)selectedAreaIdList;
+ (NSArray*)filterByServiceList:(NSArray*)placeList selectedServiceIdList:(NSArray*)selectedServiceIdList;
+ (NSArray*)sortBySelectedSortId:(NSArray*)placeList selectedSortId:(NSNumber*)selectedSortId currentLocation:(CLLocation*)currentLocation;

@end
