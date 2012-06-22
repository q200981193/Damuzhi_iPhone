//
//  DailySchedulesCell.h
//  Travel
//
//  Created by 小涛 王 on 12-6-11.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PPTableViewCell.h"
#import "TouristRoute.pb.h"

#define WIDTH_DAILY_SCHEDULE_VIEW 308

#define HEIGHT_PLACE_TOUR_LABEL 21
#define EDGE_TOP 1
#define EDGE_BOTTOM 3
#define HEIGHT_DINING_LABEL 25
#define HEIGHT_HOTEL_LABEL 25

@interface DailyScheduleCell : PPTableViewCell
@property (retain, nonatomic) IBOutlet UIButton *titleButton;
@property (retain, nonatomic) IBOutlet UIImageView *placeToursBgImageView;
@property (retain, nonatomic) IBOutlet UIButton *diningButton;
@property (retain, nonatomic) IBOutlet UIButton *hotelButton;
@property (retain, nonatomic) IBOutlet UIButton *placeToursTagButton;
@property (retain, nonatomic) IBOutlet UIButton *diningTagButton;
@property (retain, nonatomic) IBOutlet UIButton *hotelTagButton;

- (void)setCellData:(DailySchedule *)dailySchedule rowNum:(int)rowNum rowCount:(int)rowCount;


@end