//
//  FavoriteController.h
//  Travel
//
//  Created by haodong qiu on 12年3月28日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"
#import "PlaceListController.h"
#import "PlaceService.h"

@class PlaceListController;

@interface FavoriteController : PPViewController <DeletePlaceDelegate, PlaceServiceDelegate>

@property (retain, nonatomic) IBOutlet UIView *buttonHolderView;
@property (retain, nonatomic) IBOutlet UIView *myFavPlaceListView;
@property (retain, nonatomic) PlaceListController *myFavPlaceListController;
@property (retain, nonatomic) NSArray *showMyList;
@property (retain, nonatomic) IBOutlet UIView *topFavPlaceListView;
@property (retain, nonatomic) PlaceListController *topFavPlaceListController;
@property (retain, nonatomic)  NSArray *showTopList;

@property (assign, nonatomic) BOOL canDelete;
@property (retain, nonatomic) UIButton *myFavoriteButton;
@property (retain, nonatomic) UIButton *topFavoriteButton;
@property (retain, nonatomic) UIButton *deleteButton;

@property (retain, nonatomic) NSArray *myAllFavoritePlaceList;
@property (retain, nonatomic) NSArray *topAllFavoritePlaceList;
@property (retain, nonatomic) NSArray *topSpotFavoritePlaceList;
@property (retain, nonatomic) NSArray *topHotelFavoritePlaceList;
@property (retain, nonatomic) NSArray *topRestaurantFavoritePlaceList;
@property (retain, nonatomic) NSArray *topShoppingFavoritePlaceList;
@property (retain, nonatomic) NSArray *topEntertainmentFavoritePlaceList;

- (IBAction)clickAll:(id)sender;
- (IBAction)clickSpot:(id)sender;
- (IBAction)clickHotel:(id)sender;
- (IBAction)clickRestaurant:(id)sender;
- (IBAction)clickShopping:(id)sender;
- (IBAction)clickEntertainment:(id)sender;

@end
