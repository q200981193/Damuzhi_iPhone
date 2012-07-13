//
//  PersonalInfoController.m
//  Travel
//
//  Created by haodong on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PersonalInfoController.h"
#import "PersonalInfoCell.h"
#import "ImageManager.h"
#import "ChangePasswordController.h"
#import "UserManager.h"
#import "StringUtil.h"

enum{
    SECTION_0 = 0,
    SECTION_1 = 1,
};


#define ROW_LOGINID   0
#define ROW_MODIFY_PASSWORD   1

#define ROW_NICKNAME   0
#define ROW_FULLNAME  1
#define ROW_EMAIL  2
#define ROW_TELEPHONE  2

#define SEPRATOR_STRING @"|"

#define TITLE_LOGINID       NSLS(@"用户名:")
#define TITLE_EMAIL         NSLS(@"邮   箱:|请输入您的邮箱地址")
#define TITLE_TELEPHONE     NSLS(@"手机号码:|请输入您的电话号码")

#define TITLE_MODIFY_PASSWORD NSLS(@"密码修改")

#define TITLE_NICKNAME   NSLS(@"昵   称:|请输入您的昵称")
#define TITLE_FULLNAME   NSLS(@"姓   名:|请输入您的真实姓名")
//
//#define NICKNAME_PLACEHOLDER    NSLS(@"请输入您的昵称")
//#define FULLNAME_PLACEHOLDER    NSLS(@"请输入您的真实姓名")
//#define TELEPHONE_PLACEHOLDER   NSLS(@"请输入您的电话号码")
//#define EMAIL_PLACEHOLDER       NSLS(@"请输入您的邮箱地址")

@interface PersonalInfoController ()
{
    UITextField *_currentInputTextField;
}

@property (retain, nonatomic) NSString *nickName;
@property (retain, nonatomic) NSString *userName;
@property (retain, nonatomic) NSString *telephoneOrEmail;

@property (retain, nonatomic) NSMutableDictionary *sectionDic;


- (void)removeHideKeyboardButton;
- (void)addHideKeyboardButton;
- (void)clickHideKeyboardButton:(id)sender;
@end


@implementation PersonalInfoController
@synthesize userName = _userName;
@synthesize nickName = _nickName;
@synthesize telephoneOrEmail = _telephoneOrEmail;
@synthesize sectionDic = _sectionDic;

- (void)dealloc
{
    PPRelease(_userName);
    PPRelease(_nickName);
    PPRelease(_telephoneOrEmail);
    PPRelease(_sectionDic);
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
                            action:@selector(clickQuit:)];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"all_page_bg2.jpg"]]];
    
    
    self.sectionDic = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *section0Dic = [NSMutableDictionary dictionary];
    NSMutableDictionary *section1Dic = [NSMutableDictionary dictionary];
    
    [section0Dic setObject:TITLE_LOGINID forKey:[NSNumber numberWithInt:ROW_LOGINID]];
    [section0Dic setObject:TITLE_MODIFY_PASSWORD forKey:[NSNumber numberWithInt:ROW_MODIFY_PASSWORD]];

    [section1Dic setObject:TITLE_NICKNAME forKey:[NSNumber numberWithInt:ROW_NICKNAME]];
    [section1Dic setObject:TITLE_FULLNAME forKey:[NSNumber numberWithInt:ROW_FULLNAME]];
    
    if ( [[UserManager defaultManager] loginId]) {
        [section1Dic setObject:TITLE_EMAIL forKey:[NSNumber numberWithInt:ROW_EMAIL]];
    }else{
        [section1Dic setObject:TITLE_TELEPHONE forKey:[NSNumber numberWithInt:ROW_TELEPHONE]];
    }
    
    [self.sectionDic setObject:section0Dic forKey:[NSNumber numberWithInt:0]];
    [self.sectionDic setObject:section1Dic forKey:[NSNumber numberWithInt:1]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionDic count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_sectionDic objectForKey:[NSNumber numberWithInt:section]] count];
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
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
    cell.aDelegate = self;
    cell.indexPath = indexPath;
    
    NSString *title = [[_sectionDic objectForKey:[NSNumber numberWithInt:indexPath.section]] objectForKey:[NSNumber numberWithInt:indexPath.row]];
    
    NSArray *strArr = [title componentsSeparatedByString:SEPRATOR_STRING];
    
    if ([strArr count] == 1) {
        cell.titleLabel.text = [strArr objectAtIndex:0];
        cell.inputTextField.hidden = YES;
    }
    if ([strArr count] >=2) {
        cell.titleLabel.text = [strArr objectAtIndex:0];
        cell.inputTextField.placeholder = [strArr objectAtIndex:1];
    }
    
    if ([title isEqualToString:TITLE_LOGINID]) {
        cell.inputTextField.enabled = NO;
    }
    
    if ([title isEqualToString:TITLE_MODIFY_PASSWORD]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonalInfoCell *cell = (PersonalInfoCell *)[dataTableView cellForRowAtIndexPath:indexPath];
    NSString *title = cell.titleLabel.text;
    
    if ([title isEqualToString:TITLE_MODIFY_PASSWORD]) {
        ChangePasswordController *contrller = [[ChangePasswordController alloc] init];
        [self.navigationController pushViewController:contrller animated:YES];
        [contrller release];
    }
}


//
////hide the keyboard when "Done" is tapped.
//- (void)inputTextFieldShouldReturn:(NSIndexPath *)aIndexPath
//{
//    [_currentInputTextField resignFirstResponder];
//}
//
//
//- (void)clickQuit:(id)sender
//{
//    [_currentInputTextField resignFirstResponder];   
//}

#pragma mark - PersonalInfoCellDelegate methods
- (void)inputTextFieldDidBeginEditing:(NSIndexPath *)aIndexPath
{
//    [self addHideKeyboardButton];
    
    PersonalInfoCell * cell = (PersonalInfoCell*)[dataTableView cellForRowAtIndexPath:aIndexPath];
    _currentInputTextField = cell.inputTextField;
}


- (void)inputTextFieldDidEndEditing:(NSIndexPath *)aIndexPath
{
    PersonalInfoCell * cell = (PersonalInfoCell*)[dataTableView cellForRowAtIndexPath:aIndexPath];
    _currentInputTextField = cell.inputTextField;
}

#define HIDE_KEYBOARDBUTTON_TAG 77
#define TOP_HEIGHT 100
- (void)removeHideKeyboardButton
{
    UIButton *button = (UIButton*)[self.view viewWithTag:HIDE_KEYBOARDBUTTON_TAG];
    [button removeFromSuperview];
}

//- (void)addHideKeyboardButton
//{
//    [self removeHideKeyboardButton];
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, TOP_HEIGHT, self.view.frame.size.width, self.view.frame.size.height-TOP_HEIGHT)];
//    button.tag = HIDE_KEYBOARDBUTTON_TAG;
//    [button addTarget:self action:@selector(clickHideKeyboardButton:) forControlEvents:UIControlEventAllTouchEvents];
//    [self.view addSubview:button];
//    [button release];
//}

//- (void)clickHideKeyboardButton:(id)sender
//{
//    [_currentInputTextField resignFirstResponder];
//    [self removeHideKeyboardButton];
//}


@end
