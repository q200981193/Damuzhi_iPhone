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

- (void)createFilterButtons:(UIView*)superView
{
    NSLog(@"createFilterButtons");
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.frame = CGRectMake(5, 5, 50, 40);
    //button1.backgroundColor = [UIColor redColor];
    [button1 setTitle:@"分类" forState:UIControlStateNormal];
    [superView addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button2.frame = CGRectMake(65, 5, 50, 40);
    [button2 setTitle:@"排序" forState:UIControlStateNormal];
    [superView addSubview:button2];
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
