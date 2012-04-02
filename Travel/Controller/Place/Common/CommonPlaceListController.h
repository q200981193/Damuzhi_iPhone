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

@class PlaceListController;

@protocol PlaceListFilterProtocol <NSObject>
@optional
- (void)createFilterButtons:(UIView*)superView controller:(PPTableViewController*)controller;
- (void)findAllPlaces:(PPViewController<PlaceServiceDelegate>*)viewController;
+ (NSObject<PlaceListFilterProtocol>*)createFilter;

- (int)getCategoryId;
- (NSString*)getCategoryName;

- (NSArray*)filterAndSotrPlaceList:(NSArray*)placeList
            selectedCategoryIdList:(NSArray*)selectedCategoryIdList 
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
    NSMutableArray *_selectedCategoryIdList;
    NSMutableArray *_selectedSortIdList;
    NSMutableArray *_selectedAreaIdList;
    NSMutableArray *_selectedPriceIdList;
    NSMutableArray *_selectedServiceIdList;
    NSMutableArray *_selectedCuisineIdList;
    
    BOOL _showMap;
}

@property (retain, nonatomic) NSArray *placeList;
@property (retain, nonatomic) CityConfig *cityConfig;
@property (retain, nonatomic) IBOutlet UIView *buttonHolderView;
@property (retain, nonatomic) IBOutlet UIView *placeListHolderView;
@property (retain, nonatomic) IBOutlet UIButton *modeButton;

@property (retain, nonatomic) PlaceListController* placeListController;
@property (retain, nonatomic) NSObject<PlaceListFilterProtocol> *filterHandler;

@property (retain, nonatomic) NSMutableArray *selectedCategoryIdList;
@property (retain, nonatomic) NSMutableArray *selectedSortIdList;
@property (retain, nonatomic) NSMutableArray *selectedAreaIdList;
@property (retain, nonatomic) NSMutableArray *selectedPriceIdList;
@property (retain, nonatomic) NSMutableArray *selectedServiceIdList;
@property (retain, nonatomic) NSMutableArray *selectedCuisineIdList;



- (id)initWithFilterHandler:(NSObject<PlaceListFilterProtocol>*)handler;

- (IBAction)clickMapButton:(id)sender;

@end
