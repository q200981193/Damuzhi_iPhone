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

@property (retain, nonatomic) IBOutlet UILabel *departFlightTextField;

@property (retain, nonatomic) IBOutlet UILabel *departFlightLaunchInfoTextField;

@property (retain, nonatomic) IBOutlet UILabel *departFlightDescendInfoTextField;

@property (retain, nonatomic) IBOutlet UILabel *departFlightNumberTextField;



@property (retain, nonatomic) IBOutlet UILabel *returnFlightTextField;

@property (retain, nonatomic) IBOutlet UILabel *returnFlightLaunchInfoTextField;


@property (retain, nonatomic) IBOutlet UILabel *returnFlightDescendInfoTextField;

@property (retain, nonatomic) IBOutlet UILabel *returnFlightNumberTextField;



@end
