//
//  JGJGroupChatDetailInfoAddMemberVc.m
//  mix
//
//  Created by yj on 16/12/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJGroupChatDetailInfoAddMemberVc.h"
#import "JGJCreatTeamCell.h"
#import "JGJChatRootVc.h"
#import "JGJGroupChatListVc.h"
#import "NSString+Extend.h"
#import "JGJCreateGroupVc.h"
#import "JGJChatMsgDBManger+JGJGroupDB.h"

#import "JGJImageModelView.h"

typedef void(^HandleLoadGroupChatListBlock)(NSArray *);
@interface JGJGroupChatDetailInfoAddMemberVc ()<ClickPeopleItemButtondelegate>
@property (strong, nonatomic) NSMutableArray *headCellInfoModels;
@property (weak, nonatomic) IBOutlet UIButton *groupChatButton;
@property (strong, nonatomic) NSMutableArray *selectedMembers;
@property (weak, nonatomic) IBOutlet UIView *contentGroupButtonView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentGroupChatButtonViewH;
@property (strong, nonatomic) JGJAddGroupMemberRequestModel *addGroupMemberRequestModel;
@property (copy, nonatomic) HandleLoadGroupChatListBlock handleLoadGroupChatListBlock; //回调数据判断是否有数据
@property (copy, nonatomic) NSString *buttonTitle;

@property (weak, nonatomic) IBOutlet UIView *contentSelectedMemberView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSelectedMemberViewH;

@property (strong, nonatomic) JGJImageModelView *imageModelView;

@end

@implementation JGJGroupChatDetailInfoAddMemberVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    [self.groupChatButton.layer setLayerCornerRadius:JGJCornerRadius];
    if (self.contactedAddressBookVcType == JGJSingleChatCreatGroupChatVcType) {
        self.title = @"发起群聊";
        self.buttonTitle = @"进入群聊";
    }
    
    BOOL isAddMember = self.contactedAddressBookVcType == JGJContactedAddressBookAddMembersVcType || self.contactedAddressBookVcType == JGJGroupMangerAddMembersVcType || self.contactedAddressBookVcType == JGJTeamMangerAddMembersVcType;
    if (isAddMember) {
        [self.groupChatButton setTitle:@"确定" forState:UIControlStateNormal];
        self.buttonTitle = @"确定";
    }
    
    [self.contentSelectedMemberView addSubview:self.imageModelView];
    
    [self showBottomGroupChatButton];
}

#pragma mark - 第一段顶部cell的处理
- (UITableViewCell *)handleRegisterAddressBookHeadCellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath {
    JGJCreatTeamCell *cell = [JGJCreatTeamCell cellWithTableView:tableView];
    cell.creatTeamModel = self.headCellInfoModels[indexPath.row];
    cell.lineView.hidden = self.headCellInfoModels.count - 1 == indexPath.row;
    return cell;
}

#pragma mark - 点击第一段
- (void)JGJAddressBookHeadCellWithTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            [self clickGroupChatCell];
            
        }else if (indexPath.row == 1) {
            
            JGJCreateGroupVc *joinGroupVc = [JGJCreateGroupVc new];
            joinGroupVc.workProListModel = self.workProListModel;
            [self.navigationController pushViewController:joinGroupVc animated:YES];
        }
    }
}

#pragma mark -点击项目
- (void)clickGroupChatCell {
    
    JGJGroupChatListVc *groupChatListVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJGroupChatListVc"];
    groupChatListVc.groupChatListVcType = JGJGroupChatListWorkVcType; //项目
    groupChatListVc.chatType = JGJGroupChatType;
    groupChatListVc.contactedAddressBookVcType = self.contactedAddressBookVcType; //群聊信息添加人员排除当前群聊人员、单聊创建群聊排除当前单聊人员
    self.workProListModel.cur_group_id = self.workProListModel.group_id; //排除当前班组、项目人员
    self.workProListModel.cur_class_type = self.workProListModel.class_type;
    
    groupChatListVc.teamInfo = self.teamInfo;//已添加人员显示member_list
    
    groupChatListVc.workProListModel = self.workProListModel; //点击从项目添加人员根据cur_group_id、cur_class_type排除当前群选择存在人员
    [self.navigationController pushViewController:groupChatListVc animated:YES];
    
}

- (void)JGJAddressBookTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[indexPath.section - 1];
    JGJSynBillingModel *contactModel = sortFindResult.findResult[indexPath.row];
    
    //已存在点击添加没有反应
    
    if (contactModel.is_exist) {
        
        return;
    }
    
    contactModel.indexPathMember = indexPath;
    
    contactModel.isSelected = !contactModel.isSelected;
    if (contactModel.isSelected) {
        [self.selectedMembers addObject:contactModel];
    }else {
        [self.selectedMembers removeObject:contactModel];
    }
    
    [self showBottomGroupChatButton];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSInteger)JGJAddressBookFirstSectionTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.headCellInfoModels.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.section == 0 ? 50 : 68;
}

#pragma mark - buttonActon
- (IBAction)handleGroupChatButtonAction:(UIButton *)sender {
    if (self.contactedAddressBookVcType == JGJContactedAddressBookAddMembersVcType) {
        [self handleJoinExistGroupChatAddMembers];
    }else {
        [self handleCreatGroupChatRequest];
    }
}

- (void)handleCreatGroupChatRequest {
    NSMutableString *membersUidStr = [NSMutableString string];
    for (JGJSynBillingModel *memberModel in self.selectedMembers) {
        [membersUidStr appendFormat:@"%@,",memberModel.uid];
    }
    if (self.contactedAddressBookVcType == JGJSingleChatCreatGroupChatVcType) { //单聊发起群聊加入聊天对象的Uid
        [membersUidStr appendString:self.workProListModel.cur_group_id?:@""];
    }
    
    //    删除末尾的逗号
    if (membersUidStr.length > 0 && membersUidStr != nil) {
        NSString *lastStr = [membersUidStr substringWithRange:NSMakeRange(membersUidStr.length - 1, 1)];
        if ([lastStr isEqualToString:@","]) {
            [membersUidStr deleteCharactersInRange:NSMakeRange(membersUidStr.length - 1, 1)];
        }
    }
    
    NSDictionary *parameters = @{
                                 @"uid" : membersUidStr?:@"",
                                 
                                 //                                 @"code" : @"0"
                                 
                                 };
    
    __weak typeof(self) weakSelf = self;
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:JGJCreateChatURL parameters:parameters success:^(id responseObject) {
        
        JGJMyWorkCircleProListModel *groupChatModel = [JGJMyWorkCircleProListModel mj_objectWithKeyValues:responseObject];
        
//        [weakSelf handleJoinGroupChatWithgroupChatModel:groupChatModel];
        
        [weakSelf popVcWithGroupChatModel:groupChatModel];
        
        JGJChatGroupListModel *groupModel = [JGJChatGroupListModel mj_objectWithKeyValues:[groupChatModel mj_JSONObject]];
        
        groupModel.max_asked_msg_id = @"0";
        
        groupModel.sys_msg_type = @"normal";
        
        groupModel.local_head_pic = [groupChatModel.members_head_pic mj_JSONString];
        
        [JGJChatMsgDBManger insertGroupDBWithGroupModel:groupModel isHomeVc:NO];
        
        [TYLoadingHub hideLoadingView];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}

#pragma mark - ClickPeopleItemButtondelegate
- (void)ClickPeopleItem:(NSMutableArray *)ModelArray anIndexpath:(NSIndexPath *)indexpath deleteObeject:(JGJSynBillingModel *)deleteModel {
    deleteModel.isSelected = NO;
    if (self.selectedMembers.count > 0) {
        [self.selectedMembers removeObject:deleteModel];
    }
    [self.tableView reloadRowsAtIndexPaths:@[deleteModel.indexPathMember] withRowAnimation:UITableViewRowAnimationNone];
    self.selectedMembers = ModelArray;
    [self showBottomGroupChatButton];
}

#pragma mark - 选中人员加入已存在的群成功进入聊天页面
- (void)handleJoinExistGroupChatAddMembers {
    
    NSMutableArray *groupMembersInfos = [NSMutableArray array];
    
    for (JGJSynBillingModel *teamMemberModel in self.selectedMembers) { //添加返回的成员需要上传的信息
        
        JGJGroupMembersRequestModel *membersModel = [[JGJGroupMembersRequestModel alloc] init];
        
        membersModel.real_name = teamMemberModel.real_name;
        
        membersModel.telephone = teamMemberModel.telephone;
        
        membersModel.uid = teamMemberModel.uid;
        
        [groupMembersInfos addObject:membersModel];
        
    } //获取姓名和电话
    
    self.addGroupMemberRequestModel.group_members = groupMembersInfos;
    
    NSString *group_members = [[JGJGroupMembersRequestModel mj_keyValuesArrayWithObjectArray:self.addGroupMemberRequestModel.group_members] mj_JSONString];
    
    NSDictionary *parameters = [self.addGroupMemberRequestModel mj_keyValues];
    
    if (![NSString isEmpty:group_members]) {
        
        [parameters setValue:group_members forKey:@"group_members"];
    }
    
    [JLGHttpRequest_AFN PostWithNapi:JGJAddMembersURL parameters:parameters success:^(id responseObject) {
        
        [TYShowMessage showSuccess:@"添加成功"];
        
        NSInteger count = [self.workProListModel.members_num integerValue] + self.selectedMembers.count;
        
        self.workProListModel.members_num = [NSString stringWithFormat:@"%@", @(count)];
        
//        [self handleJoinGroupChatWithgroupChatModel:self.workProListModel];
        
        [self popVcWithGroupChatModel:self.workProListModel];
        
    } failure:^(NSError *error) {
        
        
    }];
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
        
        [self handleJoinGroupChatWithgroupChatModel:groupChatModel];
        
        //        [self.navigationController popViewControllerAnimated:YES];
        
    }else {
        
        [self.navigationController popToViewController:popVc animated:YES];
    }
}

#pragma mark - 进入群聊
- (void)handleJoinGroupChatWithgroupChatModel:(JGJMyWorkCircleProListModel *)groupChatModel {
    JGJChatRootVc *chatRootVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatRootCommonVc"];
    chatRootVc.workProListModel = groupChatModel; //进入群聊
    [self.navigationController pushViewController:chatRootVc animated:YES];
}

- (JGJContactedAddressBookCellType)addressBookCellType {
    return JGJContactedAddressBookCellSelectedMembersType;
}

#pragma mark - otherMethod
- (void)showBottomGroupChatButton {
    
    self.imageModelView.DataMutableArray = self.selectedMembers;
    
    //    self.contentGroupChatButtonViewH.constant = 0;
    //    self.contentGroupButtonView.hidden = YES;
    self.groupChatButton.enabled = NO;
    self.groupChatButton.backgroundColor = TYColorHex(0xaaaaaa);
    NSString *buttonTitle = nil;
    if (self.selectedMembers.count > 0) {
        //        self.contentGroupChatButtonViewH.constant = 63;
        //        self.contentGroupButtonView.hidden = NO;
        self.groupChatButton.backgroundColor = AppFontd7252cColor;
        self.groupChatButton.enabled = YES;
        switch (self.contactedAddressBookVcType) {
            case JGJSingleChatCreatGroupChatVcType:
            case JGJLaunchGroupChatVcType:
            case JGJContactedAddressBookAddDefaultType:{
                buttonTitle = [NSString stringWithFormat:@"进入群聊 (%@)", @(self.selectedMembers.count)];
                self.buttonTitle = @"进入群聊";
            }
                break;
            case JGJContactedAddressBookAddMembersVcType:
            case JGJGroupMangerAddMembersVcType:
            case JGJTeamMangerAddMembersVcType:{
                buttonTitle = [NSString stringWithFormat:@"确定 (%@)", @(self.selectedMembers.count)];
                self.buttonTitle = @"确定";
            }
                break;
            default:
                break;
        }
        
        [self.groupChatButton setTitle:buttonTitle forState:UIControlStateNormal];
    }else {
        [self.groupChatButton setTitle:self.buttonTitle forState:UIControlStateNormal];
    }
    
    self.contentSelectedMemberViewH.constant = self.selectedMembers.count == 0 ? 0 : 48;
    
    self.contentSelectedMemberView.hidden = self.selectedMembers.count == 0;
}

#pragma mark - getter
- (NSMutableArray *)headCellInfoModels {
    if (!_headCellInfoModels) {
        
        NSArray *titles = @[@"从项目选择添加" , @"邀他扫描吉工宝二维码加入"];
        
        if (self.contactedAddressBookVcType == JGJSingleChatCreatGroupChatVcType) {
            
            titles = @[@"从项目选择添加"];
        }
        
        _headCellInfoModels = [NSMutableArray array];
        for (NSInteger index= 0 ; index < titles.count; index++) {
            
            JGJCreatTeamModel *teamModel = [[JGJCreatTeamModel alloc] init];
            teamModel.title = titles[index];
            teamModel.placeholderTitle = @"";
            [_headCellInfoModels addObject:teamModel];
            
        }
    }
    return _headCellInfoModels;
}

- (NSMutableArray *)selectedMembers {
    if (!_selectedMembers) {
        _selectedMembers = [NSMutableArray array];
    }
    return _selectedMembers;
}

#pragma mark - 初始化添加班组成员网络请求模型
- (JGJAddGroupMemberRequestModel *)addGroupMemberRequestModel {
    
    if (!_addGroupMemberRequestModel) {
        
        _addGroupMemberRequestModel = [[JGJAddGroupMemberRequestModel alloc] init];
        
        _addGroupMemberRequestModel.class_type = @"groupChat";
        
        _addGroupMemberRequestModel.is_qr_code = @"0";//0通信录加入
        
        _addGroupMemberRequestModel.group_id = self.workProListModel.group_id;
        
    }
    return _addGroupMemberRequestModel;
}

- (JGJImageModelView *)imageModelView {
    
    if (!_imageModelView) {
        CGRect rect = CGRectMake(0, 0, TYGetUIScreenWidth, 48.0);
        _imageModelView = [[JGJImageModelView alloc] initWithFrame:rect];
        _imageModelView.peopledelegate = self;
    }
    return _imageModelView;
}


#pragma mark - 重写父类的方法需要获取临时朋友
- (void)loadGetTemporaryFriendList {
    
}

@end

