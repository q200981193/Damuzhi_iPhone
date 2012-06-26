//
//  PlaceOrderController.m
//  Travel
//
//  Created by 小涛 王 on 12-6-25.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PlaceOrderController.h"
#import "NSDate+TKCategory.h"
#import "TKCalendarMonthView.h"
#import "AppManager.h"
#import "TimeUtils.h"

@interface PlaceOrderController ()

@property (retain, nonatomic) TouristRoute *route;
@property (retain, nonatomic) MonthViewController *monthViewController;

@end

@implementation PlaceOrderController
@synthesize routeNameLabel = _routeNameLabel;
@synthesize routeIdLabel = _routeIdLabel;
@synthesize departCityLabel = _departCityLabel;
@synthesize departDateButton = _departDateButton;
@synthesize priceLabel = _priceLabel;
@synthesize route = _route;
@synthesize monthViewController = _monthViewController;

- (void)dealloc
{
    [_route release];
    [_monthViewController release];
    
    [_routeNameLabel release];
    [_routeIdLabel release];
    [_departCityLabel release];
    [_priceLabel release];
    [_departDateButton release];
    [super dealloc];
}

- (id)initWithRoute:(TouristRoute *)route
{
    if (self = [super init]) {
        self.route = route;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.routeNameLabel.text = _route.name;
    self.routeIdLabel.text = [NSString stringWithFormat:@"%d", _route.routeId];
    self.departCityLabel.text = [[AppManager defaultManager] getDepartCityName:_route.departCityId];
    self.priceLabel.text = _route.price;
}

- (void)viewDidUnload
{
    [self setRouteNameLabel:nil];
    [self setRouteIdLabel:nil];
    [self setDepartCityLabel:nil];
    [self setPriceLabel:nil];
    [self setDepartDateButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)clickDepartDateButton:(id)sender {
    self.monthViewController = [[[MonthViewController alloc] initWithBookings:_route.bookingsList] autorelease];
    _monthViewController.aDelegate = self;
    [self.navigationController pushViewController:_monthViewController animated:YES];
}

- (IBAction)clickAdultButton:(id)sender {
}

- (IBAction)clickChildrenButton:(id)sender {
}

- (IBAction)clickMemberBookButton:(id)sender {
}

- (IBAction)clickNonMemberBookButton:(id)sender {
    
}

- (void)didSelecteDate:(NSDate *)date
{
    [self.departDateButton setTitle:dateToChineseString(date) forState:UIControlStateNormal];
    
    [_monthViewController.navigationController popViewControllerAnimated:YES];
}


@end
