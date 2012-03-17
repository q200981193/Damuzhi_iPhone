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
    NSString        *_city;
    CityOverview    *cityOverView;
}

@property (retain, nonatomic) NSString *city;
@property (retain, nonatomic) CityOverview *cityOverView;

- (NSString*)getCurrencySymbol;
- (NSArray*)getCityArea;

- (BOOL)hasLocalCityData:(NSString*)cityId;
- (void)switchCity:(NSString*)newCity;

@end
