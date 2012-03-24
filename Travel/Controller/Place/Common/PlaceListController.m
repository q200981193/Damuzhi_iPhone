//
//  PlaceListController.m
//  Travel
//
//  Created by  on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlaceListController.h"
#import "Place.pb.h"
#import "PlaceManager.h"
#import "SpotCell.h"
#import "CommonPlaceDetailController.h"
#import "PlaceMapViewController.h"
#import "LogUtil.h"

@interface PlaceListController () 

- (void)updateViewByMode;

@end

@implementation PlaceListController

@synthesize locationLabel = _locationLabel;
@synthesize mapHolderView = _mapHolderView;
@synthesize superController = _superController;
@synthesize mapViewController = _mapViewController;

- (void)dealloc
{
    [_mapViewController release];
    [_locationLabel release];
    [_mapHolderView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _showMap = NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // create & add map view
    self.mapHolderView.hidden = YES;
    self.mapViewController = [[[PlaceMapViewController alloc] init] autorelease];
    self.mapViewController.view.frame = self.mapHolderView.bounds;
    [self.mapHolderView addSubview:self.mapViewController.view];
        
    [self updateViewByMode];
}

- (void)viewDidUnload
{
    [self setLocationLabel:nil];
    [self setMapHolderView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

+ (PlaceListController*)createController:(NSArray*)list 
                               superView:(UIView*)superView
                         superController:(UIViewController*)superController
{
    PlaceListController* controller = [[[PlaceListController alloc] init] autorelease];
    controller.view.frame = superView.bounds;
    controller.superController = superController;
    [superView addSubview:controller.view];
    [controller setAndReloadPlaceList:list];    
    
    for (Place *place in list) {
        PPDebug(@"<PlaceListController>");
        PPDebug(@"最低价格:%@",place.price);
        PPDebug(@"区域id:%d",place.areaId);
        for (NSNumber *number in place.providedServiceIdList) {
            PPDebug(@"服务选项ID:%d",number.intValue);
        }
        PPDebug(@"大拇指评级:%d",place.rank);
        PPDebug(@"酒店星级:%d",place.hotelStar);
        PPDebug(@"经纬度:%f,%f",place.longitude ,place.latitude);
    }
    
    return controller;
}

- (void)setAndReloadPlaceList:(NSArray*)list
{
    self.dataList = list;
    [self.dataTableView reloadData];
    [self.mapViewController setPlaces:list];
}

#pragma mark -
#pragma mark TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// return [self getRowHeight:indexPath.row totalRow:[dataList count]];
	// return cellImageHeight;
	
	return 76;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;		// default implementation
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [dataList count];			// default implementation
}


- (Class)getClassByPlace:(Place*)place
{
    if ([place categoryId] == PLACE_TYPE_SPOT){
        return [SpotCell class];
    }
    if ([place categoryId] == PLACE_TYPE_HOTEL){
        return [SpotCell class];
    }
    return nil;
}

- (NSString*)getCellIdentifierByClass:(Class)class
{
    return [class getCellIdentifier];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int row = [indexPath row];	
	int count = [dataList count];
	if (row >= count){
		NSLog(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
		return nil;
	}
    
    Place* place = [dataList objectAtIndex:row];
    Class placeClass = [self getClassByPlace:place];
    
    NSString *CellIdentifier = [self getCellIdentifierByClass:placeClass];
	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) { 
		cell = [placeClass createCell:self];
	}
	
    CommonPlaceCell* placeCell = (CommonPlaceCell*)cell;
    
    //[placeCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"2menu_bg.png"]]];
    UIImageView *view = [[UIImageView alloc] init];
    [view setImage:[UIImage imageNamed:@"li_bg.png"]];
    [placeCell setBackgroundView:view];
    [placeCell setCellDataByPlace:place];
	return cell;	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CommonPlaceDetailController* controller = [[CommonPlaceDetailController alloc] init];
    NSLog(@"%@",[[dataList objectAtIndex:[indexPath row]]name]);

    CommonPlaceDetailController *controller = [[CommonPlaceDetailController alloc]initWithPlace:[dataList objectAtIndex:[indexPath row]]];
    [self.superController.navigationController pushViewController:controller animated:YES];
    [controller release];

}

- (void)updateViewByMode
{    
    
    if (_showMap){
        _mapHolderView.hidden = NO;
        dataTableView.hidden = YES;
    }
    else{
        _mapHolderView.hidden = YES;
        dataTableView.hidden = NO;
    }    
}

- (void)switchToMapMode
{
    _showMap = YES;
    [self updateViewByMode];
}

- (void)switchToListMode
{
    _showMap = NO;
    [self updateViewByMode];
}


@end
