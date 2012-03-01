//
//  PlaceListController.h
//  Travel
//
//  Created by  on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"

@interface PlaceListController : PPTableViewController
{
    BOOL _showMap;
}

- (void)setAndReloadPlaceList:(NSArray*)list;
+ (PlaceListController*)createController:(NSArray*)list superView:(UIView*)superView;

@property (retain, nonatomic) IBOutlet UIView *mapView;
@property (retain, nonatomic) IBOutlet UILabel *locationLabel;
@property (retain, nonatomic) IBOutlet UIView *mapHolderView;

@end
