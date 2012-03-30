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
#import "SelectController.h"
#import "AppManager.h"
#import "CommonPlace.h"
#import "CityOverviewManager.h"

@implementation CommonPlaceListController

@synthesize modeButton;
@synthesize buttonHolderView;
@synthesize placeListHolderView;
@synthesize placeListController;
@synthesize filterHandler = _filterHandler;

@synthesize selectedCategoryIdList = _selectCategoryIdList;
@synthesize selectedSortIdList = _selectedSortIdList;
@synthesize selectedAreaIdList = _selectedAreaIdList;
@synthesize selectedPriceIdList = _selectedPriceIdList;
@synthesize selectedServiceIdList = _selectedServiceIdList;
@synthesize selectedCuisineIdList = _selectedCuisineIdList;

- (void)dealloc {
    [_filterHandler release];
    [placeListController release];
    [buttonHolderView release];
    [placeListHolderView release];
    [_selectedSortIdList release];
    [_selectedCategoryIdList release];
    [_selectedAreaIdList release];
    [_selectedPriceIdList release];
    [_selectedServiceIdList release];
    [_selectedCuisineIdList release];
    [modeButton release];
    [super dealloc];
}

- (id)initWithFilterHandler:(NSObject<PlaceListFilterProtocol>*)handler
{
    self = [super init];
    self.filterHandler = handler;
    self.selectedCategoryIdList = [[[NSMutableArray alloc] init] autorelease];
    self.selectedSortIdList = [[[NSMutableArray alloc] init] autorelease];
    self.selectedPriceIdList = [[[NSMutableArray alloc] init] autorelease];
    self.selectedAreaIdList = [[[NSMutableArray alloc] init] autorelease];
    self.selectedServiceIdList = [[[NSMutableArray alloc] init] autorelease];
    self.selectedCuisineIdList = [[[NSMutableArray alloc] init] autorelease];
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
    [self setModeButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.placeListController.dataTableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSArray*)filterAndSort:(NSArray*)placeList
{    
    placeList = [_filterHandler filterAndSotrPlaceList:placeList
                                selectedCategoryIdList:self.selectedCategoryIdList
                                   selectedPriceIdList:self.selectedPriceIdList
                                    selectedAreaIdList:self.selectedAreaIdList
                                 selectedServiceIdList:self.selectedServiceIdList
                                 selectedCuisineIdList:self.selectedCuisineIdList
                                                sortBy:[self.selectedSortIdList objectAtIndex:0]
                                       currentLocation:self.placeListController.currentLocation];
    
    return placeList;
}

- (void)findRequestDone:(int)result dataList:(NSArray*)list
{
    if (self.placeListController == nil){
        [self.selectedCategoryIdList addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
        [self.selectedSortIdList addObject:[NSNumber numberWithInt:SORT_BY_RECOMMEND]];
        [self.selectedPriceIdList addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
        [self.selectedAreaIdList addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
        [self.selectedServiceIdList addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
        [self.selectedCuisineIdList addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
        list = [self filterAndSort:list];
        self.placeListController = [PlaceListController createController:list 
                                                               superView:placeListHolderView
                                                         superController:self];    
    }
    else{
        list = [self filterAndSort:list];
        [self.placeListController setAndReloadPlaceList:list];
    }    
    self.navigationItem.title = [[_filterHandler getCategoryName] stringByAppendingFormat:@"(%d)", list.count];
}

- (void)updateModeButton
{
    // set button text by _showMap flag
    if (_showMap) {
        [self.modeButton setTitle:@"列表" forState:UIControlStateNormal];
    } else {
        [self.modeButton setTitle:@"地图" forState:UIControlStateNormal];

    }
}

- (IBAction)clickMapButton:(id)sender
{
//    CATransition *animation=[CATransition animation];
//    [animation setDelegate:self];
//    [animation setDuration:0.5];
//    animation.type = @"pageCurl"; //动画样式
//    animation.subtype = kCATransitionFromLeft; //方向
//    [self.view.layer addAnimation:animation forKey:@"animation"];
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.75];
	
	[UIView setAnimationTransition:(_showMap ?
									UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight)
						   forView:self.view cache:YES];
    [UIView commitAnimations];

    if (_showMap){
        [self.placeListController switchToListMode];
    }
    else{
        [self.placeListController switchToMapMode];
    }
    
    _showMap = !_showMap;
    [self updateModeButton];
}


- (void)clickCategoryButton:(id)sender
{
    NSArray *subCategoryList = [[AppManager defaultManager] getSubCategoryList:[_filterHandler getCategoryId]];
    SelectController* selectController = [SelectController createController:subCategoryList                                                           
                                                                selectedIds:self.selectedCategoryIdList 
                                                               multiOptions:YES];
    
    selectController.navigationItem.title = [[_filterHandler getCategoryName] stringByAppendingString:NSLS(@"分类")];
    
    [self.navigationController pushViewController:selectController animated:YES];
    selectController.delegate = self;
        
    NSLog(@"<clickCategoryButton>");
}

- (void)clickSortButton:(id)sender
{    
    NSArray *sortOptionList = [[AppManager defaultManager] getSortOptionList:[_filterHandler getCategoryId]];
    SelectController* selectController = [SelectController createController:sortOptionList
                                                                selectedIds:self.selectedSortIdList 
                                                               multiOptions:NO];

    
    selectController.navigationItem.title = [[_filterHandler getCategoryName] stringByAppendingString:NSLS(@"排序")];
    
    [self.navigationController pushViewController:selectController animated:YES];
    selectController.delegate = self;
    
    NSLog(@"<clickSortButton>");
}

- (void)clickPrice:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSString *title = button.titleLabel.text;
    
    //NSArray *hotelPriceList = [[AppManager defaultManager] getHotelPriceList];
    NSArray *hotelPriceList = [[CityOverViewManager defaultManager] getWillSelectPriceList];
    SelectController* selectController = [SelectController createController:hotelPriceList
                                                                selectedIds:self.selectedPriceIdList
                                                               multiOptions:YES];
    selectController.navigationItem.title = [[_filterHandler getCategoryName] stringByAppendingString:title];
    [self.navigationController pushViewController:selectController animated:YES];
    selectController.delegate = self;
}

- (void)clickArea:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSString *title = button.titleLabel.text;
    
    NSArray *areaList = [[CityOverViewManager defaultManager] getWillSelectAreaList];
    SelectController* selectController = [SelectController createController:areaList
                                                                selectedIds:self.selectedAreaIdList
                                                               multiOptions:YES];
    selectController.navigationItem.title = [[_filterHandler getCategoryName] stringByAppendingString:title];
    [self.navigationController pushViewController:selectController animated:YES];
    selectController.delegate = self;
}

- (void)clickService:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSString *title = button.titleLabel.text;
    NSArray *serverList = [[AppManager defaultManager] getProvidedServiceList:[_filterHandler getCategoryId]];
    SelectController* selectController = [SelectController createController:serverList
                                                                selectedIds:self.selectedServiceIdList 
                                                               multiOptions:YES];
    selectController.navigationItem.title = [[_filterHandler getCategoryName] stringByAppendingString:title];
    [self.navigationController pushViewController:selectController animated:YES];
    selectController.delegate = self;
}

- (void)didSelectFinish:(NSArray*)selectedList
{ 
    [_filterHandler findAllPlaces:self];
    self.navigationItem.title = [[_filterHandler getCategoryName] stringByAppendingFormat:@"(%d)", selectedList.count]; 
}


@end
