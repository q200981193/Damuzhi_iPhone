//
//  PersonalInfoCell.h
//  Travel
//
//  Created by haodong on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PPTableViewCell.h"

@interface PersonalInfoCell : PPTableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *backgroundImageVeiw;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UITextField *inputTextField;


@end
