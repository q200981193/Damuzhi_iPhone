//
//  CityDownloadService.m
//  Travel
//
//  Created by 小涛 王 on 12-4-20.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "CityDownloadService.h"
#import "AppUtils.h"
#import "FileUtil.h"
#import "AppUtils.h"
#import "SSZipArchive.h"
#import "AppManager.h"
#import "PPDebug.h"

@implementation CityDownloadService

@synthesize operationQueue = _operationQueue;

static CityDownloadService *_instance;

+ (id)defaultService
{
    if (_instance == nil) {
        _instance = [[CityDownloadService alloc] init];
    }
    
    return _instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.operationQueue = [[[NSOperationQueue alloc] init] autorelease];
    }
    
    return self;
}

- (void)dealloc
{
    [_operationQueue release];
    [super dealloc];
}


- (void)download:(City*)city delegate:(NSObject<LocalCityDelegate>*)delegate
{
    LocalCity *localCity = [[LocalCityManager defaultManager] createLocalCity:city.cityId];
    localCity.delegate = delegate;
    localCity.downloadStatus = DOWNLOADING;

    NSURL *url = [NSURL URLWithString:city.downloadUrl];
    
    ASIHTTPRequest *request = [self createRequest:url localCity:localCity];
    
    //set request info, user defined
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:localCity forKey:KEY_LOCAL_CITY];
    [userInfo setObject:[NSNumber numberWithInt:REQUEST_TYPE_DOWNLOAD] forKey:KEY_REQUEST_TYPE];

    
    [request setUserInfo:userInfo];
    [userInfo release];
    
    //add request into queue and run
    [_operationQueue addOperation:request];
}

- (void)update:(City*)city delegate:(NSObject<LocalCityDelegate>*)delegate
{
    LocalCity *localCity = [[LocalCityManager defaultManager] createLocalCity:city.cityId];
    localCity.delegate = delegate;
    localCity.updateStatus = UPDATING;
    
    NSURL *url = [NSURL URLWithString:city.downloadUrl];
    
    ASIHTTPRequest *request = [self createRequest:url localCity:localCity];
    
    //set request info, user defined
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:localCity forKey:KEY_LOCAL_CITY];
    
    [userInfo setObject:[NSNumber numberWithInt:REQUEST_TYPE_UPDATE] forKey:KEY_REQUEST_TYPE];
    
    [request setUserInfo:userInfo];
    [userInfo release];
    
    //add request into queue and run
    [_operationQueue addOperation:request];
}

- (ASIHTTPRequest*)createRequest:(NSURL*)url localCity:(LocalCity*)localCity
{
    // Get destination path and temp path.
    NSString *tempPath = [AppUtils getDownloadPath:localCity.cityId];
    NSString *destinationPath = [AppUtils getZipFilePath:localCity.cityId];

    // Create a request
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url]; 

    // Set temp file and dest file.
    [request setTemporaryFileDownloadPath:tempPath];
    [request setDownloadDestinationPath:destinationPath];
    [request setAllowResumeForFileDownloads:YES];

//    PPDebug(@"Download to %@ (%@)", destinationPath, tempPath);

    //set request delegate
    [request setDelegate:localCity];
    [request setDownloadProgressDelegate:localCity];
    
    return request;
}

- (void)cancel:(City*)city
{
    // Remove temp download file.
    NSString *cityZipPath = [AppUtils getDownloadPath:city.cityId];
    [[NSFileManager defaultManager] removeItemAtPath:cityZipPath error:nil];
    
    // Remove localCity.
    [[LocalCityManager defaultManager] removeLocalCity:city.cityId];
    
    // Cancel and remove request from operation queue.
    for (ASIHTTPRequest *request in [_operationQueue operations]) {
        LocalCity *localCity = [request.userInfo objectForKey:KEY_LOCAL_CITY];
        if(localCity.cityId == city.cityId)
        {
            // Cancels an asynchronous request, clearing all delegates and blocks first
            [request clearDelegatesAndCancel];    
            [request cancel];
            
            // Need to remove request ？？？
                        
            return;
        }
    }
}

- (void)pause:(City*)city
{
    for (ASIHTTPRequest *request in [_operationQueue operations]) {
        LocalCity *localCity = [request.userInfo objectForKey:KEY_LOCAL_CITY];
        int requestType = [[request.userInfo objectForKey:KEY_REQUEST_TYPE] intValue];
        if(localCity.cityId == city.cityId)
        {
            //Cancels an asynchronous request, clearing all delegates and blocks first
            [request clearDelegatesAndCancel];    
            [request cancel];
            
            switch (requestType) {
                case REQUEST_TYPE_DOWNLOAD:
                    localCity.downloadStatus = DOWNLOAD_PAUSE;
                    break;
                    
                case REQUEST_TYPE_UPDATE:
                    localCity.updateStatus = UPDATE_PAUSE;
                    break;
                    
                default:
                    break;
            }
            return;
        }
    }
}

- (void)UnzipCityDataAsynchronous:(int)cityId unzipDelegate:(id<CityDownloadServiceDelegate>)unzipDelegate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([AppUtils unzipCityZip:cityId]) {
            [[NSFileManager defaultManager] createFileAtPath:[AppUtils getUnzipFlag:cityId]
                                                    contents:nil
                                                  attributes:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (unzipDelegate && [unzipDelegate respondsToSelector:@selector(didFinishUnzip:)])
                {                    
                    if (unzipDelegate && [unzipDelegate respondsToSelector:@selector(didFinishUnzip:)]) {
                        [unzipDelegate didFinishUnzip:[[AppManager defaultManager] getCity:cityId]];
                    }
                }     
            });
        }
        else {
            [[LocalCityManager defaultManager] removeLocalCity:cityId];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (unzipDelegate && [unzipDelegate respondsToSelector:@selector(didFailUnzip:)]) {
                    [unzipDelegate didFailUnzip:[[AppManager defaultManager] getCity:cityId]];
                }
            });
        }
    });    
}

- (BOOL)unzipCityZip:(int)cityId
{
    [FileUtil createDir:[AppUtils getCityDir:cityId]];
    
    return [SSZipArchive unzipFileAtPath:[AppUtils getZipFilePath:cityId]
                           toDestination:[AppUtils getCityDir:cityId]];;
}

@end
