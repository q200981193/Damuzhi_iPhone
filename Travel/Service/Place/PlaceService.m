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
#import "AppUtils.h"
#import "UserManager.h"
#import "JSON.h"
#import "PlaceStorage.h"

@implementation PlaceService

static PlaceService* _defaultPlaceService = nil;

#pragma mark - 
#pragma mark Life Cycle Management

- (void)dealloc
{
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


#pragma mark - 
#pragma mark Share Methods

typedef NSArray* (^LocalRequestHandler)(int* resultCode);
typedef NSArray* (^RemoteRequestHandler)(int* resultCode);

- (void)processLocalRemoteQuery:(PPViewController<PlaceServiceDelegate>*)viewController
                   localHandler:(LocalRequestHandler)localHandler
                  remoteHandler:(RemoteRequestHandler)remoteHandler
{
    [viewController showActivityWithText:NSLS(@"数据加载中......")];
    
    NSOperationQueue* queue = [self getOperationQueue:@"SERACH_WORKING_QUEUE"];
    [queue cancelAllOperations];
    
    [queue addOperationWithBlock:^{
        NSArray* list = nil;
        int resultCode = 0;
        if ([AppUtils hasLocalCityData:[[AppManager defaultManager] getCurrentCityId]] == YES){
            // read local data firstly               
            PPDebug(@"Has Local Data For City %@, Read Data Locally", [[AppManager defaultManager] getCurrentCityName]);
            if (localHandler != NULL){
                list = localHandler(&resultCode);
            }
        }
        else{
            // if local data no exist, try to read data from remote            
            PPDebug(@"No Local Data For City %@, Read Data Remotely", [[AppManager defaultManager] getCurrentCityName]);            
            if (remoteHandler != NULL){
                list = remoteHandler(&resultCode);
            }
        }
            
        dispatch_async(dispatch_get_main_queue(), ^{
            [viewController hideActivity];     
            if (viewController && [viewController respondsToSelector:@selector(findRequestDone:placeList:)]) {
                [viewController findRequestDone:resultCode placeList:list];
            }
        });
    }];
}

#pragma mark - 
#pragma mark Place Life Cycle Management

- (int)getObjectTypeByPlaceCategoryId:(int)categoryId
{
    int objectType = 0;
    switch (categoryId) {
        case PLACE_TYPE_ALL:
            objectType = OBJECT_LIST_TYPE_ALL_PLACE;
            break;
            
        case PLACE_TYPE_SPOT:
            objectType = OBJECT_LIST_TYPE_SPOT;
            break;
            
        case PLACE_TYPE_HOTEL:
            objectType = OBJECT_LIST_TYPE_HOTEL;
            break;
            
        case PLACE_TYPE_RESTAURANT:
            objectType = OBJECT_LIST_TYPE_RESTAURANT;
            break;
            
        case PLACE_TYPE_SHOPPING:
            objectType = OBJECT_LIST_TYPE_SHOPPING;
            break;
            
        case PLACE_TYPE_ENTERTAINMENT:
            objectType = OBJECT_LIST_TYPE_ENTERTAINMENT;
            break;
    
        
        default:
            break;
    }
    
    return objectType;
}

- (void)findPlaces:(int)categoryId viewController:(PPViewController<PlaceServiceDelegate>*)viewController
{
    LocalRequestHandler localHandler = ^NSArray *(int* resultCode) {
        [_localPlaceManager switchCity:[[AppManager defaultManager] getCurrentCityId]];
        NSArray* list = [_localPlaceManager findPlacesByCategory:categoryId];   
        *resultCode = 0;
        return list;
    };
    
    LocalRequestHandler remoteHandler = ^NSArray *(int* resultCode) {
        // TODO, send network request here
        CommonNetworkOutput* output = [TravelNetworkRequest queryList:[self getObjectTypeByPlaceCategoryId:categoryId] 
                                                               cityId:[[AppManager defaultManager] getCurrentCityId] lang:LANGUAGE_SIMPLIFIED_CHINESE]; 
        NSArray *list = nil;
        if (output.resultCode == ERROR_SUCCESS) {
            TravelResponse *travelResponse = [TravelResponse parseFromData:output.responseData];
            _onlinePlaceManager.placeList = [[travelResponse placeList] listList];    
            list = [_onlinePlaceManager findPlacesByCategory:categoryId];   
            
            *resultCode = 0;
        }
        
        return list;
    };
    
    [self processLocalRemoteQuery:viewController
                     localHandler:localHandler
                    remoteHandler:remoteHandler];
}

- (void)addPlaceIntoFavorite:(PPViewController<PlaceServiceDelegate>*)viewController 
                       place:(Place*)place
{
    NSString* userId = [[UserManager defaultManager] userId];    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        CommonNetworkOutput* output = [TravelNetworkRequest addFavoriteByUserId:userId placeId:[NSString stringWithFormat:@"%d",place.placeId]  longitude:[NSString stringWithFormat:@"%f",place.longitude] latitude:[NSString stringWithFormat:@"%f",place.latitude]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary* jsonDict = [output.textData JSONValue];
            NSNumber *result = (NSNumber*)[jsonDict objectForKey:PARA_TRAVEL_RESULT];
            NSNumber *placeFavoriteCount = (NSNumber*)[jsonDict objectForKey:PARA_TRAVEL_PLACE_FAVORITE_COUNT];
            if (0 == result.intValue){
                    //[[PlaceStorage favoriteManager] addPlace:place];
            }else {
                PPDebug(@"<PlaceService> addPlaceIntoFavorite faild,result:%d", result.intValue);
            }
            [[PlaceStorage favoriteManager] addPlace:place];
            
            if ([viewController respondsToSelector:@selector(finishAddFavourite:count:)]){
                [viewController finishAddFavourite:result count:placeFavoriteCount];
            }
        });
    }); 
}

- (void)deletePlaceFromFavorite:(PPViewController<PlaceServiceDelegate>*)viewController 
                          place:(Place*)place
{
    NSString* userId = [[UserManager defaultManager] userId];    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        CommonNetworkOutput *output = [TravelNetworkRequest deleteFavoriteByUserId:userId placeId:[NSString stringWithFormat:@"%d",place.placeId]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary* jsonDict = [output.textData JSONValue];
            NSNumber *result = (NSNumber*)[jsonDict objectForKey:PARA_TRAVEL_RESULT];
            NSNumber *placeFavoriteCount = (NSNumber*)[jsonDict objectForKey:PARA_TRAVEL_PLACE_FAVORITE_COUNT];
            if (0 == result.intValue){
                
            }else {
                PPDebug(@"<PlaceService> deletePlaceIntoFavorite faild,result:%d", result.intValue);
            }
            [[PlaceStorage favoriteManager] deletePlace:place];
            
            if ([viewController respondsToSelector:@selector(finishDeleteFavourite:count:)]){
                [viewController finishDeleteFavourite:result count:placeFavoriteCount];
            }
            
        });
    }); 
}

- (void)getPlaceFavoriteCount:(PPViewController<PlaceServiceDelegate>*)viewController
                      placeId:(int)placeId
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        CommonNetworkOutput* output = [TravelNetworkRequest queryPlace:[[UserManager defaultManager] userId] placeId:[NSString stringWithFormat:@"%d",placeId]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary* jsonDict = [output.textData JSONValue];
            NSNumber *result = (NSNumber*)[jsonDict objectForKey:PARA_TRAVEL_RESULT];
            NSNumber *placeFavoriteCount = (NSNumber*)[jsonDict objectForKey:PARA_TRAVEL_PLACE_FAVORITE_COUNT];
            
            if (0 == result.intValue){
                
            }else {
                PPDebug(@"<PlaceService> getPlaceFavoriteCount faild,result:%d", result.intValue);
            }
            
            if ([viewController respondsToSelector:@selector(didGetPlaceData:count:)]){
                PPDebug(@"<getPlaceFavoriteCount> placeId=%d, count=%d", placeId, placeFavoriteCount.intValue);
                [viewController didGetPlaceData:placeId count:placeFavoriteCount.intValue];
            }
        });
    }); 
}

- (void)findTopFavoritePlaces:(PPViewController<PlaceServiceDelegate>*)viewController type:(int)type
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        CommonNetworkOutput *output = [TravelNetworkRequest queryList:type cityId:[[AppManager defaultManager] getCurrentCityId] lang:LANGUAGE_SIMPLIFIED_CHINESE];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            TravelResponse *travelResponse = [TravelResponse parseFromData:output.responseData];
            
            NSArray *favoritPlaceList = [[travelResponse placeList] listList];   
            
            if ([viewController respondsToSelector:@selector(finishFindTopFavoritePlaces:type:)]){
                [viewController finishFindTopFavoritePlaces:favoritPlaceList type:type];
            }
        });
    }); 
}

@end
