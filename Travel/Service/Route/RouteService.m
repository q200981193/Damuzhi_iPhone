//
//  RouteService.m
//  Travel
//
//  Created by 小涛 王 on 12-6-4.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "RouteService.h"
#import "TravelNetworkRequest.h"
#import "LocaleUtils.h"
#import "PPViewController.h"
#import "SelectedItemIds.h"

@interface RouteService ()

@property (retain, nonatomic) NSArray *routeList;

@end

static RouteService *_defaultRouteService = nil;

@implementation RouteService

@synthesize routeList = _routeList;

#pragma mark - 
#pragma mark Life Cycle Management

- (void)dealloc
{
    [_routeList release];
    [super dealloc];
}

+ (RouteService*)defaultService
{
    if (_defaultRouteService == nil){
        _defaultRouteService = [[RouteService alloc] init];                
    }
    
    return _defaultRouteService;
}

- (void)findRoutesWithType:(int)routeType
                     start:(int)start
                     count:(int)count
      routeSelectedItemIds:(RouteSelectedItemIds *)routeSelectedItemIds
            viewController:(PPViewController<RouteServiceDelegate>*)viewController
{
    [viewController showActivityWithText:NSLS(@"数据加载中......")];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
         CommonNetworkOutput* output = [TravelNetworkRequest queryList:routeType 
                                                                 start:start 
                                                                 count:count 
                                                                  lang:LanguageTypeZhHans 
                                                      departCityIdList:routeSelectedItemIds.departCityIds 
                                                 destinationCityIdList:routeSelectedItemIds.destinationCityIds 
                                                          agencyIdList:routeSelectedItemIds.agencyIds 
                                                       priceRankIdList:routeSelectedItemIds.priceRankItemIds
                                                       daysRangeIdList:routeSelectedItemIds.daysRangeItemIds 
                                                           themeIdList:routeSelectedItemIds.themeIds];
        
        int totalCount;
        NSArray *routeList;
        if (output.resultCode == ERROR_SUCCESS){
            @try{
                TravelResponse *travelResponse = [TravelResponse parseFromData:output.responseData];
            
                totalCount = [travelResponse totalCount];
                routeList = [[travelResponse routeList] routesList];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [viewController hideActivity];   
                    
                    if ([viewController respondsToSelector:@selector(findRequestDone:totalCount:list:)]) {
                        [viewController findRequestDone:output.resultCode 
                                             totalCount:totalCount
                                                   list:routeList];
                    }
                });
                

            }
            @catch (NSException *exception){
            }
        }
        

    });    
}

- (void)findRouteWithRouteId:(int)routeId viewController:(PPViewController<RouteServiceDelegate>*)viewController

{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CommonNetworkOutput* output = [TravelNetworkRequest queryObject:OBJECT_TYPE_ROUTE_DETAIL
                                                                  objId:routeId  
                                                                 lang:LanguageTypeZhHans];
        
        TravelResponse *travelResponse = nil;
        if (output.resultCode == ERROR_SUCCESS){
            @try{
                travelResponse = [TravelResponse parseFromData:output.responseData];
                TouristRoute *route = [travelResponse route];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([viewController respondsToSelector:@selector(findRequestDone:route:)]) {
                        [viewController findRequestDone:travelResponse.resultCode 
                                                  route:route];
                    }
                });
            }
            @catch (NSException *exception){
            }
        }
    }); 
}

- (void)queryRouteFeekbacks:(int)routeId 
                      start:(int)start
                      count:(int)count
             viewController:(PPViewController<RouteServiceDelegate>*)viewController
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CommonNetworkOutput* output = [TravelNetworkRequest queryList:OBJECT_LIST_ROUTE_FEEKBACK routeId:routeId start:start count:count lang:LanguageTypeZhHans];
        
        int totalCount;
        TravelResponse *travelResponse = nil;
        if (output.resultCode == ERROR_SUCCESS){
            @try{
                travelResponse = [TravelResponse parseFromData:output.responseData];
                totalCount = [travelResponse totalCount];
                NSArray *list = [[travelResponse routeFeekbackList] routeFeekbacksList] ;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([viewController respondsToSelector:@selector(findRequestDone:totalCount:list:)]) {
                        [viewController findRequestDone:output.resultCode totalCount:totalCount list:list];
                    }
                });
            }
            @catch (NSException *exception){
            }
        }
    }); 
}

@end
