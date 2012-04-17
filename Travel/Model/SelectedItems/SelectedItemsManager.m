//
//  SelectedItemsManager.m
//  Travel
//
//  Created by 小涛 王 on 12-4-3.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "SelectedItemsManager.h"
#import "CommonPlace.h"

@implementation SelectedItemsManager

@synthesize selectedSubCategoryIdList = _selectedSubCategoryIdList;
@synthesize selectedSortIdList = _selectedSortIdList;
@synthesize selectedAreaIdList = _selectedAreaIdList;
@synthesize selectedPriceIdList = _selectedPriceIdList;
@synthesize selectedServiceIdList = _selectedServiceIdList;
@synthesize selectedCuisineIdList = _selectedCuisineIdList;

- (void)dealloc {
    [_selectedSubCategoryIdList release];
    [_selectedSortIdList release];
    [_selectedAreaIdList release];
    [_selectedPriceIdList release];
    [_selectedServiceIdList release];
    [_selectedCuisineIdList release];
    [super dealloc];
}


static SelectedItemsManager *_instance = nil;

+ (id)defaultManager
{
    if (_instance == nil) {
        _instance = [[SelectedItemsManager alloc] init];
    }
    
    return _instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.selectedSubCategoryIdList = [[[NSMutableArray alloc] init] autorelease];
        self.selectedSortIdList = [[[NSMutableArray alloc] init] autorelease];
        self.selectedPriceIdList = [[[NSMutableArray alloc] init] autorelease];
        self.selectedAreaIdList = [[[NSMutableArray alloc] init] autorelease];
        self.selectedServiceIdList = [[[NSMutableArray alloc] init] autorelease];
        self.selectedCuisineIdList = [[[NSMutableArray alloc] init] autorelease];
        
        [self.selectedSubCategoryIdList addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
        [self.selectedSortIdList addObject:[NSNumber numberWithInt:SORT_BY_RECOMMEND]];
        [self.selectedPriceIdList addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
        [self.selectedAreaIdList addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
        [self.selectedServiceIdList addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
        [self.selectedCuisineIdList addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
    }
    
    return self;
}

@end
