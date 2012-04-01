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
    int        _currentCityId;

    CityOverViewManager *_localCityOverViewManager;
    CityOverViewManager *_onlineCityOverViewManager;
}

@property (nonatomic, assign) int currentCityId;

+ (CityOverViewService*)defaultService;

//- (void)findCityBasic:(PPViewController*)viewController;
//- (void)findTravelPrepration:(PPViewController*)viewController;
//- (void)findTravelUtility:(PPViewController*)viewController;
//- (void)findTravelTransportation:(PPViewController*)viewController;

- (void)findCityBasic:(int)cityId delegate:(PPViewController<CommonOverViewServiceDelegate>*)viewController;

@end
