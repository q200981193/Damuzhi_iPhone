//
//  PersonalInfoController.m
//  Travel
//
//  Created by haodong on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PersonalInfoController.h"
#import "PersonalInfoCell.h"

enum{
    SECTION_0 = 0,
    SECTION_1 = 1,
    SECTION_COUNT = 2
};

#define ROWS_SECTION_0  2
#define ROWS_SECTION_1  2

#define TITLE_SECTION_0_ROW_0   NSLS(@"用户名:")
#define TITLE_SECTION_0_ROW_1   NSLS(@"昵    称:")

#define TITLE_SECTION_1_ROW_0   NSLS(@"密码修改")
#define TITLE_SECTION_1_ROW_1   NSLS(@"资料修改")

@interface PersonalInfoController ()

@property (retain ,nonatomic) NSString *userName;
@property (retain ,nonatomic) NSString *nickName;

@end

@implementation PersonalInfoController
@synthesize userName = _userName;
@synthesize nickName = _nickName;

- (void)dealloc
{
    PPRelease(_userName);
    PPRelease(_nickName);
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    self.navigationItem.title = NSLS(@"个人资料");
    
    [self setNavigationRightButton:NSLS(@"确定") 
                         imageName:@"topmenu_btn_right.png" 
                            action:@selector(clickOK:)];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:218.0/255.0 green:226.0/255.0 blue:228.0/255.0 alpha:1]];
    
    UITapGestureRecognizer* singleTapRecognizer;
    singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom:)];
    singleTapRecognizer.numberOfTapsRequired = 1; // For single tap
    [self.view addGestureRecognizer:singleTapRecognizer];
    [singleTapRecognizer release];
}

- (void)handleSingleTapFrom:(UITapGestureRecognizer*)recognizer {
    //[self hideKeyboard];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return SECTION_COUNT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case SECTION_0:
            return ROWS_SECTION_0;
            break;
        case SECTION_1:
            return ROWS_SECTION_1;
            break;
        default:
            break;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PersonalInfoCell getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [PersonalInfoCell getCellIdentifier];
    PersonalInfoCell *cell = [dataTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [PersonalInfoCell createCell:self];
    }
    
    cell.inputTextField.hidden = YES;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.section == SECTION_0) {
        if (indexPath.row == 0) {
            cell.inputTextField.hidden = NO;
            cell.inputTextField.placeholder = NSLS(@"请输入用户名");
            cell.titleLabel.text = TITLE_SECTION_0_ROW_0;
        } else if (indexPath.row == 1) {
            cell.inputTextField.hidden = NO;
            cell.inputTextField.placeholder = NSLS(@"请输入昵称");
            cell.titleLabel.text = TITLE_SECTION_0_ROW_1;
        }
        
    } else if (indexPath.section == SECTION_1) {
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.titleLabel.text = TITLE_SECTION_1_ROW_0;
        } else if (indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.titleLabel.text = TITLE_SECTION_1_ROW_1;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)clickOk:(id)sender
{
    
}

@end
