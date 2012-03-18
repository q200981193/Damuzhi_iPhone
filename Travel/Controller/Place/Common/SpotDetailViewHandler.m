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
    UIView *introductionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 70)];
    UILabel *introductionTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 50, 20)];
    introductionView.backgroundColor = [UIColor greenColor];
    introductionTitle.font = [UIFont systemFontOfSize:12];
    introductionTitle.text  = @"景点介绍";
    [introductionView addSubview:introductionTitle];
    [introductionTitle release];
    
    UILabel *introductionContent = [[UILabel alloc]initWithFrame:CGRectMake(5, 25, 320, 50)];
    introductionContent.font = [UIFont systemFontOfSize:12];
    introductionContent.text  = [place introduction];
    [introductionView addSubview:introductionContent];
    [introductionContent release]; 
    
    [dataScrollView addSubview:introductionView];
    [introductionView release];
    
    UIView *priceView = [[UIView alloc]initWithFrame:CGRectMake(0, 70, 320, 70)];
    UILabel *priceTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 50, 20)];
    priceTitle.font = [UIFont systemFontOfSize:12];
    priceTitle.text = @"门票价格";
    priceView.backgroundColor = [UIColor blueColor];
    [priceView addSubview:priceTitle];
    [priceTitle release];
    
    UILabel *priceDescription = [[UILabel alloc]initWithFrame:CGRectMake(5, 25, 320, 50)];
    priceDescription.font = [UIFont systemFontOfSize:12];
    priceDescription.text  = [place price];
    [priceView addSubview:priceDescription];
    [priceDescription release];  
    
    [dataScrollView addSubview:priceView];
    [priceView release];
    
    UIView *openTimeView = [[UIView alloc]initWithFrame:CGRectMake(0, 140, 320, 70)];
    openTimeView.backgroundColor = [UIColor greenColor];
    UILabel *openTimeTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 50, 20)];
    openTimeTitle.font = [UIFont systemFontOfSize:12];
    openTimeTitle.text = @"开放时间";
    [openTimeView addSubview:openTimeTitle];
    [openTimeTitle release];
    
    UILabel *openTimeDescription = [[UILabel alloc]initWithFrame:CGRectMake(5, 25, 320, 50)];
    openTimeDescription.font = [UIFont systemFontOfSize:12];
    openTimeDescription.text  = [place openTime];
    [openTimeView addSubview:openTimeDescription];
    [openTimeDescription release];    
    
    [dataScrollView addSubview:openTimeView];
    [openTimeView release];
    
    UIView *transportView = [[UIView alloc]initWithFrame:CGRectMake(0, 210, 320, 50)];
    transportView.backgroundColor = [UIColor blueColor];
    UILabel *transportTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 50, 20)];
    transportTitle.font = [UIFont systemFontOfSize:12];
    transportTitle.text = @"交通信息";
    [transportView addSubview:transportTitle];
    [transportTitle release];
    
    UILabel *transportDescription = [[UILabel alloc]initWithFrame:CGRectMake(5, 25, 320, 50)];
    transportDescription.font = [UIFont systemFontOfSize:12];
    transportDescription.text  = [place transportation];
    [transportView addSubview:transportDescription];
    [transportDescription release];
    
    [dataScrollView addSubview:transportView];
    [transportView release];

    UIView *tipsView = [[UIView alloc]initWithFrame:CGRectMake(0, 280, 320, 50)];
    tipsView.backgroundColor = [UIColor greenColor];
    UILabel *tipsTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 50, 20)];
    tipsTitle.font = [UIFont systemFontOfSize:12];
    tipsTitle.text = @"游览贴士";
    [tipsView addSubview:tipsTitle];
    [tipsTitle release];
    
    UILabel *tipsDescription = [[UILabel alloc]initWithFrame:CGRectMake(5, 25, 320, 50)];
    tipsDescription.font = [UIFont systemFontOfSize:12];
    tipsDescription.text  = [place tips];
    [tipsView addSubview:tipsDescription];
    [tipsDescription release];    
    
    [dataScrollView addSubview:tipsView];
    [tipsView release];
    

}

@end
