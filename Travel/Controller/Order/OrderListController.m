//
//  OrderListController.m
//  Travel
//
//  Created by 小涛 王 on 12-6-26.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "OrderListController.h"
#import "ImageManager.h"
#import "OrderCell.h"

@interface OrderListController ()

@end

@implementation OrderListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataList count];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[OrderCell getCellIdentifier]];
    if (cell == nil) {
        cell = [OrderCell createCell:self];
        
    }
    
    OrderCell *orderCell = (OrderCell *)cell;
    
	[orderCell setCellData:[dataList objectAtIndex:indexPath.row]];
    
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
    
    
}

@end
