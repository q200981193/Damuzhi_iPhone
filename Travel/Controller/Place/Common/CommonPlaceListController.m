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
#import "CityOverviewManager.h"
#import "SelectedItemsManager.h"

@implementation CommonPlaceListController

@synthesize modeButton = _modeButton;
@synthesize buttonHolderView = _buttonHolderView;
@synthesize placeListHolderView = _placeListHolderView;
@synthesize placeListController = _placeListController;
@synthesize filterHandler = _filterHandler;

- (void)dealloc {
    [_filterHandler release];
    [_placeListController release];
    [_buttonHolderView release];
    [_placeListHolderView release];
    [_modeButton release];
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
    [self setModeButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)findRequestDone:(int)result placeList:(NSArray *)placeList
{
    placeList = [self filterAndSort:placeList];
    
    if (self.placeListController == nil){
        self.placeListController = [PlaceListController createController:placeList 
                                                               superView:_placeListHolderView
                                                         superController:self];  
    }
    
    [self.placeListController setAndReloadPlaceList:placeList];
    self.navigationItem.title = [[_filterHandler getCategoryName] stringByAppendingFormat:@"(%d)", placeList.count];
}

- (NSArray*)filterAndSort:(NSArray*)placeList
{    
    placeList = [_filterHandler filterAndSotrPlaceList:placeList
                             selectedSubCategoryIdList:[[SelectedItemsManager defaultManager] selectedSubCategoryIdList]
                                   selectedPriceIdList:[[SelectedItemsManager defaultManager] selectedPriceIdList]
                                    selectedAreaIdList:[[SelectedItemsManager defaultManager] selectedAreaIdList]
                                 selectedServiceIdList:[[SelectedItemsManager defaultManager] selectedServiceIdList]
                                 selectedCuisineIdList:[[SelectedItemsManager defaultManager] selectedCuisineIdList]
                                                sortBy:[[[SelectedItemsManager defaultManager] selectedSortIdList] objectAtIndex:0]
                                       currentLocation:self.currentLocation];
    
    return placeList;
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
									UIViewAnimationTransitionCurlUp : UIViewAnimationTransitionCurlUp)
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
                                                                selectedIds:[[SelectedItemsManager defaultManager] selectedSubCategoryIdList] 
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
                                                                selectedIds:[[SelectedItemsManager defaultManager] selectedSortIdList] 
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
    NSArray *hotelPriceList = [[CityOverViewManager defaultManager] getSelectPriceList];
    SelectController* selectController = [SelectController createController:hotelPriceList
                                                                selectedIds:[[SelectedItemsManager defaultManager] selectedPriceIdList]
                                                               multiOptions:YES];
    selectController.navigationItem.title = [[_filterHandler getCategoryName] stringByAppendingString:title];
    [self.navigationController pushViewController:selectController animated:YES];
    selectController.delegate = self;
}

- (void)clickArea:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSString *title = button.titleLabel.text;
    
    NSArray *areaList = [[CityOverViewManager defaultManager] getSelectAreaList];
    SelectController* selectController = [SelectController createController:areaList
                                                                selectedIds:[[SelectedItemsManager defaultManager] selectedAreaIdList]
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
                                                                selectedIds:[[SelectedItemsManager defaultManager] selectedServiceIdList]

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
