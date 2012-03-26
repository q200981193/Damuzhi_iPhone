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
#import "PackageManager.h"

@interface CityManagementController ()

- (void)showCityList;

@end

@implementation CityManagementController

@synthesize downloadList = _downloadList;

@synthesize promptLabel = _promptLabel;
@synthesize downloadTableView = _downloadTableView;
@synthesize timer = _timer;
@synthesize cityListBtn = _cityListBtn;
@synthesize downloadListBtn = _downloadListBtn;

- (void)dealloc {
    [_downloadTableView release];
    [_downloadList release];
    [_tipsLabel release];
    [_promptLabel release];
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
    
    self.cityListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cityListBtn.frame = CGRectMake(0, 0, 80, 30);
    
    self.downloadListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _downloadListBtn.frame = CGRectMake(80, 0, 80, 30);
       
    
    [_cityListBtn setTitle:@"城市列表" forState:UIControlStateNormal];
    _cityListBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_cityListBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_cityListBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    [_cityListBtn setBackgroundImage:[UIImage imageNamed:IMAGE_CITY_LEFT_BTN_OFF] forState:UIControlStateNormal];
    [_cityListBtn setBackgroundImage:[UIImage imageNamed:IMAGE_CITY_LEFT_BTN_ON] forState:UIControlStateSelected];
    

    [_downloadListBtn setTitle:@"下载管理" forState:UIControlStateNormal];
    _downloadListBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_downloadListBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];    
    [_downloadListBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_downloadListBtn setBackgroundImage:[UIImage imageNamed:IMAGE_CITY_RIGHT_BTN_OFF] forState:UIControlStateNormal];
    [_downloadListBtn setBackgroundImage:[UIImage imageNamed:IMAGE_CITY_RIGHT_BTN_ON] forState:UIControlStateSelected];
    
    [_cityListBtn addTarget:self action:@selector(clickCityListButton:) forControlEvents:UIControlEventTouchUpInside];
    [_downloadListBtn addTarget:self action:@selector(clickDownloadButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonView addSubview:_cityListBtn];
    [buttonView addSubview:_downloadListBtn];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:buttonView];
    [buttonView release];
    
    self.navigationItem.rightBarButtonItem = barButton;
    [barButton release];
}

- (void)viewDidLoad
{
    //self.dataList = [[AppManager defaultManager] getCityList];
    self.dataList = [[PackageManager defaultManager] getLocalCityList];
    self.downloadList = [[PackageManager defaultManager] getOnlineCityList];

    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    [self.promptLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:IMAGE_CITY_MAIN_BOTTOM]]];
    
    [self setCityManageButtons];
    [self showCityList];
    self.dataTableView.backgroundColor = [UIColor whiteColor];
    
    // start timer to update progress, timer 
}

- (void)viewDidUnload
{
    [self setTipsLabel:nil];
    [self setPromptLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark Table View Delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;		// default implementation
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.downloadTableView) {
        return [_downloadList count];
    }
    else{
        return [dataList count];			// default implementation
    }
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
        int count = [_downloadList count];
        if (row >= count){
            PPDebug(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
            return cell;
        }
        DownloadListCell* downloadCell = (DownloadListCell*)cell;
        [downloadCell setCellData:[self.downloadList objectAtIndex:row]];
        downloadCell.indexPath = indexPath;
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
        [cityCell setCellData:[self.dataList objectAtIndex:row]];
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

- (void)clickCityListButton:(id)sender
{
    [self showCityList];
    _downloadListBtn.selected = NO;
    _cityListBtn.selected = YES;
    
    
    //PPDebug(@"click left button");
}

- (void)clickDownloadButton:(id)sender
{
    [self showDownloadList];
    _downloadListBtn.selected = YES;
    _cityListBtn.selected = NO;

    //PPDebug(@"click right button");
}

- (void)handleTimer
{
    [self.downloadTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{    
    if (self.timer != nil){
        [self.timer invalidate];
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [timer invalidate];
    self.timer = nil;
    
    [super viewDidDisappear:animated];
}


@end
