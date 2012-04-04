//
//  FavoriteController.m
//  Travel
//
//  Created by haodong qiu on 12年3月28日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "FavoriteController.h"
#import "PlaceListController.h"
#import "PlaceStorage.h"
#import "LogUtil.h"
#import "Place.pb.h"
#import "CommonPlace.h"
#import "ImageName.h"
#import "PlaceService.h"
#import "TravelNetworkConstants.h"

@interface FavoriteController ()

- (void)createRightBarButton;
- (void)clickMyFavorite:(id)sender;
- (void)clickTopFavorite:(id)sender;
- (void)clickDelete:(id)sender;
- (NSArray*)filterFromMyFavorite:(int)categoryId;

@end

@implementation FavoriteController
@synthesize buttonHolderView;
@synthesize placeListHolderView;
@synthesize placeListController;
@synthesize placeList = _placeList;
@synthesize canDelete;
@synthesize myFavoriteButton;
@synthesize topFavoriteButton;
@synthesize deleteButton;
@synthesize myAllFavoritePlaceList;
@synthesize topAllFavoritePlaceList;
@synthesize topSpotFavoritePlaceList;
@synthesize topHotelFavoritePlaceList;
@synthesize topRestaurantFavoritePlaceList;
@synthesize topShoppingFavoritePlaceList;
@synthesize topEntertainmentFavoritePlaceList;

- (void)dealloc {
    [buttonHolderView release];
    [placeListHolderView release];
    [placeListController release];
    [_placeList release];
    [myFavoriteButton release];
    [topFavoriteButton release];
    [deleteButton release];
    [myAllFavoritePlaceList release];
    [topAllFavoritePlaceList release];
    [topSpotFavoritePlaceList release];
    [topHotelFavoritePlaceList release];
    [topRestaurantFavoritePlaceList release];
    [topShoppingFavoritePlaceList release];
    [topEntertainmentFavoritePlaceList release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationLeftButton:NSLS(@"返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    [self createRightBarButton];
    
    self.myAllFavoritePlaceList = [[PlaceStorage favoriteManager] allPlaces];
    if ([myAllFavoritePlaceList count] >= 1) {
        [self clickMyFavorite:nil];
    }else {
        [self clickTopFavorite:nil];
    }
}

- (void)showPlaces{
    if (self.placeListController == nil) {
        self.placeListController = [PlaceListController createController:self.placeList 
                                                               superView:placeListHolderView
                                                         superController:self];
    }
    else {
        [self.placeListController setAndReloadPlaceList:self.placeList];
    }
}

- (void)viewDidUnload
{
    [self setButtonHolderView:nil];
    [self setPlaceListHolderView:nil];
    [self setPlaceListController:nil];
    [self setPlaceList:nil];
    [self setMyFavoriteButton:nil];
    [self setTopFavoriteButton:nil];
    [self setDeleteButton:nil];
    [self setMyAllFavoritePlaceList:nil];
    [self setTopAllFavoritePlaceList:nil];
    [self setTopSpotFavoritePlaceList:nil];
    [self setTopHotelFavoritePlaceList:nil];
    [self setTopRestaurantFavoritePlaceList:nil];
    [self setTopShoppingFavoritePlaceList:nil];
    [self setTopEntertainmentFavoritePlaceList:nil];
    [super viewDidUnload];
}

#define RIGHT_BUTTON_VIEW_WIDTH     230
#define RIGHT_BUTTON_VIEW_HIGHT     30
#define BUTTON_WIDTH                80
#define BUTTON_HIGHT                30
#define DELETE_BUTTON_WIDTH          40
- (void)createRightBarButton
{
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RIGHT_BUTTON_VIEW_WIDTH, RIGHT_BUTTON_VIEW_HIGHT)];
    
    UIButton *mfbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, BUTTON_WIDTH, BUTTON_HIGHT)];
    self.myFavoriteButton = mfbtn;
    [mfbtn release];
    
    self.myFavoriteButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.myFavoriteButton setTitle:NSLS(@"我的收藏") forState:UIControlStateNormal];
    [self.myFavoriteButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];    
    [self.myFavoriteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.myFavoriteButton setBackgroundImage:[UIImage imageNamed:IMAGE_CITY_LEFT_BTN_OFF] forState:UIControlStateNormal];
    [self.myFavoriteButton setBackgroundImage:[UIImage imageNamed:IMAGE_CITY_LEFT_BTN_ON] forState:UIControlStateSelected];
    [self.myFavoriteButton addTarget:self action:@selector(clickMyFavorite:) forControlEvents:UIControlEventTouchUpInside];
    [rightButtonView addSubview:self.myFavoriteButton];
    
    UIButton *tfbtn = [[UIButton alloc] initWithFrame:CGRectMake(BUTTON_WIDTH, 0, BUTTON_WIDTH, BUTTON_HIGHT)];
    self.topFavoriteButton = tfbtn;
    self.topFavoriteButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.topFavoriteButton setTitle:NSLS(@"收藏排行") forState:UIControlStateNormal];
    [self.topFavoriteButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];    
    [self.topFavoriteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.topFavoriteButton setBackgroundImage:[UIImage imageNamed:IMAGE_CITY_RIGHT_BTN_OFF] forState:UIControlStateNormal];
    [self.topFavoriteButton setBackgroundImage:[UIImage imageNamed:IMAGE_CITY_RIGHT_BTN_ON] forState:UIControlStateSelected];
    [self.topFavoriteButton addTarget:self action:@selector(clickTopFavorite:) forControlEvents:UIControlEventTouchUpInside];
    [rightButtonView addSubview:self.topFavoriteButton];
    
    UIButton *dbtn = [[UIButton alloc] initWithFrame:CGRectMake(RIGHT_BUTTON_VIEW_WIDTH - DELETE_BUTTON_WIDTH, 0, DELETE_BUTTON_WIDTH, BUTTON_HIGHT)];
    self.deleteButton = dbtn;
    [dbtn release];
    self.deleteButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"topmenu_btn_right.png"] forState:UIControlStateNormal];
    [self.deleteButton setTitle:NSLS(@"删除") forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(clickDelete:) forControlEvents:UIControlEventTouchUpInside];
    [rightButtonView addSubview:self.deleteButton];
    
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    [rightButtonView release];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    [rightButtonItem release];
}

- (void)loadTopFavorite:(int)type
{
    [[PlaceService defaultService] findTopFavoritePlaces:self type:type];
}

#pragma mark - deletePlaceDelegate 
- (void)deletedPlace:(Place *)place
{
    [[PlaceService defaultService] deletePlaceFromFavorite:self place:place];
    self.placeList = [[PlaceStorage favoriteManager] allPlaces];
}

#pragma mark - PlaceServiceDelegate 
- (void)finishDeleteFavourite:(NSNumber *)resultCode count:(NSNumber *)count
{
    
}

- (void)finishFindTopFavoritePlaces:(NSArray *)list type:(int)type
{
    switch (type) {
        case OBJECT_TYPE_TOP_FAVORITE_ALL:
            self.topAllFavoritePlaceList = list;
            break;
            
        case OBJECT_TYPE_TOP_FAVORITE_SPOT:
            self.topSpotFavoritePlaceList = list;
            break;
            
        case OBJECT_TYPE_TOP_FAVORITE_HOTEL:
            self.topHotelFavoritePlaceList = list;
            break;
            
        case OBJECT_TYPE_TOP_FAVORITE_RESTAURANT:
            self.topRestaurantFavoritePlaceList = list;
            break;
            
        case OBJECT_TYPE_TOP_FAVORITE_SHOPPING:
            self.topShoppingFavoritePlaceList = list;
            break;
            
        case OBJECT_TYPE_TOP_FAVORITE_ENTERTAINMENT:
            self.topEntertainmentFavoritePlaceList = list;
            break;
        
        default:
            break;
    }
}

#pragma -mark BarButton action
- (void)clickDelete:(id)sender
{
    UIButton *button = (UIButton*)sender;
    canDelete = !canDelete;
    [self.placeListController canDeletePlace:canDelete delegate:self];
    if (canDelete) {
        [button setTitle:NSLS(@"完成") forState:UIControlStateNormal];
    }
    else {
        [button setTitle:NSLS(@"删除") forState:UIControlStateNormal];
    }
}

- (void)clickMyFavorite:(id)sender
{
    myFavoriteButton.selected = YES;
    topFavoriteButton.selected = NO;
    deleteButton.hidden = NO;
    
    [self clickAll:nil];
}

- (void)clickTopFavorite:(id)sender
{
    myFavoriteButton.selected = NO;
    topFavoriteButton.selected = YES;
    deleteButton.hidden = YES;
    
    [self clickAll:nil];
}

#pragma mark - filter button action
- (IBAction)clickAll:(id)sender
{
    if (self.myFavoriteButton.selected == YES) {
        self.placeList = myAllFavoritePlaceList;
    }
    
    else {
        if (topAllFavoritePlaceList == nil) {
            [self loadTopFavorite:OBJECT_TYPE_TOP_FAVORITE_ALL];
        }
        self.placeList = topAllFavoritePlaceList;
    }
    [self showPlaces];
}

- (IBAction)clickSpot:(id)sender
{ 
    if (myFavoriteButton.selected == YES) {
        self.placeList = [self filterFromMyFavorite:PLACE_TYPE_SPOT];
    }
    
    else {
        if(topSpotFavoritePlaceList == nil){
            [self loadTopFavorite:OBJECT_TYPE_TOP_FAVORITE_SPOT];
        }
        self.placeList = topAllFavoritePlaceList;
    }
    
    [self showPlaces];
}

- (IBAction)clickHotel:(id)sender
{
    if (myFavoriteButton.selected == YES) {
        self.placeList = [self filterFromMyFavorite:PLACE_TYPE_HOTEL];
    }
    
    else {
        if(topHotelFavoritePlaceList == nil){
            [self loadTopFavorite:OBJECT_TYPE_TOP_FAVORITE_HOTEL];
        }
        self.placeList = topHotelFavoritePlaceList;
    }
    
    [self showPlaces];
}

- (IBAction)clickRestaurant:(id)sender
{
    if (myFavoriteButton.selected == YES) {
        self.placeList = [self filterFromMyFavorite:PLACE_TYPE_RESTAURANT];
    }
    
    else {
        if(topRestaurantFavoritePlaceList == nil){
            [self loadTopFavorite:OBJECT_TYPE_TOP_FAVORITE_RESTAURANT];
        }
        self.placeList = topRestaurantFavoritePlaceList;
    }
    
    [self showPlaces]; 
}

- (IBAction)clickShopping:(id)sender
{
    if (myFavoriteButton.selected == YES) {
        self.placeList = [self filterFromMyFavorite:PLACE_TYPE_SHOPPING];
    }
    
    else {
        if(topShoppingFavoritePlaceList == nil){
            [self loadTopFavorite:OBJECT_TYPE_TOP_FAVORITE_SHOPPING];
        }
        self.placeList = topShoppingFavoritePlaceList;
    }
    
    [self showPlaces];
}

- (IBAction)clickEntertainment:(id)sender
{
    if (myFavoriteButton.selected == YES) {
        self.placeList = [self filterFromMyFavorite:PLACE_TYPE_ENTERTAINMENT];
    }
    
    else {
        if(topEntertainmentFavoritePlaceList == nil){
            [self loadTopFavorite:OBJECT_TYPE_TOP_FAVORITE_ENTERTAINMENT];
        }
        self.placeList = topEntertainmentFavoritePlaceList;
    }
    
    [self showPlaces];
}

- (NSArray*)filterFromMyFavorite:(int)categoryId
{
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    for (Place *place in myAllFavoritePlaceList) {
        if (place.categoryId == categoryId){
            [array addObject:place];
        }
    }
    return array;
}

@end
