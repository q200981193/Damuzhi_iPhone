//
//  FlightController.h
//  Travel
//
//  Created by 小涛 王 on 12-7-3.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PPTableViewController.h"
#import "TouristRoute.pb.h"

@interface FlightController : PPTableViewController

- (id)initWithDepartFlight:(Flight *)departFlight returnFlight:(Flight *)returnFlight;

@end
