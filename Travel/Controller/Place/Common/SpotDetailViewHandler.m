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
@synthesize detailHeight;
 
#define TITLE_VIEW_HEIGHT 35
#define MIDDLE_LINE_HEIGHT 2
#define CGRECT_TITLE CGRectMake(10, 3, 100, 20)
#define TITLE_COLOR [UIColor colorWithRed:37/255.0 green:66/255.0 blue:80/255.0 alpha:1.0]
#define DESCRIPTION_COLOR [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]
#define INTRODUCTION_BG_COLOR [UIColor colorWithRed:222/255.0 green:239/255.0 blue:247/255.0 alpha:1.0]
#define PRICE_BG_COLOR [UIColor colorWithRed:235/255.0 green:241/255.0 blue:241/255.0 alpha:1.0]


- (void)addDetailViews:(UIView*)dataScrollView WithPlace:(Place*)place
{
    UIFont *font = [UIFont systemFontOfSize:12];
    UIFont *boldFont = [UIFont boldSystemFontOfSize:13];
    CGSize withinSize = CGSizeMake(300, 100000);
    
     NSString *intruduction = [NSString stringWithString: @"香港迪斯尼乐园是一个位于香港迪斯尼度假区的主题乐园，它是迪士尼第五座迪士尼乐园。香港地铁设有专用铁路迪斯尼线来往欣澳站及迪斯尼站，为全世界第二条来往迪士尼的铁路专线。香港迪士尼乐园主题曲「让奇妙飞翔」由香港迪士尼名誉大使张学友主唱。而乐园的官方沟通语言为英文及中文"];
//    NSString *intruduction = [place introduction];
    CGSize size = [intruduction sizeWithFont:font constrainedToSize:withinSize lineBreakMode:UILineBreakModeWordWrap];
    
    UIView *introductionView = [[UIView alloc]initWithFrame:CGRectMake(0, 3, 320, size.height + TITLE_VIEW_HEIGHT)];
    introductionView.backgroundColor = INTRODUCTION_BG_COLOR;
     UILabel *introductionTitle = [[UILabel alloc]initWithFrame:CGRECT_TITLE];
    introductionTitle.backgroundColor = [UIColor clearColor];
    introductionTitle.textColor = TITLE_COLOR;
    introductionTitle.font = boldFont;
    introductionTitle.text  = @"景点介绍";
    [introductionView addSubview:introductionTitle];
    [introductionTitle release];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(5, 24, 310, 1)];
    lineView.backgroundColor = PRICE_BG_COLOR;
    [introductionView addSubview:lineView];
    [lineView release];
    
    UILabel *introductionDescription = [[UILabel alloc]initWithFrame:CGRectMake(10, 26, 300, size.height)];
    introductionDescription.lineBreakMode = UILineBreakModeWordWrap;
    introductionDescription.numberOfLines = 0;
    introductionDescription.backgroundColor = [UIColor clearColor];
    introductionDescription.textColor = DESCRIPTION_COLOR;
    introductionDescription.font = font;
    introductionDescription.text = intruduction;
    
    [introductionView addSubview:introductionDescription];
    [introductionDescription release]; 
    
    [dataScrollView addSubview:introductionView];
    [introductionView release];
    
    UIView *middleLineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, introductionView.frame.size.height, 320, MIDDLE_LINE_HEIGHT)];
    middleLineView1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"middle_line"]];
    [dataScrollView addSubview:middleLineView1];
    [middleLineView1 release];
    
    
    NSString *price = [NSString stringWithString: @"成人:港币287元。小童3至11岁200港币，长者65岁以上170港币"];
//    NSString *price = [place price];
    CGSize size2 = [price sizeWithFont:font constrainedToSize:withinSize lineBreakMode:UILineBreakModeWordWrap];
    
    UIView *priceView = [[UIView alloc]initWithFrame:CGRectMake(0, middleLineView1.frame.origin.y+middleLineView1.frame.size.height, 320, size2.height + TITLE_VIEW_HEIGHT)];
    priceView.backgroundColor = PRICE_BG_COLOR;
    UILabel *priceTitle = [[UILabel alloc]initWithFrame:CGRECT_TITLE];
    priceTitle.textColor = TITLE_COLOR;
    priceTitle.font = boldFont;
    priceTitle.text = @"门票价格";
    priceTitle.backgroundColor = [UIColor clearColor];
    [priceView addSubview:priceTitle];
    [priceTitle release];
    
    UILabel *priceDescription = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 300, size2.height)];
    priceDescription.lineBreakMode = UILineBreakModeWordWrap;
    priceDescription.numberOfLines = 0;
    priceDescription.backgroundColor = [UIColor clearColor];
    priceDescription.font = font;
    priceDescription.textColor = DESCRIPTION_COLOR;
    priceDescription.text = price;
    [priceView addSubview:priceDescription];
    [priceDescription release];  
    
    [dataScrollView addSubview:priceView];
    [priceView release];
    
    UIView *middleLineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, priceView.frame.origin.y + priceView.frame.size.height, 320, 2)];
    middleLineView2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"middle_line"]];
    [dataScrollView addSubview:middleLineView2];
    [middleLineView2 release];

    NSString *openTime = [NSString stringWithString: @"开放时间描述"];
//    NSString *openTime = [place openTime];
    CGSize size3 = [openTime sizeWithFont:font constrainedToSize:withinSize lineBreakMode:UILineBreakModeWordWrap];
    UIView *openTimeView = [[UIView alloc]initWithFrame:CGRectMake(0, middleLineView2.frame.origin.y + middleLineView2.frame.size.height, 320, size3.height + TITLE_VIEW_HEIGHT)];
    openTimeView.backgroundColor = PRICE_BG_COLOR;
    UILabel *openTimeTitle = [[UILabel alloc]initWithFrame:CGRECT_TITLE];
    openTimeTitle.backgroundColor = [UIColor clearColor];
    openTimeTitle.font = boldFont;
    openTimeTitle.textColor = TITLE_COLOR;
    openTimeTitle.text = @"开放时间";
    [openTimeView addSubview:openTimeTitle];
    [openTimeTitle release];
    
    UILabel *openTimeDescription = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 300, size3.height)];
    openTimeDescription.lineBreakMode = UILineBreakModeWordWrap;
    openTimeDescription.numberOfLines = 0;
    openTimeDescription.backgroundColor = [UIColor clearColor];
    openTimeDescription.font = [UIFont systemFontOfSize:12];
    openTimeDescription.textColor = DESCRIPTION_COLOR;
    openTimeDescription.text = openTime;
    [openTimeView addSubview:openTimeDescription];
    [openTimeDescription release];    
    
    [dataScrollView addSubview:openTimeView];
    [openTimeView release];
    
    UIView *middleLineView3 = [[UIView alloc]initWithFrame:CGRectMake(0, openTimeView.frame.origin.y + openTimeView.frame.size.height, 320, 2)];
    middleLineView3.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"middle_line"]];
    [dataScrollView addSubview:middleLineView3];
    [middleLineView3 release];
    
    
    NSString *transport = [NSString stringWithString: @"交通信息描述"];
    //    NSString *transport = [place transport];
    CGSize size4 = [transport sizeWithFont:font constrainedToSize:withinSize lineBreakMode:UILineBreakModeWordWrap];
    
    UIView *transportView = [[UIView alloc]initWithFrame:CGRectMake(0, middleLineView3.frame.origin.y + middleLineView3.frame.size.height, 320, size4.height + TITLE_VIEW_HEIGHT)];
    transportView.backgroundColor = PRICE_BG_COLOR;
    UILabel *transportTitle = [[UILabel alloc]initWithFrame:CGRECT_TITLE];
    transportTitle.backgroundColor = [UIColor clearColor];
    transportTitle.font = boldFont;
    transportTitle.textColor = TITLE_COLOR;
    transportTitle.text = @"交通信息";
    [transportView addSubview:transportTitle];
    [transportTitle release];
    
    UILabel *transportDescription = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 300, size4.height)];
    transportDescription.lineBreakMode = UILineBreakModeWordWrap;
    transportDescription.numberOfLines = 0;
    transportDescription.backgroundColor = [UIColor clearColor];
    transportDescription.font = font;
    transportDescription.text = transport;
    transportDescription.textColor = DESCRIPTION_COLOR;
    [transportView addSubview:transportDescription];
    [transportDescription release];
    
    [dataScrollView addSubview:transportView];
    [transportView release];
    
    UIView *middleLineView4 = [[UIView alloc]initWithFrame:CGRectMake(0, transportView.frame.origin.y + transportView.frame.size.height, 320, 2)];
    middleLineView4.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"middle_line"]];
    [dataScrollView addSubview:middleLineView4];
    [middleLineView4 release];

    NSString *tips = [NSString stringWithString: @"游览贴士描述"];
//    NSString *tips = [place tips];
    CGSize size5 = [tips sizeWithFont:font constrainedToSize:withinSize lineBreakMode:UILineBreakModeWordWrap];
    
    UIView *tipsView = [[UIView alloc]initWithFrame:CGRectMake(0, middleLineView4.frame.origin.y + middleLineView4.frame.size.height, 320, size5.height + TITLE_VIEW_HEIGHT)];
    tipsView.backgroundColor = PRICE_BG_COLOR;
    UILabel *tipsTitle = [[UILabel alloc]initWithFrame:CGRECT_TITLE];
    tipsTitle.backgroundColor = [UIColor clearColor];
    tipsTitle.font = boldFont;
    tipsTitle.textColor = TITLE_COLOR;
    tipsTitle.text = @"游览贴士";
    [tipsView addSubview:tipsTitle];
    [tipsTitle release];
    
    UILabel *tipsDescription = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 300, size5.height)];
    tipsDescription.lineBreakMode = UILineBreakModeWordWrap;
    tipsDescription.numberOfLines = 0;
    tipsDescription.backgroundColor = [UIColor clearColor];
    tipsDescription.font = font;
    tipsDescription.textColor = DESCRIPTION_COLOR;
    tipsDescription.text = tips;
    [tipsView addSubview:tipsDescription];
    [tipsDescription release];    
    
    [dataScrollView addSubview:tipsView];
    [tipsView release];
    
    UIView *middleLineView5 = [[UIView alloc]initWithFrame:CGRectMake(0, tipsView.frame.origin.y + tipsView.frame.size.height, 320, 2)];
    middleLineView5.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"middle_line"]];
    [dataScrollView addSubview:middleLineView5];
    [middleLineView5 release];
    
    self.detailHeight = middleLineView5.frame.origin.y + middleLineView5.frame.size.height;

}

@end
