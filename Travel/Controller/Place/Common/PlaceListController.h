//
//  PlaceListController.h
//  Travel
//
//  Created by  on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"

@class PlaceMapViewController;
@class Place;

@protocol DeletePlaceDelegate <NSObject>

- (void)deletedPlace:(Place *)place;

@end

@interface PlaceListController : PPTableViewController
{
    BOOL _showMap;
    UIView *_mapHolderView;
}



- (void)setAndReloadPlaceList:(NSArray*)list;
+ (PlaceListController*)createController:(NSArray*)list 
                               superView:(UIView*)superView
                         superController:(UIViewController*)superController;


@property (retain, nonatomic) PlaceMapViewController *mapViewController;
@property (retain, nonatomic) IBOutlet UILabel *locationLabel;
@property (retain, nonatomic) IBOutlet UIView *mapHolderView;
@property (retain, nonatomic) UIViewController *superController;
@property (assign, nonatomic) id<DeletePlaceDelegate> deletePlaceDelegate;

- (void)switchToMapMode;
- (void)switchToListMode;

- (void)canDeletePlace:(BOOL)isCan delegate:(id<DeletePlaceDelegate>)delegate;

@end
