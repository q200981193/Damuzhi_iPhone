//
//  MoreController.m
//  Travel
//
//  Created by 小涛 王 on 12-3-7.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "MoreController.h"
#import "LocaleUtils.h"
#import "HistoryController.h"
#import "AppDelegate.h"
#import "FeekbackController.h"

@interface MoreController ()

@end

@implementation MoreController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#define OPENED_CITY         NSLS(@"已开通城市")
#define BROWSE_HISTORY      NSLS(@"浏览记录")
#define FEEDBACK            NSLS(@"意见反馈")
#define VERSION_UPDATE      NSLS(@"版本更新")
#define ABOUT_APP           NSLS(@"关于大拇指旅行")
#define PRAISE              NSLS(@"给我一个好评吧")
#define SHOW_IMAGE_IN_LIST  NSLS(@"列表中显示图片")
#define APP_RECOMMENDATION  NSLS(@"精彩应用推荐")


- (void)viewDidLoad
{

    
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    self.dataList = [NSArray arrayWithObjects:
                     OPENED_CITY, 
                     BROWSE_HISTORY,
                     FEEDBACK,
                     VERSION_UPDATE,
                     ABOUT_APP,
                     PRAISE,
                     SHOW_IMAGE_IN_LIST,
                     APP_RECOMMENDATION,
                     nil];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0xDE green:0xE2 blue:0xE4 alpha:1]];
    
//    self.dataTableView.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark Table View Delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
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
    
    static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];				
		cell.selectionStyle = UITableViewCellSelectionStyleNone;		
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.imageView setImage:[UIImage imageNamed:@"more_icon.png"]];
	}
	
	// set text label
	int row = [indexPath row];	
	int count = [dataList count];
	if (row >= count){
		NSLog(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
		return cell;
	}
    
    if (row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    cell.textLabel.text = [dataList objectAtIndex:row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
	
	return cell;
}

- (void)showCityManagment
{
    CityManagementController *controller = [[CityManagementController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)showHistory
{
    HistoryController *hc = [[HistoryController alloc] init];
    hc.navigationItem.title = BROWSE_HISTORY;
    [self.navigationController pushViewController:hc animated:YES];
    [hc release];
}

- (void)showFeekback
{
    FeekbackController *controller = [[FeekbackController alloc] init];
    controller.navigationItem.title = FEEDBACK;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)queryVersion
{
    [[UserService defaultService] queryVersion:self];
}

#pragma -mark UserServiceDelegate
- (void)queryVersionFinish:(NSString *)version dataVersion:(NSString *)dataVersion
{
    if (version && dataVersion) {
        NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        if ([version isEqual:localVersion]) {
            [self popupHappyMessage:NSLS(@"isNewVersion") title:nil];
        }else {
            [UIUtils openApp:kAppId];
        }
    }
    else {
        [self popupUnhappyMessage:NSLS(@"查询版本失败") title:nil];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    switch (row) {
        case 0:
            [self showCityManagment];
            break;
        case 1:
            [self showHistory];
            break;
        case 2:
            [self showFeekback];
            break;
        case 3:
            [self queryVersion];
            break;
        default:
            break;
    }
    

}



@end
