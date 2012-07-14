//
//  FollowRouteController.m
//  Travel
//
//  Created by haodong qiu on 12年7月14日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "FollowRouteController.h"
#import "RouteListCell.h"
#import "ImageManager.h"
#import "RouteStorage.h"
#import "CommonRouteDetailController.h"
#import "TravelNetworkConstants.h"

@interface FollowRouteController ()

@property (assign, nonatomic) int routeType;

@end

@implementation FollowRouteController
@synthesize routeType = _routeType;


- (id)initWithRouteType:(int)routeType
{
    self = [super init];
    if (self) {
        self.routeType = routeType;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的关注";
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    [self setNavigationRightButton:nil 
                         imageName:@"delete.png" 
                            action:@selector(clickClear:)];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"all_page_bg2.jpg"]]];
    
    if (_routeType == OBJECT_LIST_ROUTE_PACKAGE_TOUR) {
        self.dataList = [[RouteStorage packageFollowManager] findAllRoutes];
    } else  if (_routeType == OBJECT_LIST_ROUTE_UNPACKAGE_TOUR){
        self.dataList = [[RouteStorage unpackageFollowManager] findAllRoutes];
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RouteListCell getCellHeight];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:[RouteListCell getCellIdentifier]];
    if (cell == nil) {
        cell = [RouteListCell createCell:self];		
        
        UIImageView *view = [[UIImageView alloc] init];
        [view setImage:[[ImageManager defaultManager] listBgImage]];
        [cell setBackgroundView:view];
        [view release];
    }
    RouteListCell* routeCell = (RouteListCell*)cell;
    [routeCell setCellData:[dataList objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int routeId = [[dataList objectAtIndex:indexPath.row] routeId];
    
    CommonRouteDetailController *controller = [[CommonRouteDetailController alloc] initWithRouteId:routeId routeType:_routeType];
    
    [self.navigationController pushViewController:controller animated:YES];
    
    [controller release];
}

- (void)clickClear:(id)sender
{
    //[dataTableView setEditing:!dataTableView.editing animated:YES];
}


@end
