//
//  SpotDetailViewHandler.m
//  Travel
//
//  Created by gckj on 12-3-17.
//  Copyright (c) 2012Âπ?__MyCompanyName__. All rights reserved.
//

#import "CommonPlaceDetailController.h"
#import "Place.pb.h"

@implementation SpotDetailViewHandler
@synthesize commonController;

//-(void)addSegmentViewTo:(UIView*)dataScrollView title:(NSString*)titleString description:(NSString*)descriptionString
//{
//    UIFont *font = [UIFont systemFontOfSize:12];
//    CGSize withinSize = CGSizeMake(300, 100000);
//    
//    NSString *description = descriptionString;
//    if ([description length] == 0) {
//        description = NO_DETAIL_DATA;
//    }
//    CGSize size = [description sizeWithFont:font constrainedToSize:withinSize lineBreakMode:UILineBreakModeWordWrap];
//    
//    UIView *segmentView = [[[UIView alloc]initWithFrame:CGRectMake(0, self.detailHeight, 320, size.height + TITLE_VIEW_HEIGHT)] autorelease];
//    segmentView.backgroundColor = INTRODUCTION_BG_COLOR;
//    
//    UILabel *title = [CommonPlaceDetailController createTitleView:titleString];
//    [segmentView addSubview:title];
//    
////    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(5, 24, 310, 1)];
////    lineView.backgroundColor = PRICE_BG_COLOR;
////    [segmentView addSubview:lineView];
////    [lineView release];
//    
//    UILabel *descriptionLabel = [CommonPlaceDetailController createDescriptionView:description height:size.height];    
//    [segmentView addSubview:descriptionLabel];
//    [dataScrollView addSubview:segmentView];    
//    
//    UIView *middleLineView = [CommonPlaceDetailController createMiddleLineView: self.detailHeight + segmentView.frame.size.height];
//    [dataScrollView addSubview:middleLineView];
//
//    self.detailHeight =  middleLineView.frame.origin.y + middleLineView.frame.size.height;
//}

- (void)addDetailViews:(UIView*)dataScrollView WithPlace:(Place*)place
{
//    [self addSegmentViewTo:dataScrollView title:NSLS(@"???‰ª??") description:[place introduction]];
//    [self addSegmentViewTo:dataScrollView title:NSLS(@"?®Á•®‰ª∑Ê?") description:[place price]];
//    [self addSegmentViewTo:dataScrollView title:NSLS(@"Âº???∂È?") description:[place openTime]];
//    [self addSegmentViewTo:dataScrollView title:NSLS(@"‰∫§È?‰ø°Ê?") description:[place transportation]];
//    [self addSegmentViewTo:dataScrollView title:NSLS(@"Ê∏∏Ë?Ë¥¥Â£´") description:[place tips]];

    [self.commonController addSegmentViewWith: NSLS(@"景点介绍") description:[place introduction]];
    [self.commonController addSegmentViewWith: NSLS(@"门票价格") description:[place price]];
    [self.commonController addSegmentViewWith: NSLS(@"开放时间") description:[place openTime]];
    [self.commonController addSegmentViewWith: NSLS(@"交通信息") description:[place transportation]];
    [self.commonController addSegmentViewWith: NSLS(@"旅游贴士") description:[place tips]];
}

-(id)initWith:(CommonPlaceDetailController *)controller
{
    [super init];
    self.commonController = controller;
    return  self;
}

@end
