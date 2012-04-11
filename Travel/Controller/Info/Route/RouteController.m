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
#import "PPApplication.h"
#import "PPDebug.h"
#import "TravelTipsManager.h"


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

#pragma mark - 
#pragma mark: Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 74.5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;		// default implementation
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataList count];
}

-(void) managedImageSet:(HJManagedImageV*)mi
{
}

-(void) managedImageCancelled:(HJManagedImageV*)mi
{
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int row = [indexPath row];	
	int count = [dataList count];
	if (row >= count){
		NSLog(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
		return nil;
	}
    
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellForRoute"] autorelease];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage strectchableImageName:@"list_tr_bg2.png"]];
    [cell setBackgroundView: backgroundView];
    [backgroundView release];
    
    CommonTravelTip *tip = [dataList objectAtIndex:row];
    PPDebug(@"tip name = %@", tip.name);
    PPDebug(@"tip briefIntro = %@", tip.briefIntro);
    PPDebug(@"tip image = %@", tip.image);


    
    cell.textLabel.text = tip.name;
    [cell.textLabel setFont:[UIFont systemFontOfSize:13]];

    cell.detailTextLabel.text = tip.briefIntro;
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13]];
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    
    HJManagedImageV *imageView  = [[HJManagedImageV alloc] initWithFrame:CGRectMake(30, 30, 100, 75)];
    [self setImage:imageView image:tip.image];
    UIImageView *temp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heart.png"]];
    [cell.imageView addSubview:temp];
    [imageView release];
    
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

#pragma mark -
#pragma mark: fech image from url asynchrounous

//- (void)grabURLInBackground:(NSString*)urlString
//{
//    NSURL *url = [NSURL URLWithString:urlString];
//    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//    [request setDelegate:self];
//    [request startAsynchronous];
//}
//
//- (void)requestFinished:(ASIHTTPRequest *)request
//{    
//    // Use when fetching binary data
//    NSData *responseData = [request responseData];
//    
//    UIImage *image = [UIImage ]
//}
//
//- (void)requestFailed:(ASIHTTPRequest *)request
//{
//    NSError *error = [request error];
//}




@end
