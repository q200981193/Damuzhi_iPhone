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

@class PlaceListController;

@protocol PlaceListFilterProtocol <NSObject>

- (void)createFilterButtons:(UIView*)superView;
- (void)findAllPlaces:(PPViewController<PlaceServiceDelegate>*)viewController;
+ (NSObject<PlaceListFilterProtocol>*)createFilter;

@end

@interface CommonPlaceListController : PPTableViewController <PlaceServiceDelegate>
{
    NSObject<PlaceListFilterProtocol> *_filterHandler;
}


@property (retain, nonatomic) IBOutlet UIView *buttonHolderView;
@property (retain, nonatomic) IBOutlet UIView *placeListHolderView;

@property (retain, nonatomic) PlaceListController* placeListController;
@property (retain, nonatomic) NSObject<PlaceListFilterProtocol> *filterHandler;

- (id)initWithFilterHandler:(NSObject<PlaceListFilterProtocol>*)handler;

@end
