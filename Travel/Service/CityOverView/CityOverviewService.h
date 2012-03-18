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

@interface CityOverViewService : CommonService
{
    NSString        *_currentCityId;

    CityOverViewManager *_localCityOverViewManager;
    CityOverViewManager *_onlineCityOverViewManager;
}

@property (retain, nonatomic) NSString *currentCityId;

+ (CityOverViewService*)defaultService;

//- (void)findCityBasic:(PPViewController*)viewController;
//- (void)findTravelPrepration:(PPViewController*)viewController;
//- (void)findTravelUtility:(PPViewController*)viewController;
//- (void)findTravelTransportation:(PPViewController*)viewController;

@end
