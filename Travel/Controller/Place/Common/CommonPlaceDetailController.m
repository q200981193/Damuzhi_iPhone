//
//  CommonPlaceDetailController.m
//  Travel
//
//  Created by  on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommonPlaceDetailController.h"
#import "SlideImageView.h"
#import "Place.pb.h"
#import "CommonPlace.h"
#import "ImageName.h"
#import "UIImageUtil.h"
#import "PlaceMapViewController.h"
#import "UIUtils.h"
#import "AppUtils.h"
#import "AppManager.h"
#import "PlaceService.h"
#import "LogUtil.h"
#import "PlaceStorage.h"
#import "NearByRecommendController.h"
#import "AnimationManager.h"
#import "CommonWebController.h"
#import "ImageName.h"
#import "PPNetworkRequest.h"
#import "PlaceUtils.h"
#import "AppService.h"
#import "MapUtils.h"
#import "UIImageUtil.h"

#define NO_DETAIL_DATA NSLS(@"暂无")
#define BIG_FONT_SIZE  14
#define SMALL_FONT_SIZE 13
#define WIDTH_BUTTON  300
#define HEIGHT_BUTTON 30
#define WIDTH_NAME_LABEL 190
#define HEIGHT_NAME_LABEL 14
#define MAX_NUM_PLACES_NEARBY 8

@implementation CommonPlaceDetailController
@synthesize helpButton;
@synthesize buttonHolerView;
@synthesize imageHolderView;
@synthesize dataScrollView;
@synthesize place = _place;
@synthesize nearbyPlaceList = _nearbyPlaceList;
@synthesize praiseIcon1;
@synthesize praiseIcon2;
@synthesize praiseIcon3;
@synthesize serviceHolder;
@synthesize handler;
@synthesize favoriteCountLabel;
@synthesize telephoneView;
@synthesize addressView;
@synthesize websiteView;
@synthesize detailHeight = _detailHeight;
@synthesize favouritesView;
@synthesize addFavoriteButton;
@synthesize nearbyView = _nearbyView;
@synthesize selectedBgView;
@synthesize nearbyRecommendController = _nearbyRecommendController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id<CommonPlaceDetailDataSourceProtocol>)createPlaceHandler:(Place*)onePlace superController:(CommonPlaceDetailController *)controller
{
    if ([onePlace categoryId] == PlaceCategoryTypePlaceSpot){
        return [[[SpotDetailViewHandler alloc] initWith:controller] autorelease];
    }
    else if ([onePlace categoryId] == PlaceCategoryTypePlaceHotel)
    {
        return [[[HotelDetailViewHandler alloc] initWith:controller] autorelease];
    }
    else if ([onePlace categoryId] == PlaceCategoryTypePlaceRestraurant)
    {
        return [[[RestaurantViewHandler alloc] initWith:controller] autorelease];
    }
    else if ([onePlace categoryId] == PlaceCategoryTypePlaceShopping)
    {
        return [[[ShoppingDetailViewHandler alloc] initWith:controller] autorelease];
    }
    else if ([onePlace categoryId] == PlaceCategoryTypePlaceEntertainment)
    {
        return [[[EntertainmentDetailViewHandler alloc] initWith:controller] autorelease];
    }
    return nil;
}

- (id)initWithPlace:(Place *)place
{
    self = [super init];
    self.place = place;    
    self.handler = [self createPlaceHandler:place superController:self];     
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)setRankImage:(int32_t)rank
{
    self.praiseIcon1.image = [UIImage imageNamed:IMAGE_GOOD2];
    self.praiseIcon2.image = [UIImage imageNamed:IMAGE_GOOD2];
    self.praiseIcon3.image = [UIImage imageNamed:IMAGE_GOOD2];
    
    switch (rank) {
        case 1:
            [praiseIcon1 setImage:[UIImage imageNamed:IMAGE_GOOD]];
            break;
            
        case 2:
            [praiseIcon1 setImage:[UIImage imageNamed:IMAGE_GOOD]];
            [praiseIcon2 setImage:[UIImage imageNamed:IMAGE_GOOD]];
            break;
            
        case 3:
            [praiseIcon1 setImage:[UIImage imageNamed:IMAGE_GOOD]];
            [praiseIcon2 setImage:[UIImage imageNamed:IMAGE_GOOD]];
            [praiseIcon3 setImage:[UIImage imageNamed:IMAGE_GOOD]];
            break;
            
        default:
            break;
    }
    
    return;
}

- (void)clickHelpButton:(id)sender
{
    CommonWebController *controller = [[CommonWebController alloc] initWithWebUrl:[AppUtils getHelpHtmlFilePath]];
    controller.navigationItem.title = NSLS(@"帮助");
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)clickMap:(id)sender
{
    _nearbyRecommendController = [[NearByRecommendController alloc] initWithPlace:_place];
    [self.navigationController pushViewController:_nearbyRecommendController animated:YES];
    [MapUtils gotoLocation:_place mapView:_nearbyRecommendController.mapView];
}

- (void)clickTelephone:(id)sender
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:NSLS(@"是否拨打以下电话") delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    
    for(NSString* title in self.place.telephoneList){
        [actionSheet addButtonWithTitle:title];
    }
    [actionSheet addButtonWithTitle:NSLS(@"返回")];
    [actionSheet setCancelButtonIndex:[self.place.telephoneList count]];
    [actionSheet showInView:self.view];
    [actionSheet release];
    
}

- (void)makeCall:(NSString*) phone
{
    [UIUtils makeCall:phone];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        return;
    }
    PPDebug(@"make call number:%@",[self.place.telephoneList objectAtIndex:buttonIndex]);
    [self performSelector:@selector(makeCall:) withObject:[self.place.telephoneList objectAtIndex:buttonIndex]];
}


- (void)clickFavourite:(id)sender
{
    PlaceService* placeService = [PlaceService defaultService];
    [placeService addPlaceIntoFavorite:self place:self.place];
}

#define FAVORITES_OK_VIEW 2012040817
- (void)finishAddFavourite:(NSNumber*)resultCode count:(NSNumber*)count
{
    [self updateAddFavoriteButton];
    
    if (count != nil) {
        self.favoriteCountLabel.text = [NSString stringWithFormat:NSLS(@"已有%d人收藏"), count.intValue];
    }
    
    CGRect rect = CGRectMake(0, 0, 109, 52);
    
    UIButton *button = [[UIButton alloc] initWithFrame:rect];
    button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"favorites_ok.png"]];
    [button setTitle:NSLS(@"收藏成功") forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:BIG_FONT_SIZE];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.tag = FAVORITES_OK_VIEW;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(-8, 20, 0, 0)];
    
    CGPoint fromPosition = CGPointMake(320/2, 345);
    CGPoint toPosition = CGPointMake(320/2, 345);
    
    [self.view addSubview:button];
    [button release];
    
    [AnimationManager alertView:button fromPosition:fromPosition toPosition:toPosition interval:2 delegate:self];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    UIView *view = [self.view viewWithTag:FAVORITES_OK_VIEW];
    [view removeFromSuperview];
}

- (void)didGetPlaceData:(int)placeId count:(int)placeFavoriteCount;
{
    self.favoriteCountLabel.text = [NSString stringWithFormat:NSLS(@"已有%d人收藏"),placeFavoriteCount];
}

#define DESTANCE_BETWEEN_SERVICE_IMAGES 25
#define WIDTH_OF_SERVICE_IMAGE 21
#define HEIGHT_OF_SERVICE_IMAGE 21

-(void)setServiceIcons
{
    self.serviceHolder.backgroundColor = [UIColor clearColor];
    int i = 0;

    for (NSNumber *providedServiceId in [_place providedServiceIdList]) {
        UIImageView *serviceIconView = [[UIImageView alloc] initWithFrame:CGRectMake((i++)*DESTANCE_BETWEEN_SERVICE_IMAGES, 0, WIDTH_OF_SERVICE_IMAGE, HEIGHT_OF_SERVICE_IMAGE)];
        UIImage *icon = [[UIImage alloc] initWithContentsOfFile:[AppUtils getProvidedServiceIconPath:[providedServiceId intValue]]];
        [serviceIconView setImage:icon];
        [serviceHolder addSubview:serviceIconView];
        [icon release];
        [serviceIconView release];
    }
    
}

- (UILabel*)createTitleView:(NSString*)title
{
    UIFont *boldFont = [UIFont boldSystemFontOfSize:BIG_FONT_SIZE];    
    UILabel *label = [[[UILabel alloc]initWithFrame:CGRECT_TITLE]autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = TITLE_COLOR;
    label.font = boldFont;
    label.text  = title;
    return label;
}

- (UILabel*)createDescriptionView:(NSString*)description height:(CGFloat)height
{
    UIFont *font = [UIFont systemFontOfSize:SMALL_FONT_SIZE];
    UILabel *label = [[[UILabel alloc]initWithFrame:CGRectMake(10, 26, 300, height)] autorelease];
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = DESCRIPTION_COLOR;
    label.font = font;
    label.text = description; 
    return label;
}

- (UIView*)createMiddleLineView:(CGFloat)y
{
    
    UIView *middleLineView = [[[UIView alloc]initWithFrame:CGRectMake(0, y, 320, MIDDLE_LINE_HEIGHT)] autorelease];
    middleLineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"middle_line"]];
    return middleLineView;
}

-(void)addIntroductionViewWith:(NSString*)titleString description:(NSString*)descriptionString
{
    UIFont *font = [UIFont systemFontOfSize:SMALL_FONT_SIZE];
    CGSize withinSize = CGSizeMake(300, CGFLOAT_MAX);
    
    NSString *description = [NSString stringWithFormat:@"       %@",[descriptionString stringByReplacingOccurrencesOfString:@"\n" withString:@"\n       "]];
    
    if ([description length] == 0) {
        description = NO_DETAIL_DATA;
    }
    CGSize size = [description sizeWithFont:font constrainedToSize:withinSize lineBreakMode:UILineBreakModeWordWrap];
    
    UIView *segmentView = [[[UIView alloc]initWithFrame:CGRectMake(0, self.detailHeight, 320, size.height + TITLE_VIEW_HEIGHT + 10)] autorelease];
    segmentView.backgroundColor = INTRODUCTION_BG_COLOR;
        
    UIFont *boldFont = [UIFont boldSystemFontOfSize:BIG_FONT_SIZE];    
    UILabel *title = [[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, TITLE_VIEW_HEIGHT)]autorelease];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = TITLE_COLOR;
    title.font = boldFont;
    title.text  = titleString;
    [segmentView addSubview:title];
    
    UIImageView *shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 34)];
    [shadowView setImage:[UIImage strectchableImageName:@"detail_shadow"]];
    [segmentView addSubview:shadowView];
    [segmentView sendSubviewToBack:shadowView];
    [shadowView release];
    
    UILabel *introductionDescription = [[UILabel alloc]initWithFrame:CGRectMake(10, shadowView.frame.size.height + 4, 300, size.height)];
    introductionDescription.lineBreakMode = UILineBreakModeWordWrap;
    introductionDescription.numberOfLines = 0;
    introductionDescription.backgroundColor = [UIColor clearColor];
    introductionDescription.textColor = DESCRIPTION_COLOR;
    introductionDescription.font = font;
    
    introductionDescription.text = description;
        
    [segmentView addSubview:introductionDescription];
    [introductionDescription release];
    [dataScrollView addSubview:segmentView];    
    
    UIView *middleLineView = [self createMiddleLineView: _detailHeight + segmentView.frame.size.height];
    [dataScrollView addSubview:middleLineView];
    
    _detailHeight =  middleLineView.frame.origin.y + middleLineView.frame.size.height;
}

-(void)addSegmentViewWith:(NSString*)titleString description:(NSString*)descriptionString
{
    UIFont *font = [UIFont systemFontOfSize:SMALL_FONT_SIZE];
    CGSize withinSize = CGSizeMake(300, CGFLOAT_MAX);
    
    NSString *description = [descriptionString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([description length] == 0) {
        description = NO_DETAIL_DATA;
    }
    
    CGSize size = [description sizeWithFont:font constrainedToSize:withinSize lineBreakMode:UILineBreakModeWordWrap];
    
    UIView *segmentView = [[[UIView alloc]initWithFrame:CGRectMake(0, _detailHeight, 320, size.height + TITLE_VIEW_HEIGHT)] autorelease];
    segmentView.backgroundColor = PRICE_BG_COLOR;
    
    UILabel *title = [self createTitleView:titleString];
    [segmentView addSubview:title];
    
    UILabel *introductionDescription = [self createDescriptionView:description height:size.height];    
    [segmentView addSubview:introductionDescription];
    [dataScrollView addSubview:segmentView];    
    
    UIView *middleLineView = [self createMiddleLineView: _detailHeight + segmentView.frame.size.height];
    [dataScrollView addSubview:middleLineView];
    
    _detailHeight =  middleLineView.frame.origin.y + middleLineView.frame.size.height;
        
}

- (void) clickNearbyRow:(id)sender
{
    UIButton *button = sender;
    NSInteger index = button.tag;
    
    selectedBgView = [[UIButton alloc] initWithFrame:CGRectMake(12, _nearbyView.frame.origin.y +30*(index+1), 275, 24)];
    [dataScrollView addSubview:selectedBgView];
    
    CommonPlaceDetailController *controller = [[CommonPlaceDetailController alloc] initWithPlace:[_nearbyPlaceList objectAtIndex:index]];
    
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void) addNearbyView
{
    _nearbyView = [[[UIView alloc]initWithFrame:CGRectMake(0, _detailHeight, self.view.frame.size.width , MAX_NUM_PLACES_NEARBY*HEIGHT_BUTTON+30+10)] autorelease];
    _nearbyView.backgroundColor = PRICE_BG_COLOR;
    
    UILabel *title = [self createTitleView:NSLS(@"周边推荐")];
    [_nearbyView addSubview:title];
    
    [dataScrollView addSubview:_nearbyView];    
    _detailHeight = _nearbyView.frame.origin.y + _nearbyView.frame.size.height;
    
    //get nearby placelist data
    [[PlaceService defaultService] findPlacesNearby:PlaceCategoryTypePlaceAll place:_place num:MAX_NUM_PLACES_NEARBY viewController:self];
}

- (void)setNearbyTaleRowBgImage:(UIButton*)button row:(int)row totoalRows:(int)totoalRows
{
    if (row < 1 || totoalRows <1 || row > totoalRows) {
        return;
    }
    
    switch (totoalRows) {
        case 1:
            [button setBackgroundImage:[UIImage strectchableImageName:@"table5_bg1_top.png"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage strectchableImageName:@"table5_bg2_top.png"] forState:UIControlStateHighlighted];
            break;
            
        case 2:
            if (row == 1) {
                [button setBackgroundImage:[UIImage strectchableImageName:@"table5_bg1_top.png"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage strectchableImageName:@"table5_bg2_top.png"] forState:UIControlStateHighlighted];
            }
            else {
                [button setBackgroundImage:[UIImage strectchableImageName:@"table5_bg1_down.png"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage strectchableImageName:@"table5_bg2_down.png"] forState:UIControlStateHighlighted];
            }
            break;

        default:
            if (row == 1) {
                [button setBackgroundImage:[UIImage strectchableImageName:@"table5_bg1_top.png"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage strectchableImageName:@"table5_bg2_top.png"] forState:UIControlStateHighlighted];
            }
            else if (row >1 && row <totoalRows) {
                [button setBackgroundImage:[UIImage strectchableImageName:@"table5_bg1_center.png"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage strectchableImageName:@"table5_bg2_center.png"] forState:UIControlStateHighlighted];
            }
            else {
                [button setBackgroundImage:[UIImage strectchableImageName:@"table5_bg1_down.png"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage strectchableImageName:@"table5_bg2_down.png"] forState:UIControlStateHighlighted];
            }
            break;
    }
}

//request done after get nearby placelist
- (void)findRequestDone:(int)result placeList:(NSArray *)placeList
{
    if (result == ERROR_SUCCESS) {
        self.nearbyPlaceList = placeList;
        
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:_place.latitude longitude:_place.longitude];
        int i = 0;
        for (Place *nearbyPlace in _nearbyPlaceList)
        {
            CLLocation *location = [[CLLocation alloc] initWithLatitude:nearbyPlace.latitude longitude:nearbyPlace.longitude];
            [location release];
            
            UIButton *rowView = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-WIDTH_BUTTON)/2, 30 + HEIGHT_BUTTON*(i++), WIDTH_BUTTON, HEIGHT_BUTTON)];
            rowView.tag = [_nearbyPlaceList indexOfObject:nearbyPlace];
            
            [self setNearbyTaleRowBgImage:rowView row:i totoalRows:[_nearbyPlaceList count]];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 14, 14)];
            
            NSString *imageName = [AppUtils getCategoryIcon:[nearbyPlace categoryId]];
            UIImage *image = [UIImage imageNamed:imageName];
            [imageView setImage:image];
            [rowView addSubview:imageView];
            [imageView release];
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x+imageView.frame.size.width+6, 8, WIDTH_NAME_LABEL, HEIGHT_NAME_LABEL)];
            nameLabel.text = [nearbyPlace name];
            nameLabel.font = [UIFont systemFontOfSize:SMALL_FONT_SIZE];
            nameLabel.textColor = DESCRIPTION_COLOR;
            
            nameLabel.backgroundColor = [UIColor clearColor];
            [rowView addSubview:nameLabel];
            [nameLabel release];
            
            UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x+nameLabel.frame.size.width+8, 8, 40, 14)];            
            NSString* distanceString = [PlaceUtils getDistanceString:nearbyPlace currentLocation:loc];
            distanceLabel.text = distanceString;
            distanceLabel.font = [UIFont systemFontOfSize:SMALL_FONT_SIZE];
            distanceLabel.textColor = DESCRIPTION_COLOR;
            distanceLabel.backgroundColor = [UIColor clearColor];
            [rowView addSubview:distanceLabel];
            [distanceLabel release];
            
            UIImageView *goView = [[UIImageView alloc] initWithFrame:CGRectMake(distanceLabel.frame.origin.x+distanceLabel.frame.size.width+6, 8, 7, 14)];
            
            UIImage *goImage = [UIImage imageNamed:@"go_btn"];
            [goView setImage:goImage];
            [rowView addSubview:goView];
            [goView release];
            
            [rowView addTarget:self action:@selector(clickNearbyRow:) forControlEvents:UIControlEventTouchUpInside];
            [_nearbyView addSubview:rowView];
            [rowView release];
        }    
        [loc release];
    }
    else {
        [self popupMessage:@"加载周边推荐数据失败！" title:nil];
    }
}

- (void)setTransportTaleRowBgImage:(UIButton*)button row:(int)row totoalRows:(int)totoalRows
{
    if (row < 1 || totoalRows < 2 || row > totoalRows) {
        return;
    }
    
    switch (totoalRows) {
        case 2:
            if (row == 1) {
                [button setBackgroundImage:[UIImage strectchableImageName:@"table4_bg_top.png"] forState:UIControlStateNormal];
                
            }
            else {
                [button setBackgroundImage:[UIImage strectchableImageName:@"table4_bg_down.png"] forState:UIControlStateNormal];
            }
            break;
            
        default:
            if (row == 1) {
                [button setBackgroundImage:[UIImage strectchableImageName:@"table4_bg_top.png"] forState:UIControlStateNormal];
            }
            else if (row >1 && row <totoalRows-1) {
                [button setBackgroundImage:[UIImage strectchableImageName:@"table4_bg_center.png"] forState:UIControlStateNormal];
            }
            else {
                [button setBackgroundImage:[UIImage strectchableImageName:@"table4_bg_down.png"] forState:UIControlStateNormal];            }
            break;
    }
}

- (void)addTransportView:(Place*)place
{
    NSMutableString * transportation = [NSMutableString stringWithString:[place transportation]];
    [transportation stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([transportation length] == 0) {
        [self addSegmentViewWith:NSLS(@"交通信息") description:@"暂无"];
    }
    else {
        NSString *str = [NSString stringWithFormat:@"位置:距酒店;%@",transportation];
        NSArray *array = [str componentsSeparatedByString:@";"];

        UIView *segmentView = [[UIView alloc]initWithFrame:CGRectMake(0, _detailHeight, self.view.frame.size.width, ([array count])*HEIGHT_BUTTON+10)];
        segmentView.backgroundColor = PRICE_BG_COLOR;
        
        UILabel *title = [self createTitleView:NSLS(@"交通信息")];
        [segmentView addSubview:title];
        
        [dataScrollView addSubview:segmentView];    
        _detailHeight = segmentView.frame.origin.y + segmentView.frame.size.height;
        
        int i;
        for (i=1; i < [array count]; i++)
        {
            NSArray *subArray = [[array objectAtIndex:i-1] componentsSeparatedByString:@":"];
            UIButton *rowView = [[UIButton alloc] initWithFrame:CGRectMake(10, HEIGHT_BUTTON*i, WIDTH_BUTTON, HEIGHT_BUTTON)];
            [rowView setUserInteractionEnabled:NO];
            
            [self setTransportTaleRowBgImage:rowView row:i totoalRows:[array count]];

            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 150, 14)];
            nameLabel.text = [subArray objectAtIndex:0];
            nameLabel.font = [UIFont systemFontOfSize:SMALL_FONT_SIZE];
            nameLabel.textColor = DESCRIPTION_COLOR;
            nameLabel.backgroundColor = [UIColor clearColor];
            [rowView addSubview:nameLabel];
            [nameLabel release];
            
            UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(245, 6, 60, 14)];
            
            distanceLabel.text = [subArray objectAtIndex:1];
            distanceLabel.font = [UIFont systemFontOfSize:SMALL_FONT_SIZE];
            distanceLabel.textColor = DESCRIPTION_COLOR;
            distanceLabel.backgroundColor = [UIColor clearColor];
            [rowView addSubview:distanceLabel];
            [distanceLabel release];
            
            [segmentView addSubview:rowView];
            [rowView release];
        }
        [segmentView release];
        
        UIView *middleLineView = [self createMiddleLineView: _detailHeight];
        [dataScrollView addSubview:middleLineView];
        _detailHeight =  middleLineView.frame.origin.y + middleLineView.frame.size.height;
    }
}

//创建电话、地址、网站 的通用方法
- (UIView*)createRowView:(NSString*) title detail:(NSString*)detail
{
    
    UIFont *font = [UIFont boldSystemFontOfSize:BIG_FONT_SIZE];
    int width = 235;
    CGSize withinSize = CGSizeMake(width, CGFLOAT_MAX);
    UIView* rowView;
    CGSize size = [detail sizeWithFont:font constrainedToSize:withinSize lineBreakMode:UILineBreakModeWordWrap];
    int height = 0;
    if ([detail length] == 0) {
        rowView = [[[UIView alloc]initWithFrame:CGRectMake(0, _detailHeight, 320, 42)] autorelease];
        height = 42;
    }
    else
    {
        rowView = [[[UIView alloc]initWithFrame:CGRectMake(0, _detailHeight, 320, size.height + 26)] autorelease];
        height = size.height + 26;
    }
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, height)];
    [bgImageView setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1]];
    
//    UIImageView *gotoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"go_btn.png"]];
//    [gotoImageView setCenter:CGPointMake(20, height/2)];
//    [bgImageView addSubview:gotoImageView];
    
    bgImageView.image = [UIImage imageNamed:@"t_bg.png"];
    [rowView addSubview:bgImageView];
    [rowView sendSubviewToBack:bgImageView];
    [bgImageView release];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, ceilf((height - 20)/2), 40, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:79/255.0 green:102/255.0 blue:119/255.0 alpha:1.0];
    label.font = font;
    label.text = title;
    [rowView addSubview:label];
    [label release];
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(48, 0, width, height)];
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.lineBreakMode = UILineBreakModeWordWrap;
    detailLabel.numberOfLines = 0;
    detailLabel.textColor = [UIColor colorWithRed:89/255.0 green:112/255.0 blue:129/255.0 alpha:1.0];
    detailLabel.font = font;
    if ([detail length] == 0) {
        detailLabel.text = NSLS(@" 暂无");
    }else
    {
        detailLabel.text = detail;
    }
    [rowView addSubview:detailLabel];
    [detailLabel release];
    
    return rowView;
}

- (void)addTelephoneView
{
    telephoneView = [self createRowView:NSLS(@"电话: ") detail:[self.place.telephoneList componentsJoinedByString:@" "]];
    
    if ([self.place.telephoneList count] != 0) {
        UIImageView *phoneImage = [[UIImageView alloc] initWithFrame:CGRectMake(290, 6, 29, 29)];
        [phoneImage setImage:[UIImage imageNamed:@"t_phone"]];
        [phoneImage setCenter:CGPointMake(300, telephoneView.frame.size.height/2)];
        [telephoneView addSubview:phoneImage];
        [phoneImage release];
        
        UIButton *telButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, telephoneView.frame.size.width, telephoneView.frame.size.height)];
        telButton.backgroundColor =[UIColor clearColor];
        [telButton addTarget:self action:@selector(clickTelephone:) forControlEvents:UIControlEventTouchUpInside];
        [telephoneView addSubview:telButton];
        [telButton release];
    }
    
    [dataScrollView addSubview:telephoneView];
    _detailHeight = _detailHeight + telephoneView.frame.size.height;

}

- (void)addAddressView
{
    addressView = [self createRowView:NSLS(@"地址: ") detail:[[_place addressList] componentsJoinedByString:@" "]];
    int height = addressView.frame.size.height;
    
    UIImageView *mapImageView = [[UIImageView alloc] initWithFrame:CGRectMake(290, (height - 20)/2, 29, 29)];
    [mapImageView setImage:[UIImage imageNamed:@"t_map"]];
    [mapImageView setCenter:CGPointMake(300, addressView.frame.size.height/2)];
    [addressView addSubview:mapImageView];
    [mapImageView release];
    
    UIButton *mapButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, addressView.frame.size.width, addressView.frame.size.height)];
    mapButton.backgroundColor =[UIColor clearColor];
    [mapButton addTarget:self action:@selector(clickMap:) forControlEvents:UIControlEventTouchUpInside];
    [addressView addSubview:mapButton];
    [mapButton release];
    
    [dataScrollView addSubview:addressView];
    
    _detailHeight = _detailHeight + addressView.frame.size.height;
}

- (void)addWebsiteView
{
    NSString* websiteUrl = [self.place website];
    if ([websiteUrl length] > 0) {
        websiteView = [self createRowView:NSLS(@"网站: ") detail:[self.place website]];
        [dataScrollView addSubview:websiteView];
        _detailHeight = _detailHeight + websiteView.frame.size.height;

    }
}

- (void)updateAddFavoriteButton
{
    if ([[PlaceStorage favoriteManager] isPlaceInFavorite:self.place.placeId]) {
        [addFavoriteButton setTitle:NSLS(@"已收藏") forState:UIControlStateNormal];
        [addFavoriteButton setEnabled:NO];
    }
    else {
        [addFavoriteButton setTitle:NSLS(@"收藏本页") forState:UIControlStateNormal];
        [addFavoriteButton setEnabled:YES];
    }
}

- (void)addBottomView
{
     favouritesView = [[UIView alloc]initWithFrame:CGRectMake(0, _detailHeight, 320, 60)];
    favouritesView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bottombg.png"]];
    
    UIButton *favButton = [[UIButton alloc] initWithFrame:CGRectMake((320-93)/2, 5, 93, 29)];
    [favButton addTarget:self action:@selector(clickFavourite:) forControlEvents:UIControlEventTouchUpInside];
    favButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"favorites.png"]];
    [favButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [favButton.titleLabel setFont:[UIFont systemFontOfSize:BIG_FONT_SIZE]];
    //favButton.titleLabel.shadowColor = [UIColor whiteColor];
    //favButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
    [favButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 18, 0, 0)];
    self.addFavoriteButton = favButton;
    [favButton release];
    [self updateAddFavoriteButton];
    [favouritesView addSubview:addFavoriteButton];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((320-120)/2, 40, 120, 15)];
    self.favoriteCountLabel = label;
    [label release];
    self.favoriteCountLabel.backgroundColor = [UIColor clearColor];
    self.favoriteCountLabel.textAlignment = UITextAlignmentCenter;
    self.favoriteCountLabel.textColor = [UIColor colorWithRed:125/255.0 green:125/255.0 blue:125/255.0 alpha:1.0];
    [[PlaceService defaultService] getPlaceFavoriteCount:self placeId:self.place.placeId];
    self.favoriteCountLabel.font = [UIFont boldSystemFontOfSize:BIG_FONT_SIZE];
    [favouritesView addSubview:self.favoriteCountLabel];
    
    [dataScrollView addSubview:favouritesView];
    
    [favouritesView release];

}

- (void)addHeaderView
{
    buttonHolerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage strectchableImageName:@"topmenu_bg2"]];
    [self setRankImage:[self.place rank]];
    [self setServiceIcons];
}

- (void)addSlideImageView
{
    NSMutableArray *imagePathList = [[NSMutableArray alloc] init];

    if ([AppUtils isShowImage]) {
        //handle imageList, if there has local data, each image is a relative path, otherwise, it is a absolute URL.
        for (NSString *image in self.place.imagesList) {
            NSString *path = [AppUtils getAbsolutePath:[AppUtils getCityDir:[[AppManager defaultManager] getCurrentCityId]] string:image];
            [imagePathList addObject:path];
        }
    }
    else {
        [imagePathList addObject:IMAGE_PLACE_DETAIL];
    }
    
    SlideImageView* slideImageView = [[SlideImageView alloc] initWithFrame:imageHolderView.bounds];
    slideImageView.defaultImage = IMAGE_PLACE_DETAIL;
    [slideImageView.pageControl setPageIndicatorImageForCurrentPage:[UIImage strectchableImageName:@"point_pic3.png"] forNotCurrentPage:[UIImage strectchableImageName:@"point_pic4.png"]];
    [slideImageView setImages:imagePathList];
    [self.imageHolderView addSubview:slideImageView];
    
    [imagePathList release];
    [slideImageView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    [self setNavigationRightButton:NSLS(@"") 
                         imageName:@"map_po.png" 
                            action:@selector(clickMap:)];
    [self setTitle:[self.place name]];
    
    [self addHeaderView];
   
    [self addSlideImageView];
           
    
    _detailHeight = imageHolderView.frame.size.height;
    
    [self.handler addDetailViews:dataScrollView WithPlace:self.place];
        
    [self addNearbyView];
    
    [self addTelephoneView];
    
    [self addAddressView];
    
    [self addWebsiteView];
    
    dataScrollView.backgroundColor = [UIColor whiteColor];
    [dataScrollView setContentSize:CGSizeMake(320, _detailHeight + 235)];
        
    [self addBottomView];
    
    [[PlaceStorage historyManager] addPlace:self.place];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [selectedBgView removeFromSuperview];
}

- (void)viewDidUnload
{
    [self setImageHolderView:nil];
    [self setDataScrollView:nil];
    [self setPlace:nil];
    [self setButtonHolerView:nil];
    [self setPraiseIcon1:nil];
    [self setPraiseIcon2:nil];
    [self setPraiseIcon3:nil];
    [self setHelpButton:nil];
    [self setServiceHolder:nil];
    [self setAddFavoriteButton:nil];
    [self setNearbyView:nil];
    [self setSelectedBgView:nil];
    [super viewDidUnload];
    [self setNearbyRecommendController:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [imageHolderView release];
    [dataScrollView release];
    [_place release];
    [buttonHolerView release];
    [praiseIcon1 release];
    [praiseIcon2 release];
    [praiseIcon3 release];
    [helpButton release];
    [serviceHolder release];
    [_nearbyPlaceList release];
    [favoriteCountLabel release];
    [telephoneView release];
    [addressView release];
    [websiteView release];
    [favouritesView release];
    [addFavoriteButton release];
    [selectedBgView release];
    [_nearbyRecommendController release];
    [super dealloc];
}
@end
