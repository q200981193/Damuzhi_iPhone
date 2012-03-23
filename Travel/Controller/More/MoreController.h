//
//  MoreController.h
//  Travel
//
//  Created by 小涛 王 on 12-3-7.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"
#import "CityManagementController.h"

@interface MoreController : PPTableViewController
{
    CityManagementController *_cityManagementController;
}

@property (retain, nonatomic) CityManagementController *cityManagementController;

@end
