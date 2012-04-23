//
//  PlaceItemsManager.m
//  Travel
//
//  Created by 小涛 王 on 12-4-20.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PlaceSelectedItemsManager.h"
#import "CommonPlace.h"
#import "App.pb.h"

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
        case PlaceCategoryTypePlaceSpot:
            selectedItems = _spotSelectedItems;
            break;
            
        case PlaceCategoryTypePlaceHotel:
            selectedItems = _hotelSelectedItems;
            break;
            
        case PlaceCategoryTypePlaceRestraurant:
            selectedItems = _restaurantSelectedItems;
            break;
            
        case PlaceCategoryTypePlaceShopping:
            selectedItems = _shoppingSelectedItems;
            break;
            
        case PlaceCategoryTypePlaceEntertainment:
            selectedItems = _entertainmentSelectedItems;
            break;
            
        default:
            break;
    }
    
    return selectedItems;
}

@end
