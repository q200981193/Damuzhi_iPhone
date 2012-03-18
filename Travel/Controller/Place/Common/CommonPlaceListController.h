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

@class PlaceListController;

@protocol PlaceListFilterProtocol <NSObject>

- (void)createFilterButtons:(UIView*)superView controller:(PPTableViewController*)controller;
- (void)findAllPlaces:(PPViewController<PlaceServiceDelegate>*)viewController;
+ (NSObject<PlaceListFilterProtocol>*)createFilter;

- (int)getCategoryId;
- (NSString*)getCategoryName;

- (NSArray*)filterAndSotrPlaces:(NSArray*)placeList
            selectedCategoryIds:(NSArray*)selectedCategoryIds 
               selectedPriceIds:(NSArray*)selectedPriceIds 
                selectedAreaIds:(NSArray*)selectedAreaIds 
             selectedServiceIds:(NSArray*)selectedServiceIds
             selectedCuisineIds:(NSArray*)selectedCuisineIds
                         sortBy:(NSNumber*)selectedSortId;


@end

@interface CommonPlaceListController : PPTableViewController <PlaceServiceDelegate, SelectControllerDelegate>
{
    NSObject<PlaceListFilterProtocol> *_filterHandler;
    NSMutableArray *_selectedCategoryIds;
    NSMutableArray *_selectedSortIds;
    NSMutableArray *_selectedAreaIds;
    NSMutableArray *_selectedPriceIds;
    NSMutableArray *_selectedServiceIds;
    NSMutableArray *_selectedCuisineIds;
    
}

@property (retain, nonatomic) IBOutlet UIView *buttonHolderView;
@property (retain, nonatomic) IBOutlet UIView *placeListHolderView;

@property (retain, nonatomic) PlaceListController* placeListController;
@property (retain, nonatomic) NSObject<PlaceListFilterProtocol> *filterHandler;

@property (retain, nonatomic) NSMutableArray *selectedCategoryIds;
@property (retain, nonatomic) NSMutableArray *selectedSortIds;
@property (retain, nonatomic) NSMutableArray *selectedAreaIds;
@property (retain, nonatomic) NSMutableArray *selectedPriceIds;
@property (retain, nonatomic) NSMutableArray *selectedServiceIds;
@property (retain, nonatomic) NSMutableArray *selectedCuisineIds;



- (id)initWithFilterHandler:(NSObject<PlaceListFilterProtocol>*)handler;

- (IBAction)clickMapButton:(id)sender;

@end
