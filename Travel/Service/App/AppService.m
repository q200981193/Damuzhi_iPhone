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
#import "FileUtil.h"
#import "TravelNetworkConstants.h"
#import "SSZipArchive.h"
#import "AppUtils.h"
#import "AppConstants.h"
#import "ASIHTTPRequest.h"
#import "LocalCityManager.h"


#define SERACH_WORKING_QUEUE    @"SERACH_WORKING_QUEUE"

@implementation AppService

@synthesize downloadRequestList = _downloadRequestList;
@synthesize queue = _queue;
@synthesize appServiceDelegate = _appServiceDelegate;

static AppService* _defaultAppService = nil;

#pragma mark - 
#pragma mark Life Cycle Management

- (void)dealloc
{
    for (ASIHTTPRequest *request in _downloadRequestList) {
        [request clearDelegatesAndCancel];
        [request release];
    }
    [_downloadRequestList release];
    [_queue release];
    [_appServiceDelegate release];
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
    if (self) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        self.downloadRequestList = list;
        [list release];
    }
    
    return self;
}

#pragma mark - 
#pragma mark App Life Cycle Management

- (NSString*)getAppVersion
{
    // TODO later
    return @"";
}

//- (BOOL)hasUnzipCityData:(int)cityId
//{
//    return [[NSFileManager defaultManager] fileExistsAtPath:[AppUtils getUnzipFlag:cityId]];
//}

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

- (void)copyBuildinCityZipFromBundleAndRelease
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
    if (![AppUtils hasLocalCityData:DEFAULT_CITY_ID]) {
        [AppUtils unzipCityZip:DEFAULT_CITY_ID];
    }
}

- (void)loadAppData
{
    [self copyDefaultAppDataFormBundle];
    [self copyBuildinCityZipFromBundleAndRelease];
    [[AppManager defaultManager] loadAppData];
}


- (void)updateAppData
{        
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CommonNetworkOutput* output = [TravelNetworkRequest queryList:OBJECT_TYPE_APP_DATA lang:LANGUAGE_SIMPLIFIED_CHINESE];
        TravelResponse *travelResponse = nil;
        BOOL parseDataFlag = NO;
        if (output.resultCode == ERROR_SUCCESS){
            @try{
                travelResponse = [TravelResponse parseFromData:output.responseData];
                parseDataFlag = YES;

                //save data to app file
                [output.responseData writeToFile:[AppUtils getAppFilePath] atomically:YES];
            }
            
            @catch (NSException *exception){
                NSLog (@"Caught %@%@", [exception name], [exception reason]);
                parseDataFlag = NO;
            }


        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(travelResponse.resultCode == 0 && parseDataFlag == YES)
            {
                [[AppManager defaultManager] updateAppData:[travelResponse appInfo]];
            }
        });
        
        
        if (output.resultCode == ERROR_SUCCESS && parseDataFlag == YES){
            // TODO , performance can be improved by add sperate working queue for download
            NSArray *placeMetas = [[travelResponse appInfo] placeMetaDataListList];
            for (PlaceMeta *placeMeta in placeMetas) {
                for (NameIdPair *providedService in [placeMeta providedServiceListList]) {
                    // download images of each provide service icon
                    NSURL *url = [NSURL URLWithString:providedService.image];
                    
                    NSString *destinationDir = [AppUtils getProvidedServiceIconDir];
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
    
    [request startSynchronous];
}  

#define KEY_LOCAL_CITY @"KEY_LOCAL_CITY"
- (void)downloadCity:(City*)city
{
    if(self.queue == nil)
    {
        self.queue = [[[NSOperationQueue alloc] init] autorelease];
    }
    
    LocalCity *localCity = [[LocalCityManager defaultManager] createLocalCity:city.cityId];
    localCity.downloadingFlag = YES;
    
    //specify destination path and temp path
    NSString *destinationPath = [AppUtils getZipFilePath:city.cityId];
    NSString *tempPath = [AppUtils getDownloadPath:city.cityId];
    
    [FileUtil createDir:[AppUtils getDownloadDir]];
    [FileUtil createDir:[AppUtils getZipDir]];
    
    //create a request
    NSURL *url = [NSURL URLWithString:city.downloadUrl];
    NSLog(@"url = %@", url);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url]; 
    
    [request setTemporaryFileDownloadPath:tempPath];
    [request setDownloadDestinationPath:destinationPath];
    [request setAllowResumeForFileDownloads:YES];
    
    PPDebug(@"Download to %@ (%@)", destinationPath, tempPath);
    
    //set request delegate
    [request setDelegate:self];
    [request setDownloadProgressDelegate:localCity];
    
    //add request into queue and run
    [self.queue addOperation:request];
    
    //set request info, user defined
    NSDictionary *dic = [NSDictionary dictionaryWithObject:localCity
                                                    forKey:KEY_LOCAL_CITY]; 
    
    [request setUserInfo:dic];
    
    //add request to request list
    [self.downloadRequestList addObject:request];
}

- (void)cancelDownloadCity:(City*)city
{
    // remove temp download file
    NSString *cityZipPath = [AppUtils getDownloadPath:city.cityId];
    [[NSFileManager defaultManager] removeItemAtPath:cityZipPath error:nil];
    
    // remove localCity
    [[LocalCityManager defaultManager] removeLocalCity:city.cityId];
    
    // remove request
    for (ASIHTTPRequest *request in _downloadRequestList) {
        LocalCity *localCity = [request.userInfo objectForKey:KEY_LOCAL_CITY];
        if(localCity.cityId == city.cityId)
        {
            // Cancels an asynchronous request, clearing all delegates and blocks first
            [request clearDelegatesAndCancel];    
            [request cancel];
            
            [_downloadRequestList removeObject:request];
            
            NSLog(@"cancelDownload");
            return;
        }
    }
}

- (void)pauseDownloadCity:(City*)city
{
    for (ASIHTTPRequest *request in _downloadRequestList) {
        LocalCity *localCity = [request.userInfo objectForKey:KEY_LOCAL_CITY];
        if(localCity.cityId == city.cityId)
        {
            //Cancels an asynchronous request, clearing all delegates and blocks first
            [request clearDelegatesAndCancel];    
            [request cancel];
            
            [_downloadRequestList removeObject:request];
            localCity.downloadingFlag = NO;
            NSLog(@"pauseDownload");
            return;
        }
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
//    // Use when fetching text data
//    NSString *responseString = [request responseString];
//    
//    // Use when fetching binary data
//    NSData *responseData = [request responseData];
    
    //update download city info.
    LocalCity *localCity = [request.userInfo objectForKey:KEY_LOCAL_CITY];
    localCity.downloadDoneFlag = YES;

    [_downloadRequestList removeObject:request];
    [AppUtils unzipCityZip:localCity.cityId];
    
    //call delegate method to do addition work 
    if (_appServiceDelegate && [_appServiceDelegate respondsToSelector:@selector(didFinishDownload:)]) {
        [_appServiceDelegate didFinishDownload:[[AppManager defaultManager] getCity:localCity.cityId]];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    //remove download city info.
    LocalCity *localCity = [request.userInfo objectForKey:KEY_LOCAL_CITY];
    [[LocalCityManager defaultManager] removeLocalCity:localCity.cityId];

    //remove failed request.
    [_downloadRequestList removeObject:request];
    
    //call delegate method to do addition work 
    NSError *error = [request error];
    if (_appServiceDelegate && [_appServiceDelegate respondsToSelector:@selector(didFailDownload:error:)]) {
        [_appServiceDelegate didFailDownload:[[AppManager defaultManager] getCity:localCity.cityId] error:error];
    }
}


@end
