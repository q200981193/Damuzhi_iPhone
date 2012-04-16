//
//  CommonPlaceListController.h
//  Travel
//
//  Created by  on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"
#import "PlaceService.h"
#import "SelectController.h"
#import "CityOverviewService.h"

#define WIDTH_OF_FILTER_BUTTON 52
#define HEIGHT_OF_FILTER_BUTTON 27
#define DISTANCE_BETWEEN_BUTTONS 5

#define SORT_BUTTON_TAG 99

@class PlaceListController;

@protocol PlaceListFilterProtocol <NSObject>

@optional
- (void)createFilterButtons:(UIView*)superView controller:(PPTableViewController*)controller;
- (void)findAllPlaces:(PPViewController<PlaceServiceDelegate>*)viewController;
+ (NSObject<PlaceListFilterProtocol>*)createFilter;

- (int)getCategoryId;
- (NSString*)getCategoryName;

- (NSArray*)filterAndSotrPlaceList:(NSArray*)placeList
         selectedSubCategoryIdList:(NSArray*)selectedSubCategoryIdList 
               selectedPriceIdList:(NSArray*)selectedPriceIdList 
                selectedAreaIdList:(NSArray*)selectedAreaIdList 
             selectedServiceIdList:(NSArray*)selectedServiceIdList
             selectedCuisineIdList:(NSArray*)selectedCuisineIdList
                            sortBy:(NSNumber*)selectedSortId
                   currentLocation:(CLLocation*)currentLocation;

@end

@interface CommonPlaceListController : PPTableViewController <PlaceServiceDelegate, CityOverviewServiceDelegate, SelectControllerDelegate>
{
    NSObject<PlaceListFilterProtocol> *_filterHandler;    
}

@property (retain, nonatomic) IBOutlet UIView *buttonHolderView;
@property (retain, nonatomic) IBOutlet UIView *placeListHolderView;
@property (retain, nonatomic) IBOutlet UIButton *modeButton;

@property (retain, nonatomic) PlaceListController* placeListController;
@property (retain, nonatomic) NSObject<PlaceListFilterProtocol> *filterHandler;

- (id)initWithFilterHandler:(NSObject<PlaceListFilterProtocol>*)handler;

- (IBAction)clickMapButton:(id)sender;

@end
