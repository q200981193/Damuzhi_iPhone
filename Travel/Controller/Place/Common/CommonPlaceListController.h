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

- (void)findPlacesByCategory:(NSArray*)categoryList 
                  priceIndex:(int)priceIndex 
                    areaList:(NSArray*)areaList 
         providedServiceList:(NSArray*)providedServiceList
                 cuisineList:(NSArray*)cuisineList
                      sortBy:(int)sortBy;

@end

@interface CommonPlaceListController : PPTableViewController <PlaceServiceDelegate, SelectControllerDelegate>
{
    NSObject<PlaceListFilterProtocol> *_filterHandler;
    int _currentFilterAction;
    NSMutableArray *_selectedCategoryList;
    NSMutableArray *_selectedSortList;
}

@property (assign, nonatomic) int currentFilterAction;
@property (retain, nonatomic) IBOutlet UIView *buttonHolderView;
@property (retain, nonatomic) IBOutlet UIView *placeListHolderView;

@property (retain, nonatomic) PlaceListController* placeListController;
@property (retain, nonatomic) NSObject<PlaceListFilterProtocol> *filterHandler;

@property (retain, nonatomic) NSMutableArray *selectedCategoryList;
@property (retain, nonatomic) NSMutableArray *selectedSortList;


- (id)initWithFilterHandler:(NSObject<PlaceListFilterProtocol>*)handler;

- (IBAction)clickMapButton:(id)sender;

@end
