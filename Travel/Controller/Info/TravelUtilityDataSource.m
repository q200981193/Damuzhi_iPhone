//
//  TravelUtilityDataSource.m
//  Travel
//
//  Created by gckj on 12-4-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TravelUtilityDataSource.h"
#import "AppManager.h"

@implementation TravelUtilityDataSource

- (NSString*)getTitleName
{
    return NSLS(@"实用信息");
}

- (void)requestDataWithDelegate:(PPViewController<CityOverviewServiceDelegate>*)delegate
{
    int currentyCityId = [[AppManager defaultManager] getCurrentCityId];
    [[CityOverviewService defaultService] findCommonOverView:currentyCityId 
                                                        type:CommonOverviewTypeTravelUtility 
                                                    delegate:delegate];
}

+ (NSObject<CommonWebDataSourceProtocol>*)createDataSource
{
    TravelUtilityDataSource* obj = [[[TravelUtilityDataSource alloc] init] autorelease];    
    return obj;
}

@end
