//
//  SpotDetailViewHandler.m
//  Travel
//
//  Created by gckj on 12-3-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommonPlaceDetailController.h"
#import "Place.pb.h"
#define NO_DETAIL_DATA NSLS(@"暂无")
@implementation HotelDetailViewHandler
@synthesize detailHeight;

-(void)addSegmentViewTo:(UIView*)dataScrollView title:(NSString*)titleString description:(NSString*)descriptionString
{
    UIFont *font = [UIFont systemFontOfSize:12];
    CGSize withinSize = CGSizeMake(300, 100000);
    
    NSString *description = descriptionString;
    if ([description length] == 0) {
        description = NO_DETAIL_DATA;
    }
    CGSize size = [description sizeWithFont:font constrainedToSize:withinSize lineBreakMode:UILineBreakModeWordWrap];
    
    UIView *segmentView = [[[UIView alloc]initWithFrame:CGRectMake(0, self.detailHeight, 320, size.height + TITLE_VIEW_HEIGHT)] autorelease];
    segmentView.backgroundColor = INTRODUCTION_BG_COLOR;
    
    UILabel *title = [CommonPlaceDetailController createTitleView:titleString];
    [segmentView addSubview:title];
    
    //    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(5, 24, 310, 1)];
    //    lineView.backgroundColor = PRICE_BG_COLOR;
    //    [segmentView addSubview:lineView];
    //    [lineView release];
    
    UILabel *descriptionLabel = [CommonPlaceDetailController createDescriptionView:description height:size.height];    
    [segmentView addSubview:descriptionLabel];
    [dataScrollView addSubview:segmentView];    
    
    UIView *middleLineView = [CommonPlaceDetailController createMiddleLineView: self.detailHeight + segmentView.frame.size.height];
    [dataScrollView addSubview:middleLineView];
    
    self.detailHeight =  middleLineView.frame.origin.y + middleLineView.frame.size.height;
}

- (NSString*)starToString:(int32_t)star
{
    return @"五星级";
}

- (void)addDetailViews:(UIView*)dataScrollView WithPlace:(Place*)place
{
    detailHeight = 3;
    [self addSegmentViewTo:dataScrollView title:NSLS(@"酒店简介") description:[place introduction]];
    
    NSString *hotelStar = [self starToString:[place hotelStar]];
    [self addSegmentViewTo:dataScrollView title:NSLS(@"酒店星级") description:hotelStar];
    
    [self addSegmentViewTo:dataScrollView title:NSLS(@"用户评价关键词") description:[place.keywordsList componentsJoinedByString:@" "]];
    [self addSegmentViewTo:dataScrollView title:NSLS(@"房间价格") description:[place price]];
    [self addSegmentViewTo:dataScrollView title:NSLS(@"交通信息") description:[place transportation]];
    
}

@end
