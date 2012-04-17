//
//  CityConfigDataSource.m
//  Travel
//
//  Created by gckj on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TravelPreparationDataSource.h"
#import "CityOverviewManager.h"
#import "AppManager.h"

@implementation TravelPreparationDataSource

- (NSString*)getTitleName
{
    return NSLS(@"旅行准备");
}

- (void)requestDataWithDelegate:(PPViewController<CityOverviewServiceDelegate>*)delegate
{
    [[CityOverviewService defaultService]findTravelPreparation:[[AppManager defaultManager] getCurrentCityId] delegate:delegate];
    
}

+ (NSObject<CommonInfoDataSourceProtocol>*)createDataSource
{
    TravelPreparationDataSource* obj = [[[TravelPreparationDataSource alloc] init] autorelease];    
    return obj;
}

@end
