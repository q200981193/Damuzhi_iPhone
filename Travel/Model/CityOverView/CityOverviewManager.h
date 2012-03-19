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


//message CityOverview {
//    optional CommonOverview cityBasic = 1;               // 城市概况
//    optional CommonOverview travelPrepration = 2;        // 旅行准备
//    optional CommonOverview travelUtility = 3;           // 实用信息
//    optional CommonOverview travelTransportation = 4;    // 城市交通
//    
//    repeated CityArea areaList = 5;                      // 城市区域列表，二级列表
//    
//    required string currencySymbol = 6;                  // 货币显示符号，如人民币为¥，美元为$
//    required string currencyId = 7;                      // 货币ID，用于实时汇率查询，使用国际标准，如人民币为CNY，美元为USD
//    required string currencyName = 8;                    // 货币显示名字，如“人民币”，“美元”，“欧元”
//    
//    optional int32 priceRank = 9 [default=3];            // 城市查询价格等级，默认为3
//}

- (NSString*)getCurrencySymbol;
- (NSArray*)getCityArea;

- (BOOL)hasLocalCityData:(NSString*)cityId;
- (void)switchCity:(NSString*)newCity;

@end
