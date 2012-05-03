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
#import "CommonPlace.h"
#import "UIImageUtil.h"

@interface SelectController ()

@end

@implementation SelectController
@synthesize tableView;
@synthesize delegate;
@synthesize selectedIds = _selectedIds;
@synthesize beforeSelectedIds = _beforeSelectedIds;
@synthesize multiOptions = _multiOptinos;
@synthesize needConfirm = _needConfirm;

+ (SelectController*)createController:(NSArray*)list selectedIds:(NSMutableArray*)selectedIds multiOptions:(BOOL)multiOptions needConfirm:(BOOL)needConfirm
{
    SelectController* controller = [[[SelectController alloc] init] autorelease];  
    
    controller.dataList = list;
    
    controller.beforeSelectedIds = selectedIds;

    controller.selectedIds = [NSMutableArray arrayWithArray:selectedIds];
    
    controller.multiOptions = multiOptions;
    
    controller.needConfirm = needConfirm;
    
//    [controller viewDidLoad];
    
    return controller;
}

- (void)viewDidLoad
{        
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    if (_needConfirm) {
        [self setNavigationRightButton:NSLS(@"确定") 
                             imageName:@"topmenu_btn_right.png" 
                                action:@selector(clickFinish:)];
    }
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"all_page_bg2.jpg"]]];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [tableView release];
    [_selectedIds release];
    [_beforeSelectedIds release];
    [super dealloc];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 36;
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
    
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellForCategory"] autorelease];
    
    NSString *currentName = [[[self.dataList objectAtIndex:row] allValues] objectAtIndex:0];
    NSNumber *currentId = [[[self.dataList objectAtIndex:row] allKeys] objectAtIndex:0];
    
    [[cell textLabel] setText:currentName];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    BOOL found = NO;
    for(NSNumber *selectedId in self.selectedIds)
    {
        if ([currentId intValue] == [selectedId intValue]) {
            found = YES;
            break;
        }
    }
    
    if (!found) {
        [cell.imageView setImage:[self getUnselectedImage]];
        cell.accessoryView = nil;
    }else 
    {
        [cell.imageView setImage:[self getSelectedImage]];
        cell.backgroundView = [self getBackgoundImageView:row];
        if (!_multiOptinos) {
            cell.accessoryView =[self getCheckedImageView];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;	
}

- (UIImageView*)getCheckedImageView
{
    CGRect rect = CGRectMake(0, 0, 36, 36);
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:rect] autorelease];
    [imageView setImage:[UIImage imageNamed:@"select_btn_1.png"]];
    
    return  imageView;
}

- (UIView*)getBackgoundImageView:(int)row
{
    UIImageView *view = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 20)] autorelease];
  
    if (row == 0) {
        [view setImage:[UIImage imageNamed:@"select_bg_top.png"]];
    }
    else if(row == [dataList count]-1){
        [view setImage:[UIImage imageNamed:@"select_bg_down.png"]];
    }
    else {
        [view setImage:[UIImage strectchableImageName:@"select_bg_center.png"]];
    }
    
    return view;
}

- (UIImage*)getUnselectedImage
{
    if (_multiOptinos) {
        return [UIImage imageNamed:@"no_s.png"];
    }
    else {
        return [UIImage imageNamed:@"radio_1.png"];
    }
}

- (UIImage*)getSelectedImage
{
    if (_multiOptinos) {
        return [UIImage imageNamed:@"yes_s.png"];
    }
    else {
        return [UIImage imageNamed:@"radio_2.png"];
    }
}

- (void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *selectedDictionary = [self.dataList objectAtIndex:indexPath.row];
    NSNumber *currentSelectedId = [[selectedDictionary allKeys] objectAtIndex:0];

    if(self.multiOptions == YES){
        BOOL found = NO;
        for(NSNumber *selectedId in self.selectedIds)
        {
            if ([currentSelectedId intValue] == [selectedId intValue]) {
                found = YES;
                break;
            }
        }
        
        if(!found)
        {
            if([currentSelectedId intValue] == ALL_CATEGORY)
            {
                [self.selectedIds removeAllObjects];
            }
            for (NSNumber *selectedId in self.selectedIds) {
                if ([selectedId intValue]== ALL_CATEGORY) {
                    [self.selectedIds removeObject:selectedId];
                }
            }
            
            [self.selectedIds addObject:currentSelectedId];
        }
        else {
            [self.selectedIds removeObject:currentSelectedId];
        }
        
        [tableView1 reloadData];
    }
    else{
        [self.selectedIds removeAllObjects];
        [self.selectedIds addObject:currentSelectedId];
        
        [tableView1 reloadData];
    }
    
    if (!_needConfirm) {
        
        [_beforeSelectedIds removeAllObjects];
        for (NSNumber *selectId in _selectedIds) {
            [_beforeSelectedIds addObject:selectId];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        if (delegate && [delegate respondsToSelector:@selector(didSelectFinish:)]) {
            [delegate didSelectFinish:self.selectedIds];
        }
        else {
            PPDebug(@"[delegate respondsToSelector:@selector(didSelectFinish:)]");
        }
    }
}

- (void)clickFinish:(id)sender
{
    if ([self.selectedIds count] == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLS(@"温馨提示") message:NSLS(@"亲，您还没有选择哦！") delegate:nil cancelButtonTitle:NSLS(@"好的") otherButtonTitles:nil];
        
        [alert show];
        [alert release];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
        
        [_beforeSelectedIds removeAllObjects];
        for (NSNumber *selectId in _selectedIds) {
            [_beforeSelectedIds addObject:selectId];
        }
        
        [delegate didSelectFinish:self.selectedIds];
    }
}


@end
