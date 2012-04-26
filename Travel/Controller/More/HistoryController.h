//
//  HistoryController.h
//  Travel
//
//  Created by haodong qiu on 12年3月29日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"
#import "PlaceListController.h"


@interface HistoryController : PPViewController

@property (retain, nonatomic) IBOutlet UIView *placeListHolderView;
@property (retain, nonatomic) NSArray *placeList;
@property (retain, nonatomic) PlaceListController *placeListController;

@end
