//
//  CityBasicDataSource.m
//  Travel
//
//  Created by  on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CityBasicDataSource.h"
#import "AppManager.h"

@implementation CityBasicDataSource

- (NSString*)getTitleName
{
    return NSLS(@"城市概况");
}

- (void)requestDataWithDelegate:(PPViewController<CityOverviewServiceDelegate>*)delegate
{
    int currentyCityId = [[AppManager defaultManager] getCurrentCityId];
    [[CityOverviewService defaultService] findCommonOverView:currentyCityId 
                                                        type:CommonOverviewTypeCityBasic 
                                                    delegate:delegate];
}

+ (NSObject<CommonInfoDataSourceProtocol>*)createDataSource
{
    CityBasicDataSource* obj = [[[CityBasicDataSource alloc] init] autorelease];    
    return obj;
}


@end
