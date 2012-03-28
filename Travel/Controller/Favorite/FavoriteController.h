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

@class PlaceListController;

@interface FavoriteController : PPViewController <DeletePlaceDelegate>

@property (retain, nonatomic) IBOutlet UIView *buttonHolderView;
@property (retain, nonatomic) IBOutlet UIView *placeListHolderView;
@property (retain, nonatomic) PlaceListController* placeListController;
@property (retain, nonatomic) NSArray *placeList;
@property (assign, nonatomic) BOOL canDelete;

- (IBAction)clickAll:(id)sender;
- (IBAction)clickSpot:(id)sender;
- (IBAction)clickHotel:(id)sender;

@end
