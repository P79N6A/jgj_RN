//
//  JGJGroupChatSelelctedMembersVc.m
//  mix
//
//  Created by yj on 16/12/22.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJGroupChatSelelctedMembersVc.h"
#import "JGJGroupChatSelectedMemberCell.h"
#import "JGJChatRootVc.h"
#import "JGJGroupChatSelelctedMemberHeadView.h"
#import "JGJPerInfoVc.h"
#import "TYTextField.h"
#import "JGJSearchResultView.h"
#import "JGJImageModelView.h"
#import "CustomAlertView.h"
#import "NSString+Extend.h"

#import "JGJGroupMangerTool.h"

#import "DSectionIndexView.h"

#import "DSectionIndexItemView.h"

#import "JGJAddressBookTool.h"

#import "JGJComDefaultView.h"

#import "JGJCreatTeamVC.h"

#import "JGJChatMsgDBManger+JGJGroupDB.h"

#import "JGJCheckGroupChatAllMemberVc.h"
#import "JGJKnowledgeDaseTool.h"
#import "JGJCustomProInfoAlertVIew.h"

#define RowH 87
#define HeaderH 35
#define Padding 15
#define LinViewH 7
#define Selelcted
#define ShowCount 10
#define kSectionIndexWidth 20.f
#define kSectionIndexHeight 450.f
#define IndexPadding 5
#define OffsetY 75

#define HeadViewTitleH 50
@interface JGJGroupChatSelelctedMembersVc ()<
    UITextFieldDelegate,
    UITableViewDelegate,
    UITableViewDataSource,

    JGJSearchResultViewdelegate,

    JGJGroupChatSelelctedMemberHeadViewDelegate,

    ClickPeopleItemButtondelegate,

    DSectionIndexViewDataSource,

    DSectionIndexViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray <JGJSynBillingModel *>*members;
@property (weak, nonatomic) IBOutlet UIButton *groupChatButton;
@property (strong, nonatomic) NSMutableArray *selectedMembers;

@property (weak, nonatomic) IBOutlet UIView *contentGroupChatButtonView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentGroupChatButtonViewH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSearchBarViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSearchBarViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonW;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet LengthLimitTextField *searchBarTF;
@property (strong, nonatomic) JGJSearchResultView *searchResultView;
@property (assign, nonatomic) BOOL isAllSelected; //是否全选中
@property (weak, nonatomic) IBOutlet UIView *contentSelectedMemberView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSelectedMemberViewH;

@property (strong, nonatomic) JGJImageModelView *imageModelView;
@property (strong, nonatomic) JGJAddGroupMemberRequestModel *addGroupMemberRequestModel;
@property (strong, nonatomic) JGJGroupChatSelelctedMemberHeadView *selectedMemberHeadView;//选择人员头部
@property (copy, nonatomic) NSString *buttonTitle;

@property (retain, nonatomic) DSectionIndexView *sectionIndexView;

@property (nonatomic,strong) UILabel *centerShowLetter;

@property (nonatomic, strong) NSArray *contactsLetters;//包含首字母

//排序数据
@property (nonatomic, strong) JGJAddressBookSortContactsModel *sortContactsModel;

@property (nonatomic, strong) JGJComDefaultView *defaultView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSearchH;

@property (weak, nonatomic) IBOutlet UIView *containSearchView;

//备份搜索数据
@property (strong, nonatomic) NSArray *backUpdataArr;

//没有被添加的人员
@property (strong, nonatomic) NSMutableArray *remainMembers;

//分享菜单
@property (nonatomic, strong) JGJKnowledgeDaseTool *shareMenuTool;

@end

@implementation JGJGroupChatSelelctedMembersVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择成员";
    
    //3.4 错误 #15505
    if (self.contactedAddressBookVcType == JGJContactedAddressBookAddDefaultType) {

        self.title = @"项目成员";

    }else if (self.isRecordSelMembers) {
        
        self.title = @"选择班组成员";
    }
    
    [self commonSet];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self handleSearchBarViewMoveDown];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self handleSearchBarViewMoveDown];
}

- (void)commonSet {
    self.searchBarTF.layer.borderWidth = 0;
    self.searchBarTF.layer.cornerRadius = 3;
    self.searchBarTF.layer.borderColor = TYColorHex(0Xf3f3f3).CGColor;
    self.searchBarTF.backgroundColor = TYColorHex(0Xf3f3f3);
    self.view.backgroundColor = AppFontf1f1f1Color;
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    BOOL isAddMember = self.contactedAddressBookVcType == JGJContactedAddressBookAddMembersVcType || self.contactedAddressBookVcType == JGJGroupMangerAddMembersVcType || self.contactedAddressBookVcType == JGJTeamMangerAddMembersVcType || self.contactedAddressBookVcType == JGJCreatGroupAddMemberType;
    if (isAddMember) {
        [self.groupChatButton setTitle:@"确定" forState:UIControlStateNormal];
        self.buttonTitle = @"确定";
    }else {
    
//        self.buttonTitle = @"进入群聊";
    }

    JGJGroupChatSelelctedMemberHeadView *headerView = [[JGJGroupChatSelelctedMemberHeadView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, HeadViewTitleH)];
    self.selectedMemberHeadView = headerView;
    headerView.chatType = self.chatType;
    headerView.groupListModel = self.groupListModel;
    headerView.delegate = self;
    self.tableView.tableHeaderView = headerView;
    self.cancelButtonW.constant = 12;
    self.cancelButton.hidden = YES;
    self.searchBarTF.maxLength = 20;
    UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search-icon"]];
    searchIcon.contentMode = UIViewContentModeCenter;
    searchIcon.width = 33;
    searchIcon.height = 33;
    self.searchBarTF.leftViewMode = UITextFieldViewModeAlways;
    self.searchBarTF.leftView = searchIcon;
    [self.contentSelectedMemberView addSubview:self.imageModelView];
    __weak typeof(self) weakSelf = self;
    self.searchBarTF.valueDidChange = ^(NSString *value){
        
        if (![NSString isEmpty:value]) {
            
            [weakSelf searchValueChange:value];
            
        }else {
            
             weakSelf.tableView.tableHeaderView = nil;
        }
        
    };
    [self.groupChatButton.layer setLayerCornerRadius:JGJCornerRadius];

    [self loadGroupChatMemberList];
    
    //显示底部按钮情况
    [self showBottomGroupChatButton];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [JGJGroupChatSelectedMemberCell chatSelectedMemberCellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sortContactsModel.sortContacts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    SortFindResultModel *sortFindResultModel = self.sortContactsModel.sortContacts[section];
    
    return sortFindResultModel.findResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJGroupChatSelectedMemberCell *cell = [JGJGroupChatSelectedMemberCell cellWithTableView:tableView];
    cell.chatType = self.chatType;
    
    SortFindResultModel *sortFindResultModel = self.sortContactsModel.sortContacts[indexPath.section];
    
    JGJSynBillingModel *contactModel = sortFindResultModel.findResult[indexPath.row];
    
    cell.isMoveActiveButton = _contactsLetters.count  > ShowCount; //不移动不是平台标识
    
    contactModel.indexPathMember = indexPath;
    cell.groupChatMemberModel = contactModel;
    cell.lineView.hidden = indexPath.row == sortFindResultModel.findResult.count - 1;
    
    TYWeakSelf(self);
    cell.clickUnRegesterWithModel = ^(JGJSynBillingModel *model) {
        
      BOOL isActiveMember = [model.is_active isEqualToString:@"1"];
        JGJTeamMemberCommonModel *commonModel = [[JGJTeamMemberCommonModel alloc] init];
        commonModel.teamModelModel = model;
        if (!isActiveMember) {// 未注册
            
            commonModel.alertViewHeight = 210.0;
            
            commonModel.alertmessage = @"该用户还未注册,赶紧邀请他下载[吉工家]一起使用吧！";
            
            commonModel.alignment = NSTextAlignmentLeft;
            
            JGJCustomProInfoAlertVIew *alertView = [JGJCustomProInfoAlertVIew alertViewWithCommonModel:commonModel];
            
            if (!weakself.shareMenuTool) {
                
                weakself.shareMenuTool = [[JGJKnowledgeDaseTool alloc] init];
                
                weakself.shareMenuTool.targetVc  = weakself;
                
                weakself.shareMenuTool.isUnCanShareCount = YES; //不清零
            }
            
            
            alertView.confirmButtonBlock = ^{
                
                NSString *img = [NSString stringWithFormat:@"%@%@", JLGHttpRequest_IP_center, @"media/default_imgs/logo.jpg"];
                
                NSString *uid = [TYUserDefaults objectForKey:JLGUserUid];
                
                NSString *url =[NSString stringWithFormat:@"%@page/open-invite.html?uid=%@&plat=person", JGJWebDiscoverURL,uid];;
                
                NSString *title = @"我正在用招工找活、记工记账神器：吉工家APP";
                
                NSString *desc = @"1200万建筑工友都在用！下载注册就送100积分抽百元话费！";
                
                [weakself.shareMenuTool showShareBtnClick:img desc:desc title:title url:url];
            };
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    SortFindResultModel *sortFindResultModel = self.sortContactsModel.sortContacts[indexPath.section];
    
    JGJSynBillingModel *memberModel = sortFindResultModel.findResult[indexPath.row];

    //记账选择人员回调
    if (self.selelctedMembersVcBlock) {
        
        self.selelctedMembersVcBlock(memberModel);
        
        return;
    }
    
    // 是否注册
    BOOL isActiveMember = [memberModel.is_active isEqualToString:@"1"];
    
    if (self.chatType == JGJSingleChatType && isActiveMember) {
        
        JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
        perInfoVc.jgjChatListModel.uid = memberModel.uid;
        perInfoVc.jgjChatListModel.group_id = self.groupListModel.group_id;
        perInfoVc.jgjChatListModel.class_type = self.groupListModel.class_type;
        [self.navigationController pushViewController:perInfoVc animated:YES];
        
    }else if (self.chatType == JGJGroupChatType) { //群聊添加人员全部可以选
        
        if (!memberModel.is_exist) {
            
            memberModel.isSelected = !memberModel.isSelected;
            
            if (memberModel.isSelected) {
                
                [self.selectedMembers addObject:memberModel];
                
            }else {
                
                [self.selectedMembers removeObject:memberModel];
                
            }
            
            [self showBottomGroupChatButton];
            
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        }
        
    }else if (self.chatType == JGJSingleChatType && !isActiveMember) {
        
        [TYShowMessage showPlaint:@"TA还没加入吉工家，没有更多资料了"];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return _members.count == 0 ? CGFLOAT_MIN : HeaderH;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = AppFontf1f1f1Color;
    UILabel *firstLetterLable = [[UILabel alloc] init];
    firstLetterLable.backgroundColor = [UIColor clearColor];
    firstLetterLable.font = [UIFont systemFontOfSize:AppFont32Size];
    firstLetterLable.frame = CGRectMake(Padding, 0, TYGetViewW(self.view), HeaderH);
    SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[section];
    
    if (sortFindResult.findResult.count > 0) {
        
        NSString *firstLetter = sortFindResult.firstLetter.uppercaseString;
        
        firstLetterLable.text = firstLetter;
    }

    firstLetterLable.textColor = AppFontccccccColor;
    
    [headerView addSubview:firstLetterLable];
    
    return headerView;

}

#pragma mark - otherMethod
- (void)showBottomGroupChatButton {

    if (self.selectedMembers.count > 0) {
        
        self.imageModelView.DataMutableArray = self.selectedMembers;
        
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"is_exist!=%@",@(YES)];
//        
//        NSArray *unExistMembers = [self.members filteredArrayUsingPredicate:predicate];
        
        //记账选多人情况
        
        if (self.isRecordSelMembers) {
            
            self.selectedMemberHeadView.selectedButton.selected = self.selectedMembers.count == self.members.count;
            
        }else {
            
            self.selectedMemberHeadView.selectedButton.selected = self.selectedMembers.count == self.remainMembers.count;
            
        }
        
    }else {
        
        self.selectedMemberHeadView.selectedButton.selected = NO;
    }
    
    TYLog(@"selectedMembers=== %ld members==== %ld", self.selectedMembers.count, self.members.count);

    self.contentSelectedMemberView.hidden = YES;
    self.contentSelectedMemberViewH.constant = 0;
    self.groupChatButton.enabled = NO;
    self.groupChatButton.backgroundColor = TYColorHex(0xaaaaaa);
    NSString *buttonTitle = nil;
    if (self.selectedMembers.count > 0) {

        self.contentSelectedMemberView.hidden = NO;
        
        self.contentSelectedMemberViewH.constant = 45;
        
        self.groupChatButton.backgroundColor = AppFontd7252cColor;
        
        self.groupChatButton.enabled = YES;
        
    }else {

        self.contentSelectedMemberView.hidden = YES;
        
        self.contentSelectedMemberViewH.constant = 0;
        //通讯录项目 没有底部按钮。单选人员
        if (self.contactedAddressBookVcType == JGJContactedAddressBookAddDefaultType) {
            
            self.contentGroupChatButtonViewH.constant = 0;
            
            self.contentGroupChatButtonView.hidden = YES;
            
        }

    }
    
    switch (self.contactedAddressBookVcType) {
        case JGJSingleChatCreatGroupChatVcType:
        case JGJLaunchGroupChatVcType:
        case JGJContactedAddressBookAddDefaultType:{
            
            if (self.selectedMembers.count == 0) {
                
                buttonTitle = @"进入群聊";
                
            }else {
                
               buttonTitle = [NSString stringWithFormat:@"进入群聊 (%@)", @(self.selectedMembers.count)];
            }
            
            self.buttonTitle = buttonTitle;
        }
            break;
        case JGJContactedAddressBookAddMembersVcType:
        case JGJGroupMangerAddMembersVcType:
        case JGJCreatGroupAddMemberType:
        case JGJTeamMangerAddMembersVcType:{
            
            if (self.selectedMembers.count == 0) {
                
                buttonTitle = @"确定";
                
            }else {
                
                buttonTitle = [NSString stringWithFormat:@"确定 (%@)", @(self.selectedMembers.count)];
            }
            
            self.buttonTitle = buttonTitle;
        }
            break;
        default:
            break;
    }

    [self.groupChatButton setTitle:self.buttonTitle forState:UIControlStateNormal];
    
}

- (void)loadGroupChatMemberList {
    
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    
    NSPredicate *predicate = nil;
    
    NSString *class_type = self.groupListModel.class_type;
    
    NSMutableDictionary *parameters = @{
                                        @"class_type" : class_type,
                                        
                                        @"group_id" : self.groupListModel.group_id?:@""
                                        
                                        }.mutableCopy;
    switch (self.contactedAddressBookVcType) {
        case JGJSingleChatCreatGroupChatVcType:
        case JGJContactedAddressBookAddMembersVcType:
        case JGJLaunchGroupChatVcType:{
            
            //排除未注册人员
//            [parameters setObject:@"1" forKey:@"is_active"];
//排除自己和未注册
            predicate = [NSPredicate predicateWithFormat:@"uid!=%@ and is_active!=%@", myUid,@"0"];
            
        }

            break;
        case JGJGroupMangerAddMembersVcType:
        case JGJTeamMangerAddMembersVcType:{
            
            //班组、项目添加人员显示未注册人员
//            [parameters setObject:@"0" forKey:@"is_active"];
            
            predicate = [NSPredicate predicateWithFormat:@"uid!=%@", myUid];
            
        }
            break;
        default:
            break;
    }
//    //排除自己
//    [parameters setObject:@"1" forKey:@"is_exclude_self"];
//
//    if (self.contactedAddressBookVcType == JGJContactedAddressBookAddDefaultType) {
//
//        [parameters setObject:@"0" forKey:@"is_exclude_self"];
//
//    }
//    //排除已添加的人员
//    [parameters setObject:self.groupListModel.cur_group_id?:@"" forKey:@"cur_group_id"];
//
//    [parameters setObject:self.groupListModel.cur_class_type?:@"" forKey:@"cur_class_type"];
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:JGJGetMembersListURL parameters:parameters success:^(id responseObject) {
       
        NSArray *members = [JGJSynBillingModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        //非记账选人状态（班组设置，项目设置群聊设置加人）
        
        if (predicate && !self.isRecordSelMembers) {

            members = [members filteredArrayUsingPredicate:predicate];
        }

        self.members = members.mutableCopy;
        
        [TYLoadingHub hideLoadingView];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
    
}

- (void)setMembers:(NSMutableArray<JGJSynBillingModel *> *)members {
    
    _members = members;
    
    _members = [self remainMembersWithMembers:members];
    
    //搜索使用
    
    self.backUpdataArr = _members.mutableCopy;
    
    if (_members.count == 0) {
        
        self.tableView.tableHeaderView = self.defaultView;
        
        self.topSearchH.constant = 0;
        
        self.containSearchView.hidden = YES;
        
        self.contentGroupChatButtonViewH.constant = 0;
        
        self.contentGroupChatButtonView.hidden = YES;
        
    }
    
    NSUInteger allMember = [self.groupListModel.members_num integerValue];
    
    if (_members.count > 0 && allMember > members.count + 1 && self.contactedAddressBookVcType != JGJTeamMangerAddMembersVcType && self.contactedAddressBookVcType != JGJGroupMangerAddMembersVcType) { //加1是自己
        
        [self setFooterViewCount:_members.count];
        
    }
    
    if (_members.count > 0) {
        
        self.sortContactsModel = [JGJAddressBookTool addressBookToolSortContcts:_members];
        
        self.contactsLetters = self.sortContactsModel.contactsLetters;
    }
    
    [self.tableView reloadData];
}

#pragma mark - 创建班组排除剩余人员
- (NSMutableArray *)remainMembersWithMembers:(NSMutableArray *)members {
    
    //数据来源人和普通成员
    
    NSArray *existMembers = self.commonModel.memberType == JGJProSourceMemberType ? self.teamInfo.source_members : self.teamInfo.member_list;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isMangerModel!=%@",@(YES)];
    
    existMembers = [existMembers filteredArrayUsingPredicate:predicate];
    
    NSMutableString *uids = [[NSMutableString alloc] init];
    
//    if (![NSString isEmpty:self.groupListModel.member_uids]) {
//
//        uids = self.groupListModel.member_uids.mutableCopy;
//
//    }
    
    
    if (existMembers.count > 0) {
        
        for (JGJSynBillingModel *existMember in existMembers) {
            
            [uids appendFormat:@"%@",[NSString stringWithFormat:@"%@,", existMember.telephone]];
            
            if (!self.isRecordSelMembers) {
                
                existMember.is_exist = YES;
                
            }
            
        }
        
    }

    NSMutableArray *remainMembers = [NSMutableArray new];
    
    for (JGJSynBillingModel *teamMember in members) {

        if (![NSString isEmpty:teamMember.telephone]) {
            
            if (![uids containsString:teamMember.telephone]) {
                
                [remainMembers addObject:teamMember];
                
                teamMember.is_exist = NO;
                
            }else {
                
                if (self.isRecordSelMembers) {
                    
                    teamMember.isSelected = YES;
                    
                    [self.selectedMembers addObject:teamMember];
                    
                }else {
                    
                    teamMember.is_exist = YES;
                    
                }
            }
        }
        
    }
    
    //记账选择多人
    
    if (self.isRecordSelMembers && self.selectedMembers.count > 0) {
        
        [self showBottomGroupChatButton];
        
    }
    
    //没有被添加的人员，用于全选标记
    
    self.remainMembers = remainMembers.mutableCopy;
    
//    [remainMembers addObjectsFromArray:members];
    
    return members;
}

#pragma mark - 设置底部数据
- (void)setFooterViewCount:(NSUInteger)count {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 40)];
    footerView.backgroundColor = AppFontf1f1f1Color;
    UILabel *memberNumLable = [[UILabel alloc] initWithFrame:footerView.bounds];
    memberNumLable.textAlignment = NSTextAlignmentCenter;
    memberNumLable.backgroundColor = AppFontf1f1f1Color;
    memberNumLable.textColor = AppFont999999Color;
    memberNumLable.font = [UIFont systemFontOfSize:AppFont26Size];
    [footerView addSubview:memberNumLable];
    self.tableView.tableFooterView = footerView;
    memberNumLable.text = @"项目中未加入吉工家的成员不能加入群聊";
}

#pragma mark - buttonActon
- (IBAction)handleGroupChatButtonAction:(UIButton *)sender {
    switch (self.contactedAddressBookVcType) {
        case JGJSingleChatCreatGroupChatVcType://单聊详情发起群聊
        case JGJLaunchGroupChatVcType:
        case JGJContactedAddressBookAddDefaultType:
            [self handleCreatGroupChatRequest]; //默认创建群聊
            break;
        case JGJContactedAddressBookAddMembersVcType:
            [self handleJoinExistGroupChatAddMembers]; //从群聊信息添加人员
            break;
        case JGJTeamMangerAddMembersVcType:
        case JGJGroupMangerAddMembersVcType:
            [self handleJoinExistGroupAddMembers]; //从班组或者项目管理添加人员
            break;
            
        case JGJCreatGroupAddMemberType:
            
            [self creatGroupAddmembers];
            
            break;
            
        default:
            break;
    }
}

#pragma mark - 创建班组添加人员
- (void)creatGroupAddmembers {
    
    for (JGJCreatTeamVC *creatTeamVc in self.navigationController.viewControllers) {
        
        if ([creatTeamVc isKindOfClass:NSClassFromString(@"JGJCreatTeamVC")]) {
            
            [creatTeamVc handleJGJGroupMemberSelectedTeamMembers:self.selectedMembers groupMemberMangeType:JGJGroupMemberMangeAddMemberType];
    
            [self.navigationController popToViewController:creatTeamVc animated:YES];
    
            break;
        }
        
    }
}

- (void)handleCreatGroupChatRequest {
    NSMutableString *membersUidStr = [NSMutableString string];
    
    NSMutableArray *memberIds = [[NSMutableArray alloc] init];
    
    for (JGJSynBillingModel *memberModel in self.selectedMembers) {
        
        [memberIds addObject:memberModel.uid];
        
    }
    
    membersUidStr = [memberIds componentsJoinedByString:@","].mutableCopy;
    
//    if (self.contactedAddressBookVcType == JGJSingleChatCreatGroupChatVcType) { //单聊发起群聊加入聊天对象的Uid
//        
//        NSString *uids = [NSMutableString stringWithFormat:@",%@", self.groupListModel.cur_group_id?:@""];
//        
//        [membersUidStr appendString:uids];
//    }
    
    NSDictionary *parameters = @{
                                 
                                 @"uid" : membersUidStr?:@"",
                                 
                                 };
    
    __weak typeof(self) weakSelf = self;
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:JGJCreateChatURL parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        JGJMyWorkCircleProListModel *groupChatModel = [JGJMyWorkCircleProListModel mj_objectWithKeyValues:responseObject];
        
        [weakSelf popVcWithGroupChatModel:groupChatModel];
        
        JGJChatGroupListModel *groupModel = [JGJChatGroupListModel mj_objectWithKeyValues:[groupChatModel mj_JSONObject]];
        
        groupModel.max_asked_msg_id = @"0";
        
        groupModel.sys_msg_type = @"normal";
        
        groupModel.local_head_pic = [groupChatModel.members_head_pic mj_JSONString];
        
        [JGJChatMsgDBManger insertGroupDBWithGroupModel:groupModel isHomeVc:NO];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
    
}

#pragma mark - 选中人员加入已存在的群成功进入聊天页面
- (void)handleJoinExistGroupChatAddMembers {
    __weak typeof(self) weakSelf = self;

    NSMutableArray *groupMembersInfos = [NSMutableArray array];
    for (JGJSynBillingModel *teamMemberModel in self.selectedMembers) { //添加返回的成员需要上传的信息
        JGJGroupMembersRequestModel *membersModel = [[JGJGroupMembersRequestModel alloc] init];
        membersModel.real_name = teamMemberModel.real_name;
        membersModel.telephone = teamMemberModel.telephone;
        membersModel.uid = teamMemberModel.uid;
        [groupMembersInfos addObject:membersModel];
    } //获取姓名和电话
    
    NSString *group_members = [[JGJGroupMembersRequestModel mj_keyValuesArrayWithObjectArray:groupMembersInfos] mj_JSONString];
    
    self.addGroupMemberRequestModel.group_id = self.groupListModel.cur_group_id; //之前群id
    
    NSDictionary *parameters = [self.addGroupMemberRequestModel mj_keyValues];
    
    if (![NSString isEmpty:group_members]) {
        
        [parameters setValue:group_members forKey:@"group_members"];
    }
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:JGJAddMembersURL parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView:nil];
        
        [TYShowMessage showSuccess:@"添加成功"];
        
        JGJMyWorkCircleProListModel *groupListModel = [JGJMyWorkCircleProListModel new];
        
        groupListModel.group_id = weakSelf.groupListModel.cur_group_id;//进入之前的cur_group_id
        
        groupListModel.class_type = weakSelf.groupListModel.cur_class_type;
        
        groupListModel.members_num = weakSelf.groupListModel.cur_member_num;
        
        groupListModel.group_name = weakSelf.groupListModel.cur_group_name;
        
        groupListModel.creater_uid = [TYUserDefaults objectForKey:JLGUserUid];
        
//        [weakSelf handleJoinGroupChatWithGroupChatModel:groupListModel];
        
        [weakSelf popVcWithGroupChatModel:groupListModel];
        
    } failure:^(NSError *error) {
       
        [TYLoadingHub hideLoadingView:nil];
    }];
    
}

#pragma mark - 加入存在班组管理和项目管理
- (void)handleJoinExistGroupAddMembers {
    
    //记账选择人员回调
    
    if (self.isRecordSelMembers) {
        
        if (self.recordSelMembersVcBlock) {
            
            self.recordSelMembersVcBlock(self.selectedMembers);
        }
        
        return;
    }

    //添加人数限制2.3。0
    if ([self handleMaxSelMemberWithSelMembers:self.selectedMembers]) {
        
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    NSMutableArray *groupMembersInfos = [NSMutableArray array];
    for (JGJSynBillingModel *teamMemberModel in self.selectedMembers) { //添加返回的成员需要上传的信息
        JGJGroupMembersRequestModel *membersModel = [[JGJGroupMembersRequestModel alloc] init];
        membersModel.real_name = teamMemberModel.real_name;
        membersModel.telephone = teamMemberModel.telephone;
        membersModel.uid = teamMemberModel.uid;
        [groupMembersInfos addObject:membersModel];
    } //获取姓名和电话
    self.addGroupMemberRequestModel.group_id = self.groupListModel.cur_group_id; //被添加的班组或者项目
    
    //添加为数据来源人
    
    NSMutableDictionary *parameters = [self.addGroupMemberRequestModel mj_keyValues];
    
    //普通成员地址
    
    NSString *requestApi = JGJAddMembersURL;
    
    NSString *group_members = @"";
    
    NSString *source_members = @"";
    
    if (self.commonModel.memberType == JGJProSourceMemberType) {
        
        self.addGroupMemberRequestModel = [JGJAddGroupMemberRequestModel new];
        
//        self.addGroupMemberRequestModel.action = @"addSourceMember";
//
//        self.addGroupMemberRequestModel.ctrl = @"team";
        
        self.addGroupMemberRequestModel.class_type = @"team";
        
        self.addGroupMemberRequestModel.group_id = self.groupListModel.cur_group_id;
        
        self.addGroupMemberRequestModel.source_members = groupMembersInfos;
        
        //数据来人员地址
        
        requestApi = JGJGroupAddSourceMemberURL;
        
         source_members = [[JGJGroupMembersRequestModel mj_keyValuesArrayWithObjectArray:self.addGroupMemberRequestModel.source_members] mj_JSONString];
        
    }else {
        
        self.addGroupMemberRequestModel.group_members = groupMembersInfos;
        
        group_members = [[JGJGroupMembersRequestModel mj_keyValuesArrayWithObjectArray:self.addGroupMemberRequestModel.group_members] mj_JSONString];
    }
    
    parameters = [self.addGroupMemberRequestModel mj_keyValuesWithIgnoredKeys:@[@"group_members", @"source_members"]];
    
    if (![NSString isEmpty:group_members]) {
        
        parameters[@"group_members"] = group_members;
    }
    
    if (![NSString isEmpty:source_members]) {
        
        parameters[@"source_members"] = source_members;
    }
    
    //批量记账标记
    for (UIViewController *curVc in self.navigationController.viewControllers) {
        
        if ([curVc isKindOfClass:NSClassFromString(@"JGJMorePeopleViewController")]) {
            
            self.addGroupMemberRequestModel.is_batch = @"1";
            
            break;
        }
        
    }
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:requestApi parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView:nil];
        
        for (UIViewController *popVc in self.navigationController.viewControllers ) {
            if (weakSelf.contactedAddressBookVcType == JGJGroupMangerAddMembersVcType && [popVc isKindOfClass:NSClassFromString(@"JGJTeamMangerVC")]) {
                
                [weakSelf.navigationController popToViewController:popVc animated:YES];
                
                break;
            }else if (weakSelf.contactedAddressBookVcType == JGJTeamMangerAddMembersVcType && [popVc isKindOfClass:NSClassFromString(@"JGJGroupMangerVC")]) {
                
                [weakSelf.navigationController popToViewController:popVc animated:YES];
                
                break;
            }else if ([popVc isKindOfClass:NSClassFromString(@"JGJMorePeopleViewController")]) {  //记多人加成员返回
                
                [weakSelf.navigationController popToViewController:popVc animated:YES];
                
                break;
            }else if ([popVc isKindOfClass:NSClassFromString(@"JGJCheckGroupChatAllMemberVc")]) {  //首页成员管理添加人员
                
                JGJCheckGroupChatAllMemberVc *allMemberVc = (JGJCheckGroupChatAllMemberVc *)popVc;
                
                if (allMemberVc.successBlock) {
                    
                    allMemberVc.successBlock(responseObject);
                }
                
                [weakSelf.navigationController popToViewController:popVc animated:YES];
                
                break;
            }
            
        }
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView:nil];
    }];
    
}

#pragma mark - 进入群聊
- (void)handleJoinGroupChatWithGroupChatModel:(JGJMyWorkCircleProListModel *)groupChatModel {
    JGJChatRootVc *chatRootVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatRootCommonVc"];
    chatRootVc.workProListModel = groupChatModel; //进入群聊
    [self.navigationController pushViewController:chatRootVc animated:YES];
}

- (void)popVcWithGroupChatModel:(JGJMyWorkCircleProListModel *)groupChatModel {
    
    UIViewController *popVc = nil;
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:NSClassFromString(@"JGJCheckGroupChatAllMemberVc")]) {
            
            popVc = vc;
            
            break;
            
        }else if ([vc isKindOfClass:NSClassFromString(@"JGJGroupChatDetailInfoVc")]) {
            
            popVc = vc;
            
            break;
            
        }
        
    }
    
    if (!popVc) {
        
        [self handleJoinGroupChatWithGroupChatModel:groupChatModel];
        
//        [self.navigationController popViewControllerAnimated:YES];
        
    }else {
        
        [self.navigationController popToViewController:popVc animated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - JGJSearchResultViewdelegate

- (void)searchResultView:(JGJSearchResultView *)searchResultView didSelectedMember:(JGJSynBillingModel *)memberModel {
    memberModel.isSelected = !memberModel.isSelected;
    if (self.chatType == JGJSingleChatType) {
        JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
        perInfoVc.jgjChatListModel.uid = memberModel.uid;
        perInfoVc.jgjChatListModel.group_id = self.groupListModel.group_id;
        perInfoVc.jgjChatListModel.class_type = self.groupListModel.class_type;
        [self.navigationController pushViewController:perInfoVc animated:YES];
    }else if (self.chatType == JGJGroupChatType) { //发起群聊添加人员
        
        if (!memberModel.is_exist) {
         
            if (memberModel.isSelected) {
                
                [self.selectedMembers addObject:memberModel];
                
            }else {
                
                [self.selectedMembers removeObject:memberModel];
            }
            
        }
        
        [self showBottomGroupChatButton];
        
        [self.tableView reloadData];
        
        [self.searchResultView removeFromSuperview];
    }
    
    [self handleSearchBarViewMoveDown]; //选中之后恢复原来的状态
}

#pragma mark - JGJGroupChatSelelctedMemberHeadViewDelegate
- (void)JGJGroupChatSelelctedMemberHeadView:(JGJGroupChatSelelctedMemberHeadView *)headerView groupListModel:(JGJMyWorkCircleProListModel *)groupListModel {
    if (self.chatType == JGJSingleChatType) { //进来选择聊天，不选中
        return;
    }
//    self.isAllSelected = !self.isAllSelected;
    for (JGJSynBillingModel *memberModel in self.members) {
        
        if (!memberModel.is_exist) {
         
            memberModel.isSelected = headerView.selectedButton.selected;
            
        }
        
    }
    
    if (headerView.selectedButton.selected) {
        
        [self.selectedMembers removeAllObjects];
        
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"is_exist!=%@",@(YES)];
//
//        NSArray *unExistMembers = [self.members filteredArrayUsingPredicate:predicate];
        
        if (self.isRecordSelMembers) {
           
            [self.selectedMembers addObjectsFromArray:self.members];
            
        }else {
            
            [self.selectedMembers addObjectsFromArray:self.remainMembers];
        }
        
    }else {
        
        [self.selectedMembers removeAllObjects];
    }
    
    [self showBottomGroupChatButton];
    
    [self.tableView reloadData];
    
}

#pragma mark - ClickPeopleItemButtondelegate

- (void)ClickPeopleItem:(NSMutableArray *)ModelArray anIndexpath:(NSIndexPath *)indexpath deleteObeject:(JGJSynBillingModel *)deleteModel {
    deleteModel.isSelected = NO;
    if (self.selectedMembers.count > 0) {
        [self.selectedMembers removeObject:deleteModel];
    }
//    [self.tableView reloadRowsAtIndexPaths:@[deleteModel.indexPathMember] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView reloadData];
    
    [self showBottomGroupChatButton];
}

- (NSMutableArray *)selectedMembers {
    if (!_selectedMembers) {
        _selectedMembers = [NSMutableArray array];
    }
    return _selectedMembers;
}

- (void)searchValueChange:(NSString *)value {
    [self handleSearchBarMoveTop];
    if (![self.view.subviews containsObject:self.searchResultView] && ![NSString isEmpty:value]) {
        [self.view addSubview:self.searchResultView];
    }else if([self.view.subviews containsObject:self.searchResultView] && [NSString isEmpty:value]){
        [self.searchResultView removeFromSuperview];
    }
    self.searchResultView.searchValue = value;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"real_name contains %@ or telephone contains %@", value,value];
    NSMutableArray *contacts = [self.backUpdataArr filteredArrayUsingPredicate:predicate].mutableCopy;
    self.searchResultView.results = contacts;
    
}

#pragma mark - 电话号码
- (void)searchMemberTelephone:(NSString *)telephone {
    if (telephone.length <= 3) {
        self.searchResultView.results = @[];
        return;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"telephone contains %@", telephone];
    NSMutableArray *contacts = [self.members filteredArrayUsingPredicate:predicate].mutableCopy;
    self.searchResultView.results = contacts;
}

#pragma mark - 姓名
- (void)searchMemberName:(NSString *)name {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"real_name contains %@", name];
    NSMutableArray *contacts = [self.members filteredArrayUsingPredicate:predicate].mutableCopy;
    self.searchResultView.results = contacts;
}

- (JGJSearchResultView *)searchResultView {
    CGFloat searchResultViewY = 68.0;
    if (!_searchResultView) {
        JGJSearchResultView *searchResultView = [[JGJSearchResultView alloc] initWithFrame:(CGRect){{0,searchResultViewY},{TYGetUIScreenWidth,TYGetUIScreenHeight - searchResultViewY}}];
        searchResultView.resultViewType = JGJSearchMemberResultViewType;
        searchResultView.delegate = self;
        searchResultView.chatType = self.chatType;
        self.searchResultView = searchResultView;
    }
    return _searchResultView;
}

- (JGJImageModelView *)imageModelView {

    if (!_imageModelView) {
        CGRect rect = CGRectMake(0, 0, TYGetUIScreenWidth, 48.0);
        _imageModelView = [[JGJImageModelView alloc] initWithFrame:rect];
        _imageModelView.peopledelegate = self;
    }
    return _imageModelView;
}

#pragma mark - 初始化添加班组成员网络请求模型
- (JGJAddGroupMemberRequestModel *)addGroupMemberRequestModel {
    if (!_addGroupMemberRequestModel) {
        
        _addGroupMemberRequestModel = [[JGJAddGroupMemberRequestModel alloc] init];
        _addGroupMemberRequestModel.class_type = @"group";
        _addGroupMemberRequestModel.action = @"addMembers";
        _addGroupMemberRequestModel.client_type = @"person";
        _addGroupMemberRequestModel.class_type = @"groupChat";
        _addGroupMemberRequestModel.is_qr_code = @"0";//0通信录加入
        _addGroupMemberRequestModel.group_id = self.groupListModel.cur_group_id; //被添加的班组或者项目id
        switch (self.contactedAddressBookVcType) {
            case JGJContactedAddressBookAddMembersVcType:{
                  _addGroupMemberRequestModel.ctrl = @"group";
                _addGroupMemberRequestModel.class_type = @"groupChat";
            }
                break;
            case JGJGroupMangerAddMembersVcType:{
                _addGroupMemberRequestModel.ctrl = @"group";
                _addGroupMemberRequestModel.class_type = @"group";
            }
                break;
            case JGJTeamMangerAddMembersVcType:{
                 _addGroupMemberRequestModel.ctrl = @"team";
                _addGroupMemberRequestModel.class_type = @"team";
                _addGroupMemberRequestModel.group_id = self.groupListModel.cur_group_id; //被添加的项目id
            }
                break;
            default:
                break;
        }
    }
    return _addGroupMemberRequestModel;
}

- (IBAction)handleCancelButtonAction:(UIButton *)sender {
    [self handleSearchBarViewMoveDown];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    if (![NSString isEmpty:self.searchBarTF.text]) {
//        [self handleSearchBarMoveTop];
//    }
    [self handleSearchBarMoveTop];
    return YES;
}

- (void)handleSearchBarMoveTop {
    
    self.searchResultView.searchValue = nil;
    
    self.searchResultView.results = @[];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.navigationBarHidden = YES;
        self.cancelButtonW.constant = 45;
        self.cancelButton.hidden = NO;
        [self.view addSubview:self.searchResultView];
        [self.view layoutIfNeeded];
    }];
}

- (void)handleSearchBarViewMoveDown {
    self.searchBarTF.text = nil;
    [self.searchBarTF resignFirstResponder];
    [self.view endEditing:YES];
    self.navigationController.navigationBarHidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.cancelButtonW.constant = 12;
        self.cancelButton.hidden = YES;
        [self.searchResultView removeFromSuperview];
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 处理最大可选人数

- (BOOL)handleMaxSelMemberWithSelMembers:(NSArray *)selMembers {
    
    NSUInteger allMemberNum = self.teamInfo.members_num.integerValue + selMembers.count;
    
    JGJGroupMangerTool *mangerTool = [[JGJGroupMangerTool alloc] init];
    
    self.teamInfo.cur_member_num = allMemberNum - 1;
    
    mangerTool.teamInfo = self.teamInfo;
    
    mangerTool.targetVc = self.navigationController;
    
    JGJMyWorkCircleProListModel *proListModel = [JGJMyWorkCircleProListModel new];
    
    proListModel.is_degrade = self.groupListModel.is_degrade;
    
    proListModel.is_senior_expire = self.teamInfo.team_info.is_senior_expire;
    
//    proListModel.is_cloud_expire = self.teamInfo.team_info.is_cloud_expire;
    
    proListModel.is_degrade = self.teamInfo.team_info.is_degrade;
    
    proListModel.group_id = self.groupListModel.cur_group_id;
    
    proListModel.class_type = self.groupListModel.cur_class_type;
    
    mangerTool.workProListModel = proListModel;
    
    return mangerTool.isPopView;
    
}

#pragma mark - 以下代码索引用

- (UILabel *)centerShowLetter {
    if (!_centerShowLetter) {
        
        _centerShowLetter = [[UILabel alloc] init];
        _centerShowLetter.hidden = YES;
        _centerShowLetter.textColor = [UIColor whiteColor];
        _centerShowLetter.textAlignment = NSTextAlignmentCenter;
        _centerShowLetter.font = [UIFont systemFontOfSize:30];
        _centerShowLetter.frame = CGRectMake(0, 0, 55, 55);
        _centerShowLetter.center = self.view.center;
        _centerShowLetter.clipsToBounds = YES;
        _centerShowLetter.layer.cornerRadius = TYGetViewW(_centerShowLetter)  / 2;
        _centerShowLetter.backgroundColor = [UIColor orangeColor];
    }
    return _centerShowLetter;
}

- (void)setContactsLetters:(NSArray *)contactsLetters {
    _contactsLetters = contactsLetters;
    if (_contactsLetters.count > ShowCount) {
        if (!self.sectionIndexView) {
            [self creatTableIndexView];
        }
        BOOL isShow = _contactsLetters.count  > ShowCount? NO:YES; //搜索时隐藏所以
        self.sectionIndexView.hidden = isShow;
        [self.sectionIndexView reloadItemViews];
    }else {
        
        self.sectionIndexView.hidden = YES;
    }
}

- (void)setSortContactsModel:(JGJAddressBookSortContactsModel *)sortContactsModel {
    
    _sortContactsModel = sortContactsModel;
    
    self.contactsLetters = sortContactsModel.contactsLetters;
    
}

#pragma Mark - 创建右边索引
- (void)creatTableIndexView {
    
    _sectionIndexView = [[DSectionIndexView alloc] init];
    _sectionIndexView.frame = CGRectMake(TYGetUIScreenWidth - kSectionIndexWidth - IndexPadding, OffsetY, kSectionIndexWidth, TYGetUIScreenHeight - OffsetY * 3);
    [_sectionIndexView setBackgroundViewFrame];
    _sectionIndexView.backgroundColor = [UIColor whiteColor];
    _sectionIndexView.dataSource = self;
    _sectionIndexView.delegate = self;
    _sectionIndexView.isShowCallout = NO;
    _sectionIndexView.calloutViewType = CalloutViewTypeForUserDefined;
    _sectionIndexView.calloutDirection = SectionIndexCalloutDirectionLeft;
    _sectionIndexView.calloutMargin = 100.f;
    if (self.sectionIndexView) {
        [self.sectionIndexView removeFromSuperview];
        [self.view addSubview:self.sectionIndexView];
    }
}

#pragma mark DSectionIndexViewDataSource && delegate method
- (NSInteger)numberOfItemViewForSectionIndexView:(DSectionIndexView *)sectionIndexView
{
    return self.contactsLetters.count;
}

- (DSectionIndexItemView *)sectionIndexView:(DSectionIndexView *)sectionIndexView itemViewForSection:(NSInteger)section
{
    DSectionIndexItemView *itemView = [[DSectionIndexItemView alloc] init];
    itemView.titleLabel.text = [self.contactsLetters objectAtIndex:section];
    itemView.titleLabel.font = [UIFont systemFontOfSize:12];
    itemView.titleLabel.textColor = AppFont999999Color;
    itemView.titleLabel.highlightedTextColor = AppFontd7252cColor;
    itemView.titleLabel.shadowColor = [UIColor whiteColor];
    itemView.titleLabel.shadowOffset = CGSizeMake(0, 1);
    return itemView;
}

- (UIView *)sectionIndexView:(DSectionIndexView *)sectionIndexView calloutViewForSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 80, 80);
    label.backgroundColor = [UIColor yellowColor];
    label.textColor = [UIColor redColor];
    label.font = [UIFont boldSystemFontOfSize:36];
    label.text = [self.contactsLetters objectAtIndex:section];
    label.textAlignment = NSTextAlignmentCenter;
    [label.layer setCornerRadius:label.frame.size.width/2];
    [label.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [label.layer setBorderWidth:3.0f];
    [label.layer setShadowColor:[UIColor blackColor].CGColor];
    [label.layer setShadowOpacity:0.8];
    [label.layer setShadowRadius:5.0];
    [label.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    return label;
}

- (NSString *)sectionIndexView:(DSectionIndexView *)sectionIndexView
               titleForSection:(NSInteger)section {
    return [self.contactsLetters objectAtIndex:section];
}

- (void)sectionIndexView:(DSectionIndexView *)sectionIndexView didSelectSection:(NSInteger)section
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    __weak typeof(self) weakSelf  = self;
    self.centerShowLetter.text = self.contactsLetters[section];
    self.centerShowLetter.hidden = NO;
    sectionIndexView.touchCancelBlock = ^(DSectionIndexView *sectionIndexView, BOOL isTouchCancel){
        //        延时的目的是当touch停止的时候还会滚动一小段时间
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.centerShowLetter.hidden = isTouchCancel;
        });
    };
}

- (JGJComDefaultView *)defaultView {
    
    if (!_defaultView) {
        
        _defaultView = [[JGJComDefaultView alloc] initWithFrame:self.view.bounds];
        
        JGJComDefaultViewModel *defaultViewModel = [JGJComDefaultViewModel new];
        
        defaultViewModel.des = @"该项目中没有更多的成员可添加";
        
        defaultViewModel.isHiddenButton = YES;
        
        _defaultView.defaultViewModel = defaultViewModel;
    }
    
    return _defaultView;
}

@end
