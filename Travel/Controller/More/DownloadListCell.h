//
//  DownloadListCell.h
//  Travel
//
//  Created by 小涛 王 on 12-3-7.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewCell.h"

@interface DownloadListCell : PPTableViewCell<PPTableViewCellProtocol>


@property (retain, nonatomic) IBOutlet UIButton *downloadFlagButton;
@property (retain, nonatomic) IBOutlet UIProgressView *downloadProgressView;
@property (retain, nonatomic) IBOutlet UILabel *downloadPersentLable;
@property (retain, nonatomic) IBOutlet UIButton *downloadButton;
@property (retain, nonatomic) IBOutlet UIButton *onlineButton;
@property (retain, nonatomic) IBOutlet UILabel *cityNameLable;


@end
