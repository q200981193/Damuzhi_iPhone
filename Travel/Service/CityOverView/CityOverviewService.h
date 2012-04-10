//
//  CityOverViewCity.h
//  Travel
//
//  Created by 小涛 王 on 12-3-17.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "CommonService.h"
#import "CityOverViewManager.h"
#import "PPViewController.h"
#import "CityOverview.pb.h"


@protocol CityOverviewServiceDelegate <NSObject>

@optional
- (void)findOverviewRequestDone:(int)result overview:(CommonOverview*)overView;
@end

@interface CityOverviewService : CommonService
{
    CityOverViewManager *_localCityOverViewManager;
    CityOverViewManager *_onlineCityOverViewManager;
}

+ (CityOverviewService*)defaultService;

- (void)findCityBasic:(int)cityId delegate:(PPViewController<CityOverviewServiceDelegate>*)viewController;
- (void)findCityConfig:(int)cityId delegate:(PPViewController<CityOverviewServiceDelegate>*)viewController;
- (void)findTravelUtility:(int)cityId delegate:(PPViewController<CityOverviewServiceDelegate>*)viewController;
- (void)findTravelTransportation:(int)cityId delegate:(PPViewController<CityOverviewServiceDelegate>*)viewController;

@end
