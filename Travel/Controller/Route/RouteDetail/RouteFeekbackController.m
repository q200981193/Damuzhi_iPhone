//
//  RouteFeekback.m
//  Travel
//
//  Created by 小涛 王 on 12-6-20.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "RouteFeekbackController.h"
#import "Package.pb.h"
#import "RouteService.h"

@interface RouteFeekbackController ()

@property (assign, nonatomic) int routeId;

@end

@implementation RouteFeekbackController

@synthesize routeId = _routeId;

- (id)initWithRouteId:(int)routeId
{
    if (self = [super init]) {
        // Custom initialization
        self.routeId = routeId;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png" 
                           action:@selector(clickBack:)];
    
    [self setNavigationRightButton:NSLS(@"我的关注") 
                         imageName:@"topmenu_btn2.png"
                            action:@selector(clickMyFollow:)];    
    
    
    
    
    
    
    [RouteService defaultService] ;
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return [RouteFeekbackController getCellHeight];
}

@end









