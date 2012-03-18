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

@implementation CommonPlaceListController

@synthesize buttonHolderView;
@synthesize placeListHolderView;
@synthesize placeListController;
@synthesize filterHandler = _filterHandler;

@synthesize selectedCategoryIds = _selectCategoryIds;
@synthesize selectedSortIds = _selectedSortIds;
@synthesize selectedAreaIds = _selectedAreaIds;
@synthesize selectedPriceIds = _selectedPriceIds;
@synthesize selectedServiceIds = _selectedServiceIds;
@synthesize selectedCuisineIds = _selectedCuisineIds;

- (void)dealloc {
    [_filterHandler release];
    [placeListController release];
    [buttonHolderView release];
    [placeListHolderView release];
    [_selectedSortIds release];
    [_selectedCategoryIds release];
    [_selectedAreaIds release];
    [_selectedPriceIds release];
    [_selectedServiceIds release];
    [_selectedCuisineIds release];
    [super dealloc];
}

- (id)initWithFilterHandler:(NSObject<PlaceListFilterProtocol>*)handler
{
    self = [super init];
    self.filterHandler = handler;
    self.selectedCategoryIds = [[[NSMutableArray alloc] init] autorelease];
    self.selectedSortIds = [[[NSMutableArray alloc] init] autorelease];
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

- (NSArray*)filterAndSort:(NSArray*)placeList
{    
    placeList = [_filterHandler filterAndSotrPlaces:placeList
                           selectedCategoryIds:self.selectedCategoryIds
                              selectedPriceIds:self.selectedPriceIds
                               selectedAreaIds:self.selectedAreaIds
                            selectedServiceIds:self.selectedServiceIds
                            selectedCuisineIds:self.selectedCuisineIds
                                        sortBy:[self.selectedSortIds objectAtIndex:0]];
    
    return placeList;
}

- (void)findRequestDone:(int)result dataList:(NSArray*)list
{
    if (self.placeListController == nil){
        [self.selectedCategoryIds addObject:[NSNumber numberWithInt:ALL_SUBCATEGORY]];
        [self.selectedSortIds addObject:[NSNumber numberWithInt:SORT_BY_RECOMMEND]];
        list = [self filterAndSort:list];
        self.placeListController = [PlaceListController createController:list 
                                                               superView:placeListHolderView
                                                         superController:self];    
    }
    else{
        list = [self filterAndSort:list];
        [self.placeListController setAndReloadPlaceList:list];
    }    
}

- (IBAction)clickMapButton:(id)sender
{
    PlaceMapViewController* controller = [[PlaceMapViewController alloc] init];
    //设置Places
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)clickCategoryButton:(id)sender
{
    NSMutableArray *subCategories = [[NSMutableArray alloc] init];    
    [subCategories addObject:[NSDictionary dictionaryWithObject:NSLS(@"全部") forKey:[NSNumber numberWithInt:-1]]];
    
    for (NameIdPair *subCategory in [[[AppManager defaultManager] getPlaceMeta:[_filterHandler getCategoryId]] subCategoryListList]) {
        [subCategories addObject:[NSDictionary dictionaryWithObject:subCategory.name 
                                                             forKey:[NSNumber numberWithInt:subCategory.id]]];
    }
    
//    for (NameIdPair* subCategoryPair in [[AppManager defaultManager] getSubCategories:[_filterHandler getCategoryId]]) {
//        [subCategories addObject:[NSDictionary dictionaryWithObject:subCategoryPair.name 
//                                                             forKey:[NSNumber numberWithInt:subCategoryPair.id]]];
//    }
    
    SelectController* selectController = [SelectController createController:subCategories
                                                               selectedIds:self.selectedCategoryIds 
                                                               multiOptions:YES];
    
    selectController.navigationItem.title = [[_filterHandler getCategoryName] stringByAppendingString:NSLS(@"分类")];
    
    [self.navigationController pushViewController:selectController animated:YES];
    selectController.delegate = self;
        
    NSLog(@"<clickCategoryButton>");
}

- (void)clickSortButton:(id)sender
{
//    SelectController* selectController = [SelectController createController:
//                                          [[AppManager defaultManager] getSortOptions:[_filterHandler getCategoryId]]selectedIds:self.selectedSortIds 
//                                                               multiOptions:NO];
    
    SelectController* selectController = [SelectController createController:
                                          [[AppManager defaultManager] getSortOptionList:[_filterHandler getCategoryId]]selectedIds:self.selectedSortIds 
                                                               multiOptions:NO];

    
    selectController.navigationItem.title = [[_filterHandler getCategoryName] stringByAppendingString:NSLS(@"排序")];
    
    [self.navigationController pushViewController:selectController animated:YES];
    selectController.delegate = self;
    
    NSLog(@"<clickSortButton>");
}

- (void)didSelectFinish:(NSArray*)selectedList
{ 
    [_filterHandler findAllPlaces:self];
}


@end
