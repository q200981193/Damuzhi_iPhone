//
//  TravelUtilityDataSource.m
//  Travel
//
//  Created by gckj on 12-4-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TravelUtilityDataSource.h"
#import "CityOverviewManager.h"
#import "AppManager.h"

@implementation TravelUtilityDataSource

- (NSString*)getTitleName
{
    return NSLS(@"实用信息");
}

- (void)requestDataWithDelegate:(PPViewController<CityOverviewServiceDelegate>*)delegate
{
    [[CityOverviewService defaultService]findTravelUtility:[[AppManager defaultManager] getCurrentCityId] delegate:delegate];
}

+ (NSObject<CommonInfoDataSourceProtocol>*)createDataSource
{
    TravelUtilityDataSource* obj = [[[TravelUtilityDataSource alloc] init] autorelease];    
    return obj;
}

@end
