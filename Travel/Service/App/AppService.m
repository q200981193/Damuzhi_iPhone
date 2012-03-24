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


#define SERACH_WORKING_QUEUE    @"SERACH_WORKING_QUEUE"

@implementation AppService

@synthesize downloadRequestList = _downloadRequestList;
@synthesize queue = _queue;
@synthesize downloadDelegate = _downloadDelegate;

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
    [super dealloc];
}

+ (AppService*)defaultService
{
    if (_defaultAppService == nil){
        _defaultAppService = [[AppService alloc] init];       
        _defaultAppService.downloadRequestList = [[NSMutableArray alloc] init]; 
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
        BOOL parseDataFlag = NO;
        if (output.resultCode == ERROR_SUCCESS){
            @try{
                travelResponse = [TravelResponse parseFromData:output.responseData];
                parseDataFlag = YES;

                //save data to app file
                //[[[travelResponse appInfo] data] writeToFile:[AppUtils getAppFilePath] atomically:YES];
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

- (void)downloadCity:(City*)city
{
    if(self.queue == nil)
    {
        self.queue = [[[NSOperationQueue alloc] init] autorelease];
    }
    
    for (ASIHTTPRequest *request in _downloadRequestList) {
        if (city.cityId == [[[request.userInfo allKeys] objectAtIndex:0] intValue]) {
            return;
        }
    }        
    
    NSString *destinationPath = [AppUtils getZipFilePath:city.cityId];
    [FileUtil createDir:[AppUtils getDownloadDir]];
    NSString *tempPath = [AppUtils getDownloadPath:city.cityId];
    
    NSURL *url = [NSURL URLWithString:city.downloadUrl];
    NSLog(@"url = %@", url);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url]; 
    
    [request setTemporaryFileDownloadPath:tempPath];
    [request setAllowResumeForFileDownloads:YES];
    [request setDownloadDestinationPath:destinationPath];
    
    PPDebug(@"Download to %@ (%@)", destinationPath, tempPath);
    
    [request setDelegate:self];
    [request setDownloadProgressDelegate:self];
//    self.downloadDelegate = self;
    [request setShowAccurateProgress:YES];
    [request totalBytesRead];
    
    [self.queue addOperation:request];
    
    //set request info, user defined
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:0.0]
                                                    forKey:[NSNumber numberWithInt:city.cityId]]; 
    
    [request setUserInfo:dic];
    [self.downloadRequestList addObject:request];
}

- (void)cancelDownloadCity:(City*)city
{
    [self pauseDownloadCity:city];
    [[NSFileManager defaultManager] removeItemAtPath:[AppUtils getDownloadPath:city.cityId]
                                               error:nil];
}

- (void)pauseDownloadCity:(City*)city
{
    for (ASIHTTPRequest *request in _downloadRequestList) {
        if (city.cityId == [[[request.userInfo allKeys]objectAtIndex:0] intValue] ) {
            //    Cancels an asynchronous request, clearing all delegates and blocks first
            [request clearDelegatesAndCancel];
            
            //    When a request in this queue fails or is cancelled, other requests will continue to run
            //    [self.queue setShouldCancelAllRequestsOnFailure:NO];
            
            [request cancel];
            [self.downloadRequestList removeObject:request];
            return;
        }
    }

    NSLog(@"cancelDownload");
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
//    // Use when fetching text data
//    NSString *responseString = [request responseString];
//    
//    // Use when fetching binary data
//    NSData *responseData = [request responseData];
        
    NSLog(@"requestFinished");
    [_downloadRequestList removeObject:request];
    if (self.downloadDelegate && [self.downloadDelegate respondsToSelector:@selector(didFinishedDownload)]) {
        [self.downloadDelegate didFinishedDownload];
    }
}


//- (void)requestFailed:(ASIHTTPRequest *)request
//{
////    NSError *error = [request error];
//    NSLog(@"requestFailed");
//    [_downloadRequestList removeObject:request];
//    if (self.downloadDelegate && [self.downloadDelegate respondsToSelector:@selector(didFailedDownload)]) {
//        [self.downloadDelegate didFailedDownload];
//    }
//}

- (float)getCityDownloadProgress:(City*)city
{
//    ASIHTTPRequest *request = [_downloadingDic objectForKey:city];
    for (ASIHTTPRequest *request in _downloadRequestList) {
        NSNumber *progress = [request.userInfo objectForKey:[NSNumber numberWithInt:city.cityId]];
        if(progress != nil)
        {
            return [progress floatValue];
        }
    }
    
    return 0.0;
}

- (void)setProgress:(float)newProgress
{
    NSLog(@"progress = %f", newProgress);
    if (self.downloadDelegate && [self.downloadDelegate respondsToSelector:@selector(setDownloadProgress:)]) {
        [self.downloadDelegate setDownloadProgress:newProgress];
    }
}

@end
