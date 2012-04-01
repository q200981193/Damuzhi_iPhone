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

@interface AppService : CommonService

@property (retain, nonatomic) NSMutableArray *downloadRequestList;
@property (retain, nonatomic) NSOperationQueue *queue;

+ (AppService*)defaultService;

- (void)loadAppData;
- (void)updateAppData;

- (void)downloadCity:(City*)city;
- (void)pauseDownloadCity:(City*)city;
- (void)cancelDownloadCity:(City*)city;

@end
