//
//  JGJMemberSelTypeVc.m
//  mix
//
//  Created by yj on 2017/9/28.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJMemberSelTypeVc.h"

#import "JGJMemberSelTypeCell.h"

#import "JGJGroupChatListVc.h"

#import "JGJSynBillAddContactsHUBView.h"

#import "JGJAddTeamMemberVC.h"

#import "JGJAddressBookTool.h" //通信录数据库工具

#import "JGJCreateGroupVc.h"

#import "JGJCreatTeamVC.h"

#import "JGJGroupMangerTool.h"

#import "JGJAddFriendCell.h"

#import "JGJImageModelView.h"

#import "JGJCusBottomButtonView.h"

#import "JGJAddTeamMemberCell.h"

#import "JGJCheckGroupChatAllMemberVc.h"

#import "JGJCustomShareMenuView.h"

#define HeaderH 35

#define Padding 12

#define RowH 75

@interface JGJMemberSelTypeVc () <UITableViewDelegate, UITableViewDataSource, JGJSynBillAddContactsHUBViewDelegate, JGJAddTeamMemberDelegate, ClickPeopleItemButtondelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) JGJSynBillAddContactsHUBView *addContactsHuBView;

@property (nonatomic, strong) JGJTeamGroupInfoDetailRequest *infoDetailRequest;

@property (nonatomic, strong) JGJAddGroupMemberRequestModel *addGroupMemberRequestModel;

//好友人员
@property (strong, nonatomic) NSArray *singleChatMembers;

//当前班组项目的成员合并排序的数据
@property (strong, nonatomic) JGJAddressBookSortContactsModel *sortContactModel;

//当前班组项目的成员合并排序的数据
@property (strong, nonatomic) JGJAddressBookSortContactsModel *sortFriendModel;

@property (strong, nonatomic) JGJSingleListRequest *singleListRequest; //单聊请求数据

@property (strong, nonatomic) dispatch_semaphore_t semaphore;

//选择的成员
@property (strong, nonatomic) NSMutableArray *selMembers;

@property (strong, nonatomic) JGJImageModelView *imageModelView;

@property (nonatomic, strong) JGJCusBottomButtonView *buttonView;

@end

@implementation JGJMemberSelTypeVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加成员";
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.buttonView];
    
    [self.view addSubview:self.imageModelView];
    
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    [self dataSource];
    
    if ([self.targetVc isKindOfClass:NSClassFromString(@"JGJCreatTeamVC")]) {
        
        JGJTeamInfoModel *teamInfo = [JGJTeamInfoModel new];
        
        self.teamInfo = teamInfo;
        
        self.teamInfo.member_list = self.currentTeamMembers.copy;
        
    }
    
    [self getAllLoadNetData];
    
    [self showBottomGroupChatButton];
    
    TYWeakSelf(self);
    
    self.buttonView.handleCusBottomButtonViewBlock = ^(JGJCusBottomButtonView *buttonView) {
      
        if (weakself.contactedAddressBookVcType == JGJCreatGroupAddMemberType) {
            
            [weakself creatGroupAddmember];
            
        }else {
            
            [weakself handleAddMember];
        }
        
    };
    
}

#pragma mark - 添加成员
- (void)handleAddMember {
    
    JGJGroupMemberMangeType type = self.commonModel.memberType == JGJProSourceMemberType ? JGJGroupMemberMangePushNotifyType : JGJGroupMemberMangeAddMemberType;
    
    [self handleUploadTeamMembers:self.selMembers groupMemberMangeType:type];
    
}

#pragma mark - 创建班组添加人员
- (void)creatGroupAddmember {
    
    if (self.targetVc) {
        
        JGJCreatTeamVC *creatTeamVc = (JGJCreatTeamVC *)self.targetVc;
        
        [creatTeamVc handleJGJGroupMemberSelectedTeamMembers:self.selMembers groupMemberMangeType:JGJGroupMemberMangeAddMemberType];
        
        [self.navigationController popToViewController:self.targetVc animated:YES];
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger count = self.sortFriendModel.sortContacts.count;
    
    return count > 0 ? 1 + count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = 0;
    
    if (section == 0) {
        
        count = _dataSource.count;
        
    }else if(self.sortFriendModel.sortContacts.count > 0){
        
        SortFindResultModel *resultModel = self.sortFriendModel.sortContacts[section - 1];
        
        count = resultModel.findResult.count;
    }
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 60;
    
    if (indexPath.section == 0) {
        
        height = 60;
        
    }else if (indexPath.section > 0) {
        
        height = RowH;
    }
    
    return height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        
        JGJMemberSelTypeCell *selTypeCell = [JGJMemberSelTypeCell cellWithTableView:tableView];
        
        selTypeCell.selTypeModel = _dataSource[indexPath.row];
        
        cell = selTypeCell;
        
    }else {
        
        JGJAddTeamMemberCell *friendCell = [JGJAddTeamMemberCell cellWithTableView:tableView];
        
        if (self.sortFriendModel.sortContacts.count > 0) {
            
            SortFindResultModel *resultModel = self.sortFriendModel.sortContacts[indexPath.section - 1];
            
            JGJSynBillingModel *memberModel = resultModel.findResult[indexPath.row];
            
            friendCell.lineView.hidden = resultModel.findResult.count - 1 == indexPath.row;
            
            friendCell.maxTrail = 12;
            
            friendCell.synBillingModel = memberModel;
            
        }
        
        cell = friendCell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        [self registerSelTypeWithTableView:tableView didSelectRowAtIndexPath:indexPath];
        
    }else {
        
        [self registerSelMemberWithTableView:tableView didSelectRowAtIndexPath:indexPath];
        
    }
    
}

- (void)registerSelTypeWithTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:{
            
            [self addTelAddressBook];
        }
            
            break;

        case 1:{
            
            [self manualAddFriend];
        }
            
            break;
            
        case 2:{
            
            [self addProMember];
        }
            
            break;
            
        case 3:{
            
            [self QRCodeAddFriend];
        }
            
            break;
            
        case 4:{
            
            [self shareWxMiniPro];
            
        }
            break;
            
        default:
            break;
    }
}

- (void)shareWxMiniPro {
    
    JGJShowShareMenuModel *shareModel = [[JGJShowShareMenuModel alloc] init];
    
    NSString *real_name = [TYUserDefaults objectForKey:JGJUserName];
    
    shareModel.title = [NSString stringWithFormat:@"%@邀请你加入[%@]班组，即时记工、实时对帐~",real_name,self.workProListModel.group_name];
    
//    shareModel.describe = @"1200万建筑工友都在用！海量工作任你挑，实名招工更靠谱！";
    
    JGJWXMiniModel *wxMiniModel = [JGJWXMiniModel new];
    
    wxMiniModel.appId = @"gh_89054fe67201";
    
    NSString *uid = [TYUserDefaults objectForKey:JLGUserUid];
    
    NSString *path = [NSString stringWithFormat:@"/pages/group/groupInvite?group_id=%@&group_name=%@&name=%@",self.workProListModel.group_id,self.workProListModel.group_name,real_name];
    
    wxMiniModel.path = path;
    
    wxMiniModel.wxMiniImage = [UIImage imageNamed:@"share_wxMini_add_member_icon"];
    
//    shareModel.url = [NSString stringWithFormat:@"%@page/open-invite.html?uid=%@&plat=person",JGJWebDiscoverURL, uid];
    
    shareModel.imgUrl = [NSString stringWithFormat:@"%@%@", JLGHttpRequest_IP, @"public/imgs/mp/share/grop.jpg"];
    
    JGJCustomShareMenuView *shareMenuView = [[JGJCustomShareMenuView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
    
    shareMenuView.Vc = self;
    
    shareMenuView.shareMenuModel = shareModel;
    
    shareModel.wxMini = wxMiniModel;
    
    [shareMenuView sendMiniProgramWithShareMenuModel:shareModel];
}

- (void)registerSelMemberWithTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SortFindResultModel *resultModel = self.sortFriendModel.sortContacts[indexPath.section - 1];
    
    JGJSynBillingModel *memberModel = resultModel.findResult[indexPath.row];
    
    //已存在不能点击
    if (memberModel.isAddedSyn || memberModel.is_exist) {
        
        return;
    }
    
    memberModel.isSelected = !memberModel.isSelected;
    
    memberModel.indexPathMember = indexPath;
    
    if (memberModel.isSelected) {
        
        [self.selMembers addObject:memberModel];
        
    }else {
        
        [self.selMembers removeObject:memberModel];
        
    }
    
    [self showBottomGroupChatButton];
    
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView reloadData];

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = nil;
    
    if (section > 0 && self.sortFriendModel.sortContacts.count > 0) {
        
        headerView = [[UIView alloc] init];
        headerView.backgroundColor = AppFontf1f1f1Color;
        UILabel *firstLetterLable = [[UILabel alloc] init];
        firstLetterLable.backgroundColor = [UIColor clearColor];
        firstLetterLable.font = [UIFont systemFontOfSize:AppFont32Size];
        firstLetterLable.frame = CGRectMake(Padding, 0, TYGetViewW(self.view), HeaderH);
        if ([self.sortFriendModel.sortContacts[section - 1] isKindOfClass:[SortFindResultModel class]]) {
            
            SortFindResultModel *sortFindResult = self.sortFriendModel.sortContacts[section - 1];
            
            NSString *firstLetter = sortFindResult.firstLetter.uppercaseString;
            
            firstLetterLable.text = firstLetter;
            
        }
        
        firstLetterLable.textColor = AppFontccccccColor;
        
        [headerView addSubview:firstLetterLable];
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return section > 0 && self.sortFriendModel.sortContacts.count > 0 ? HeaderH : CGFLOAT_MIN;
}

#pragma mark - 项目添加
- (void)addProMember {
    
    JGJGroupChatListVc *groupChatListVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJGroupChatListVc"];
    groupChatListVc.groupChatListVcType = JGJGroupChatListWorkVcType;
    groupChatListVc.chatType = JGJGroupChatType;
    groupChatListVc.commonModel = self.commonModel;
    
    if ([self.workProListModel.class_type isEqualToString:@"group"]) {
        
        self.contactedAddressBookVcType = JGJGroupMangerAddMembersVcType;
        
    }else if ([self.workProListModel.class_type isEqualToString:@"team"]) {
        
        self.contactedAddressBookVcType = JGJTeamMangerAddMembersVcType;
    }
    
    //是数据来源人添加就排除数据来源人2.0.0
    self.workProListModel.is_exclude_source = self.commonModel.memberType == JGJProSourceMemberType ? @"1" : @"0";
    
    groupChatListVc.contactedAddressBookVcType = self.contactedAddressBookVcType; //班组和项目管理添加人员
    self.workProListModel.cur_group_id = self.workProListModel.group_id;
    self.workProListModel.cur_class_type = self.workProListModel.class_type;
    groupChatListVc.workProListModel = self.workProListModel; //点击从项目添加人员根据cur_group_id、cur_class_type排除当前群选择存在人员
//    groupChatListVc.groupChatList = groupChatList;
    
    //2.3.0
    groupChatListVc.teamInfo = self.teamInfo;
    
    [self.navigationController pushViewController:groupChatListVc animated:YES];
    
}

#pragma mark - 手机通信录
- (void)addTelAddressBook {
    
    JGJSynBillingCommonModel *synBillingCommonModel = [[JGJSynBillingCommonModel alloc] init];
    JGJAddTeamMemberVC *addTeamMemberVC = [[UIStoryboard storyboardWithName:@"JGJCreatTeam" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJAddTeamMemberVC"];
    addTeamMemberVC.workProListModel = self.workProListModel; //获取当前班组信息，根据当前有哪些成员加载通信录
    synBillingCommonModel.synBillingTitle = self.commonModel.memberType == JGJProSourceMemberType ? @"添加数据来源人" : @"从手机通讯录添加" ;
    

    
    addTeamMemberVC.commonModel = self.commonModel;
    
    addTeamMemberVC.delegate = self;
    
    addTeamMemberVC.targetVc = self.targetVc;
    
    addTeamMemberVC.groupMemberMangeType = self.commonModel.memberType == JGJProSourceMemberType ? JGJGroupMemberMangePushNotifyType : JGJGroupMemberMangeAddMemberType;
    
    addTeamMemberVC.contactedAddressBookVcType = JGJTeamMangerAddMembersVcType;//项目组添加
    
    if (self.contactedAddressBookVcType == JGJCreatGroupAddMemberType) {
        
        addTeamMemberVC.contactedAddressBookVcType = self.contactedAddressBookVcType;//项目组添加
        
    }else {
        
        addTeamMemberVC.contactedAddressBookVcType = JGJTeamMangerAddMembersVcType;//项目组添加
    }
    
    NSArray *members = self.teamInfo.team_group_members;
    
    if (self.commonModel.memberType == JGJProMemberType) {
        
        members = self.teamInfo.team_group_members;
        
    }else if (self.commonModel.memberType == JGJProSourceMemberType) {
        
        members = self.teamInfo.source_report_members;
    }
    
    addTeamMemberVC.currentTeamMembers = members;
    
    addTeamMemberVC.synBillingCommonModel = synBillingCommonModel;
    
    addTeamMemberVC.sortContactsModel = self.sortContactModel;
    
//    addTeamMemberVC.maxMemberNum = self.teamInfo.buyer_person;
    
    addTeamMemberVC.teamInfo = self.teamInfo;
    
    [self.navigationController pushViewController:addTeamMemberVC animated:YES];
    
}

#pragma mark - 获得的添加人员数据
- (void)handleJGJGroupMemberSelectedTeamMembers:(NSMutableArray *)teamsMembers groupMemberMangeType:(JGJGroupMemberMangeType)groupMemberMangeType {
    
    [self getAddTeamMembers:teamsMembers groupMemberMangeType:groupMemberMangeType];
}

#pragma mark - 获取成员信息
- (void)getAddTeamMembers:(NSMutableArray *)teamMembers groupMemberMangeType:(JGJGroupMemberMangeType)groupMemberMangeType {
    //创建班组直接添加不需要请求接口

    NSMutableArray *source_pro_ids = [NSMutableArray array];
    
    NSMutableArray *groupMembersInfos = [NSMutableArray array];
    for (JGJSynBillingModel *teamMemberModel in teamMembers) { //添加返回的成员需要上传的信息
        JGJGroupMembersRequestModel *membersModel = [[JGJGroupMembersRequestModel alloc] init];
        membersModel.real_name = teamMemberModel.real_name;
        membersModel.telephone = teamMemberModel.telephone;
        membersModel.source_pro_id = teamMemberModel.source_pro_id;
        membersModel.uid = teamMemberModel.uid;
        teamMemberModel.isAddedSyn = NO;
        teamMemberModel.isSelected = NO;
        [groupMembersInfos addObject:membersModel];
        
        if (![NSString isEmpty:teamMemberModel.source_pro_id]) {
            
            [source_pro_ids addObject:teamMemberModel.source_pro_id];
        }

    } //获取姓名和电话
    
    NSString *source_pro_id = [source_pro_ids componentsJoinedByString:@","];
    
    if (![NSString isEmpty:source_pro_id]) {
        
        self.addGroupMemberRequestModel.source_pro_id = source_pro_id;
    }
    
    [self handleUploadTeamMembers:groupMembersInfos groupMemberMangeType:groupMemberMangeType];
}

#pragma mark - 上传班组成员信息
- (void)handleUploadTeamMembers:(NSMutableArray *)groupMembersInfos groupMemberMangeType:(JGJGroupMemberMangeType)groupMemberMangeType {
    __weak typeof(self) weakSelf = self;
    
    NSString *requestApi = JGJAddMembersURL;
    
    NSMutableDictionary *parameters = [self.addGroupMemberRequestModel mj_keyValues];
    
    NSString *group_members = @"";
    
    NSString *source_members = @"";
    
    if ((self.commonModel.memberType == JGJProMemberType || self.commonModel.memberType == JGJGroupMemberType) && groupMemberMangeType != JGJGroupMemberMangePushNotifyType) {
        
        self.addGroupMemberRequestModel.group_members = groupMembersInfos;
        
        self.addGroupMemberRequestModel.source_members = nil;
        
        group_members = [[JGJGroupMembersRequestModel mj_keyValuesArrayWithObjectArray:self.addGroupMemberRequestModel.group_members] mj_JSONString];
        
    } else {
        
        self.addGroupMemberRequestModel.source_members = groupMembersInfos;
        
        self.addGroupMemberRequestModel.team_members = nil;
        
        source_members = [[JGJGroupMembersRequestModel mj_keyValuesArrayWithObjectArray:self.addGroupMemberRequestModel.source_members] mj_JSONString];
        
        requestApi = JGJGroupAddSourceMemberURL;
    }
    
    parameters = [self.addGroupMemberRequestModel mj_keyValuesWithIgnoredKeys:@[@"group_members", @"source_members"]];
    
    if (![NSString isEmpty:group_members]) {
        
        parameters[@"group_members"] = group_members;
    }
    
    if (![NSString isEmpty:source_members]) {
        
        parameters[@"source_members"] = source_members;
    }
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:requestApi parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        if ([self.targetVc isMemberOfClass:[JGJCheckGroupChatAllMemberVc class]]) {
            
            JGJCheckGroupChatAllMemberVc *allmemberVc = (JGJCheckGroupChatAllMemberVc *)self.targetVc;
            
            if (allmemberVc.successBlock) {
                
                allmemberVc.successBlock(responseObject);
                
            }
        }
        
        [TYShowMessage showSuccess:@"添加成功"];
        
        [weakSelf.navigationController popToViewController:self.targetVc animated:YES];
        
    } failure:^(NSError *error) {
        
         [TYLoadingHub hideLoadingView];
        
    }];
}

#pragma mark - 聊聊通信录好友
- (void)addChatAddressBook {
    
    JGJSynBillingCommonModel *synBillingCommonModel = [[JGJSynBillingCommonModel alloc] init];
    JGJAddTeamMemberVC *addTeamMemberVC = [[UIStoryboard storyboardWithName:@"JGJCreatTeam" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJAddTeamMemberVC"];
    
    addTeamMemberVC.workProListModel = self.workProListModel; //获取当前班组信息，根据当前有哪些成员加载通信录
    
    synBillingCommonModel.synBillingTitle = @"添加成员";
    
    addTeamMemberVC.commonModel = self.commonModel;
    
    addTeamMemberVC.delegate = self;
    
    addTeamMemberVC.groupMemberMangeType = JGJAddFriendType;
    
    addTeamMemberVC.contactedAddressBookVcType = self.contactedAddressBookVcType;//项目组、班组添加
    
    addTeamMemberVC.synBillingCommonModel = synBillingCommonModel;
    
    addTeamMemberVC.sortContactsModel = self.sortContactModel;
    
    addTeamMemberVC.maxMemberNum = self.teamInfo.buyer_person;
    
    addTeamMemberVC.targetVc = self.targetVc;
    
    addTeamMemberVC.teamInfo = self.teamInfo;
    
    [self.navigationController pushViewController:addTeamMemberVC animated:YES];
}

#pragma mark - 手动添加
- (void)manualAddFriend {
    
    //人员是否升级弹框
    if ([self showPopView]) {
        
        return;
    }
    
    if (!self.addContactsHuBView.delegate) {
        
        self.addContactsHuBView.delegate = self;
    }
    [self.addContactsHuBView showAddContactsHubView];
    
    _addContactsHuBView.titleLabel.text = @"添加成员";
    
    if (self.commonModel.memberType == JGJGroupMemberType) {
        
        _addContactsHuBView.titleLabel.text = @"添加班组成员";
        
    } else if (self.commonModel.memberType == JGJProMemberType) {
        
        _addContactsHuBView.titleLabel.text = @"添加成员";
        
    } else if (self.commonModel.memberType == JGJProSourceMemberType) {
        
        _addContactsHuBView.titleLabel.text = @"添加数据来源人";
    }

    [_addContactsHuBView.saveButton setTitle:@"保存" forState:UIControlStateNormal];
}

#pragma mark - 二维码加入
- (void)QRCodeAddFriend {
    
        JGJCreateGroupVc *joinGroupVc = [JGJCreateGroupVc new];
        
        if (self.teamInfo.members_head_pic.count > 0) {
            
            self.workProListModel.members_head_pic = self.teamInfo.members_head_pic;
            
        }else {
            
            JGJChatGroupListModel *groupListModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:self.teamInfo.group_id classType:self.teamInfo.class_type];
            
            NSArray *members_head_pic = [groupListModel.local_head_pic mj_JSONObject];
            
            if (members_head_pic.count > 0) {
                
               self.workProListModel.members_head_pic = members_head_pic;
                
            }
            
        }
    
        if (![NSString isEmpty:_teamInfo.group_full_name]) {
            
            self.workProListModel.group_full_name = _teamInfo.group_full_name;
        }
    
        joinGroupVc.workProListModel = self.workProListModel;
    
        [self.navigationController pushViewController:joinGroupVc animated:YES];

}

- (void)loadProMember {
    
//    NSDictionary *parameters = [self.infoDetailRequest mj_keyValues];
//
//    [JLGHttpRequest_AFN PostWithNapi:JGJGetMembersListURL parameters:parameters success:^(id responseObject) {
//
//        NSMutableArray *memberbers = [JGJSynBillingModel mj_objectArrayWithKeyValuesArray:responseObject];
//
//        dispatch_semaphore_signal(self.semaphore);
//
//    } failure:^(NSError *error) {
//
//        [TYLoadingHub hideLoadingView];
//    }];
    
    dispatch_semaphore_signal(self.semaphore);
    
}
#pragma mark - 加载单聊列表
- (void)loadSingleChatList {
    
    [JLGHttpRequest_AFN PostWithNapi:JGJGetFriendsListURL parameters:nil success:^(id responseObject) {
        
        self.singleChatMembers =  [JGJSynBillingModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        dispatch_semaphore_signal(self.semaphore);
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)setSingleChatMembers:(NSArray *)singleChatMembers {
    
    _singleChatMembers = singleChatMembers;
    
    NSMutableString *uids = [[NSMutableString alloc] init];
    
    NSArray *members = self.commonModel.memberType == JGJProSourceMemberType ? _teamInfo.source_members : _teamInfo.member_list;
    
    //去掉添加和删除模型
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isMangerModel!=%@",@(YES)];
    
    members = [members filteredArrayUsingPredicate:predicate];
    
    if (members.count > 0) {
        
        for (JGJSynBillingModel *member in members) {
            
            if (![NSString isEmpty:member.telephone]) {
                
                NSString *uid = [NSString stringWithFormat:@"%@,",member.telephone];
                
                [uids appendFormat:@"%@", uid];
                
                member.is_exist = YES;
                
            }
            
        }
    }
    
    if (!self.workProListModel) {
        
        self.workProListModel = [JGJMyWorkCircleProListModel new];
    }
    
//    self.workProListModel.member_uids = [self getMembers];
    
    self.workProListModel.member_uids = uids;
    
    NSMutableArray *remainMembers = [NSMutableArray new];
    
//    if ([NSString isEmpty:self.workProListModel.member_uids]) {
//
//        remainMembers = singleChatMembers.mutableCopy;
//
//    }else {
//
//        for (JGJSynBillingModel *memberModel in singleChatMembers) {
//
//            if (![self.workProListModel.member_uids containsString:memberModel.telephone]) {
//
//                [remainMembers addObject:memberModel];
//            }
//
//        }
//
//    }
    
    for (JGJSynBillingModel *memberModel in singleChatMembers) {
        
        if (![self.workProListModel.member_uids containsString:memberModel.telephone]) {
            
//            [remainMembers addObject:memberModel];
            
            memberModel.is_exist = NO;
            
        }else {
            
            memberModel.is_exist = YES;
        }
        
    }
    
    [remainMembers addObjectsFromArray:singleChatMembers];
    
    JGJAddressBookSortContactsModel *sortFriendModel = [JGJAddressBookTool addressBookToolSortContcts:remainMembers];
    
    self.sortFriendModel = sortFriendModel;
    
    [self.tableView reloadData];
}

- (NSString *)getMembers {
    
    NSMutableString *uids = [[NSMutableString alloc] init];
    
    NSArray *members = self.commonModel.memberType == JGJProSourceMemberType ? _teamInfo.source_members : _teamInfo.member_list;
    
    if (members.count > 0) {
        
        for (JGJSynBillingModel *member in members) {
            
            if (![NSString isEmpty:member.telephone]) {
                
                NSString *uid = [NSString stringWithFormat:@"%@,",member.telephone];
                
                [uids appendFormat:@"%@", uid];
                
                member.is_exist = YES;
                
            }
            
        }
    }
    
    return uids;
}

#pragma mark - 添加成功返回单个自定义联系人数据
- (void)SynBillAddContactsHubSaveSuccess:(JGJSynBillAddContactsHUBView *)contactsView {
    NSString *name = contactsView.nameTF.text;
    JGJSynBillingModel *teamModel = [[JGJSynBillingModel alloc] init];
    teamModel.isSelected = YES;
    teamModel.real_name = name;
    teamModel.telephone = contactsView.phoneNumTF.text;
    teamModel.head_pic = contactsView.head_pic;
    
    NSString *myTel = [TYUserDefaults objectForKey:JLGPhone];
    
    if ([myTel isEqualToString:teamModel.telephone]) {
        
        [TYShowMessage showPlaint:@"不能添加自己为成员"];
        
        return;
    }
    
    //    判断是否有相同的人添加
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"telephone contains %@",teamModel.telephone];
    NSArray *addedMembers = @[];
    
    if (self.commonModel.memberType == JGJProSourceMemberType) {
        
        addedMembers = [self.teamInfo.source_members filteredArrayUsingPredicate:predicate];
        
    }else {
        
        addedMembers = [self.teamInfo.member_list filteredArrayUsingPredicate:predicate];
    }
    
    if (addedMembers.count > 0) {
        
        [TYShowMessage showPlaint:@"已添加!"];
        
        return;
    }
    
    if (self.contactedAddressBookVcType == JGJCreatGroupAddMemberType) {
        
        [self creatGroupAddmemberWithMemberModel:teamModel];
        
    }else {
        
        [self handleJGJGroupMemberSelectedTeamMembers:@[teamModel].mutableCopy groupMemberMangeType:JGJGroupMemberMangeAddMemberType];
    }
    
}

#pragma mark - ClickPeopleItemButtondelegate
- (void)ClickPeopleItem:(NSMutableArray *)ModelArray anIndexpath:(NSIndexPath *)indexpath deleteObeject:(JGJSynBillingModel *)deleteModel {
    
    deleteModel.isSelected = NO;
    
    if (self.selMembers.count > 0) {
        
        [self.selMembers removeObject:deleteModel];
        
    }
    [self.tableView reloadRowsAtIndexPaths:@[deleteModel.indexPathMember] withRowAnimation:UITableViewRowAnimationNone];
    
    self.selMembers = ModelArray;
    
    [self showBottomGroupChatButton];
    
}

#pragma mark - otherMethod
- (void)showBottomGroupChatButton {
    
    self.imageModelView.DataMutableArray = self.selMembers;
    
    self.buttonView.actionButton.enabled = NO;
    
    self.buttonView.actionButton.backgroundColor = TYColorHex(0xaaaaaa);
    
    self.imageModelView.height = 0;
    
    self.imageModelView.hidden = YES;
    
    CGFloat height = TYGetUIScreenHeight - JGJ_NAV_HEIGHT - self.buttonView.height - JGJ_IphoneX_BarHeight;
    
    if (self.selMembers.count > 0) {

        self.buttonView.actionButton.backgroundColor = AppFontd7252cColor;
        
        self.buttonView.actionButton.enabled = YES;
        
        self.imageModelView.height = ImageModelViewHeight;
        
        self.imageModelView.hidden = NO;
        
        NSString *buttonTitle = [NSString stringWithFormat:@"确定 (%@)", @(self.selMembers.count)];
        
        [self.buttonView.actionButton setTitle:buttonTitle forState:UIControlStateNormal];
        
        self.tableView.height = height - ImageModelViewHeight;
        
    }else {

        self.imageModelView.height = 0;
        
        self.imageModelView.hidden = YES;
        
        [self.buttonView.actionButton setTitle:@"确定" forState:UIControlStateNormal];
        
        self.tableView.height = height;
        
    }
}

#pragma mark - 创建班组添加人员
- (void)creatGroupAddmemberWithMemberModel:(JGJSynBillingModel *)memberModel {
    
    if (self.targetVc && [NSString isEmpty:memberModel.uid]) {
        
        JGJCreatTeamVC *creatTeamVc = (JGJCreatTeamVC *)self.targetVc;
        
        [creatTeamVc handleJGJGroupMemberSelectedTeamMembers:@[memberModel].mutableCopy groupMemberMangeType:JGJGroupMemberMangeAddMemberType];
        
        [self.navigationController popToViewController:self.targetVc animated:YES];
        
    }
    
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        CGRect rect = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - JGJ_NAV_HEIGHT - self.buttonView.height);
        
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        
        _tableView.backgroundColor = AppFontf1f1f1Color;
        
    }
    
    return _tableView;
    
}

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {

        NSArray *titles = @[@"从手机通讯录添加", @"手动添加", @"从项目选择添加",@"邀他扫描吉工家二维码加入"];
        
        NSArray *icons = @[@"from_addressbook_icon", @"from_tel_icon", @"from_pro_add_icon",@"sweep_Qrcode_join_team",@"jgj_wx_add_member"];
        
        _dataSource = [NSMutableArray new];
        
        //创建班组不要二维码加入
        
        if (self.contactedAddressBookVcType == JGJCreatGroupAddMemberType) {
            
            titles = @[@"从手机通讯录添加", @"手动添加", @"从项目选择添加"];
            
            icons = @[@"from_addressbook_icon", @"from_tel_icon", @"from_pro_add_icon"];
            
        }else if (self.contactedAddressBookVcType == JGJGroupMangerAddMembersVcType) {
            
            titles = @[@"从手机通讯录添加", @"手动添加",@"从项目选择添加", @"邀他扫描吉工家二维码加入", @"邀请微信好友加入班组"];
            
            icons = @[@"from_addressbook_icon", @"from_tel_icon", @"from_pro_add_icon",@"sweep_Qrcode_join_team",@"jgj_wx_add_member"];
        }
        
        NSInteger count = titles.count;
        
        for (NSInteger indx = 0; indx < count; indx++) {
            
            JGJMemberSelTypeModel *selTypeModel = [JGJMemberSelTypeModel new];
            
            NSString *title = titles[indx];
            
            selTypeModel.title = title;
            
            selTypeModel.icon = icons[indx];
            
            [_dataSource addObject:selTypeModel];
        }
    }
    
    return _dataSource;
}

#pragma mark - 懒加载
- (JGJSynBillAddContactsHUBView *)addContactsHuBView{
    if (!_addContactsHuBView) {
        _addContactsHuBView = [[JGJSynBillAddContactsHUBView alloc] initWithFrame:TYSetRect(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
        _addContactsHuBView.delegate = self;
        _addContactsHuBView.addContactsHUBViewType = AddProTeamContactsHUBViewType;
        [self.view addSubview:_addContactsHuBView];
    }
    return _addContactsHuBView;
}

- (JGJTeamGroupInfoDetailRequest *)infoDetailRequest {
    
    if (!_infoDetailRequest) {
        _infoDetailRequest = [[JGJTeamGroupInfoDetailRequest alloc] init];
        _infoDetailRequest.group_id = self.workProListModel.team_id;
        _infoDetailRequest.ctrl = @"team";
        _infoDetailRequest.action = @"getMemberList";
        _infoDetailRequest.class_type = self.workProListModel.class_type;
    }
    return _infoDetailRequest;
}

#pragma mark - 初始化添加项目成员网络请求模型
- (JGJAddGroupMemberRequestModel *)addGroupMemberRequestModel {
    
    if (!_addGroupMemberRequestModel) {
        
        _addGroupMemberRequestModel = [[JGJAddGroupMemberRequestModel alloc] init];
        
//        _addGroupMemberRequestModel.ctrl = [self.workProListModel.class_type isEqualToString:@"team"] ? @"team" : @"group";
        
        _addGroupMemberRequestModel.is_qr_code = self.commonModel.memberType == JGJProMemberType ? @"0" : nil;
        
        _addGroupMemberRequestModel.group_id = self.workProListModel.group_id;
        
//        //有班组群聊添加传的是group_id
//        if (![self.workProListModel.class_type isEqualToString:@"team"]) {
//
//            _addGroupMemberRequestModel.group_id = self.workProListModel.team_id;
//        }
        
        _addGroupMemberRequestModel.class_type = self.workProListModel.class_type;
        
    }
    
//    _addGroupMemberRequestModel.action = self.commonModel.memberType == JGJProMemberType ? @"addMembers" : @"addSourceMember";
    
    //批量记账标记
    for (UIViewController *curVc in self.navigationController.viewControllers) {
        
        if ([curVc isKindOfClass:NSClassFromString(@"JGJMorePeopleViewController")]) {
            
            _addGroupMemberRequestModel.is_batch = @"1";
            
            break;
        }
        
    }
    
    return _addGroupMemberRequestModel;
}

- (JGJSingleListRequest *)singleListRequest {
    
    if (!_singleListRequest) {
        _singleListRequest = [JGJSingleListRequest new];
        _singleListRequest.ctrl = @"Chat";
        _singleListRequest.action = @"getSingleList";
        _singleListRequest.class_type = @"friendsChat";
//        _singleListRequest.cur_class_type = self.workProListModel.class_type;
//        _singleListRequest.cur_group_id = self.workProListModel.group_id;
    }
    return _singleListRequest;
}

#pragma mark - 获取当前班组和项目组人员获取聊聊通信录好友
- (void)getAllLoadNetData {
    
    [TYLoadingHub showLoadingWithMessage:nil];
//    /创建信号量/
    self.semaphore = dispatch_semaphore_create(0);
//    /创建全局并行/
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_t group = dispatch_group_create();
    
    //创建班组不请求当前成员
    if (self.contactedAddressBookVcType != JGJCreatGroupAddMemberType && self.commonModel.memberType != JGJProSourceMemberType) {
        
        dispatch_group_async(group, queue, ^{
            NSLog(@"处理事件A");
            [self loadProMember];
        });
    }
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"处理事件B");
        [self loadSingleChatList];
        
    });

    dispatch_group_notify(group, queue, ^{
//        /两个请求对应两次次信号等待/
        
        if (self.contactedAddressBookVcType != JGJCreatGroupAddMemberType && self.commonModel.memberType != JGJProSourceMemberType) {
         
            dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        }

        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"处理事件C");
        
        [self mergeAllMemberModel];
    });
    
}

- (void)mergeAllMemberModel {
    
    NSMutableArray *mergeMembers = [NSMutableArray new];
    
    for (JGJSynBillingModel *existMember in self.teamInfo.member_list) {
        
        existMember.isAddedSyn = YES;
    }
    
    for (JGJSynBillingModel *memberModel in self.singleChatMembers) {
        
        //    判断是否有相同的人添加
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"telephone contains %@",memberModel.telephone];
        
        NSArray *member = nil;
        
        if (self.commonModel.memberType == JGJProSourceMemberType) {
            
            member = self.teamInfo.source_members;
            
        }else {
            
            member = self.teamInfo.member_list;
        }
        
        NSArray *existedMembers = [member filteredArrayUsingPredicate:predicate];
        
        if (existedMembers.count > 0) {
            
            memberModel.isAddedSyn = YES;
            
        }
        
        [mergeMembers addObject:memberModel];
    }
    
    JGJAddressBookSortContactsModel *sortContactModel = [JGJAddressBookTool addressBookToolSortContcts:mergeMembers];
    
    self.sortContactModel = sortContactModel;
    
    [TYLoadingHub hideLoadingView];
    
}

#pragma mark - 处理对应点的弹框

- (BOOL)showPopView {
    
    JGJGroupMangerTool *mangerTool = [[JGJGroupMangerTool alloc] init];
    
    self.teamInfo.cur_member_num = self.teamInfo.members_num.integerValue;
    
    self.workProListModel.is_senior_expire = self.teamInfo.team_info.is_senior_expire;
    
//    self.workProListModel.is_cloud_expire = self.teamInfo.team_info.is_cloud_expire;
    
    self.workProListModel.is_degrade = self.teamInfo.team_info.is_degrade;
    
    mangerTool.workProListModel = self.workProListModel;
    
    mangerTool.teamInfo = self.teamInfo;
    
    mangerTool.targetVc = self.navigationController;
    
    return mangerTool.isPopView;
}

- (NSMutableArray *)selMembers {
    
    if (!_selMembers) {
        
        _selMembers = [[NSMutableArray alloc] init];
    }
    
    return _selMembers;
}

- (JGJImageModelView *)imageModelView {
    
    if (!_imageModelView) {
        
        CGRect rect = CGRectMake(0, TYGetMaxY(self.tableView) - ImageModelViewHeight - JGJ_IphoneX_BarHeight, TYGetUIScreenWidth, ImageModelViewHeight);
        
        _imageModelView = [[JGJImageModelView alloc] initWithFrame:rect];
        
        _imageModelView.peopledelegate = self;
        
    }
    
    return _imageModelView;
}

- (JGJCusBottomButtonView *)buttonView {
    
    if (!_buttonView) {
        
        CGFloat height = [JGJCusBottomButtonView cusBottomButtonViewHeight];
        
        CGFloat buttonViewY = TYGetUIScreenHeight - JGJ_NAV_HEIGHT - height - JGJ_IphoneX_BarHeight;
        
        _buttonView = [[JGJCusBottomButtonView alloc] initWithFrame:CGRectMake(0, buttonViewY, TYGetUIScreenWidth, height)];
        
        [_buttonView.actionButton setTitle:@"添加" forState:UIControlStateNormal];
        
    }
    return _buttonView;
}

@end
