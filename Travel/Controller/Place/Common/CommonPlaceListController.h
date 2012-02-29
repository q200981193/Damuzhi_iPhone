//
//  CommonPlaceListController.h
//  Travel
//
//  Created by  on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"

@class PlaceListController;

@interface CommonPlaceListController : PPTableViewController 

@property (retain, nonatomic) IBOutlet UIView *buttonHolderView;
@property (retain, nonatomic) IBOutlet UIView *placeListHolderView;

@property (retain, nonatomic) PlaceListController* placeListController;

@end
