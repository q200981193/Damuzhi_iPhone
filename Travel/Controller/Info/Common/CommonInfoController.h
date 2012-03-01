//
//  CommonInfoController.h
//  Travel
//
//  Created by  on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"

@protocol CommonInfoDataSourceProtocol <NSObject>

- (NSArray*)getImages;
- (NSString*)getHtmlFilePath;
+ (NSObject<CommonInfoDataSourceProtocol>*)createDataSource;

@end

@interface CommonInfoController : PPViewController

@property (retain, nonatomic) IBOutlet UIView *imageHolderView;
@property (retain, nonatomic) NSObject<CommonInfoDataSourceProtocol> *dataSource;

- (id)initWithDataSource:(NSObject<CommonInfoDataSourceProtocol>*)source;

@end
