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

@implementation PlaceListController
@synthesize mapView;
@synthesize locationLabel;
@synthesize mapHolderView;

- (void)dealloc
{
    [mapView release];
    [locationLabel release];
    [mapHolderView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    // Do any additional setup after loading the view from its nib.
    if (_showMap){
        mapHolderView.hidden = NO;
        dataTableView.hidden = YES;
    }
    else{
        mapHolderView.hidden = YES;
        dataTableView.hidden = NO;
    }
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setLocationLabel:nil];
    [self setMapHolderView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

+ (PlaceListController*)createController:(NSArray*)list superView:(UIView*)superView
{
    PlaceListController* controller = [[[PlaceListController alloc] init] autorelease];    
    [superView addSubview:controller.view];
    controller.view.frame = superView.bounds;
    [controller setAndReloadPlaceList:list];    
    [controller viewDidLoad];
    return controller;
}

- (void)setAndReloadPlaceList:(NSArray*)list
{
    self.dataList = list;
    [self.dataTableView reloadData];
}

#pragma mark -
#pragma mark TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// return [self getRowHeight:indexPath.row totalRow:[dataList count]];
	// return cellImageHeight;
	
	return 55;
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
    [placeCell setCellDataByPlace:place];
    
	return cell;	
}


@end
