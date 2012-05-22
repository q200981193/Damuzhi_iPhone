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
#import "PlaceUtils.h"

@interface SelectController ()

@end

@implementation SelectController
@synthesize tableView;
@synthesize delegate;
@synthesize type = _type;
@synthesize selectedIds = _selectedIds;
@synthesize beforeSelectedIds = _beforeSelectedIds;
@synthesize multiOptions = _multiOptinos;
@synthesize needConfirm = _needConfirm;
@synthesize placeList = _placeList;
@synthesize allItems = _allItems;
@synthesize meaningfulItems = _meaningfulItems;

- (void)dealloc {
    [tableView release];
    [_selectedIds release];
    [_beforeSelectedIds release];
    [_placeList release];
    [_allItems release];
    [_meaningfulItems release];
    [super dealloc];
}

+ (SelectController*)createController:(NSArray*)list selectedIds:(NSMutableArray*)selectedIds multiOptions:(BOOL)multiOptions needConfirm:(BOOL)needConfirm type:(int)type
{
    SelectController* controller = [[[SelectController alloc] init] autorelease];  
    
    controller.type = type;
    
    controller.allItems = list;
    
    controller.beforeSelectedIds = selectedIds;

    controller.selectedIds = [NSMutableArray arrayWithArray:selectedIds];
    
    controller.multiOptions = multiOptions;
    
    controller.needConfirm = needConfirm;
        
    return controller;
}

- (void)setAndReload:(NSArray*)placeList
{
    self.placeList = placeList;

    if (_type == TYPE_SUBCATEGORY || _type == TYPE_PROVIDED_SERVICE || _type == TYPE_AREA) {
        [self setMeaningfulItemsAccordingToPlaceList];
    }else {
        self.meaningfulItems = _allItems;
    }
    
    [tableView reloadData];
}

- (void)setMeaningfulItemsAccordingToPlaceList
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in _allItems) {
        int typeId =  [[[dic allKeys] objectAtIndex:0] intValue];
        int count = [PlaceUtils getPlacesCountInSameType:_type typeId:typeId  placeList:_placeList];
        if (count != 0) {
            [array addObject:dic];
        }
    }
    
    self.meaningfulItems = array;
    [array release];
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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 36;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_meaningfulItems count];			// default implementation
}

- (void)setCellTextLabel:(UITableViewCell*)cell typeId:(int)typeId typeName:(NSString*)name
{
    NSString *text = nil;
    switch (_type) {
        case TYPE_SUBCATEGORY:
        case TYPE_PROVIDED_SERVICE:
        case TYPE_AREA:
            text = [name stringByAppendingFormat:@" (%d)", [PlaceUtils getPlacesCountInSameType:_type typeId:typeId placeList:_placeList]];
            break;
            
        default:
            text = name;
            break;
    }
    
    [[cell textLabel] setText:text];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    int row = [indexPath row];	
	int count = [_meaningfulItems count];
	if (row >= count){
		PPDebug(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
		return nil;
	}
    
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellForCategory"] autorelease];
    
    NSString *currentName = [[[_meaningfulItems objectAtIndex:row] allValues] objectAtIndex:0];
    NSNumber *currentId = [[[_meaningfulItems objectAtIndex:row] allKeys] objectAtIndex:0];
    
//    [[cell textLabel] setText:currentName];
    [self setCellTextLabel:cell typeId:[currentId intValue] typeName:currentName];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    if ([_selectedIds containsObject:currentId]) {
        [cell.imageView setImage:[self getSelectedImage]];
        cell.backgroundView = [self getBackgoundImageView:row];
        if (!_multiOptinos) {
            cell.accessoryView =[self getCheckedImageView];
        }
    }else 
    {
        [cell.imageView setImage:[self getUnselectedImage]];
        cell.accessoryView = nil;
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
    else if(row == [_meaningfulItems count]-1){
        [view setImage:[UIImage imageNamed:@"select_bg_down.png"]];
    }
    else {
        [view setImage:[UIImage strectchableImageName:@"select_bg_center.png"]];
    }
    
    return view;
}

- (UIImage*)getUnselectedImage
{
    return _multiOptinos ? [UIImage imageNamed:@"no_s.png"] : [UIImage imageNamed:@"radio_1.png"];
}

- (UIImage*)getSelectedImage
{
    return _multiOptinos ? [UIImage imageNamed:@"yes_s.png"] : [UIImage imageNamed:@"radio_2.png"];
}

- (void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *selectedDictionary = [_meaningfulItems objectAtIndex:indexPath.row];
    NSNumber *currentSelectedId = [[selectedDictionary allKeys] objectAtIndex:0];

    if(self.multiOptions == YES){
//        BOOL found = NO;
//        for(NSNumber *selectedId in self.selectedIds)
//        {
//            if ([currentSelectedId intValue] == [selectedId intValue]) {
//                found = YES;
//                break;
//            }
//        }
//        
//        if(!found)
        if (![_selectedIds containsObject:currentSelectedId])
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
        
        if (delegate && [delegate respondsToSelector:@selector(didSelectFinish:)]) {
            [delegate didSelectFinish:self.selectedIds];
        }
        else {
            PPDebug(@"[delegate respondsToSelector:@selector(didSelectFinish:)]");
        }
    }
}


@end
