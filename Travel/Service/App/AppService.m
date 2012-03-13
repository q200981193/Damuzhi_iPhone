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
    return @"";
}

- (void)updateAppData
{        
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        // TODO, send network request here        
        CommonNetworkOutput* output = [TravelNetworkRequest queryAppData:10 lang:1];
        TravelResponse *travelResponse = [TravelResponse parseFromData:output.responseData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(travelResponse.resultCode == 0)
            {
                [output.responseData writeToFile:@"/iphone/travel/app.dat" atomically:YES];
                [[AppManager defaultManager] initApp:[travelResponse appInfo]];
            }
            else {
                NSData *localData = [NSData dataWithContentsOfFile:@"/iphone/travel/app.dat"];
                App *app = [App parseFromData:localData];
                [[AppManager defaultManager] initApp:app];
            }
            
        });
    });    
}

@end
