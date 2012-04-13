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
#import "LogUtil.h"
#import "ImageName.h"
#import "PackageManager.h"
#import "AppUtils.h"

@implementation CityManagementController 

static CityManagementController *_instance;

@synthesize downloadList = _downloadList;
@synthesize promptLabel = _promptLabel;
@synthesize downloadTableView = _downloadTableView;
@synthesize timer = _timer;
@synthesize cityListBtn = _cityListBtn;
@synthesize downloadListBtn = _downloadListBtn;


+ (CityManagementController*)getInstance
{
    if (_instance == nil) {
        _instance = [[CityManagementController alloc] init];
    }
    
    return _instance;
}

- (void)dealloc {
    [_downloadTableView release];
    [_downloadList release];
    [_tipsLabel release];
    [_promptLabel release];
    [_timer release];
    [_cityListBtn release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [self setBackgroundImageName:IMAGE_CITY_MAIN_BOTTOM];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.dataList = [[AppManager defaultManager] getCityList];
    self.downloadList = [[PackageManager defaultManager] getLocalCityList];
    
    UIColor *color = [[UIColor alloc] initWithRed:121.0/255.0 green:164.0/255.0 blue:180.0/255.0 alpha:1]; 
    [self.promptLabel setBackgroundColor:color];
    [color release];
    
    [self addCityManageButtons];
    
    // Set buttons status.
    _downloadListBtn.selected = NO;
    _cityListBtn.selected = YES;
    
    // Show city list table view.
    self.dataTableView.hidden = NO;
    self.downloadTableView.hidden = YES;
        
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:IMAGE_NAVIGATIONBAR_BACK_BTN
                           action:@selector(clickBack:)];
    [[AppService defaultService] setAppServiceDelegate:self];
} 

- (void)viewDidUnload
{
    // Release any retained subviews of the main view
    // e.g. self.myOutlet = nil;
    [self setTipsLabel:nil];
    [self setPromptLabel:nil];
    
    [super viewDidUnload];
}

-(void)addCityManageButtons
{
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 180, 30)];
    
    // set position of the two button
    self.cityListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cityListBtn.frame = CGRectMake(0, 0, 80, 30);
    
    self.downloadListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _downloadListBtn.frame = CGRectMake(80, 0, 80, 30);
    
    // Customize the appearance 
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
    
    // Add target to the two buttons
    [_downloadListBtn addTarget:self action:@selector(clickDownloadListButton:) forControlEvents:UIControlEventTouchUpInside];
    [_cityListBtn addTarget:self action:@selector(clickCityListButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonView addSubview:_cityListBtn];
    [buttonView addSubview:_downloadListBtn];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:buttonView];
    [buttonView release];
    
    self.navigationItem.rightBarButtonItem = barButton;
    [barButton release];
}


#pragma mark - 
#pragma mark: Table View Delegate
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
            
            // Customize the appearance of table view cells at first time
            UIImageView *view = [[UIImageView alloc] init];
            [view setImage:[UIImage imageNamed:IMAGE_CITY_CELL_BG]];
            [cell setBackgroundView:view];
            [view release];
        }
        
        int row = [indexPath row];	
        int count = [_downloadList count];
        if (row >= count){
            PPDebug(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
            return cell;
        }
        DownloadListCell* downloadCell = (DownloadListCell*)cell;
        [downloadCell setCellData:[self.downloadList objectAtIndex:row]];
        downloadCell.downloadListCellDelegate = self;
    }
    else {
        cell = [theTableView dequeueReusableCellWithIdentifier:[CityListCell getCellIdentifier]];
        
        if (cell == nil) {
            cell = [CityListCell createCell:self];				
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            // Customize the appearance of table view cells at first time
            UIImageView *view = [[UIImageView alloc] init];
            [view setImage:[UIImage imageNamed:IMAGE_CITY_CELL_BG]];
            [cell setBackgroundView:view];
            [view release];
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
        cityCell.cityListCellDelegate = self;
    }

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.dataTableView) {
        City *city = [self.dataList objectAtIndex:indexPath.row];
        if ([AppUtils hasLocalCityData:city.cityId]) {
            [[AppManager defaultManager] setCurrentCityId:city.cityId];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

#pragma mark -
#pragma mark: implementation of buttons event
- (void)clickCityListButton:(id)sender
{
    // Set buttons status.
    _downloadListBtn.selected = NO;
    _cityListBtn.selected = YES;
    
    // Show city list table view.
    self.dataTableView.hidden = NO;
    self.downloadTableView.hidden = YES;
    
    // reload city list table view
    [self.dataTableView reloadData];
}

- (void)clickDownloadListButton:(id)sender
{
    // Set buttons status.
    _downloadListBtn.selected = YES;
    _cityListBtn.selected = NO;
    
    // Show download management table view.
    self.dataTableView.hidden = YES;
    self.downloadTableView.hidden = NO;
    
    // load downloadList and reload download table view
    self.downloadList = [[PackageManager defaultManager] getLocalCityList];
    [self.downloadTableView reloadData];
}

#pragma mark -
#pragma mark: implementation of Timer
- (void)createTimer
{
    if (self.timer != nil){
        [self.timer invalidate];
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                  target: self
                                                selector: @selector(handleTimer)
                                                userInfo: nil
                                                 repeats: YES];
}

- (void)killTimer
{
    [timer invalidate];
    self.timer = nil;
}

- (void)handleTimer
{
    [self.dataTableView reloadData];
}

#pragma mark -
#pragma mark: implementation of CityListCellDelegate
- (void)didSelectCurrendCity:(City*)city
{
    NSString *message = [NSString stringWithFormat:NSLS(@"您已把%@.%@设为默认访问城市!"), city.cityName, city.countryName];
    [self popupMessage:message title:NSLS(@"提示")];
    [self.dataTableView reloadData];
}

- (void)didStartDownload:(City*)city
{
    [self createTimer];
}

- (void)didCancelDownload:(City*)city
{
    [self killTimer];
}

- (void)didPauseDownload:(City*)city
{
    [self killTimer];
}

#pragma mark -
#pragma mark: implementation of DownloadListCellDelegate
- (void)didDeleteCity:(City*)city
{
    self.downloadList = [[PackageManager defaultManager] getLocalCityList];
    [self.downloadTableView reloadData];
}

- (void)didUpdateCity:(City*)city
{
    // TODO: 
//    [self.dataTableView reloadData];
}

#pragma mark -
#pragma mark: implementation of AppServiceDelegate
- (void)didFailDownload:(City*)city error:(NSError *)error;
{
    [self killTimer];

    PPDebug(@"down load failed, error = %@", error.description);
    NSString *message = [NSString stringWithFormat:NSLS(@"%@.%@城市数据下载失败"), city.countryName, city.cityName];
    [self popupMessage:message title:nil];
    [self.dataTableView reloadData];
}

- (void)didFinishDownload:(City*) city
{
    [self killTimer];

    NSString *message = [NSString stringWithFormat:NSLS(@"%@.%@城市数据下载成功"), city.countryName, city.cityName];
    [self popupMessage:message title:nil];
    [self.dataTableView reloadData];
}

@end
