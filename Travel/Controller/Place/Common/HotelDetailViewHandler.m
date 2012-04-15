//
//  SpotDetailViewHandler.m
//  Travel
//
//  Created by gckj on 12-3-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommonPlaceDetailController.h"
#import "Place.pb.h"
#import "PlaceUtils.h"

@implementation HotelDetailViewHandler
@synthesize commonController;

#define NO_DETAIL_DATA NSLS(@"暂无")

-(void)addStarLevelViewWith:(NSString*)titleString description:(NSString*)descriptionString starCount:(int32_t)starCount
{
    UIFont *font = [UIFont systemFontOfSize:12];
    CGSize withinSize = CGSizeMake(300, 100000);
    
    NSString *description = descriptionString;
    if ([description length] == 0) {
        description = NO_DETAIL_DATA;
    }
    CGSize size = [description sizeWithFont:font constrainedToSize:withinSize lineBreakMode:UILineBreakModeWordWrap];
    
    UIView *segmentView = [[[UIView alloc]initWithFrame:CGRectMake(0, self.commonController.detailHeight, 320, size.height + TITLE_VIEW_HEIGHT)] autorelease];
    segmentView.backgroundColor = PRICE_BG_COLOR;
    
    UILabel *title = [self.commonController createTitleView:titleString];
    [segmentView addSubview:title];
    
    UIView *starIconView = [[[UIView alloc]initWithFrame:CGRectMake(10, 26, 10 + 15 * starCount, 12.5)] autorelease];

    int32_t i = 0;
    CGRect rect = CGRectMake(0, 0, 12.5, 12);
    for (i = 0; i < starCount; i++) {
        UIImageView *starView = [[UIImageView alloc] initWithFrame:rect];
        UIImage *icon = [UIImage imageNamed:@"star_ico"];
        
        starView.center = CGPointMake(8+i*15, 6); 
        
        [starView setImage:icon];
        [starIconView addSubview:starView];
        [starView release];
    }

    [segmentView addSubview:starIconView];

    
    UILabel *introductionDescription = [[[UILabel alloc]initWithFrame:CGRectMake(starIconView.frame.origin.x + starIconView.frame.size.width + 10, 26, 300, size.height)] autorelease];
    introductionDescription.lineBreakMode = UILineBreakModeWordWrap;
    introductionDescription.numberOfLines = 0;
    introductionDescription.backgroundColor = [UIColor clearColor];
    introductionDescription.textColor = DESCRIPTION_COLOR;
    introductionDescription.font = font;
    introductionDescription.text = description;  
    
    
    [segmentView addSubview:introductionDescription];
    [commonController.dataScrollView addSubview:segmentView];    
    
    UIView *middleLineView = [self.commonController createMiddleLineView2: self.commonController.detailHeight + segmentView.frame.size.height];
    [commonController.dataScrollView addSubview:middleLineView];
    
    self.commonController.detailHeight =  middleLineView.frame.origin.y + middleLineView.frame.size.height;
}


- (void)addDetailViews:(UIView*)dataScrollView WithPlace:(Place*)place
{
    
    [self.commonController addIntroductionViewWith: NSLS(@"酒店简介") description:[place introduction]];
    
    [self addStarLevelViewWith: NSLS(@"酒店星级") description:[PlaceUtils hotelStarToString:[place hotelStar]] starCount:[place hotelStar]];
    
    //NSString *keyWords = [[place keywordsList] componentsJoinedByString:@" "];
    NSString *keyWords = [[place keywordsList] objectAtIndex:0];

    NSLog(@"keyWords = %@", keyWords);
    [self.commonController addSegmentViewWith: NSLS(@"用户评价关键词") description:[[place keywordsList] componentsJoinedByString:@" "]];
    
    [self.commonController addSegmentViewWith: NSLS(@"房间价格") description:[PlaceUtils getPriceString:place]];

    [self.commonController addTransportView:place];
}

- (id)initWith:(CommonPlaceDetailController *)controller
{
    [super init];
    self.commonController = controller;
    return  self;
}

@end
