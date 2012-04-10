//
//  CityConfigDataSource.m
//  Travel
//
//  Created by gckj on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CityConfigDataSource.h"
#import "CityOverviewManager.h"
#import "AppManager.h"

@implementation CityConfigDataSource

- (NSString*)getTitleName
{
    return NSLS(@"旅行准备");
}

- (void)requestDataWithDelegate:(PPViewController<CityOverviewServiceDelegate>*)delegate
{
    [[CityOverviewService defaultService]findCityConfig:[[AppManager defaultManager] getCurrentCityId] delegate:delegate];
    
}

+ (NSObject<CommonInfoDataSourceProtocol>*)createDataSource
{
    CityConfigDataSource* obj = [[[CityConfigDataSource alloc] init] autorelease];    
    return obj;
}

@end
