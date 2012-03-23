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
#import "SSZipArchive.h"
#import "AppUtils.h"
#import "AppConstants.h"


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

- (BOOL)hasUnzipCityData:(int)cityId
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[AppUtils getUnzipFlag:cityId]];
}

- (void)copyDefaultAppDataFormBundle
{    
    // create City Dir
    [FileUtil createDir:[AppUtils getAppDir]];
    
    // copy file from bundle to zip dir
    if (![[NSFileManager defaultManager] fileExistsAtPath:[AppUtils getAppFilePath]]) {
        PPDebug(@"copy defalut app.dat from bundle to app dir");
        [FileUtil copyFileFromBundleToAppDir:FILENAME_OF_APP_DATA
                                      appDir:[AppUtils getAppDir] 
                                   overwrite:YES];
    }
}

- (void)copyDefaultCityZipFromBundleAndRelease
{    
    // create City Dir
    [FileUtil createDir:[AppUtils getZipDir]];
    
    // copy file from bundle to zip dir
    if (![[NSFileManager defaultManager] fileExistsAtPath:[AppUtils getZipFilePath:DEFAULT_CITY_ID]]) {
        PPDebug(@"copy defalut zip from bundle to zip dir");
        [FileUtil copyFileFromBundleToAppDir:DEFAULT_CITY_ZIP
                                      appDir:[AppUtils getZipDir] 
                                   overwrite:YES];
    }
    
    // if there has no unzip city data, unzip
    if (![self hasUnzipCityData:DEFAULT_CITY_ID]) {
        [AppUtils unzipCityZip:DEFAULT_CITY_ID];
    }
}

- (void)loadAppData
{
    [self copyDefaultAppDataFormBundle];
    [self copyDefaultCityZipFromBundleAndRelease];
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
        });
        
        
        if (output.resultCode == ERROR_SUCCESS){
            //save data to app file
            //[[[travelResponse appInfo] data] writeToFile:[AppUtils getAppFilePath] atomically:YES];
            [output.responseData writeToFile:[AppUtils getAppFilePath] atomically:YES];
            
            // TODO , performance can be improved by add sperate working queue for download
            NSArray *placeMetas = [[travelResponse appInfo] placeMetaDataListList];
            for (PlaceMeta *placeMeta in placeMetas) {
                for (NameIdPair *providedService in [placeMeta providedServiceListList]) {
                    // download images of each provide service icon
                    NSURL *url = [NSURL URLWithString:providedService.image];
                    
                    NSString *destinationDir = [AppUtils getProvidedServiceImageDir];
                    NSString *fileName = [[NSString alloc] initWithFormat:@"%d.png", providedService.id]; 
                    
                    [self downloadResource:url destinationDir:destinationDir fileName:fileName];
                    [fileName release];
                }
            }
        }
    });    
}

- (void)downloadResource:(NSURL*)url destinationDir:(NSString*)destinationDir fileName:(NSString*)fileName
{
    [FileUtil createDir:destinationDir];
    NSString *destinationPath = [destinationDir stringByAppendingPathComponent:fileName];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDownloadDestinationPath:destinationPath];
    
    //PPDebug(@"download url: %@ to destination: %@", url, destinationPath);
    
    [request startSynchronous];
}  

- (void)downloadCity:(City *)city
{
    
}

@end
