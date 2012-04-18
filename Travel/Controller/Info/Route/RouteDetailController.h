//
//  RouteDetailController.h
//  Travel
//
//  Created by 小涛 王 on 12-4-18.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PPViewController.h"
#import "TravelTips.pb.h"


@interface RouteDetailController : PPViewController

@property (retain, nonatomic) CommonTravelTip *tip;
@property (retain, nonatomic) IBOutlet UIView *imageHolderView;
@property (retain, nonatomic) IBOutlet UILabel *routeNameLabel;
@property (retain, nonatomic) IBOutlet UIView *detailIntroView;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

- (RouteDetailController*)initWithDataSource:(CommonTravelTip*)tip;

@end
