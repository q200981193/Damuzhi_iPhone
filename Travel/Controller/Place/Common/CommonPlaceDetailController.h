//
//  CommonPlaceDetailController.h
//  Travel
//
//  Created by  on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"

@class Place;

@protocol CommonPlaceDetailDataSourceProtocol <NSObject>

@property (assign, nonatomic) float detailHeight;
- (void)addDetailViews:(UIView*)superView WithPlace:(Place*)place;

@end

@interface SpotDetailViewHandler : NSObject<CommonPlaceDetailDataSourceProtocol> 

@end

@interface HotelDetailViewHandler : NSObject<CommonPlaceDetailDataSourceProtocol> 

@end

@interface RestaurantViewHandler : NSObject<CommonPlaceDetailDataSourceProtocol> 

@end

@interface ShoppingDetailViewHandler : NSObject<CommonPlaceDetailDataSourceProtocol> 

@end

@interface EntertainmentDetailViewHandler : NSObject<CommonPlaceDetailDataSourceProtocol> 

@end

@interface CommonPlaceDetailController : PPViewController
@property (retain, nonatomic) IBOutlet UIButton *helpButton;

@property (retain, nonatomic) IBOutlet UIView *buttonHolerView;
@property (retain, nonatomic) IBOutlet UIView *imageHolderView;
@property (retain, nonatomic) IBOutlet UIScrollView *dataScrollView;
@property (retain, nonatomic) IBOutlet UIImageView *praiseIcon1;
@property (retain, nonatomic) IBOutlet UIImageView *praiseIcon2;
@property (retain, nonatomic) IBOutlet UIImageView *praiseIcon3;
@property (retain, nonatomic) IBOutlet UIView *serviceHolder;
@property (retain, nonatomic) Place *place;
@property (assign, nonatomic) id<CommonPlaceDetailDataSourceProtocol> handler;

- (IBAction)clickHelpButton:(id)sender;
- (id)initWithPlace:(Place*)onePlace;
@end
