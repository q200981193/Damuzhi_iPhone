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

@implementation CityOverViewService

@synthesize currentCityId = _currentCityId;

static CityOverViewService *_cityOverViewService = nil;

+ (CityOverViewService*)defaultService
{
    if (_cityOverViewService == nil) {
        _cityOverViewService = [[CityOverViewService alloc] init];
    }
    
    return _cityOverViewService;
}

- (id)init
{
    self = [super init];
    _localCityOverViewManager = [[CityOverViewManager alloc] init];
    _onlineCityOverViewManager = [[CityOverViewManager alloc] init];
    self.currentCityId = [[AppManager defaultManager] getCurrentCityId];
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

- (void)processLocalRemoteQuery:(PPViewController<CommonOverViewServiceDelegate>*)viewController
                   localHandler:(LocalRequestHandler)localHandler
                  remoteHandler:(RemoteRequestHandler)remoteHandler
{
    [viewController showActivityWithText:NSLS(@"kLoadingData")];
    
    NSOperationQueue* queue = [self getOperationQueue:SERACH_WORKING_QUEUE1];
    [queue cancelAllOperations];
    
    [queue addOperationWithBlock:^{
        CommonOverview* overview = nil;
        int resultCode = 0;
        if ([AppUtils hasLocalCityData:[[AppManager defaultManager] getCurrentCityId]] == YES){
            // read local data firstly               
            PPDebug(@"Has Local Data For City %@, Read Data Locally", [[AppManager defaultManager] getCityName:_currentCityId]);
            if (localHandler != NULL){
                overview = localHandler(&resultCode);
            }
        }
        else{
            // if local data no exist, try to read data from remote            
            PPDebug(@"No Local Data For City %@, Read Data Remotely", [[AppManager defaultManager] getCityName:_currentCityId]);            
            if (remoteHandler != NULL){
                overview = remoteHandler(&resultCode);
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [viewController hideActivity];             
            [viewController findRequestDone:resultCode data:overview];
        });
    }];
}

- (void)findTravelUtility:(int)cityId delegate:(PPViewController<CommonOverViewServiceDelegate> *)viewController
{
    LocalRequestHandler localHandler = ^CommonOverview *(int* resultCode) {
        [_localCityOverViewManager switchCity:cityId];
        *resultCode = 0;
        return _localCityOverViewManager.cityOverView.cityBasic;
    };
    
    LocalRequestHandler remoteHandler = ^CommonOverview *(int* resultCode) {
        CommonNetworkOutput* output = [TravelNetworkRequest queryObject:4 objId:_currentCityId lang:LANGUAGE_SIMPLIFIED_CHINESE]; 
        
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

- (void)findCityBasic:(int)cityId delegate:(PPViewController<CommonOverViewServiceDelegate>*)viewController 
{
    LocalRequestHandler localHandler = ^CommonOverview *(int* resultCode) {
        [_localCityOverViewManager switchCity:cityId];
        *resultCode = 0;
        return _localCityOverViewManager.cityOverView.cityBasic;
    };
    
    LocalRequestHandler remoteHandler = ^CommonOverview *(int* resultCode) {
        CommonNetworkOutput* output = [TravelNetworkRequest queryObject:2 objId:_currentCityId lang:LANGUAGE_SIMPLIFIED_CHINESE]; 
        
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
