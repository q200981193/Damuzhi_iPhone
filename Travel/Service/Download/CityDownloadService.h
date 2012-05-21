//
//  CityDownloadService.h
//  Travel
//
//  Created by 小涛 王 on 12-4-20.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalCityManager.h"

@protocol CityDownloadServiceDelegate <NSObject>
@optional
- (void)didFinishUnzip:(City*)city;
- (void)didFailUnzip:(City*)city;

@end

@interface CityDownloadService : NSObject

@property (retain, nonatomic) NSOperationQueue *operationQueue;

+ (id)defaultService;

- (void)download:(City*)city delegate:(NSObject<LocalCityDelegate>*)delegate;
- (void)update:(City*)city  delegate:(NSObject<LocalCityDelegate>*)delegate;
- (void)cancel:(City*)city;
- (void)pause:(City*)city;

- (void)UnzipCityDataAsynchronous:(int)cityId unzipDelegate:(id<CityDownloadServiceDelegate>)unzipDelegate;

@end
