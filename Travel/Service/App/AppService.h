//
//  AppService.h
//  Travel
//
//  Created by 小涛 王 on 12-3-12.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "CommonService.h"
#import "AppManager.h"
#import "ASINetworkQueue.h"

@protocol DownloadServiceDelegate <NSObject>
@optional   
- (void)didFinishedDownload:(int)cityId;
- (void)didFailedDownload:(int)cityId;
- (void)setDownloadProgress:(float)newProgress;
@end

@interface AppService : CommonService
{
    id<DownloadServiceDelegate> _downloadDelegate;
}

@property (retain, nonatomic) NSMutableArray *downloadRequestList;
@property (retain, nonatomic) NSOperationQueue *queue;
@property (assign, nonatomic) id<DownloadServiceDelegate> downloadDelegate;

+ (AppService*)defaultService;

- (void)loadAppData;
- (void)updateAppData;

- (void)downloadCity:(City*)city;
- (void)pauseDownloadCity:(City*)city;
- (void)cancelDownloadCity:(City*)city;
- (float)getCityDownloadProgress:(City*)city;

+ (void)downloadResource:(NSURL*)url destinationDir:(NSString*)destinationDir fileName:(NSString*)fileName;

@end
