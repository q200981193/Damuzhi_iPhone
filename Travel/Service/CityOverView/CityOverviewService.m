//
//  CityOverViewCity.m
//  Travel
//
//  Created by 小涛 王 on 12-3-17.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "CityOverviewService.h"
#import "PPViewController.h"
#import "LogUtil.h"
#import "TravelNetworkRequest.h"
#import "CityOverview.pb.h"
#import "Package.pb.h"
#import "CityOverViewManager.h"
#import "TravelNetworkConstants.h"
#import "AppManager.h"
#import "AppUtils.h"


#define SERACH_WORKING_QUEUE1    @"SERACH_WORKING_QUEUE1"

@implementation CityOverviewService

static CityOverviewService *_cityOverViewService = nil;

+ (CityOverviewService*)defaultService
{
    if (_cityOverViewService == nil) {
        _cityOverViewService = [[CityOverviewService alloc] init];
    }
    
    return _cityOverViewService;
}

- (id)init
{
    self = [super init];
    _localCityOverViewManager = [[CityOverViewManager alloc] init];
    _onlineCityOverViewManager = [[CityOverViewManager alloc] init];
    return self;
}

- (void)dealloc
{
    [_localCityOverViewManager release];
    [_onlineCityOverViewManager release];
    [super dealloc];
}

typedef CommonOverview* (^LocalRequestHandler)(int* resultCode);
typedef CommonOverview* (^RemoteRequestHandler)(int* resultCode);

- (void)processLocalRemoteQuery:(PPViewController<CityOverviewServiceDelegate>*)viewController
                   localHandler:(LocalRequestHandler)localHandler
                  remoteHandler:(RemoteRequestHandler)remoteHandler
{
    [viewController showActivityWithText:NSLS(@"数据加载中......")];
    
    NSOperationQueue* queue = [self getOperationQueue:SERACH_WORKING_QUEUE1];
    [queue cancelAllOperations];
    
    [queue addOperationWithBlock:^{
        CommonOverview* overview = nil;
        int resultCode = 0;
        if ([AppUtils hasLocalCityData:[[AppManager defaultManager] getCurrentCityId]] == YES){
            // read local data firstly               
            PPDebug(@"Has Local Data For City %@, Read Data Locally", [[AppManager defaultManager] getCityName:[[AppManager defaultManager]getCurrentCityId]]);
            if (localHandler != NULL){
                overview = localHandler(&resultCode);
            }
        }
        else{
            // if local data no exist, try to read data from remote            
            PPDebug(@"No Local Data For City %@, Read Data Remotely", [[AppManager defaultManager] getCityName:[[AppManager defaultManager]getCurrentCityId]]);            
            if (remoteHandler != NULL){
                overview = remoteHandler(&resultCode);
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [viewController hideActivity];             
            [viewController findOverviewRequestDone:resultCode overview:overview];
        });
    }];
}

- (void)findCityBasic:(int)cityId delegate:(PPViewController<CityOverviewServiceDelegate>*)viewController 
{
    LocalRequestHandler localHandler = ^CommonOverview *(int* resultCode) {
        [_localCityOverViewManager switchCity:cityId];
        *resultCode = 0;
        return _localCityOverViewManager.cityBasic;
    };
    
    RemoteRequestHandler remoteHandler = ^CommonOverview *(int* resultCode) {
        CommonNetworkOutput* output = [TravelNetworkRequest queryObject:OBJECT_TYPE_CITY_BASIC objId:[[AppManager defaultManager]getCurrentCityId] lang:LANGUAGE_SIMPLIFIED_CHINESE]; 
        
        // TODO check output result code
        
        TravelResponse *travelResponse = [TravelResponse parseFromData:output.responseData];

        CommonOverview *commonOverView = [travelResponse overview];

        *resultCode = 0;
        
        return commonOverView;
    };
    
    [self processLocalRemoteQuery:viewController
                     localHandler:localHandler
                    remoteHandler:remoteHandler];
}

- (void)findCityConfig:(int)cityId delegate:(PPViewController<CityOverviewServiceDelegate> *)viewController
{
    LocalRequestHandler localHandler = ^CommonOverview *(int* resultCode) {
        [_localCityOverViewManager switchCity:cityId];
        return _localCityOverViewManager.travelUtility;
        *resultCode = 0;
    };
    
    RemoteRequestHandler remoteHandler = ^CommonOverview *(int* resultCode) {
        CommonNetworkOutput* output = [TravelNetworkRequest queryObject:OBJECT_TYPE_CITY_CONFIG objId:[[AppManager defaultManager]getCurrentCityId] lang:LANGUAGE_SIMPLIFIED_CHINESE]; 
        
        // TODO check output result code
        
        TravelResponse *travelResponse = [TravelResponse parseFromData:output.responseData];
        
        CommonOverview *commonOverView = [travelResponse overview];
        
        *resultCode = 0;
        
        return commonOverView;
    };
    
    [self processLocalRemoteQuery:viewController
                     localHandler:localHandler
                    remoteHandler:remoteHandler];
    

}

- (void)findTravelUtility:(int)cityId delegate:(PPViewController<CityOverviewServiceDelegate> *)viewController
{
    LocalRequestHandler localHandler = ^CommonOverview *(int* resultCode) {
        [_localCityOverViewManager switchCity:cityId];
        return _localCityOverViewManager.travelUtility;
        *resultCode = 0;
    };
    
    RemoteRequestHandler remoteHandler = ^CommonOverview *(int* resultCode) {
        CommonNetworkOutput* output = [TravelNetworkRequest queryObject:OBJECT_TYPE_TRAVEL_UTILITY objId:[[AppManager defaultManager]getCurrentCityId] lang:LANGUAGE_SIMPLIFIED_CHINESE]; 
        
        // TODO check output result code
        
        TravelResponse *travelResponse = [TravelResponse parseFromData:output.responseData];
        
        CommonOverview *commonOverView = [travelResponse overview];
        
        *resultCode = 0;
        
        return commonOverView;
    };
    
    [self processLocalRemoteQuery:viewController
                     localHandler:localHandler
                    remoteHandler:remoteHandler];
    
}

- (void)findTravelTransportation:(int)cityId delegate:(PPViewController<CityOverviewServiceDelegate> *)viewController
{
    LocalRequestHandler localHandler = ^CommonOverview *(int* resultCode) {
        [_localCityOverViewManager switchCity:cityId];
        return _localCityOverViewManager.travelUtility;
        *resultCode = 0;
    };
    
    RemoteRequestHandler remoteHandler = ^CommonOverview *(int* resultCode) {
        CommonNetworkOutput* output = [TravelNetworkRequest queryObject:OBJECT_TYPE_TRAVEL_TRANSPORTATION objId:[[AppManager defaultManager]getCurrentCityId] lang:LANGUAGE_SIMPLIFIED_CHINESE]; 
        
        // TODO check output result code
        
        TravelResponse *travelResponse = [TravelResponse parseFromData:output.responseData];
        
        CommonOverview *commonOverView = [travelResponse overview];
        
        *resultCode = 0;
        
        return commonOverView;
    };
    
    [self processLocalRemoteQuery:viewController
                     localHandler:localHandler
                    remoteHandler:remoteHandler];
    
}


@end
