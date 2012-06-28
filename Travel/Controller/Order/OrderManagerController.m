//
//  OrderManagerController.m
//  Travel
//
//  Created by 小涛 王 on 12-6-26.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "OrderManagerController.h"
#import "ImageManager.h"
#import "TravelNetworkConstants.h"
#import "OrderListController.h"

@interface OrderManagerController ()

@property (retain, nonatomic) NSArray *orderTypeList;

@end

@implementation OrderManagerController

@synthesize orderTypeList = _orderTypeList;

- (void)dealloc
{
    [_orderTypeList release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [self setBackgroundImageName:@"all_page_bg2.jpg"];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.dataList = [NSArray arrayWithObjects:NSLS(@"跟团游订单管理"), NSLS(@"自由行订单管理"), NSLS(@"自定制订单管理"),nil];
    self.orderTypeList = [NSArray arrayWithObjects:[NSNumber numberWithInt:OBJECT_LIST_PACKAGE_TOUR_ORDER], [NSNumber numberWithInt:OBJECT_LIST_UNPACKAGE_TOUR_ORDER], [NSNumber numberWithInt:OBJECT_LIST_SELF_GUIDE_TOUR_ORDER], nil];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataList count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OrderManagerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        cell.imageView.image = [[ImageManager defaultManager] morePointImage];
        
        UIImage* image = [[ImageManager defaultManager] accessoryImage];
        UIImageView* cellAccessoryView = [[UIImageView alloc] initWithImage:image];
        cell.accessoryView = cellAccessoryView;
        [cellAccessoryView release];
        
        cell.textLabel.textColor = [UIColor colorWithRed:97.0/255.0 green:97.0/255.0 blue:97.0/255.0 alpha:1.0];
    }
    
	cell.textLabel.text = [dataList objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 18;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderListController *controller = [[OrderListController alloc] initWithOrderType:[[_orderTypeList objectAtIndex:indexPath.row] intValue]];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
}


@end
