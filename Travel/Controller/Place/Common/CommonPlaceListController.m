//
//  CommonPlaceListController.m
//  Travel
//
//  Created by  on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommonPlaceListController.h"
#import "PlaceListController.h"
#import "PlaceService.h"
#import "PlaceMapViewController.h"
#import "SelectController.h"
#import "AppManager.h"
#import "PlaceSelectedItemsManager.h"
#import "UIImageUtil.h"
#import "CommonWebController.h"
#import "AppUtils.h"
#import "PPNetworkRequest.h"
#import "PPDebug.h"

@implementation CommonPlaceListController

@synthesize modeButton = _modeButton;
@synthesize buttonHolderView = _buttonHolderView;
@synthesize placeListHolderView = _placeListHolderView;
@synthesize placeListController = _placeListController;
@synthesize filterHandler = _filterHandler;
@synthesize selectedItems = _selectedItems;
@synthesize placeList = _placeList;

- (void)dealloc {
    [_filterHandler release];
    [_placeListController release];
    [_buttonHolderView release];
    [_placeListHolderView release];
    [_modeButton release];
    [_selectedItems release];
    [_placeList release];
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
    CommonWebController *controller = [[CommonWebController alloc] initWithWebUrl:[AppUtils getHelpHtmlFilePath]];
    controller.navigationItem.title = NSLS(@"帮助");
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    [self setNavigationRightButton:NSLS(@"帮助") 
                         imageName:@"topmenu_btn_right.png" 
                            action:@selector(clickHelp:)];
    
    [self setNavigationBarTitle];
        
    [_filterHandler createFilterButtons:self.buttonHolderView controller:self];
    UIImage *image = [UIImage imageNamed:@"select_tr_bg.png"];
    _buttonHolderView.backgroundColor = [UIColor colorWithPatternImage:image];

    self.selectedItems = [[PlaceSelectedItemsManager defaultManager] getSelectedItems:[_filterHandler getCategoryId]];
    
    [_filterHandler findAllPlaces:self];
}

- (void)setNavigationBarTitle
{
    UILabel *categoryNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -8, 38, 20)];
    categoryNameLabel.text = [_filterHandler getCategoryName];
    categoryNameLabel.font = [UIFont boldSystemFontOfSize:19];
    categoryNameLabel.textColor = [UIColor whiteColor];
    categoryNameLabel.backgroundColor = [UIColor clearColor];

    UILabel *placeCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, -8, 30, 20)];
    placeCountLabel.text = [NSString stringWithFormat:NSLS(@"(%d)"), dataList.count];
    placeCountLabel.font = [UIFont systemFontOfSize:12];
    placeCountLabel.textColor = [UIColor colorWithRed:183 green:222 blue:243 alpha:1];
    placeCountLabel.backgroundColor = [UIColor clearColor];
    placeCountLabel.tag = 1;

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 8)];
    [view addSubview:categoryNameLabel];
    [view addSubview:placeCountLabel];
    [self.navigationItem setTitleView:view];

    [categoryNameLabel release];
    [placeCountLabel release];
    [view release];
}

- (void)updateNavigationBarTitle:(int)count
{
    UILabel *placeCountLabel = (UILabel*)[self.navigationItem.titleView viewWithTag:1];
    [placeCountLabel setText:[NSString stringWithFormat:NSLS(@"(%d)"), count]];
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
    if (result != ERROR_SUCCESS) {
        [self popupMessage:@"数据加载失败" title:nil];
    }

    self.placeList = [self filterAndSort:placeList];
    [self createAndReloadPlaceListController];
}

- (void)createAndReloadPlaceListController
{
    if (self.placeListController == nil){
        self.placeListController = [PlaceListController createController:_placeList 
                                                               superView:_placeListHolderView
                                                         superController:self];  
    }
    
    [self.placeListController setAndReloadPlaceList:_placeList];
    [self updateNavigationBarTitle:_placeList.count];
}

- (NSArray*)filterAndSort:(NSArray*)placeList
{    
    return [_filterHandler filterAndSotrPlaceList:placeList selectedItems:_selectedItems];
}

- (void)updateModeButton
{
    // set button text by _showMap flag
    _modeButton.selected = !_modeButton.selected;
    if (_modeButton.selected) {
        [self hideSomeFilterButtons];
    } else {
        [self showFilterButtons];
    }
}

- (IBAction)clickMapButton:(id)sender
{    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.75];
	
	[UIView setAnimationTransition:(_modeButton.selected ?
									UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight)
						   forView:self.view cache:YES];
    [UIView commitAnimations];

    if (_modeButton.selected){
        [self.placeListController switchToListMode];
    }
    else{
        [self.placeListController switchToMapMode];
    }
    
    [self updateModeButton];
}

- (void)hideSomeFilterButtons
{
    for (UIView *subView in [self.buttonHolderView subviews]) {
        if (subView.tag ==SORT_BUTTON_TAG) {
            subView.hidden = YES;
        }
    }
    
    return;
}

- (void)showFilterButtons
{
    for (UIView *subView in [self.buttonHolderView subviews]) {
            subView.hidden = NO;
    }
}


- (void)clickCategoryButton:(id)sender
{
    NSArray *subCategoryList = [[AppManager defaultManager] getSubCategoryList:[_filterHandler getCategoryId]];
    
    SelectController* selectController = [SelectController createController:subCategoryList                                                           
                                                                selectedIds:[_selectedItems selectedSubCategoryIdList] 
                                                               multiOptions:YES
                                                                needConfirm:YES];
    
    [self setSelectControllerNavigationTitle:selectController title:((UIButton*)sender).titleLabel.text];
    
    [self.navigationController pushViewController:selectController animated:YES];
    selectController.delegate = self;
        
    NSLog(@"<clickCategoryButton>");
}

- (void)clickSortButton:(id)sender
{    
    NSArray *sortOptionList = [[AppManager defaultManager] getSortOptionList:[_filterHandler getCategoryId]];
    SelectController* selectController = [SelectController createController:sortOptionList
                                                                selectedIds:[_selectedItems selectedSortIdList] 
                                                               multiOptions:NO
                                                                needConfirm:NO];

    [self setSelectControllerNavigationTitle:selectController title:((UIButton*)sender).titleLabel.text];    
    [self.navigationController pushViewController:selectController animated:YES];
    selectController.delegate = self;
}

- (void)clickPrice:(id)sender
{    
    NSArray *hotelPriceList = [[AppManager defaultManager] getPriceList:[[AppManager defaultManager] getCurrentCityId]];
    SelectController* selectController = [SelectController createController:hotelPriceList
                                                                selectedIds:[_selectedItems selectedPriceIdList]
                                                               multiOptions:YES
                                                                needConfirm:YES];
    
    [self setSelectControllerNavigationTitle:selectController title:((UIButton*)sender).titleLabel.text];
    [self.navigationController pushViewController:selectController animated:YES];
    selectController.delegate = self;
}

- (void)clickArea:(id)sender
{
    NSArray *areaList = [[AppManager defaultManager] getAreaNameList:[[AppManager defaultManager] getCurrentCityId]];
    SelectController* selectController = [SelectController createController:areaList
                                                                selectedIds:[_selectedItems selectedAreaIdList]
                                                               multiOptions:YES 
                                                                needConfirm:YES];

    [self setSelectControllerNavigationTitle:selectController title:((UIButton*)sender).titleLabel.text];
    [self.navigationController pushViewController:selectController animated:YES];
    selectController.delegate = self;
}

- (void)clickService:(id)sender
{
    
    NSArray *serviceList = [[AppManager defaultManager] getProvidedServiceList:[_filterHandler getCategoryId]];
    
    SelectController* selectController = [SelectController createController:serviceList
                                                                selectedIds:[_selectedItems selectedServiceIdList]
                                                               multiOptions:YES
                                                                needConfirm:YES];
    
    [self setSelectControllerNavigationTitle:selectController title:((UIButton*)sender).titleLabel.text];
    [self.navigationController pushViewController:selectController animated:YES];
    selectController.delegate = self;
}

- (void)setSelectControllerNavigationTitle:(SelectController*)controller title:(NSString*)title
{
    NSLog(@"cagegory name : %@", [_filterHandler getCategoryName]);
    controller.navigationItem.title = [NSString stringWithFormat:NSLS(@"%@%@"),[_filterHandler getCategoryName],title];
}

- (void)didSelectFinish:(NSArray*)selectedList
{ 
    [_filterHandler findAllPlaces:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [_placeListController.dataTableView reloadData];
}

@end
