//
//  CityManagementController.h
//  Travel
//
//  Created by 小涛 王 on 12-3-7.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"

@interface CityManagementController : PPTableViewController
{
    UITableView *_downloadTableView;
    NSArray *_downloadList;
    NSMutableArray *_downloadingList;
}

@property (nonatomic, retain) NSArray *downloadList;
@property (nonatomic, retain) NSMutableArray *downloadingList; 

@property (nonatomic, retain) IBOutlet UITableView *downloadTableView;
@property (retain, nonatomic) IBOutlet UILabel *promptLabel;

@end
