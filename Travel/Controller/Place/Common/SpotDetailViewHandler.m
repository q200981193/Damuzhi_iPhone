//
//  SpotDetailViewHandler.m
//  Travel
//
//  Created by gckj on 12-3-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommonPlaceDetailController.h"
#import "Place.pb.h"

@implementation SpotDetailViewHandler

- (void)addDetailViews:(UIView*)dataScrollView WithPlace:(Place*)place
{
    UIView *introductionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    UILabel *introductionTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 50, 20)];
    introductionTitle.font = [UIFont systemFontOfSize:12];
    introductionTitle.text  = @"景点介绍";
    [introductionView addSubview:introductionTitle];
    [introductionView release];
    
    UILabel *introductionContent = [[UILabel alloc]initWithFrame:CGRectMake(5, 25, 320, 80)];
    introductionContent.font = [UIFont systemFontOfSize:12];
    introductionContent.text  = [place introduction];
    [introductionView addSubview:introductionContent];
    [introductionContent release];    
    [dataScrollView addSubview:introductionView];
    
    UIView *priceView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 320, 50)];
    UILabel *priceTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, 105, 50, 20)];
    priceTitle.font = [UIFont systemFontOfSize:12];
    priceTitle.text = @"门票价格";
    [priceView addSubview:priceTitle];
    [priceTitle release];
    
    UILabel *priceDescription = [[UILabel alloc]initWithFrame:CGRectMake(5, 125, 320, 30)];
    priceDescription.font = [UIFont systemFontOfSize:12];
    priceDescription.text  = [place price];
    [priceView addSubview:priceDescription];
    [priceDescription release];    
    [dataScrollView addSubview:priceView];
    
    UIView *openTimeView = [[UIView alloc]initWithFrame:CGRectMake(0, 150, 320, 50)];
    UILabel *openTimeTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, 155, 50, 20)];
    openTimeTitle.font = [UIFont systemFontOfSize:12];
    openTimeTitle.text = @"开放时间";
    [openTimeView addSubview:openTimeTitle];
    [openTimeTitle release];
    
    UILabel *openTimeDescription = [[UILabel alloc]initWithFrame:CGRectMake(5, 175, 320, 30)];
    openTimeDescription.font = [UIFont systemFontOfSize:12];
    openTimeDescription.text  = [place price];
    [openTimeView addSubview:openTimeDescription];
    [openTimeDescription release];    
    [dataScrollView addSubview:openTimeView];
    
    UIView *transportView = [[UIView alloc]initWithFrame:CGRectMake(0, 200, 320, 50)];
    UILabel *transportTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, 205, 50, 20)];
    transportTitle.font = [UIFont systemFontOfSize:12];
    transportTitle.text = @"交通信息";
    [transportView addSubview:transportTitle];
    [transportTitle release];
    
    UILabel *transportDescription = [[UILabel alloc]initWithFrame:CGRectMake(5, 225, 320, 30)];
    transportDescription.font = [UIFont systemFontOfSize:12];
    transportDescription.text  = [place price];
    [transportView addSubview:transportDescription];
    [transportDescription release];    
    [dataScrollView addSubview:transportView];

    UIView *tipsView = [[UIView alloc]initWithFrame:CGRectMake(0, 250, 320, 50)];
    UILabel *tipsTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, 255, 50, 20)];
    tipsTitle.font = [UIFont systemFontOfSize:12];
    tipsTitle.text = @"交通信息";
    [tipsView addSubview:tipsTitle];
    [transportTitle release];
    
    UILabel *tipsDescription = [[UILabel alloc]initWithFrame:CGRectMake(5, 275, 320, 30)];
    tipsDescription.font = [UIFont systemFontOfSize:12];
    tipsDescription.text  = [place price];
    [tipsView addSubview:tipsDescription];
    [tipsDescription release];    
    [dataScrollView addSubview:tipsView];
    

}

@end
