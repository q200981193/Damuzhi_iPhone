//
//  DownloadListCell.h
//  Travel
//
//  Created by 小涛 王 on 12-3-7.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewCell.h"
#import "App.pb.h"

@interface DownloadListCell : PPTableViewCell<PPTableViewCellProtocol>
{
    City *_city;
    NSNumber *_downloading;
}

@property (retain, nonatomic) City *city;
@property (retain, nonatomic) NSNumber *downloading;

@property (retain, nonatomic) IBOutlet UIButton *downloadFlagButton;
@property (retain, nonatomic) IBOutlet UILabel *dataSizeLabel;
@property (retain, nonatomic) IBOutlet UIProgressView *downloadProgressView;
@property (retain, nonatomic) IBOutlet UILabel *downloadPersentLabel;
@property (retain, nonatomic) IBOutlet UIButton *downloadButton;
@property (retain, nonatomic) IBOutlet UIButton *onlineButton;
@property (retain, nonatomic) IBOutlet UILabel *cityNameLabel;

- (void)setCellData:(City*)city downloading:(NSNumber*)downloading;

@end
