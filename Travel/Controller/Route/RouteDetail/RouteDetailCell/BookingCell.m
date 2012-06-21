//
//  BookingCell.m
//  Travel
//
//  Created by 小涛 王 on 12-6-14.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "BookingCell.h"
#import "NSDate+TKCategory.h"
#import <QuartzCore/QuartzCore.h>
#import "PPDebug.h"
#import "LocaleUtils.h"
#import "TimeUtils.h"
#import "TouristRoute.pb.h"

@interface BookingCell ()

@property (retain, nonatomic) TKCalendarMonthView *monthView;
@property (retain, nonatomic) NSMutableArray *dataArray;
@property (retain, nonatomic) NSArray *bookings;

@end

@implementation BookingCell
@synthesize bookingBgImageView = _bookingBgImageView;
@synthesize monthHolderView = _monthHolderView;
@synthesize currentMonthButton = _currentMonthButton;
@synthesize nextMonthButton = _nextMonthButton;
@synthesize bookings = _bookings;

@synthesize monthView = _monthView;
@synthesize dataArray = _dataArray;

+ (NSString*)getCellIdentifier
{
    return @"BookingCell";
}

- (void)dealloc
{
    [_monthView release];
    [_dataArray release];
    [_monthHolderView release];
    [_currentMonthButton release];
    [_nextMonthButton release];
    [_bookings release];
    [_bookingBgImageView release];
    [super dealloc];
}

- (void)setCellData:(BOOL)sundayFirst bookings:(NSArray*)bookings
{    
    NSDate *now = [NSDate date];
    self.monthView = [[[TKCalendarMonthView alloc] initWithSundayAsFirst:NO 
                                                                    date:now
                                                    hasMonthYearAndArrow:NO 
                                                        hasTopBackground:NO
                                                               hasShadow:NO 
                                                   userInteractionEnable:NO] autorelease];
    
    [self.currentMonthButton setTitle:dateToStringByFormat(now, @"yyyy年MM月") forState:UIControlStateNormal];
    [self.nextMonthButton  setTitle:dateToStringByFormat([now nextMonth], @"yyyy年MM月") forState:UIControlStateNormal];
    
    _monthView.delegate = self;
    _monthView.dataSource = self;
    

    
    CGFloat scale = _monthHolderView.frame.size.width / _monthView.frame.size.width;
    CGAffineTransform transform =  CGAffineTransformMakeScale(scale, scale);
    _monthView.transform = transform;
    _monthView.frame = CGRectMake(0, 0, _monthView.frame.size.width, _monthView.frame.size.height);
    
    [self.monthHolderView addSubview:_monthView];
    
    if (self.currentMonthButton.selected == NO && self.nextMonthButton.selected == NO) {
        self.currentMonthButton.selected = YES;
    }
        
    self.bookings = bookings;
    
    [_monthView reload];
}


- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate
{
    [self generateRandomDataForStartDate:startDate endDate:lastDate];
	return _dataArray;
}

- (IBAction)clickCurrentMonthButton:(id)sender {
    if (self.currentMonthButton.selected == YES) {
        return;
    }
    
    UIButton *button = [_monthView valueForKey:@"leftArrow"];
    [_monthView performSelector:@selector(changeMonth:) withObject:button];
    self.currentMonthButton.selected = YES;
    self.nextMonthButton.selected = NO;
}

- (IBAction)clickNextMonthButton:(id)sender {
    if (self.nextMonthButton.selected == YES) {
        return;
    }
    
    UIButton *button = [_monthView valueForKey:@"rightArrow"];
    [_monthView performSelector:@selector(changeMonth:) withObject:button];
    
    self.nextMonthButton.selected = YES;
    self.currentMonthButton.selected = NO;
}

- (void) generateRandomDataForStartDate:(NSDate*)start endDate:(NSDate*)end{
	
	PPDebug(@"Delegate Range: %@ %@ %d",start,end,[start daysBetweenDate:end]);
	
	self.dataArray = [NSMutableArray array];
	
	NSDate *d = start;
	while(YES){
        [self.dataArray addObject:[NSNumber numberWithBool:YES]];
		
		TKDateInformation info = [d dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		info.day++;
		d = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		if([d compare:end]==NSOrderedDescending) break;
	}
	
}

- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView markTextsFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate
{
    NSMutableArray *texts = [[NSMutableArray alloc] init];

    // 计算这个时间离1970年1月1日0时0分0秒过去的天数。
    NSDate *d = startDate;
    
    while(YES){
//        if ([d compare:[NSDate date]] == NSOrderedAscending) {
//            [texts addObject:@""];
//        }else {
            [texts addObject:[self bookingStringWithDate:d]];
//        }
		
		TKDateInformation info = [d dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		info.day++;
		d = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		if([d compare:lastDate]==NSOrderedDescending) break;
	}
    
    return texts;
}

- (NSString*)bookingStringWithDate:(NSDate *)date
{
    int passDay = [date timeIntervalSince1970] / 86400;
    for (Booking *booking in _bookings) {
        if (passDay == booking.date / 86400) {
            if (booking.status == 1) {
                return @"未开售";
            }else if (booking.status == 2) {
                return [NSString stringWithFormat:@"%@\n%@", booking.adultPrice, booking.remainder];
            }else if (booking.status == 3) {
                return NSLS(@"满");
            }
        }
    }
    
    return @"";
}

- (CGSize)sizeForLatticeOfcalendarMonthView:(TKCalendarMonthView *)monthView
{
    return CGSizeMake(46, 68);
}

@end
