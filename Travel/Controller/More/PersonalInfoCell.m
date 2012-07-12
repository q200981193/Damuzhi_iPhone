//
//  PersonalInfoCell.m
//  Travel
//
//  Created by haodong on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PersonalInfoCell.h"
#import "LogUtil.h"

@interface PersonalInfoCell()

@end

@implementation PersonalInfoCell
@synthesize backgroundImageVeiw;
@synthesize titleLabel;
@synthesize inputTextField;
@synthesize pointImageView;
@synthesize personalInfoCellDelegate;

- (void)dealloc {
    [titleLabel release];
    [inputTextField release];
    [backgroundImageVeiw release];
    [pointImageView release];
    [super dealloc];
}


#pragma mark: implementation of PPTableViewCellProtocol
+ (NSString*)getCellIdentifier
{
    return @"PersonalInfoCell";
}

+ (CGFloat)getCellHeight
{
    return 44.0f;
}

- (void)setCellIndexPath:(NSIndexPath *)aIndexPath
{
    self.indexPath = aIndexPath;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([personalInfoCellDelegate respondsToSelector:@selector(inputTextFieldDidBeginEditing:)]) {
        [personalInfoCellDelegate inputTextFieldDidBeginEditing:self.indexPath];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([personalInfoCellDelegate respondsToSelector:@selector(inputTextFieldDidEndEditing:)]) {
        [personalInfoCellDelegate inputTextFieldDidEndEditing:self.indexPath];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([personalInfoCellDelegate respondsToSelector:@selector(inputTextFieldShouldReturn:)]) {
        [personalInfoCellDelegate inputTextFieldShouldReturn:self.indexPath];
    }
    
    return YES;
}

@end
