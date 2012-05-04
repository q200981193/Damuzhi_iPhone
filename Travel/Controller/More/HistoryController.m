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

- (void)updateDeleteButton;

@end

@implementation HistoryController
@synthesize placeListHolderView;
@synthesize placeList = _placeList;
@synthesize placeListController;

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
                                                     superController:self
                                                      pullToRreflash:NO];
    
    [self.placeListController setAndReloadPlaceList:_placeList];
    [self updateDeleteButton];
}


- (void)viewDidUnload
{
    [self setPlaceListHolderView:nil];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
                                                    message:NSLS(@"确定要清空所有浏览记录")
                                                   delegate:self 
                                          cancelButtonTitle:NSLS(@"取消") otherButtonTitles:NSLS(@"确定"), nil];
    [alert show];
    [alert release];
}

#pragma -mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[PlaceStorage historyManager] deleteAllPlaces];
         self.placeList = [[PlaceStorage historyManager] allPlaces];
        [self.placeListController setAndReloadPlaceList:_placeList];
        [self updateDeleteButton];
    }
}

- (void)updateDeleteButton
{
    if ([_placeList count] == 0) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

@end
