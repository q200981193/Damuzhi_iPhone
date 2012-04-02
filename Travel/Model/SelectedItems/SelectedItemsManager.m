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
        
        _instance.selectedSubCategoryIdList = [[[NSMutableArray alloc] init] autorelease];
        _instance.selectedSortIdList = [[[NSMutableArray alloc] init] autorelease];
        _instance.selectedPriceIdList = [[[NSMutableArray alloc] init] autorelease];
        _instance.selectedAreaIdList = [[[NSMutableArray alloc] init] autorelease];
        _instance.selectedServiceIdList = [[[NSMutableArray alloc] init] autorelease];
        _instance.selectedCuisineIdList = [[[NSMutableArray alloc] init] autorelease];
        
        [_instance.selectedSubCategoryIdList addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
        [_instance.selectedSortIdList addObject:[NSNumber numberWithInt:SORT_BY_RECOMMEND]];
        [_instance.selectedPriceIdList addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
        [_instance.selectedAreaIdList addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
        [_instance.selectedServiceIdList addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
        [_instance.selectedCuisineIdList addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
    }
    
    return _instance;
}

@end
