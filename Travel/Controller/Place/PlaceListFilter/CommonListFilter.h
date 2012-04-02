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
+ (NSArray*)filterBySelectedSubCategoryIdList:(NSArray*)list selectedSubCategoryIdList:(NSArray*)selectedSubCategoryIdList;
+ (NSArray*)filterBySelectedPriceIdList:(NSArray*)placeList selectedPriceIdList:(NSArray*)selectedPriceIdList;
+ (NSArray*)filterBySelectedAreaIdList:(NSArray*)placeList selectedAreaIdList:(NSArray*)selectedAreaIdList;
+ (NSArray*)filterBySelectedServiceIdList:(NSArray*)placeList selectedServiceIdList:(NSArray*)selectedServiceIdList;
+ (NSArray*)sortBySelectedSortId:(NSArray*)placeList selectedSortId:(NSNumber*)selectedSortId currentLocation:(CLLocation*)currentLocation;

@end
