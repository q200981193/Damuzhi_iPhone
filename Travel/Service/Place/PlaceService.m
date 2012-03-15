//
//  PlaceSevice.m
//  Travel
//
//  Created by  on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlaceService.h"
#import "PlaceManager.h"
#import "PPViewController.h"
#import "LogUtil.h"
#import "TravelNetworkRequest.h"
#import "Package.pb.h"
#import "AppManager.h"
#import "TravelNetworkConstants.h"

#define SERACH_WORKING_QUEUE    @"SERACH_WORKING_QUEUE"

@implementation PlaceService

static PlaceService* _defaultPlaceService = nil;

@synthesize currentCityId = _currentCityId;

#pragma mark - 
#pragma mark Life Cycle Management

- (void)dealloc
{
    [_currentCityId release];
    [_localPlaceManager release];
    [_onlinePlaceManager release];
    [super dealloc];
}

+ (PlaceService*)defaultService
{
    if (_defaultPlaceService == nil){
        _defaultPlaceService = [[PlaceService alloc] init];                
    }
    
    return _defaultPlaceService;
}

- (id)init
{
    self = [super init];
    _localPlaceManager = [[PlaceManager alloc] init];
    _onlinePlaceManager = [[PlaceManager alloc] init];
    self.currentCityId = [NSString stringWithFormat:@"%d",[[AppManager defaultManager] getCurrentCityId]];
    return self;
}


#pragma mark - 
#pragma mark Share Methods

typedef NSArray* (^LocalRequestHandler)(int* resultCode);
typedef NSArray* (^RemoteRequestHandler)(int* resultCode);

- (void)processLocalRemoteQuery:(PPViewController<PlaceServiceDelegate>*)viewController
                   localHandler:(LocalRequestHandler)localHandler
                  remoteHandler:(RemoteRequestHandler)remoteHandler
{
    [viewController showActivityWithText:NSLS(@"kLoadingData")];
    
    NSOperationQueue* queue = [self getOperationQueue:SERACH_WORKING_QUEUE];
    [queue cancelAllOperations];
    
    [queue addOperationWithBlock:^{
        NSArray* list = nil;
        int resultCode = 0;
        if ([_localPlaceManager hasLocalCityData:_currentCityId] == YES){
            // read local data firstly               
            PPDebug(@"Has Local Data For City %@, Read Data Locally", _currentCityId);
            if (localHandler != NULL){
                list = localHandler(&resultCode);
            }
        }
        else{
            // if local data no exist, try to read data from remote            
            PPDebug(@"No Local Data For City %@, Read Data Remotely", _currentCityId);            
            if (remoteHandler != NULL){
                list = remoteHandler(&resultCode);
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [viewController hideActivity];             
            [viewController findRequestDone:resultCode dataList:list];
        });
    }];

}

#pragma mark - 
#pragma mark Place Life Cycle Management

- (void)findAllSpots:(PPViewController<PlaceServiceDelegate>*)viewController
{
    LocalRequestHandler localHandler = ^NSArray *(int* resultCode) {
        [_localPlaceManager switchCity:_currentCityId];
        NSArray* list = [_localPlaceManager findAllSpots];   
        *resultCode = 0;
        return list;
    };
    
    LocalRequestHandler remoteHandler = ^NSArray *(int* resultCode) {
        // TODO, send network request here
        CommonNetworkOutput* output = [TravelNetworkRequest queryList:OBJECT_TYPE_SPOT cityId:[_currentCityId intValue] lang:LANGUAGE_SIMPLIFIED_CHINESE]; 
        TravelResponse *travelResponse = [TravelResponse parseFromData:output.responseData];
        
        _onlinePlaceManager.placeList = [[travelResponse placeList] listList];   
        
        NSArray* list = [_onlinePlaceManager findAllSpots];   
        
        *resultCode = 0;

        return list;
    };

    [self processLocalRemoteQuery:viewController
                     localHandler:localHandler
                    remoteHandler:remoteHandler];
}


- (void)findAllHotels:(PPViewController<PlaceServiceDelegate>*)viewController
{
    LocalRequestHandler localHandler = ^NSArray *(int* resultCode) {
        [_localPlaceManager switchCity:_currentCityId];
        NSArray* list = [_localPlaceManager findAllHotels];   
        *resultCode = 0;
        return list;
    };
    
    LocalRequestHandler remoteHandler = ^NSArray *(int* resultCode) {
        // TODO, send network request here
        CommonNetworkOutput* output = [TravelNetworkRequest queryList:OBJECT_TYPE_HOTEL cityId:[_currentCityId intValue] lang:LANGUAGE_SIMPLIFIED_CHINESE]; 
        TravelResponse *travelResponse = [TravelResponse parseFromData:output.responseData];
        
        _onlinePlaceManager.placeList = [[travelResponse placeList] listList];   
        
        NSArray* list = [_onlinePlaceManager findAllHotels];   
        *resultCode = 0;
        
        return list;
    };
    
    [self processLocalRemoteQuery:viewController
                     localHandler:localHandler
                    remoteHandler:remoteHandler];
}

- (void)findAllPlaces:(PPViewController<PlaceServiceDelegate>*)viewController
{
    
    LocalRequestHandler localHandler = ^NSArray *(int* resultCode) {
        [_localPlaceManager switchCity:_currentCityId];
        NSArray* list = [_localPlaceManager findAllPlaces];   
        *resultCode = 0;
        return list;
    };
    
    LocalRequestHandler remoteHandler = ^NSArray *(int* resultCode) {
        // TODO, send network request here
        return nil;
    };
    
    [self processLocalRemoteQuery:viewController
                     localHandler:localHandler
                    remoteHandler:remoteHandler];    
}


@end
