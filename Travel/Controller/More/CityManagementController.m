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
#import "ImageName.h"

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

-(void)setCityManageButtons
{
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 180, 30)];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 80, 30);
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(80, 0, 80, 30);
        
    [leftButton setTitle:@"城市列表" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    leftButton.tintColor = [UIColor blackColor];
    [leftButton setBackgroundImage:[UIImage imageNamed:IMAGE_CITY_LEFT_BTN_OFF] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:IMAGE_CITY_LEFT_BTN_ON] forState:UIControlStateHighlighted];
    
    [rightButton setTitle:@"下载管理" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    rightButton.tintColor = [UIColor blackColor];
    [rightButton setBackgroundImage:[UIImage imageNamed:IMAGE_CITY_RIGHT_BTN_OFF] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:IMAGE_CITY_RIGHT_BTN_ON] forState:UIControlStateHighlighted];
    
    [leftButton addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonView addSubview:rightButton];
    [buttonView addSubview:leftButton];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:buttonView];
    [buttonView release];
    
    self.navigationItem.rightBarButtonItem= barButton;
    [barButton release];
}

- (void)viewDidLoad
{
    self.dataList = [[[AppManager defaultManager] app] cityListList];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setCityManageButtons];
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
        downloadCell.cityNameLable.text = city.cityName;
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
        cityCell.cityNameLable.text = city.cityName;
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
    
    //PPDebug(@"click left button");
}

- (void)clickRightButton
{
    [self showDownloadList];

    //PPDebug(@"click right button");
}


@end
