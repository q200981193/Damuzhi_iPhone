//
//  PlaceListController.m
//  Travel
//
//  Created by  on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlaceListController.h"
#import "Place.pb.h"
#import "CommonPlaceDetailController.h"
#import "PlaceMapViewController.h"
#import "LogUtil.h"
#import "PlaceCell.h"
#import "PlaceStorage.h"
#import "AppManager.h"
#import "UIImageUtil.h"
#import "AppService.h"
#import "MapUtils.h"

@interface PlaceListController () 

@property (assign, nonatomic) BOOL canDelete;

- (void)updateViewByMode;

@end

@implementation PlaceListController

@synthesize locationLabel = _locationLabel;
@synthesize mapHolderView = _mapHolderView;
@synthesize superController = _superController;
@synthesize mapViewController = _mapViewController;
@synthesize canDelete = _canDelete;
@synthesize deletePlaceDelegate = _deletePlaceDelegate;
@synthesize pullDownDelegate = _pullDownDelegate;

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
    self.supportRefreshHeader = YES;

    [super viewDidLoad];
     
    [self.dataTableView setSeparatorColor:[UIColor clearColor]];

    // create & add map view
    self.mapHolderView.hidden = YES;
    self.mapViewController = [[[PlaceMapViewController alloc] init] autorelease];
    [self.mapViewController.view setFrame:self.mapHolderView.bounds];
    [self.mapHolderView addSubview:self.mapViewController.view];
    [self updateViewByMode];
}

#pragma mark For Sub Class to override and implement
- (void) reloadTableViewDataSource
{
	NSLog(@"Please override reloadTableViewDataSource"); 
    if (_pullDownDelegate && [_pullDownDelegate respondsToSelector:@selector(didPullDown)]) {
        [_pullDownDelegate didPullDown];
    }
}

- (void)canDeletePlace:(BOOL)isCan delegate:(id<DeletePlaceDelegate>)delegateValue
{
    self.canDelete = isCan;
    [self.dataTableView setEditing:isCan];
    self.deletePlaceDelegate = delegateValue;
    [self.dataTableView reloadData];
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

+ (PlaceListController*)createController:(NSArray*)placeList
                               superView:(UIView*)superView
                         superController:(PPViewController*)superController
{
    PlaceListController* controller = [[[PlaceListController alloc] init] autorelease];
    [controller.view setFrame:superView.bounds];
    controller.superController = superController;
    controller.mapViewController.superController = superController;
    
    [superView addSubview:controller.view];
    
    return controller;
}


#define SHOW_NO_DATA_LABEL_TAG 100
- (void)removeNoDataTips
{
    UILabel *label = (UILabel*)[self.dataTableView viewWithTag:SHOW_NO_DATA_LABEL_TAG];
    [label removeFromSuperview];
}

- (void)addNoDataTips
{
    [self removeNoDataTips];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    label.tag = SHOW_NO_DATA_LABEL_TAG;
    label.textAlignment = UITextAlignmentCenter;
    label.text = NSLS(@"未找到相关信息");
    label.font = [UIFont systemFontOfSize:13];
    [self.dataTableView addSubview:label];
    [label release];
}

- (void)setAndReloadPlaceList:(NSArray*)list
{
    self.dataList = list;

    [self.dataTableView reloadData];
    [self.mapViewController setPlaces:list];
    if ([list count] > 0) {
        [MapUtils gotoLocation:[list objectAtIndex:0] mapView:self.mapViewController.mapView];
    }
        if ([dataList count] == 0) {
        [self addNoDataTips];
    }
    else {
        [self removeNoDataTips];
    }
    
    // after finish loading data, please call the following codes
	[refreshHeaderView setCurrentDate];  	
	[self dataSourceDidFinishLoadingNewData];
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
    return [PlaceCell class];
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
		PPDebug(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
		return nil;
	}
    
    Place* place = [dataList objectAtIndex:row];
    Class placeClass = [self getClassByPlace:place];
    
    NSString *CellIdentifier = [self getCellIdentifierByClass:placeClass];
	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) { 
		cell = [placeClass createCell:self];
	}
	
    PlaceCell *placeCell = (PlaceCell*)cell;
    
    UIImageView *view = [[UIImageView alloc] init];
    [view setImage:[UIImage strectchableImageName:@"li_bg.png"]];
    [placeCell setBackgroundView:view];
    [view release];
    [placeCell setCellDataByPlace:place currentLocation:[[AppService defaultService] currentLocation]];
    
    if (_canDelete) {
        placeCell.priceLable.hidden = YES;
        placeCell.favoritesView.hidden = YES;
        placeCell.areaLable.hidden= YES;
        placeCell.distanceLable.hidden = YES;
    }else {
        placeCell.priceLable.hidden = NO;
        placeCell.favoritesView.hidden = NO;
        placeCell.areaLable.hidden= NO;
        placeCell.distanceLable.hidden = NO;
    }
    
	return cell;	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonPlaceDetailController *controller = [[CommonPlaceDetailController alloc] initWithPlace:[dataList objectAtIndex:indexPath.row]];
    
    [self.superController.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_deletePlaceDelegate && [_deletePlaceDelegate respondsToSelector:@selector(deletedPlace:)]){
        [_deletePlaceDelegate deletedPlace:[dataList objectAtIndex:[indexPath row]]];
    }
    
    NSMutableArray *mutableDataList = [NSMutableArray arrayWithArray:dataList];
    [mutableDataList removeObjectAtIndex:indexPath.row];
    self.dataList = mutableDataList;
    
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    if ([dataList count] == 0) {
        [self addNoDataTips];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_canDelete) {
        return UITableViewCellEditingStyleDelete;
    }
    else {
        return UITableViewCellEditingStyleNone;
    }
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
