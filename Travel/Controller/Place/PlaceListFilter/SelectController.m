//
//  SelectController.m
//  Travel
//
//  Created by 小涛 王 on 12-3-13.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "SelectController.h"
#import "PPTableViewCell.h"
#import "PPDebug.h"
#import "AppManager.h"

@interface SelectController ()

@end

@implementation SelectController
@synthesize tableView;
@synthesize delegate;
@synthesize selectedList = _selectedList;
@synthesize multiOptions = _multiOptinos;

+ (SelectController*)createController:(NSArray*)list selectedList:(NSMutableArray*)selectedList multiOptions:(BOOL)multiOptions
{
    SelectController* controller = [[[SelectController alloc] init] autorelease];  
    
    controller.dataList = list;
    
    controller.selectedList = selectedList;
    
    controller.multiOptions = multiOptions;
    
    [controller viewDidLoad];
    return controller;
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
    // Do any additional setup after loading the view from its nib.
    [self setNavigationLeftButton:NSLS(@"返回") 
                        imageName:@"back.png"
                           action:@selector(clickFinish:)];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"select_bg_1.png"]]];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)dealloc {
    [tableView release];
    [_selectedList release];
    [super dealloc];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 37.2;
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
    
    
    int row = [indexPath row];	
	int count = [dataList count];
	if (row >= count){
		NSLog(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
		return nil;
	}
    
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellForCategory"] autorelease];
    
    [[cell textLabel] setText:[self.dataList objectAtIndex:row]];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    if (NSNotFound!=[self.selectedList indexOfObject:[NSNumber numberWithInt:row]]) {
        //cell.accessoryType = UITableViewCellAccessoryCheckmark;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 10, 32, 32)];
        [imageView setImage:[UIImage imageNamed:@"select_btn_1"]];
        cell.accessoryView = imageView;
        [imageView release];
    }else {
        //cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = nil;
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;	
}

- (void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *row = [NSNumber numberWithInt:[indexPath row]];
    
    if(self.multiOptions == YES){
        if(NSNotFound == [self.selectedList indexOfObject:row])
        {
            [self.selectedList addObject:row];
        }
        else {
            [self.selectedList removeObject:row];
        }
        
        [tableView1 reloadData];
    }
    else{
        [self.selectedList removeAllObjects];
        [self.selectedList addObject:row];
        
        [tableView1 reloadData];
    }
}

- (void)clickFinish:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [delegate didSelectFinish:self.selectedList];
}

@end
