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
#import "NearbyController.h"
#import "WBEngine.h"


@interface MainController : PPViewController<UIActionSheetDelegate>
{
    CommonPlaceListController *_spotListComtroller;
    CommonPlaceListController *_hotelListComtroller;
    CommonPlaceListController *_restaurantListComtroller;
    CommonPlaceListController *_shoppingListComtroller;
    CommonPlaceListController *_entertainmentListComtroller;
    NearbyController *_nearbyController;
    MoreController *_moreController;
}

- (IBAction)clickSpotButton:(id)sender;
- (IBAction)clickHotelButton:(id)sender;
- (IBAction)clickRestaurant:(id)sender;
- (IBAction)clickShopping:(id)sender;
- (IBAction)clickEntertainment:(id)sender;

- (IBAction)clickCityBasicButton:(id)sender;
- (IBAction)clickTravelPreparationButton:(id)sender;
- (IBAction)clickTravelUtilityButton:(id)sender;
- (IBAction)clickTravelTransportButton:(id)sender;
- (IBAction)clickTraveGuideButton:(id)sender;
- (IBAction)clickNearbyButton:(id)sender;
- (IBAction)clickMoreButton:(id)sender;
-(void) clickTitle:(id)sender;
- (IBAction)clickFavorite:(id)sender;
- (IBAction)clickShare:(id)sender;

@end
