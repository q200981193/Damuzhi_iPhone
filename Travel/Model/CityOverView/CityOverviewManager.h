//
//  CityManager.h
//  Travel
//
//  Created by 小涛 王 on 12-3-14.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"
#import "CityOverview.pb.h"

@interface CityOverViewManager : NSObject <CommonManagerProtocol>
{
    int             _cityId;
    CityOverview    *cityOverView;
}

@property (assign, nonatomic) int          cityId;
@property (retain, nonatomic) CityOverview *cityOverView;

- (NSArray*)getCityBasicImageList;
- (NSString*)getCityBasicHtml;

- (NSString*)getTravelPreprationHtml;
- (NSString*)getTravelUtilityHtml;
- (NSString*)getTravelTransportationHtml;

- (NSArray*)getAreaList;
- (NSString*)getAreaName:(int)areaId;
- (NSString*)getCurrencySymbol;
- (NSString*)getCurrencyId;
- (NSString*)getCurrencyName;
- (int)getPriceRank;

- (void)switchCity:(int)newCity;

@end
