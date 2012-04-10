//
//  TravelTransportDataSource.m
//  Travel
//
//  Created by gckj on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TravelTransportDataSource.h"
#import "CityOverviewManager.h"
#import "AppManager.h"

@implementation TravelTransportDataSource

- (NSString*)getTitleName
{
    return NSLS(@"城市交通");
}

- (void)requestDataWithDelegate:(PPViewController<CityOverviewServiceDelegate>*)delegate
{
    [[CityOverviewService defaultService]findTravelTransportation:[[AppManager defaultManager] getCurrentCityId] delegate:delegate];
    
}

+ (NSObject<CommonInfoDataSourceProtocol>*)createDataSource
{
    TravelTransportDataSource* obj = [[[TravelTransportDataSource alloc] init] autorelease];    
    return obj;
}

@end
