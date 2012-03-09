//
//  CityManagementController.m
//  Travel
//
//  Created by 小涛 王 on 12-3-7.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "CityManagementController.h"
#import "AppManager.h"
#import "App.pb.h"
#import "CityListCell.h"
#import "DownloadListCell.h"
#import "LogUtil.h"

@interface CityManagementController ()

- (void)showCityList;

@end

@implementation CityManagementController

@synthesize downloadList = _downloadList;
@synthesize downloadTableView = _downloadTableView;

- (void)dealloc {
    [_downloadTableView release];
    [_downloadList release];
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

-(void)setTwoButtonsInNavBar
{
    
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButton.frame = CGRectMake(0, 0, 100, 30);
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightButton.frame = CGRectMake(100, 0, 100, 30);
    
    //[leftButton setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    
    [leftButton setTitle:@"城市列表" forState:UIControlStateNormal];
    [rightButton setTitle:@"下载管理" forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonView addSubview:rightButton];
    [buttonView addSubview:leftButton];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:buttonView];
    [buttonView release];
    
    self.navigationItem.rightBarButtonItem= barButton;
    //self.navigationItem.title = @"hello";
    
    [barButton release];
}

- (void)viewDidLoad
{
    self.dataList = [[AppManager defaultManager] getCityList];
    self.downloadList = [[AppManager defaultManager] getCityList];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTwoButtonsInNavBar];
    [self showCityList];
    self.dataTableView.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark Table View Delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 61;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;		// default implementation
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [dataList count];			// default implementation
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    if (theTableView == self.downloadTableView) {
  //    if (0) {
        cell = [theTableView dequeueReusableCellWithIdentifier:[DownloadListCell getCellIdentifier]];
        
        if (cell == nil) {
            cell = [DownloadListCell createCell:self];				
            cell.selectionStyle = UITableViewCellSelectionStyleNone;				        
        }
        
        // set text label
        int row = [indexPath row];	
        int count = [dataList count];
        if (row >= count){
            PPDebug(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
            return cell;
        }
        DownloadListCell* downloadCell = (DownloadListCell*)cell;
        City *city = [self.downloadList objectAtIndex:row];
        //cityCell.textLabel.text = city.cityName;
        downloadCell.cityNameLable.text = city.cityName;
        //downloadCell.downloadProgressView.hidden = YES;
        //PPDebug(@"cityname = %@", city.cityName);
        
    }
    else {
        cell = [theTableView dequeueReusableCellWithIdentifier:[CityListCell getCellIdentifier]];
        
        if (cell == nil) {
            cell = [CityListCell createCell:self];				
            cell.selectionStyle = UITableViewCellSelectionStyleNone;				        
        }
        
        // set text label
        int row = [indexPath row];	
        int count = [dataList count];
        if (row >= count){
            PPDebug(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
            return cell;
        }
        CityListCell* cityCell = (CityListCell*)cell;
        City *city = [dataList objectAtIndex:row];
        //cityCell.textLabel.text = city.cityName;
        cityCell.cityNameLable.text = city.cityName;
        PPDebug(@"cityname = %@", city.cityName);
    }

	return cell;
}

- (void)showCityList
{
    self.dataTableView.hidden = NO;
    self.downloadTableView.hidden = YES;
}

- (void)showDownloadList
{
    self.dataTableView.hidden = YES;
    self.downloadTableView.hidden = NO;
    
}

- (void)clickLeftButton
{

    [self showCityList];
    
    PPDebug(@"click left button");
}

- (void)clickRightButton
{
    [self showDownloadList];

    PPDebug(@"click right button");
}


@end
