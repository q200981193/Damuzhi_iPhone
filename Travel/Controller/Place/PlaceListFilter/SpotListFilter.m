//
//  SpotListFilter.m
//  Travel
//
//  Created by  on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SpotListFilter.h"
#import "PlaceManager.h"
#import "PlaceService.h"
#import "AppManager.h"

@implementation SpotListFilter

@synthesize selectedCategoryList = _selectedCategoryList;
@synthesize selectedSotrList = _selectedSortList;
@synthesize controller;

- (void)dealloc
{
    [controller release];
    [super dealloc];
}

- (UIButton*)createFilterButton:(CGRect)frame title:(NSString*)title bgImageForNormalState:(NSString*)bgImageForNormalState bgImageForHeightlightState:(NSString*)bgImageForHeightlightState 
{
    UIImage *bgImageForNormal = [UIImage imageNamed:bgImageForNormalState];
    UIImage *bgImageForHeightlight = [UIImage imageNamed:bgImageForHeightlightState];
    
    UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundImage:bgImageForNormal forState:UIControlStateNormal];
    [button setBackgroundImage:bgImageForHeightlight forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize: 15];
    
    return button;
}

- (void)clickCategoryButton:(id)sender
{
    //SelectController* selectController = [SelectController createController:[[AppManager defaultManager] getSubCategories:1]];  
    NSArray *subCategoryNames = [[AppManager defaultManager] getSubCategoryNames:1];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:@"全部"];
    for (NSString *string in subCategoryNames) {
        [array addObject:string];
    }
    
    SelectController* selectController = [SelectController createController:array selectedList:self.selectedCategoryList multiOptions:YES];
    
    selectController.navigationItem.title = @"景点分类";
    
    [controller.navigationController pushViewController:selectController animated:YES];
    selectController.delegate = self;
    
    
    NSLog(@"click category button");
}

- (void)clickSortButton:(id)sender
{
//    NSArray *sortList = [[NSArray alloc] init];
    NSArray *sortList = [NSArray arrayWithObjects:NSLS(@"大拇指推荐"), NSLS(@"距离近至远"), NSLS(@"门票价格高到低"), nil];
    SelectController* selectController1 = [SelectController createController:sortList selectedList:self.selectedSotrList multiOptions:NO];
    
    selectController1.navigationItem.title = @"景点排序";
    
    [controller.navigationController pushViewController:selectController1 animated:YES];
    selectController1.delegate = self;
    NSLog(@"click sort button");
    
}

- (void)createFilterButtons:(UIView*)superView controller:(PPTableViewController *)filteController
{
    superView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"2menu_bg.png"]];
    
    CGRect frame1 = CGRectMake(0, 0, 58, 36);
    CGRect frame2 = CGRectMake(58, 0, 58, 36);
    
    UIButton *buttonCategory = [self createFilterButton:frame1 title:@"分类" bgImageForNormalState:@"2menu_btn.png" bgImageForHeightlightState:@"2menu_btn_on.png"];
    [buttonCategory addTarget:self action:@selector(clickCategoryButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buttonSort = [self createFilterButton:frame2 title:@"排序" bgImageForNormalState:@"2menu_btn.png" bgImageForHeightlightState:@"2menu_btn_on.png"];
    [buttonSort addTarget:self action:@selector(clickSortButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [superView addSubview:buttonCategory];
    [superView addSubview:buttonSort];

    self.controller = filteController;
    
}

+ (NSObject<PlaceListFilterProtocol>*)createFilter
{
    SpotListFilter* filter = [[[SpotListFilter alloc] init] autorelease];
    filter.selectedSotrList = [[[NSMutableArray alloc] init] autorelease];
    filter.selectedCategoryList = [[[NSMutableArray alloc] init] autorelease];

    return filter;
}


- (void)findAllPlaces:(PPViewController<PlaceServiceDelegate>*)viewController
{
    return [[PlaceService defaultService] findAllSpots:viewController];
}

- (void)didSelectFinish:(NSArray*)selectedList
{
    //TODO, spot category    
    
}


@end
