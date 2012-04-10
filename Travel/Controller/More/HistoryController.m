//
//  HistoryController.m
//  Travel
//
//  Created by haodong qiu on 12年3月29日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "HistoryController.h"
#import "PlaceStorage.h"
#import "PlaceListController.h"

@interface HistoryController ()

@property (assign, nonatomic) BOOL canDelete;

@end

@implementation HistoryController
@synthesize placeListHolderView;
@synthesize placeList = _placeList;
@synthesize placeListController;
@synthesize canDelete;

- (void)dealloc {
    [placeListHolderView release];
    [_placeList release];
    [placeListController release];
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
    
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    [self setNavigationRightButton:NSLS(@"清空") 
                         imageName:@"topmenu_btn_right.png" 
                            action:@selector(clickDelete:)];
    
    self.placeList = [[PlaceStorage historyManager] allPlaces];
    self.placeListController = [PlaceListController createController:_placeList 
                                                           superView:placeListHolderView
                                                     superController:self];
    [self.placeListController setAndReloadPlaceList:self.placeList];
}

- (void)viewDidUnload
{
    [self setPlaceListHolderView:nil];
    [self setPlaceList:nil];
    [self setPlaceListController:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
        [button setTitle:NSLS(@"清空") forState:UIControlStateNormal];
    }
}

#pragma mark - DeletePlaceDelegate 
- (void)deletedPlace:(Place *)place
{
    PlaceStorage *manager = [PlaceStorage historyManager];
    [manager deletePlace:place];
    self.placeList = [manager allPlaces];
}


@end
