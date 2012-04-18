//
//  RouteDetailController.m
//  Travel
//
//  Created by 小涛 王 on 12-4-18.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "RouteDetailController.h"
#import "UIImageUtil.h"
#import "AppUtils.h"
#import "AppManager.h"
#import "ImageName.h"
#import "SlideImageView.h"

@implementation RouteDetailController

@synthesize tip = _tip;
@synthesize imageHolderView;
@synthesize routeNameLabel;
@synthesize detailIntroView;
@synthesize scrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithRed:222.0/255.0 green:239.0/255.0 blue:248.0/255.0 alpha:1]];
    
    [self setNavigationLeftButton:@"返回" imageName:@"back.png" action:@selector(clickBack:)];

    [self addSlideImageView];
    
    [scrollView setContentSize:detailIntroView.frame.size];
    
    [routeNameLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage strectchableImageName:@"detail_shadow.png"]]];
    [routeNameLabel setTextColor:[UIColor colorWithRed:36.0/255.0 green:65.0/255.0 blue:79.0/255.0 alpha:1]];
    [routeNameLabel setText:_tip.name];
    [routeNameLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [routeNameLabel setTextAlignment:UITextAlignmentCenter];
    
    [detailIntroView setBackgroundColor:[UIColor colorWithRed:222.0/255.0 green:239.0/255.0 blue:248.0/255.0 alpha:1]];

    UILabel *label = [[UILabel alloc] init];
    [label setNumberOfLines:0];
    [label setLineBreakMode:UILineBreakModeWordWrap];

    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont systemFontOfSize:15]];
    [label setTextColor:[UIColor colorWithRed:101/255.0 green:101/255.0 blue:101/255.0 alpha:1]];
    
    NSString *detailIntro = [NSString stringWithFormat:@"       %@", [_tip.detailIntro stringByReplacingOccurrencesOfString:@"\n" withString:@"       \n"]];
//    NSString *detailIntro = @"大拇指测试2城市-香港客户端闪退严重，稍有数据加载不了就会闪退。城市列表，每个城市切换时，点击城市时不需要重复提示。除了香港，其它无法点击进入。点击在线时，无法进入，只会切换默认城市。下载离线包时，没有下载进度，只提示已载成功。打开各类型列表，列表图片会显示空白一片，没有加载，也没有显示默认图片。各列表，非当前城市下查询，相在的距离显示可以屏蔽。各类型，在筛选时，如果筛选出没有内容，即页面中增加提示，未找到相关信息。景点，进入时，常会空白，无内容，需要进行一次筛选才显示相关内容。门票价格如果为无门票时，统一显示为免费，现在列表与详情显示不一致。详情页面，周边推荐应整个列表栏都可以点击，并在点击时增加反馈效果。详情里的电话及地址定位，应可以整个列表点击，这样更能方便用户进行点击操作。收藏人数，与收藏功能，用两行显示，收藏人数在底部显示。收藏了的内容，下方的文字应修改成“已收藏”且设为不可操作。除景点，酒店等详情下方的收藏人数，收藏后人数会变负数。排序、分类这些按钮在选中时，应增加选中的反馈效果。帮助内容还没有。酒店列表里的服务图标可以再大一点，现在略小了。我的附近，距离选择功能无效。我的收藏，列表上方的分类内容，样式没有调整好，类型上有边框。各列表，如果图片无法加载情况下，应在若干时间后取消读取图片的显示，直接显示默认图片。各列表，底部的表格线应该去掉。";
    CGSize constrainedSize = CGSizeMake(detailIntroView.frame.size.width, CGFLOAT_MAX);
    CGSize detailIntroSize = [detailIntro sizeWithFont:label.font constrainedToSize:constrainedSize lineBreakMode:label.lineBreakMode];
    [label setFrame:CGRectMake(0, 0, detailIntroView.frame.size.width, detailIntroSize.height)];
    [label setText:detailIntro];
    
    if (detailIntroSize.height > detailIntroView.frame.size.height) {
        
        float increaseHeight = detailIntroSize.height - detailIntroView.frame.size.height;
        
        [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, 
                                              scrollView.frame.size.height + increaseHeight)];
        
        [detailIntroView setFrame:CGRectMake(detailIntroView.frame.origin.x, 
                                             detailIntroView.frame.origin.y,
                                             detailIntroView.frame.size.width,
                                             detailIntroSize.height)];
        
    }
//    [detailIntroView setFrame:CGRectMake(detailIntroView.frame.origin.x, 
//                                         detailIntroView.frame.origin.y,
//                                         detailIntroView.frame.size.width,
//                                         1000)];
//
//    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, 
//                                          1000)];
    
    [detailIntroView addSubview:label];
    [label release];
    
    
}

- (void)viewDidUnload
{
    [self setRouteNameLabel:nil];
    [self setDetailIntroView:nil];
    [self setScrollView:nil];
    [self setImageHolderView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [_tip release];
    [routeNameLabel release];
    [detailIntroView release];
    [scrollView release];
    [imageHolderView release];
    [super dealloc];
}

- (RouteDetailController*)initWithDataSource:(CommonTravelTip*)tip
{
    self = [super init];
    if (self) {
        self.tip = tip;
    }
    
    return self;
}

- (void)addSlideImageView
{
    NSMutableArray *imagePathList = [[NSMutableArray alloc] init];
    
    if ([AppUtils isShowImage]) {
        //handle imageList, if there has local data, each image is a relative path, otherwise, it is a absolute URL.
        for (NSString *image in _tip.imagesList) {
            NSString *path = [AppUtils getAbsolutePath:[AppUtils getCityDataDir:[[AppManager defaultManager] getCurrentCityId]] string:image];
            [imagePathList addObject:path];
        }
    }
    else {
        [imagePathList addObject:IMAGE_PLACE_DETAIL];
    }
    
    SlideImageView *slideImageView = [[SlideImageView alloc] initWithFrame:imageHolderView.bounds];
    [slideImageView setImages:imagePathList];
    [imageHolderView addSubview:slideImageView];
    [imagePathList release];
    [slideImageView release];
}

@end
