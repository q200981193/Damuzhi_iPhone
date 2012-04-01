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

@protocol CommonOverViewServiceDelegate <NSObject>

@optional
- (void)findRequestDone:(int)result data:(CommonOverview*)overViewData;
@end

@interface CityOverViewService : CommonService
{
    CityOverViewManager *_localCityOverViewManager;
    CityOverViewManager *_onlineCityOverViewManager;
}

+ (CityOverViewService*)defaultService;

- (void)findCityBasic:(int)cityId delegate:(PPViewController<CommonOverViewServiceDelegate>*)viewController;
- (void)findTravelUtility:(int)cityId delegate:(PPViewController<CommonOverViewServiceDelegate> *)viewController;
@end
