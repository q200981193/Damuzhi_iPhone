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

@property (assign, nonatomic) int cityId;
@property (retain, nonatomic) CommonOverview *cityBasic;                  // 城市概况
@property (retain, nonatomic) CommonOverview *travelPrepration;           // 旅行准备
@property (retain, nonatomic) CommonOverview *travelUtility;              // 实用信息
@property (retain, nonatomic) CommonOverview *travelTransportation ;      // 城市交通

- (void)switchCity:(int)newCity;

- (CommonOverview*)getCommonOverview:(CommonOverviewType)type;

@end
