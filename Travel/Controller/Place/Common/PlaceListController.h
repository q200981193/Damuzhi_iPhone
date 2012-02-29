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

- (void)setAndReloadPlaceList:(NSArray*)list;
+ (PlaceListController*)createController:(NSArray*)list superView:(UIView*)superView;

@end
