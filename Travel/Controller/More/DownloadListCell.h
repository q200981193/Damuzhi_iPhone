//
//  CityListCell.h
//  Travel
//
//  Created by 小涛 王 on 12-3-7.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewCell.h"
#import "App.pb.h"

@protocol  DownloadListCellDelegate <NSObject>
@optional
- (void)didDeleteCity:(City*)city;
- (void)didUpdateCity:(City*)city;
@end

@interface DownloadListCell : PPTableViewCell<PPTableViewCellProtocol>

@property (retain, nonatomic) City *city;
@property (assign, nonatomic) NSObject<DownloadListCellDelegate>* downloadListCellDelegate;

@property (retain, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (retain, nonatomic) IBOutlet UIButton *updateButton;
@property (retain, nonatomic) IBOutlet UIButton *deleteButton;
@property (retain, nonatomic) IBOutlet UILabel *dataSizeLabel;
@property (retain, nonatomic) IBOutlet UILabel *defaultLabel;

- (void)setCellData:(City*)city;

@end
