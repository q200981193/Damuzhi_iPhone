//
//  CommonInfoController.h
//  Travel
//
//  Created by  on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"
#import "CityOverviewService.h"

@protocol CommonInfoDataSourceProtocol <NSObject>
- (NSString*)getTitleName;
- (void)requestDataWithDelegate:(PPViewController<CityOverviewServiceDelegate>*)delegate;
+ (NSObject<CommonInfoDataSourceProtocol>*)createDataSource;

@end

@interface CityBasicController : PPViewController <CityOverviewServiceDelegate, UIWebViewDelegate>
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property (retain, nonatomic) IBOutlet UIView *imageHolderView;
@property (retain, nonatomic) IBOutlet UIWebView *dataWebview;
@property (retain, nonatomic) NSObject<CommonInfoDataSourceProtocol> *dataSource;

- (id)initWithDataSource:(NSObject<CommonInfoDataSourceProtocol>*)source;

@end
