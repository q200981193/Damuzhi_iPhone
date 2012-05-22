//
//  NearbyController.h
//  Travel
//
//  Created by  on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceService.h"
#import "PPTableViewController.h"
#import "PlaceListController.h"

@class PlaceListController;

@interface NearbyController : PPViewController<PlaceServiceDelegate, UIGestureRecognizerDelegate,PullToRefrshDelegate, UIAlertViewDelegate>

@property (assign, nonatomic) int distance;
@property (assign, nonatomic) int categoryId;
@property (retain, nonatomic) NSArray *placeList;
@property (retain, nonatomic) NSArray *allPlaceList;
@property (assign, nonatomic) BOOL showMap;

@property (retain, nonatomic) PlaceListController* placeListController;
@property (retain, nonatomic) IBOutlet UIView *placeListHolderView;
@property (retain, nonatomic) IBOutlet UIImageView *distanceView;
@property (retain, nonatomic) UIImageView *imageRedStartView;
@property (retain, nonatomic) IBOutlet UIButton *findAllPlaceButton;
@property (retain, nonatomic) IBOutlet UIButton *findSpotButton;
@property (retain, nonatomic) IBOutlet UIButton *findHotelButton;
@property (retain, nonatomic) IBOutlet UIButton *findShoppingButton;
@property (retain, nonatomic) IBOutlet UIButton *findEntertainmentButton;
@property (retain, nonatomic) IBOutlet UIButton *findRestaurantButton;
@property (retain, nonatomic) IBOutlet UIView *buttonHolderView;

@end
