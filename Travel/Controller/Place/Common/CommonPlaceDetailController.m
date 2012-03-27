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

#define NO_DETAIL_DATA NSLS(@"暂无")

@implementation CommonPlaceDetailController
@synthesize helpButton;
@synthesize buttonHolerView;
@synthesize imageHolderView;
@synthesize dataScrollView;
@synthesize place;
@synthesize praiseIcon1;
@synthesize praiseIcon2;
@synthesize praiseIcon3;
@synthesize serviceHolder;
@synthesize handler;
@synthesize favoriteCountLabel;
@synthesize telephoneView;
@synthesize addressView;
@synthesize websiteView;
@synthesize detailHeight;
@synthesize favouritesView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id<CommonPlaceDetailDataSourceProtocol>)createPlaceHandler:(Place*)onePlace
{
    if ([onePlace categoryId] == PLACE_TYPE_SPOT){
        return [[[SpotDetailViewHandler alloc] init] autorelease];
    }
    else if ([onePlace categoryId] == PLACE_TYPE_HOTEL)
    {
        return [[[HotelDetailViewHandler alloc] init] autorelease];
    }
    return nil;
}

- (id)initWithPlace:(Place *)onePlace
{
    self = [super init];
    self.place = onePlace;    
    self.handler = [self createPlaceHandler:onePlace];     
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
    NSLog(@"click help");
}

- (void)clickMap:(id)sender
{
    PlaceMapViewController* controller = [[[PlaceMapViewController alloc]init]autorelease];
    controller.superController = self;
    [self.navigationController pushViewController:controller animated:YES];
    [controller gotoLocation:self.place];
    
    NSArray *placeList = [[NSArray alloc]initWithObjects:self.place, nil];
    [controller setPlaces:placeList];
    
    [placeList release];
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
    NSLog(@"make call number:%@",[self.place.telephoneList objectAtIndex:buttonIndex]);
    [self performSelector:@selector(makeCall:) withObject:[self.place.telephoneList objectAtIndex:buttonIndex]];
}


- (void)clickFavourite:(id)sender
{
    PlaceService* placeService = [PlaceService defaultService];
    [placeService addPlaceIntoFavorite:self place:self.place];
}

- (void)didGetPlaceData:(int)placeId count:(int)placeFavoriteCount;
{
    self.favoriteCountLabel.text = [NSString stringWithFormat:NSLS(@"(已有%d人收藏)"),placeFavoriteCount];
}

#define DESTANCE_BETWEEN_SERVICE_IMAGES 25
#define WIDTH_OF_SERVICE_IMAGE 21
#define HEIGHT_OF_SERVICE_IMAGE 21

-(void)setServiceIcons
{
    self.serviceHolder.backgroundColor = [UIColor clearColor];
    int i = 0;

    for (NSNumber *providedServiceId in [place providedServiceIdList]) {
        NSString *destinationDir = [AppUtils getProvidedServiceImageDir];
        NSString *fileName = [[NSString alloc] initWithFormat:@"%d.png", [providedServiceId intValue]];
        
        UIImageView *serviceIconView = [[UIImageView alloc] initWithFrame:CGRectMake((i++)*DESTANCE_BETWEEN_SERVICE_IMAGES, 0, WIDTH_OF_SERVICE_IMAGE, HEIGHT_OF_SERVICE_IMAGE)];
        UIImage *icon = [[UIImage alloc] initWithContentsOfFile:[destinationDir stringByAppendingPathComponent:fileName]];
        
//        UIImage *icon = [UIImage imageNamed:@"map_food"];
//        NSLog(@"providedServiceIcon = %@", [destinationDir stringByAppendingPathComponent:fileName]);
        [serviceIconView setImage:icon];
        
        [serviceHolder addSubview:serviceIconView];
        [icon release];
        [serviceIconView release];
        
    }
    
}

+ (UILabel*)createTitleView:(NSString*)title
{
    UIFont *boldFont = [UIFont boldSystemFontOfSize:13];    
    UILabel *label = [[[UILabel alloc]initWithFrame:CGRECT_TITLE]autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = TITLE_COLOR;
    label.font = boldFont;
    label.text  = title;
    return label;
}

+ (UILabel*)createDescriptionView:(NSString*)description height:(CGFloat)height
{
    UIFont *font = [UIFont systemFontOfSize:12];
    UILabel *label = [[[UILabel alloc]initWithFrame:CGRectMake(10, 26, 300, height)] autorelease];
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = DESCRIPTION_COLOR;
    label.font = font;
    label.text = description; 
    return label;
}

+ (UIView*)createMiddleLineView:(CGFloat)y
{
    
    UIView *middleLineView = [[[UIView alloc]initWithFrame:CGRectMake(0, y, 320, MIDDLE_LINE_HEIGHT)] autorelease];
    middleLineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"middle_line"]];
    return middleLineView;
}

-(void)addSegmentViewTo:(NSString*)titleString description:(NSString*)descriptionString
{
    UIFont *font = [UIFont systemFontOfSize:12];
    CGSize withinSize = CGSizeMake(300, 100000);
    
    NSString *description = descriptionString;
    if ([description length] == 0) {
        description = NO_DETAIL_DATA;
    }
    CGSize size = [description sizeWithFont:font constrainedToSize:withinSize lineBreakMode:UILineBreakModeWordWrap];
    
    UIView *segmentView = [[[UIView alloc]initWithFrame:CGRectMake(0, self.detailHeight, 320, size.height + TITLE_VIEW_HEIGHT)] autorelease];
    segmentView.backgroundColor = INTRODUCTION_BG_COLOR;
    
    UILabel *title = [CommonPlaceDetailController createTitleView:titleString];
    [segmentView addSubview:title];
    
    //    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(5, 24, 310, 1)];
    //    lineView.backgroundColor = PRICE_BG_COLOR;
    //    [segmentView addSubview:lineView];
    //    [lineView release];
    
    UILabel *introductionDescription = [CommonPlaceDetailController createDescriptionView:description height:size.height];    
    [segmentView addSubview:introductionDescription];
    [dataScrollView addSubview:segmentView];    
    
    UIView *middleLineView = [CommonPlaceDetailController createMiddleLineView: self.detailHeight + segmentView.frame.size.height];
    [dataScrollView addSubview:middleLineView];
    
    self.detailHeight =  middleLineView.frame.origin.y + middleLineView.frame.size.height;
}


- (void)addPaddingVew
{
    UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 3)];
    paddingView.backgroundColor = [UIColor colorWithRed:40/255.0 green:123/255.0 blue:181/255.0 alpha:1.0];
    [dataScrollView addSubview:paddingView];
    [paddingView release];
}

- (void)addTelephoneView
{
    telephoneView = [[UIView alloc]initWithFrame:CGRectMake(0, detailHeight, 320, 32)];
    telephoneView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"t_bg"]];
    UILabel *telephoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 4, 250, 20)];
    telephoneLabel.backgroundColor = [UIColor clearColor];
    telephoneLabel.textColor = [UIColor colorWithRed:89/255.0 green:112/255.0 blue:129/255.0 alpha:1.0];
    telephoneLabel.font = [UIFont boldSystemFontOfSize:12];
    NSString *telephoneString = @"";
    if ([self.place.telephoneList count] > 0) {
        telephoneString = [self.place.telephoneList componentsJoinedByString:@" "];
    }
    telephoneLabel.text = [[NSString stringWithString:NSLS(@"电话: ")] stringByAppendingString:telephoneString];
    [telephoneView addSubview:telephoneLabel];
    [telephoneLabel release];
    
    if ([self.place.telephoneList count] != 0) {
        UIButton *telButton = [[UIButton alloc]initWithFrame:CGRectMake(290, 4, 24, 24)];
        [telButton setImage:[UIImage imageNamed:@"t_phone"] forState:UIControlStateNormal];     
        [telButton addTarget:self action:@selector(clickTelephone:) forControlEvents:UIControlEventTouchUpInside];
        [telephoneView addSubview:telButton];
        [telButton release];
    }
    
    [dataScrollView addSubview:telephoneView];
    [telephoneView release];

}

- (void)addAddressView
{
    addressView = [[UIView alloc]initWithFrame:CGRectMake(0, telephoneView.frame.origin.y + telephoneView.frame.size.height, 320, 32)];
    addressView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"t_bg"]];
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 4, 250, 20)];
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.textColor = [UIColor colorWithRed:89/255.0 green:112/255.0 blue:129/255.0 alpha:1.0];
    addressLabel.font = [UIFont boldSystemFontOfSize:12];
    NSString *addr = [[[NSString alloc]initWithFormat:NSLS(@"地址:")] autorelease];
    NSArray *addressList = [self.place addressList];
    for (NSString* address in addressList) {
        addr = [addr stringByAppendingFormat:@" ", address];
    }
    addressLabel.text = addr;
    [addressView addSubview:addressLabel];
    [addressLabel release];
    
    UIButton *mapButton = [[UIButton alloc]initWithFrame:CGRectMake(290, 4, 24, 24)];
    [mapButton setImage:[UIImage imageNamed:@"t_map"] forState:UIControlStateNormal];
    [mapButton addTarget:self action:@selector(clickMap:) forControlEvents:UIControlEventTouchUpInside];
    [addressView addSubview:mapButton];
    [mapButton release];
    
    [dataScrollView addSubview:addressView];
    [addressView release];

}

- (void)addWebsiteView
{
     websiteView = [[UIView alloc]initWithFrame:CGRectMake(0, addressView.frame.origin.y + addressView.frame.size.height, 320, 32)];
    websiteView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"t_bg"]];
    UILabel *websiteLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 4, 250, 20)];
    websiteLabel.backgroundColor = [UIColor clearColor];
    websiteLabel.textColor = [UIColor colorWithRed:89/255.0 green:112/255.0 blue:129/255.0 alpha:1.0];
    websiteLabel.font = [UIFont boldSystemFontOfSize:12];
    NSString *website = NSLS(@"网站: ");
    websiteLabel.text = [website stringByAppendingString:[self.place website]];
    [websiteView addSubview:websiteLabel];
    [websiteLabel release];
    
    [dataScrollView addSubview:websiteView];
    [websiteView release];

}

- (void)addBottomView
{
     favouritesView = [[UIView alloc]initWithFrame:CGRectMake(0, websiteView.frame.origin.y + websiteView.frame.size.height, 320, 60)];
    favouritesView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bottombg"]];
    
    UIButton *favButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 10, 130, 27)];
    [favButton addTarget:self action:@selector(clickFavourite:) forControlEvents:UIControlEventTouchUpInside];
    favButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fov"]];
    [favouritesView addSubview:favButton];
    
    self.favoriteCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 40, 120, 15)];
    self.favoriteCountLabel.backgroundColor = [UIColor clearColor];
    self.favoriteCountLabel.textColor = [UIColor colorWithRed:125/255.0 green:125/255.0 blue:125/255.0 alpha:1.0];
    [[PlaceService defaultService] getPlaceFavoriteCount:self placeId:self.place.placeId];
    self.favoriteCountLabel.font = [UIFont boldSystemFontOfSize:13];
    [favouritesView addSubview:self.favoriteCountLabel];
    
    [dataScrollView addSubview:favouritesView];
    [self.favoriteCountLabel release];
    [favButton release];
    [favouritesView release];

}

- (void)addHeaderView
{
    buttonHolerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topmenu_bg2"]];
    
    [self setRankImage:[self.place rank]];
    [self setServiceIcons];
}

- (void)addSlideImageView
{
    SlideImageView* slideImageView = [[SlideImageView alloc] initWithFrame:imageHolderView.bounds];
    [imageHolderView addSubview:slideImageView];  
    
    //    // add image array
    //    NSArray* imagePathArray = [self.place imagesList];
    //    NSMutableArray* images = [[[NSMutableArray alloc] init] autorelease];
    //    for (NSString* imagePath in imagePathArray){
    //        NSLog(@"%@", imagePath);
    //        [images addObject:[UIImage imageNamed:imagePath]];
    //    }
    //    [slideImageView setImages:images];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationLeftButton:NSLS(@"返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    [self setNavigationRightButton:NSLS(@"") 
                         imageName:@"map_po.png" 
                            action:@selector(clickMap:)];
    [self setTitle:[self.place name]];
    
    [self addHeaderView];
   
    [self addSlideImageView];
           
    [self addPaddingVew];
    
    [self.handler addDetailViews:dataScrollView WithPlace:self.place];
    detailHeight = [self.handler detailHeight];
    dataScrollView.backgroundColor = [UIColor whiteColor];
    [dataScrollView setContentSize:CGSizeMake(320, detailHeight + 266)];

    [self addTelephoneView];
    
    [self addAddressView];
    
    [self addWebsiteView];
        
    [self addBottomView];
    
    
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
    [super viewDidUnload];
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
    [place release];
    [buttonHolerView release];
    [praiseIcon1 release];
    [praiseIcon2 release];
    [praiseIcon3 release];
    [helpButton release];
    [serviceHolder release];
    [super dealloc];
}
@end
