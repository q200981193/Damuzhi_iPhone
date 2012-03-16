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

@interface MainController : PPViewController
{
    CommonPlaceListController *_spotListComtroller;
}

- (IBAction)clickSpotButton:(id)sender;
- (IBAction)clickCityOverviewButton:(id)sender;
- (IBAction)clickNearbyButton:(id)sender;
- (IBAction)clickMoreButton:(id)sender;
-(void) clickTitle:(id)sender;

@end
