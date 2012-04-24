//
//  CityConfigDataSource.m
//  Travel
//
//  Created by gckj on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TravelPreparationDataSource.h"
#import "AppManager.h"

@implementation TravelPreparationDataSource

- (NSString*)getTitleName
{
    return NSLS(@"旅行准备");
}

- (void)requestDataWithDelegate:(PPViewController<CityOverviewServiceDelegate>*)delegate
{
    int currentyCityId = [[AppManager defaultManager] getCurrentCityId];
    [[CityOverviewService defaultService] findCommonOverView:currentyCityId 
                                                        type:CommonOverviewTypeTravelPrepration 
                                                    delegate:delegate];    
}

+ (NSObject<CommonWebDataSourceProtocol>*)createDataSource
{
    TravelPreparationDataSource* obj = [[[TravelPreparationDataSource alloc] init] autorelease];    
    return obj;
}

@end
