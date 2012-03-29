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

@interface FavoriteController ()

- (void)createRightBarButton;
- (void)clickMyFavorite:(id)sender;
- (void)clickTopFavorite:(id)sender;
- (void)clickDelete:(id)sender;
- (void)reloadList:(NSArray*)list;

@end

@implementation FavoriteController
@synthesize buttonHolderView;
@synthesize placeListHolderView;
@synthesize placeListController;
@synthesize placeList = _placeList;
@synthesize canDelete;


- (void)dealloc {
    [buttonHolderView release];
    [placeListHolderView release];
    [placeListController release];
    [_placeList release];
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
    
    self.placeList = [[PlaceStorage favoriteManager] allPlaces];
    
    PPDebug(@"%d",[_placeList count]);
    self.placeListController = [PlaceListController createController:_placeList 
                                                           superView:placeListHolderView
                                                     superController:self];  
}

- (void)viewDidUnload
{
    [self setButtonHolderView:nil];
    [self setPlaceListHolderView:nil];
    [self setPlaceListController:nil];
    [self setPlaceList:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#define RIGHT_BUTTON_VIEW_WIDTH     230
#define RIGHT_BUTTON_VIEW_HIGHT     30
#define BUTTON_WIDTH                80
#define BUTTON_HIGHT                30
#define DELETE_BUTTON_WIDTH          40

#define TAG_MY_FAVORITE_BUTTON   210
#define TAG_TOP_FAVORITE_BUTTON  211
#define TAG_DELETE_BUTTON        222

- (void)createRightBarButton
{
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RIGHT_BUTTON_VIEW_WIDTH, RIGHT_BUTTON_VIEW_HIGHT)];
    //test backgroundcolor
    //rightButtonView.backgroundColor = [UIColor blueColor];
    
    UIButton *myFavoriteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, BUTTON_WIDTH, BUTTON_HIGHT)];
    myFavoriteButton.tag = TAG_MY_FAVORITE_BUTTON;
    //test backgroundcolor
    //myFavoriteButton.backgroundColor = [UIColor grayColor];
    myFavoriteButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [myFavoriteButton setTitle:NSLS(@"我的收藏") forState:UIControlStateNormal];
    [myFavoriteButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];    
    [myFavoriteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [myFavoriteButton setBackgroundImage:[UIImage imageNamed:IMAGE_CITY_LEFT_BTN_OFF] forState:UIControlStateNormal];
    [myFavoriteButton setBackgroundImage:[UIImage imageNamed:IMAGE_CITY_LEFT_BTN_ON] forState:UIControlStateSelected];
    [myFavoriteButton addTarget:self action:@selector(clickMyFavorite:) forControlEvents:UIControlEventTouchUpInside];
    [rightButtonView addSubview:myFavoriteButton];
    [myFavoriteButton release];
    
    UIButton *topFavoriteButton = [[UIButton alloc] initWithFrame:CGRectMake(BUTTON_WIDTH, 0, BUTTON_WIDTH, BUTTON_HIGHT)];
    topFavoriteButton.tag = TAG_TOP_FAVORITE_BUTTON;
    //test backgroundcolor
    //topFavoriteButton.backgroundColor = [UIColor greenColor];
    topFavoriteButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [topFavoriteButton setTitle:NSLS(@"收藏排行") forState:UIControlStateNormal];
    [topFavoriteButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];    
    [topFavoriteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [topFavoriteButton setBackgroundImage:[UIImage imageNamed:IMAGE_CITY_RIGHT_BTN_OFF] forState:UIControlStateNormal];
    [topFavoriteButton setBackgroundImage:[UIImage imageNamed:IMAGE_CITY_RIGHT_BTN_ON] forState:UIControlStateSelected];
    [topFavoriteButton addTarget:self action:@selector(clickTopFavorite:) forControlEvents:UIControlEventTouchUpInside];
    [rightButtonView addSubview:topFavoriteButton];
    [topFavoriteButton release];
    
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(RIGHT_BUTTON_VIEW_WIDTH - DELETE_BUTTON_WIDTH, 0, DELETE_BUTTON_WIDTH, BUTTON_HIGHT)];
    deleteButton.tag = TAG_DELETE_BUTTON;
    //test backgroundcolor
    //deleteButton.backgroundColor = [UIColor grayColor];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"topmenu_btn_right.png"] forState:UIControlStateNormal];
    [deleteButton setTitle:NSLS(@"删除") forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(clickDelete:) forControlEvents:UIControlEventTouchUpInside];
    [rightButtonView addSubview:deleteButton];
    [deleteButton release];
    
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    [rightButtonView release];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    [rightButtonItem release];
}

- (void)clickMyFavorite:(id)sender
{
    UIButton *myFavoriteButton = (UIButton*)sender;
    UIButton *topFavoriteButton = (UIButton*)[self.navigationItem.rightBarButtonItem.customView viewWithTag:TAG_TOP_FAVORITE_BUTTON];
    myFavoriteButton.selected = YES;
    topFavoriteButton.selected = NO;
    
    //show my favorite
}

- (void)clickTopFavorite:(id)sender
{
    UIButton *myFavoriteButton = (UIButton*)[self.navigationItem.rightBarButtonItem.customView viewWithTag:TAG_MY_FAVORITE_BUTTON];
    UIButton *topFavoriteButton = (UIButton*)sender;
    myFavoriteButton.selected = NO;
    topFavoriteButton.selected = YES;
    
    //show top favorite
}

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

#pragma mark - deletePlaceDelegate 
- (void)deletedPlace:(Place *)place
{
    PlaceStorage *manager = [PlaceStorage favoriteManager];
    [manager deletePlace:place];
    self.placeList = [manager allPlaces];
}


#pragma mark - filter button action
- (IBAction)clickAll:(id)sender
{
     [self reloadList:_placeList];
}

- (IBAction)clickSpot:(id)sender
{ 
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (Place *place in _placeList) {
        if (place.categoryId == PLACE_TYPE_SPOT){
            [array addObject:place];
        }
    }
    [self reloadList:array];
    [array release];
}

- (IBAction)clickHotel:(id)sender
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (Place *place in _placeList) {
        if (place.categoryId == PLACE_TYPE_HOTEL){
            [array addObject:place];
        }
    }
    [self reloadList:array];
    [array release];
}

- (void)reloadList:(NSArray*)list
{
    [self.placeListController setAndReloadPlaceList:list];
}


@end
