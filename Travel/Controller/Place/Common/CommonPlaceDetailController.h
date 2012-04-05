//
//  CommonPlaceDetailController.h
//  Travel
//
//  Created by  on 12-2-24.
//  Copyright (c) 2012å¹?__MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"
#import "PlaceService.h"

@class Place;
@class CommonPlaceDetailController;

#define TITLE_VIEW_HEIGHT 35
#define MIDDLE_LINE_HEIGHT 2
#define CGRECT_TITLE CGRectMake(10, 3, 100, 20)
#define TITLE_COLOR [UIColor colorWithRed:37/255.0 green:66/255.0 blue:80/255.0 alpha:1.0]
#define DESCRIPTION_COLOR [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]
#define INTRODUCTION_BG_COLOR [UIColor colorWithRed:222/255.0 green:239/255.0 blue:247/255.0 alpha:1.0]
#define PRICE_BG_COLOR [UIColor colorWithRed:235/255.0 green:241/255.0 blue:241/255.0 alpha:1.0]

@protocol CommonPlaceDetailDataSourceProtocol <NSObject>

@property (retain, nonatomic) CommonPlaceDetailController* commonController;

- (void)addDetailViews:(UIView*)superView WithPlace:(Place*)place;
- (id)initWith:(CommonPlaceDetailController*)controller;

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

@interface CommonPlaceDetailController : PPViewController<UIActionSheetDelegate,PlaceServiceDelegate>
@property (retain, nonatomic) IBOutlet UIButton *helpButton;

@property (retain, nonatomic) IBOutlet UIView *buttonHolerView;
@property (retain, nonatomic) IBOutlet UIView *imageHolderView;
@property (retain, nonatomic) IBOutlet UIScrollView *dataScrollView;
@property (retain, nonatomic) IBOutlet UIImageView *praiseIcon1;
@property (retain, nonatomic) IBOutlet UIImageView *praiseIcon2;
@property (retain, nonatomic) IBOutlet UIImageView *praiseIcon3;
@property (retain, nonatomic) IBOutlet UIView *serviceHolder;
@property (retain, nonatomic) Place *place;
@property (retain, nonatomic) NSArray *placeList;
@property (assign, nonatomic) id<CommonPlaceDetailDataSourceProtocol> handler;

@property (assign, nonatomic) float detailHeight;
@property (retain, nonatomic) UILabel *favoriteCountLabel;
@property (retain, nonatomic) UIView *telephoneView;
@property (retain, nonatomic) UIView *addressView;
@property (retain, nonatomic) UIView *websiteView;
@property (retain, nonatomic) UIView *favouritesView;

- (IBAction)clickHelpButton:(id)sender;
- (id)initWithPlace:(Place*)onePlace;
- (id)initWithPlaceList:(NSArray *)placeList selectedIndex:(NSInteger)row;

-(void)addSegmentViewWith:(NSString*)titleString description:(NSString*)descriptionString;
@end
