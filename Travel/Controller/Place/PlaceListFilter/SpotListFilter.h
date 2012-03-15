//
//  SpotListFilter.h
//  Travel
//
//  Created by  on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonPlaceListController.h"
#import "SelectController.h"
@interface SpotListFilter : NSObject<PlaceListFilterProtocol,SelectControllerDelegate>
{
    NSMutableArray *_selectedCategoryList;
    NSMutableArray *_selectedSortList;
}

@property (retain, nonatomic) NSMutableArray *selectedCategoryList;
@property (retain, nonatomic) NSMutableArray *selectedSotrList;

@property (retain, nonatomic) PPTableViewController *controller;



@end
