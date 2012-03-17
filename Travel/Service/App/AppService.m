//
//  AppService.m
//  Travel
//
//  Created by 小涛 王 on 12-3-12.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "AppService.h"
#import "PPViewController.h"
#import "LogUtil.h"
#import "TravelNetworkRequest.h"
#import "Package.pb.h"
#import "ASIHTTPRequest.h"
#import "FileUtil.h"
#import "TravelNetworkConstants.h"

#define SERACH_WORKING_QUEUE    @"SERACH_WORKING_QUEUE"

@implementation AppService

static AppService* _defaultAppService = nil;

#pragma mark - 
#pragma mark Life Cycle Management

- (void)dealloc
{
    [super dealloc];
}

+ (AppService*)defaultService
{
    if (_defaultAppService == nil){
        _defaultAppService = [[AppService alloc] init];                
    }
    
    return _defaultAppService;
}

- (id)init
{
    self = [super init];
    return self;
}

#pragma mark - 
#pragma mark App Life Cycle Management

- (NSString*)getAppVersion
{
    // TODO later
    return @"";
}

- (void)downloadResource:(NSURL*)url destinationPath:(NSString*)destinationPath
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDownloadDestinationPath:destinationPath];
    [request startSynchronous];
}

- (void)loadAppData
{
    [[AppManager defaultManager] loadAppData];
}


- (void)updateAppData
{        
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CommonNetworkOutput* output = [TravelNetworkRequest queryList:OBJECT_TYPE_APP_DATA lang:LANGUAGE_SIMPLIFIED_CHINESE];
        TravelResponse *travelResponse = nil;
        if (output.resultCode == ERROR_SUCCESS){
            travelResponse = [TravelResponse parseFromData:output.responseData];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(travelResponse.resultCode == 0)
            {
                [[AppManager defaultManager] updateAppData:[travelResponse appInfo]];
            }
//            else {
//                [[AppManager defaultManager] loadAppData];
//            }
            
        });
        
        // TODO , performance can be improved by add sperate working queue for download
        
        
        if (output.resultCode == ERROR_SUCCESS){
            NSArray *placeMetas = [[travelResponse appInfo] placeMetaDataListList];
            for (PlaceMeta *placeMeta in placeMetas) {
                for (NameIdPair *providedService in [placeMeta providedServiceListList]) {
                    // download images of each provide service icon
                    NSURL *url = [NSURL URLWithString:providedService.image];
                    
                    [FileUtil createDir:[FileUtil getFileFullPath:IMAGE_DIR_OF_PROVIDED_SERVICE]];
                    
                    NSString *destination = [FileUtil getFileFullPath:[NSString stringWithFormat:@"%@/%d.png", IMAGE_DIR_OF_PROVIDED_SERVICE, providedService.id]];
                    
                    PPDebug(@"download providedService icon, image = %@, name=%@, save path=%@", 
                            providedService.image, providedService.name, destination);

                    [self downloadResource:url destinationPath:destination];
                }
            }
        }
    });    
}

@end
