//
//  RestaurantFilter.h
//  Travel
//
//  Created by haodong qiu on 12年3月29日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonPlaceListController.h"

@interface RestaurantFilter : NSObject<PlaceListFilterProtocol>

@property (retain, nonatomic) PPTableViewController *controller;

@end
