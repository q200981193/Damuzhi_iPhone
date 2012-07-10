//
//  SelectCityController.m
//  Travel
//
//  Created by haodong qiu on 12年7月7日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "SelectCityController.h"
#import "Item.h"


@interface SelectCityController ()

@property (retain, nonatomic) NSArray *allDataList;
@property (assign, nonatomic) id<SelectCityDelegate> delegate;

@property (retain, nonatomic) NSMutableArray *selectedItemIds;
@property (retain, nonatomic) NSMutableArray *selectedItemIdsBeforConfirm;

@end

@implementation SelectCityController
@synthesize searchBar = _searchBar;
@synthesize delegate = _delegate;
@synthesize allDataList = _allDataList;
@synthesize selectedItemIds = _selectedItemIds;
@synthesize selectedItemIdsBeforConfirm = _selectedItemIdsBeforConfirm;

- (void)dealloc
{
    PPRelease(_allDataList);
    PPRelease(_searchBar);
    PPRelease(_selectedItemIds);
    [super dealloc];
}

- (id)initWithAllItemList:(NSArray *)itemsList 
         selectedItemList:(NSMutableArray *)selectedItemIds 
                 delegate:(id<SelectCityDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.allDataList = itemsList;
        self.dataList = itemsList;
        self.selectedItemIds = selectedItemIds;
        self.selectedItemIdsBeforConfirm = [NSMutableArray arrayWithArray:selectedItemIds];
        self.delegate = delegate;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    self.navigationItem.title = NSLS(@"出发城市");
    
    [self setNavigationRightButton:NSLS(@"确定") 
                         imageName:@"topmenu_btn_right.png" 
                            action:@selector(clickSubmit:)];
    
    dataTableView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [super viewDidUnload];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return [NSArray arrayWithObjects:@"A", @"B", @"C", @"D",@"E", @"F",@"G", @"H",nil];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"SelectCityControllerCell";
    UITableViewCell *cell = [dataTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    Item *item = [dataList objectAtIndex:indexPath.row];
    cell.textLabel.text = item.itemName;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    
    BOOL found = NO;
    for (NSNumber *findItemId in self.selectedItemIdsBeforConfirm) {
        if ([findItemId intValue] == item.itemId) {
            found = YES;
            break;
        }
    }
    if (found) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Item *item = [dataList objectAtIndex:indexPath.row];
    
    BOOL found = NO;
    NSNumber *findItemId;
    for (findItemId in self.selectedItemIdsBeforConfirm) {
        if ([findItemId intValue] == item.itemId) {
            found = YES;
            break;
        }
    }
    
    if (found) {
        [_selectedItemIdsBeforConfirm removeObject:findItemId];
    } else {
        [_selectedItemIdsBeforConfirm addObject:[NSNumber numberWithInt:item.itemId]];
    }
    
    [dataTableView reloadData];
    
//    if (_delegate && [_delegate respondsToSelector:@selector(didSelectCity:)]) {
//        [_delegate didSelectCity:item];
//    }
    
    //[self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

//根据关键字查询,更新表视图
- (void)update:(NSString *)keyword
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(Item *item in self.allDataList){
        int i=[item.itemName rangeOfString:keyword].location;
        if(i<item.itemName.length){
            [array addObject:item];
        }
    }
    
    self.dataList = array;
    if(keyword.length==0){
        self.dataList = _allDataList;
    }
    [array release];
    [dataTableView reloadData];
}

#pragma mark - searchbar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar; 
{
    [self.searchBar setShowsCancelButton:YES animated:YES];
    
    [self updateHideKeyboardButton];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self updateHideKeyboardButton];
    [self update:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self updateHideKeyboardButton];
    [self update:searchBar.text];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:NO animated:YES];
}


#pragma mark - custom methods
- (void)clickSubmit:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectCity:)]) {
        
        [_selectedItemIds removeAllObjects];
        for (NSNumber *itemId in _selectedItemIdsBeforConfirm) {
            [_selectedItemIds addObject:itemId];
        }
        
        [_delegate didSelectCity:_selectedItemIds];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)updateHideKeyboardButton
{
    if ([self.searchBar.text length] == 0) {
         [self addHideKeyboardButton];
    } else {
        [self removeHideKeyboardButton];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self clickHideKeyboardButton:nil];
}

#define HIDE_KEYBOARDBUTTON_TAG 77
- (void)removeHideKeyboardButton
{
    UIButton *button = (UIButton*)[self.view viewWithTag:HIDE_KEYBOARDBUTTON_TAG];
    [button removeFromSuperview];
}

- (void)addHideKeyboardButton
{
    [self removeHideKeyboardButton];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, self.searchBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.searchBar.frame.size.height)];
    button.backgroundColor = [UIColor blackColor];
    button.alpha = 0.5;
    button.tag = HIDE_KEYBOARDBUTTON_TAG;
    [button addTarget:self action:@selector(clickHideKeyboardButton:) forControlEvents:UIControlEventAllTouchEvents];
    [self.view addSubview:button];
    [button release];
}

- (void)clickHideKeyboardButton:(id)sender
{
    [self.searchBar resignFirstResponder];
    [self removeHideKeyboardButton];
}

@end
