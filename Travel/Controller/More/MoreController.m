//
//  MoreController.m
//  Travel
//
//  Created by 小涛 王 on 12-3-7.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "MoreController.h"
#import "LocaleUtils.h"
#import "CityManagementController.h"

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

- (void)viewDidLoad
{
    self.dataList = [NSArray arrayWithObjects:
                     NSLS(@"已开通城市"), 
                     NSLS(@"浏览记录"),
                     NSLS(@"意见反馈"),
                     NSLS(@"版本更新"),
                     NSLS(@"关于大拇指旅行"),
                     NSLS(@"给我一个好评吧"),
                     NSLS(@"列表中显示图片"),
                     NSLS(@"精彩应用推荐"),
                     nil];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    
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
	}
	
	// set text label
	int row = [indexPath row];	
	int count = [dataList count];
	if (row >= count){
		NSLog(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
		return cell;
	}
    
    cell.textLabel.text = [dataList objectAtIndex:row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.imageView.image = [UIImage imageNamed:@"pageStateNormal.jpg"];
	
	return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CityManagementController* controller = [[CityManagementController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

@end
