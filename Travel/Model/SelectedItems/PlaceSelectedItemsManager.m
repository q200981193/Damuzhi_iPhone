//
//  PlaceItemsManager.m
//  Travel
//
//  Created by 小涛 王 on 12-4-20.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PlaceSelectedItemsManager.h"
#import "CommonPlace.h"

@implementation PlaceSelectedItemsManager

@synthesize spotSelectedItems = _spotSelectedItems;
@synthesize hotelSelectedItems = _hotelSelectedItems;
@synthesize restaurantSelectedItems = _restaurantSelectedItems;
@synthesize shoppingSelectedItems = _shoppingSelectedItems;
@synthesize entertainmentSelectedItems = _entertainmentSelectedItems;

static PlaceSelectedItemsManager *_instance = nil;

+(id)defaultManager
{
    if (_instance == nil) {
        _instance = [[PlaceSelectedItemsManager alloc] init];
    }
    
    return _instance;
}

-(id)init
{
    self = [super init];
    if (self) {
        self.spotSelectedItems = [[SelectedItems alloc] init];
        self.hotelSelectedItems = [[SelectedItems alloc] init];
        self.restaurantSelectedItems = [[SelectedItems alloc] init];
        self.shoppingSelectedItems = [[SelectedItems alloc] init];
        self.entertainmentSelectedItems = [[SelectedItems alloc] init];
    }
    
    return self;
}

-(void)dealloc
{
    [_spotSelectedItems release];
    [_hotelSelectedItems release];
    [_restaurantSelectedItems release];
    [_shoppingSelectedItems release];
    [_entertainmentSelectedItems release];
    [super dealloc];
}

- (SelectedItems*)getSelectedItems:(int)categoryId
{
    SelectedItems *selectedItems = nil;
    switch (categoryId) {
        case PLACE_TYPE_SPOT:
            selectedItems = _spotSelectedItems;
            break;
            
        case PLACE_TYPE_HOTEL:
            selectedItems = _hotelSelectedItems;
            break;
            
        case PLACE_TYPE_RESTAURANT:
            selectedItems = _restaurantSelectedItems;
            break;
            
        case PLACE_TYPE_SHOPPING:
            selectedItems = _shoppingSelectedItems;
            break;
            
        case PLACE_TYPE_ENTERTAINMENT:
            selectedItems = _entertainmentSelectedItems;
            break;
            
            
        default:
            break;
    }
    
    return selectedItems;
}

@end
