//
//  CommonRouteDetailController.m
//  Travel
//
//  Created by 小涛 王 on 12-6-8.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "CommonRouteDetailController.h"
#import "TouristRoute.pb.h"
#import "PPNetworkRequest.h"
#import "ImageManager.h"
#import "RouteFeekbackController.h"
#import "PlaceOrderController.h"
#import "CommonWebController.h"

@interface CommonRouteDetailController ()

@property (assign, nonatomic) int routeId;
@property (assign, nonatomic) int routeType;
@property (retain, nonatomic) TouristRoute *route;

@property (retain, nonatomic) RouteIntroductionController *introductionController;
@property (retain, nonatomic) CommonWebController *feeController;

@property (retain, nonatomic) CommonWebController *bookingPolicyController;
@property (retain, nonatomic) CommonWebController *userFeekbackController;
@end

@implementation CommonRouteDetailController

@synthesize routeId = _routeId;
@synthesize routeType = _routeType;
@synthesize route = _route;

@synthesize introductionController = _introductionController;
@synthesize feeController = _feeController;
@synthesize bookingPolicyController = _bookingPolicyController;
@synthesize userFeekbackController = _userFeekbackController;

@synthesize introductionButton = _introductionButton;
@synthesize costDescriptionButton = _costDescriptionButton;
@synthesize bookingPolicyButton = _bookingPolicyButton;
@synthesize userFeekbackButton = _userFeekbackButton;
@synthesize buttonsHolderView = _buttonsHolderView;
@synthesize contentScrollView = _contentScrollView;


- (void)dealloc {
    [_route release];
    [_introductionController release];
    [_feeController release];
    
    [_introductionButton release];
    [_costDescriptionButton release];
    [_bookingPolicyButton release];
    [_userFeekbackButton release];
    
    [_buttonsHolderView release];
    [_contentScrollView release];
    [super dealloc];
}

- (id)initWithRouteId:(int)routeId routeType:(int)routeType
{
    if (self = [super init]) {
        self.routeId = routeId;
        self.routeType = routeType;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.buttonsHolderView.backgroundColor = [UIColor colorWithPatternImage:[[ImageManager defaultManager] lineNavBgImage]];
    
    [[RouteService defaultService] findRouteWithRouteId:_routeId viewController:self];
}

- (void)viewDidUnload
{
    [self setIntroductionButton:nil];
    [self setCostDescriptionButton:nil];
    [self setBookingPolicyButton:nil];
    [self setUserFeekbackButton:nil];
    [self setButtonsHolderView:nil];
    [self setContentScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)clickIntroductionButton:(id)sender {
    if (_introductionController == nil) {
        self.introductionController = [[[RouteIntroductionController alloc] initWithRoute:_route routeType:_routeType] autorelease];
        _introductionController.aDelegate = self;
    }
    
    [_introductionController showInView:self.contentScrollView];
}



- (IBAction)clickCostDecriptionButton:(id)sender {
    if (_feeController == nil) {
        self.feeController = [[[CommonWebController alloc] initWithWebUrl:_route.fee] autorelease];
    }
    
    [_feeController showInView:self.contentScrollView];    
}



- (IBAction)clickBookingPolicyButton:(id)sender {
    if (_bookingPolicyController == nil) {
        self.bookingPolicyController = [[[CommonWebController alloc] initWithWebUrl:_route.bookingNotice] autorelease];
    }
    
    [_bookingPolicyController showInView:self.contentScrollView];        
    
}




- (IBAction)clickUserFeekbackButton:(id)sender {
    RouteFeekbackController *controller = [[RouteFeekbackController alloc] initWithRouteId:_routeId];
[controller showInView:self.contentScrollView];   
//    [self.navigationController pushViewController:controller animated:YES];
//    [controller release];
       
}



- (void)findRequestDone:(int)result route:(TouristRoute *)route
{
    if (result != ERROR_SUCCESS) {
        [self popupMessage:@"网络弱，数据加载失败" title:nil];
        return;
    }
    
    self.route = route;
    
    [self clickIntroductionButton:nil];

}

- (void)didClickBookButton
{
    PlaceOrderController *controller = [[[PlaceOrderController alloc] initWithRoute:_route] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
    
    
}

@end
