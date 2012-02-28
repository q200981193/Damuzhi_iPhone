//
//  PlaceManager.m
//  Travel
//
//  Created by  on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlaceManager.h"

@implementation PlaceManager

static PlaceManager *_placeDefaultManager;

+ (PlaceManager*)defaultManager
{
    if (_placeDefaultManager == nil){
        
    }
    
    return _placeDefaultManager;
}

@end
