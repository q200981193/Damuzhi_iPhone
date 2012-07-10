//
//  RouteSelectController.m
//  Travel
//
//  Created by 小涛 王 on 12-7-9.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "RouteSelectController.h"
#import "TravelNetworkConstants.h"
#import "AppManager.h"
#import "RouteSelectCell.h"

#define SECTION_TITLE_PRICE_RANK NSLS(@"价格区间")
#define SECTION_TITLE_DAYS_RANGE NSLS(@"出行天数")
#define SECTION_TITLE_ROUTE_THEME NSLS(@"路线主题")

@interface RouteSelectController ()

@property (assign, nonatomic) int routeType;
@property (retain, nonatomic) NSMutableDictionary *sectionTitleDic;
@property (retain, nonatomic) NSDictionary *itemListInfoDic;
@property (retain, nonatomic) NSDictionary *selectedItemListInfoDic;

@property (retain, nonatomic) RouteSelectedItemIds *selectedItemIds;

@end

@implementation RouteSelectController

@synthesize routeType = _routeType;
@synthesize sectionTitleDic = _sectionTitleDic;
@synthesize itemListInfoDic = _itemListInfoDic;
@synthesize selectedItemListInfoDic = _selectedItemListInfoDic;

@synthesize selectedItemIds = _selectedItemIds;

- (void)dealloc
{    
    [_sectionTitleDic release];
    [_itemListInfoDic release];
    [_selectedItemListInfoDic release];
        
    [_selectedItemIds release];
    
    [super dealloc];
}

- (id)initWithRouteType:(int)routeType
        selectedItemIds:(RouteSelectedItemIds *)selectedItemIds
{
    if (self = [super init]) {
        self.routeType = routeType;
        self.selectedItemIds = selectedItemIds;
        self.sectionTitleDic = [NSMutableDictionary dictionary];
        
    }
    
    return self;
}
    

- (void)viewDidLoad
{
    self.title = NSLS(@"筛选");
    [self setBackgroundImageName:@"all_page_bg2.jpg"];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Init UI Interface
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png" 
                           action:@selector(clickBack:)];
    
    [self setNavigationRightButton:NSLS(@"确定") 
                         imageName:@"topmenu_btn2.png"
                            action:@selector(clickFinish:)];
    
    NSArray *priceRankItemList = [[AppManager defaultManager] buildRoutePriceRankItemList];
    NSArray *daysRangeItemList = [[AppManager defaultManager] buildDaysRangeItemList];
    NSArray *routeThemeItemList = [[AppManager defaultManager] getRouteThemeItemList];
    
    int row = 0;
    if (_routeType == OBJECT_LIST_ROUTE_PACKAGE_TOUR) {
        [self.sectionTitleDic setObject:SECTION_TITLE_PRICE_RANK forKey:[NSNumber numberWithInt:row++]];
        [self.sectionTitleDic setObject:SECTION_TITLE_DAYS_RANGE forKey:[NSNumber numberWithInt:row++]];
        [self.sectionTitleDic setObject:SECTION_TITLE_ROUTE_THEME forKey:[NSNumber numberWithInt:row++]];
        
        [self.itemListInfoDic setValue:priceRankItemList forKey:SECTION_TITLE_PRICE_RANK];
        [self.itemListInfoDic setValue:daysRangeItemList forKey:SECTION_TITLE_DAYS_RANGE];
        [self.itemListInfoDic setValue:routeThemeItemList forKey:SECTION_TITLE_ROUTE_THEME];
        
        [self.selectedItemListInfoDic setValue:_selectedItemIds.priceRankItemIds 
                                        forKey:SECTION_TITLE_PRICE_RANK];
        [self.selectedItemListInfoDic setValue:_selectedItemIds.daysRangeItemIds
                                        forKey:SECTION_TITLE_DAYS_RANGE];
        [self.selectedItemListInfoDic setValue:_selectedItemIds.themeIds 
                                        forKey:SECTION_TITLE_ROUTE_THEME];

        
    }else if (_routeType == OBJECT_LIST_ROUTE_UNPACKAGE_TOUR) {
        [self.sectionTitleDic setObject:SECTION_TITLE_PRICE_RANK forKey:[NSNumber numberWithInt:row++]];
        [self.sectionTitleDic setObject:SECTION_TITLE_DAYS_RANGE forKey:[NSNumber numberWithInt:row++]];
        
        [self.itemListInfoDic setValue:priceRankItemList forKey:SECTION_TITLE_PRICE_RANK];
        [self.itemListInfoDic setValue:daysRangeItemList forKey:SECTION_TITLE_DAYS_RANGE];
        
        [self.selectedItemListInfoDic setValue:_selectedItemIds.priceRankItemIds 
                                        forKey:SECTION_TITLE_PRICE_RANK];
        [self.selectedItemListInfoDic setValue:_selectedItemIds.daysRangeItemIds
                                        forKey:SECTION_TITLE_DAYS_RANGE];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark -
#pragma mark: Implementation for UITableView datasource.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[RouteSelectCell getCellIdentifier]];
    if (cell == nil) {
        cell = [RouteSelectCell createCell:self];		
    }
    
    int row = [indexPath row];	
    int count = [dataList count];
    if (row >= count){
        PPDebug(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
        return cell;
    }
    
    NSArray *itemList = [self itemListForSection:indexPath.section];
    NSMutableArray *selectedItemIds = [self selectedItemIdsForSection:indexPath.section];
    
    RouteSelectCell* routeSelectCell = (RouteSelectCell*)cell;
    [routeSelectCell setCellData:itemList
                 selectedItemIds:selectedItemIds
                    multiOptions:YES 
                     needConfirm:YES 
                   needShowCount:NO];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    PPDebug(@"[_sectionTitleDic count] = %d", [_sectionTitleDic count]);
    return [_sectionTitleDic count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_sectionTitleDic objectForKey:[NSNumber numberWithInt:section]];
}

#pragma mark -
#pragma mark: Implementation for UITableView delegate.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int count = [[self itemListForSection:indexPath.section] count];
    int rows = (count + NUM_OF_SELECT_BUTTON_IN_LINE - 1) / NUM_OF_SELECT_BUTTON_IN_LINE;
    
    return rows * HEIGHT_SELECT_BUTTON;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSArray *)itemListForSection:(NSInteger)section
{
    NSString *title = [_sectionTitleDic objectForKey:[NSNumber numberWithInt:section]];
    
    return [_itemListInfoDic valueForKey:title];
}

- (NSMutableArray *)selectedItemIdsForSection:(NSInteger)section
{
    NSString *title = [_sectionTitleDic objectForKey:[NSNumber numberWithInt:section]];
    
    return [_selectedItemListInfoDic valueForKey:title];
}

@end
