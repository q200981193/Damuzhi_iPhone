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

@interface NearbyController : PPViewController<PlaceServiceDelegate>

@property (retain, nonatomic) PlaceListController* placeListController;
@property (retain, nonatomic) IBOutlet UIView *placeListHolderView;

@end
