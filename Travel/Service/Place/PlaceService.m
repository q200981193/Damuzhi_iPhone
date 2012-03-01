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

#define SERACH_WORKING_QUEUE    @"SERACH_WORKING_QUEUE"

@implementation PlaceService

static PlaceService* _defaultPlaceService;

@synthesize currentCityId = _currentCityId;

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
    return self;
}

- (void)findAllSpots:(PPViewController<PlaceServiceDelegate>*)viewController
{
    [viewController showActivityWithText:NSLS(@"kLoadingData")];
    
    NSOperationQueue* queue = [self getOperationQueue:SERACH_WORKING_QUEUE];
    [queue cancelAllOperations];
    
    [queue addOperationWithBlock:^{
        NSArray* list = nil;
        int resultCode = 0;
        if ([_localPlaceManager hasLocalCityData:_currentCityId] == YES){
            
            PPDebug(@"Has Local Data For City %@, Read Data Locally", _currentCityId);
            
            // read local data firstly   
            [_localPlaceManager switchCity:_currentCityId];
            list = [_localPlaceManager findAllSpots];
        }
        else{
            // if local data no exist, try to read data from remote
            
            PPDebug(@"No Local Data For City %@, Read Data Remotely", _currentCityId);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [viewController hideActivity];             
            [viewController findRequestDone:resultCode dataList:list];
        });
        
    
    }];
    
}

- (void)findAllPlaces:(PPViewController<PlaceServiceDelegate>*)viewController
{
    [viewController showActivityWithText:NSLS(@"kLoadingData")];
    
    NSOperationQueue* queue = [self getOperationQueue:SERACH_WORKING_QUEUE];
    [queue cancelAllOperations];
    
    [queue addOperationWithBlock:^{
        NSArray* list = nil;
        int resultCode = 0;
        if ([_localPlaceManager hasLocalCityData:_currentCityId] == YES){
            
            PPDebug(@"Has Local Data For City %@, Read Data Locally", _currentCityId);
            
            // read local data firstly   
            [_localPlaceManager switchCity:_currentCityId];
            list = [_localPlaceManager findAllPlaces];
        }
        else{
            // if local data no exist, try to read data from remote
            
            PPDebug(@"No Local Data For City %@, Read Data Remotely", _currentCityId);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [viewController hideActivity];             
            [viewController findRequestDone:resultCode dataList:list];
        });
        
        
    }];
    
}


@end
