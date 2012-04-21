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

- (void)copyDefaultAppDataFormBundle
{    
    // create City Dir
    [FileUtil createDir:[AppUtils getAppDir]];
    
    // copy file from bundle to zip dir
    PPDebug(@"copy defalut app.dat from bundle to app dir");
    [FileUtil copyFileFromBundleToAppDir:FILENAME_OF_APP_DATA
                                  appDir:[AppUtils getAppDir] 
                               overwrite:NO];
}

- (void)copyBuildinHelpHtmlFileFormBundleAndRelease
{    
     if ([AppUtils hasLocalHelpHtml]) {
         return;
     }

    // copy file from bundle to zip dir
    PPDebug(@"copy defalut help.html from bundle to app dir");
    [FileUtil copyFileFromBundleToAppDir:FILENAME_OF_HELP_ZIP
                                  appDir:[AppUtils getZipDir]
                               overwrite:NO];
    
    // create City Dir
    [FileUtil createDir:[AppUtils getHelpHtmlDir]];
    
    // unzip
    [SSZipArchive unzipFileAtPath:[AppUtils getHelpZipFilePath]
                    toDestination:[AppUtils getHelpHtmlDir]];
}

- (void)copyBuildinCityZipFromBundleAndRelease
{       
    if ([AppUtils hasLocalCityData:DEFAULT_CITY_ID]) { 
        return;
    }
    
    // create City Dir
    [FileUtil createDir:[AppUtils getZipDir]];
    
    // copy file from bundle to zip dir
    PPDebug(@"copy defalut zip from bundle to zip dir");
    [FileUtil copyFileFromBundleToAppDir:DEFAULT_CITY_ZIP
                                  appDir:[AppUtils getZipDir] 
                               overwrite:NO];
    
    // if there has no unzip city data, unzip
    [self UnzipDefaultCity];
}

- (void)loadAppData
{
    [self copyDefaultAppDataFormBundle];
    [[AppManager defaultManager] loadAppData];

    [self copyBuildinCityZipFromBundleAndRelease];
    [self copyBuildinHelpHtmlFileFormBundleAndRelease];
}

- (void)updateHelpHtmlFile
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CommonNetworkOutput* output = [TravelNetworkRequest queryObject:OBJECT_TYPE_HELP_INOF lang:LANGUAGE_SIMPLIFIED_CHINESE];
        HelpInfo *helpInfo = nil;
        
        if (output.resultCode == ERROR_SUCCESS){
            @try{
                helpInfo = [[TravelResponse parseFromData:output.responseData] helpInfo];
                if (![helpInfo.version isEqualToString:[self getHelpHtmlFileVersion]]) {
                    NSURL *url = [NSURL URLWithString:helpInfo.helpHtml];
                    [self downloadResource:url destinationDir:[AppUtils getZipDir] fileName:FILENAME_OF_HELP_ZIP];
                    [SSZipArchive unzipFileAtPath:[AppUtils getHelpZipFilePath] 
                                    toDestination:[AppUtils getHelpHtmlDir]];
                    [self setHelpHtmlFileVersion:helpInfo.version];
                }
            }
            
            @catch (NSException *exception){
                NSLog (@"Caught %@%@", [exception name], [exception reason]);
            }
        }
    });    

}

#define KEY_HELP_HTML_FILE_VERSION @"KEY_HELP_HTML_FILE_VERSION"
- (NSString*)getHelpHtmlFileVersion
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:KEY_HELP_HTML_FILE_VERSION];
}

- (void)setHelpHtmlFileVersion:(NSString*)version
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:version forKey:KEY_HELP_HTML_FILE_VERSION];
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
            [self downloadProvidedServiceIcons:placeMetas];
        }
    });    
}

- (void)downloadProvidedServiceIcons:(NSArray*)placeMetas
{
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

- (void)downloadResource:(NSURL*)url destinationDir:(NSString*)destinationDir fileName:(NSString*)fileName
{
    [FileUtil createDir:destinationDir];
    NSString *destinationPath = [destinationDir stringByAppendingPathComponent:fileName];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    PPDebug(@"download request = %@", url.description);
    [request setDownloadDestinationPath:destinationPath];
//    [request setResponseEncoding:NSUTF8StringEncoding];
    
    [request startSynchronous];
}  

- (void)UnzipDefaultCity
{
    // if there has no unzip city data, unzip
    if ([AppUtils unzipCityZip:DEFAULT_CITY_ID]) {
        [[NSFileManager defaultManager] createFileAtPath:[AppUtils getUnzipFlag:DEFAULT_CITY_ID]
                                                contents:nil
                                              attributes:nil];
        LocalCity *localCity = [[LocalCityManager defaultManager] createLocalCity:DEFAULT_CITY_ID];
        localCity.downloadStatus = DOWNLOAD_SUCCEED;
    }
    else {
        PPDebug(@"解压默认城市失败");
    }
}

- (void)UnzipCityDataAsynchronous:(int)cityId unzipDelegate:(id<UnzipDelegate>)unzipDelegate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // if there has no unzip city data, unzip
        if ([AppUtils unzipCityZip:cityId]) {
            [[NSFileManager defaultManager] createFileAtPath:[AppUtils getUnzipFlag:cityId]
                                                    contents:nil
                                                  attributes:nil];
            if (unzipDelegate && [unzipDelegate respondsToSelector:@selector(didFinishUnzip:)]) {
                [unzipDelegate didFinishUnzip:[[AppManager defaultManager] getCity:cityId]];
            }
        }
        else {
            [[LocalCityManager defaultManager] removeLocalCity:cityId];
            
            if (unzipDelegate && [unzipDelegate respondsToSelector:@selector(didFailUnzip:)]) {
                [unzipDelegate didFailUnzip:[[AppManager defaultManager] getCity:cityId]];
            }
        }
    });    
}

@end
