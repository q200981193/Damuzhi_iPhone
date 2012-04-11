//
//  RouteController.m
//  Travel
//
//  Created by 小涛 王 on 12-4-10.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "RouteController.h"
#import "AppUtils.h"
#import "AppManager.h"
#import "UIImageUtil.h"
#import "PPDebug.h"
#import "RouteCell.h"

@implementation RouteController

- (void)viewDidLoad
{
    [self setBackgroundImageName:@"all_page_bg2.jpg"];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationLeftButton:NSLS(@"返回") imageName:@"back.png" action:@selector(clickBack:)];
    
    [self.navigationItem setTitle:NSLS(@"线路推荐")];
        
    [[TravelTipsService defaultService] findTravelRouteList:[[AppManager defaultManager] getCurrentCityId] viewController:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 75;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;		// default implementation
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    cell = [theTableView dequeueReusableCellWithIdentifier:[RouteCell getCellIdentifier]];
    if (cell == nil) {
        cell = [RouteCell createCell:self];				
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        // Customize the appearance of table view cells at first time
        UIImageView *view = [[UIImageView alloc] init];
        [view setImage:[UIImage imageNamed:@"list_tr_bg2.png"]];
        [cell setBackgroundView:view];
        [view release];
    }
    
    int row = [indexPath row];	
    int count = [dataList count];
    if (row >= count){
        PPDebug(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
        return cell;
    }
    RouteCell* routeCell = (RouteCell*)cell;
    [routeCell setCellData:[dataList objectAtIndex:row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark -
#pragma mark: implementation of TravelTipsServiceDelegate

- (void)findRequestDone:(int)resulteCode tipList:(NSArray*)tipList
{
    if (resulteCode == 0) {
        self.dataList = tipList;
        [self.dataTableView reloadData];
    }
    else {
        [self popupMessage:NSLS(@"加载数据失败") title:nil];
    }
    
}

@end
