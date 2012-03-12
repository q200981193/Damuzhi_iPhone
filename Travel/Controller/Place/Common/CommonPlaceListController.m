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


- (void)clickHelp
{
    NSLog(@"click help");
}

- (void)popSelf
{
    NSLog(@"pop self");
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"景点";
    
    //set hel
    UIImage *helpImage = [UIImage imageNamed:@"topmenu_btn_right.png"];
    UIButton *helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, helpImage.size.width, helpImage.size.height)];
    [helpButton setBackgroundImage:helpImage forState:UIControlStateNormal];
    [helpButton setTitle:@"帮助" forState:UIControlStateNormal];
    helpButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [helpButton addTarget:self action:@selector(clickHelp) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *helpButtonItem = [[UIBarButtonItem alloc] initWithCustomView:helpButton];
    self.navigationItem.rightBarButtonItem = helpButtonItem;
    [helpButton release];
    [helpButtonItem release];    
    
    UIImage *backImage = [UIImage imageNamed:@"back.png"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, backImage.size.width, backImage.size.height)];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [backButton addTarget:self action:@selector(popSelf) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [backButton release];
    [backButtonItem release]; 
    
    [_filterHandler createFilterButtons:self.buttonHolderView];
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

@end
