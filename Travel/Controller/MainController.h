//
//  MainController.h
//  Travel
//
//  Created by  on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"
#import "CommonPlaceListController.h"
#import "MoreController.h"

@interface MainController : PPViewController
{
    CommonPlaceListController *_spotListComtroller;
    MoreController *_moreController;
}

- (IBAction)clickSpotButton:(id)sender;
- (IBAction)clickCityOverviewButton:(id)sender;
- (IBAction)clickNearbyButton:(id)sender;
- (IBAction)clickMoreButton:(id)sender;
-(void) clickTitle:(id)sender;

@end
