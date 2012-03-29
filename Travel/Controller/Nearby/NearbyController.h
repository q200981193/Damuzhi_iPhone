//
//  NearbyController.h
//  Travel
//
//  Created by  on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceService.h"
#import "PPViewController.h"

@class PlaceListController;

@interface NearbyController : PPViewController<PlaceServiceDelegate, UIGestureRecognizerDelegate>

@property (assign, nonatomic) int placeType;

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

@end
