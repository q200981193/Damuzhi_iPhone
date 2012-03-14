//
//  CommonPlaceListController.m
//  Travel
//
//  Created by  on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommonPlaceListController.h"
#import "PlaceListController.h"
#import "PlaceManager.h"
#import "PlaceService.h"
#import "PlaceMapViewController.h"

@implementation CommonPlaceListController

@synthesize buttonHolderView;
@synthesize placeListHolderView;
@synthesize placeListController;
@synthesize filterHandler = _filterHandler;

- (void)dealloc {
    [_filterHandler release];
    [placeListController release];
    [buttonHolderView release];
    [placeListHolderView release];
    [super dealloc];
}

- (id)initWithFilterHandler:(NSObject<PlaceListFilterProtocol>*)handler
{
    self = [super init];
    self.filterHandler = handler;
    return self;
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


- (void)clickHelp:(id)sender
{
    NSLog(@"click help");
}

- (void)popSelf
{
    [self.navigationController popViewControllerAnimated:YES];    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    [self setNavigationLeftButton:NSLS(@"返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    [self setNavigationRightButton:NSLS(@"帮助") 
                         imageName:@"topmenu_btn_right.png" 
                            action:@selector(clickHelp:)];
    
    [_filterHandler createFilterButtons:self.buttonHolderView controller:self];
    [_filterHandler findAllPlaces:self];
}

- (void)viewDidUnload
{
    [self setButtonHolderView:nil];
    [self setPlaceListHolderView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)findRequestDone:(int)result dataList:(NSArray*)list
{
    self.placeListController = [PlaceListController createController:list superView:placeListHolderView];    
}

- (IBAction)clickMapButton:(id)sender
{
    PlaceMapViewController* controller = [[PlaceMapViewController alloc] init];
    //设置Places
//    [controller setPlaces:nil];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

@end
