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

@implementation SpotListFilter

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

- (void)createFilterButtons:(UIView*)superView
{
    superView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"2menu_bg.png"]];
    
    CGRect frame1 = CGRectMake(0, 0, 58, 36);
    CGRect frame2 = CGRectMake(58, 0, 58, 36);
    
    
    UIButton *buttonCategory = [self createFilterButton:frame1 title:@"分类" bgImageForNormalState:@"2menu_btn.png" bgImageForHeightlightState:@"2menu_btn_on.png"];
    UIButton *buttonSort = [self createFilterButton:frame2 title:@"排序" bgImageForNormalState:@"2menu_btn.png" bgImageForHeightlightState:@"2menu_btn_on.png"];
    
    [superView addSubview:buttonCategory];
    [superView addSubview:buttonSort];
}

+ (NSObject<PlaceListFilterProtocol>*)createFilter
{
    SpotListFilter* filter = [[[SpotListFilter alloc] init] autorelease];
    return filter;
}

- (void)findAllPlaces:(PPViewController<PlaceServiceDelegate>*)viewController
{
    return [[PlaceService defaultService] findAllSpots:viewController];
}

@end
