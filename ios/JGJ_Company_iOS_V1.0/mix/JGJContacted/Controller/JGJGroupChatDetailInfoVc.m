//
//  JGJGroupChatDetailInfoVc.m
//  mix
//
//  Created by YJ on 16/12/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJGroupChatDetailInfoVc.h"
#import "JGJGroupChatInfoMemberCell.h"
#import "JGJCreatTeamCell.h"
#import "JGJCusSwitchMsgCell.h"
#import "JGJCheckGroupChatAllMemberVc.h"
#import "JGJEditNameVc.h"
#import "JGJUpgradeGroupVc.h"
#import "JGJPerInfoVc.h"
#import "JGJGroupChatDetailInfoAddMemberVc.h"
#import "JGJAddTeamMemberVC.h"
#import "NSString+Extend.h"
#import "JGJTransferAuthorityVc.h"
#import "JGJUpgradeGroupSelectedMangerVc.h"
#import "JGJCreateGroupVc.h"
#import "UILabel+GNUtil.h"
#import "CustomAlertView.h"
#import "JGJCustomBottomCell.h"

#import "JGJCheckAllMemberCell.h"

#import "JGJChatMsgDBManger.h"

#import "JGJChatMsgDBManger+JGJClearCacheDB.h"

#import "JGJChatMsgDBManger+JGJGroupDB.h"

#import "JGJComPaddingCell.h"

#import "JGJChatListAllVc.h"

#import "JGJChatRootVc.h"

#import "JGJCustomPopView.h"

#import "JGJCusBottomButtonView.h"

#import "JGJGroupSetMemberCell.h"

#import "JGJTabHeaderAvatarView.h"

//#define MaxNum  TYIS_IPHONE_5_OR_LESS ? 10 : 13
typedef enum : NSUInteger {
    JGJGroupChatDetailInfoHeadCellType,
    JGJGroupChatDetailInfoGroupNameCellType,
    JGJGroupChatDetailInfoEditNameCellType,
    JGJGroupChatDetailInfoMsgSwitchCellType,
    JGJGroupChatDetailInfoMangerAuthorCellType
} JGJGroupChatDetailInfoCellType;
typedef void(^ModifyTeamInfoBlock)();
@interface JGJGroupChatDetailInfoVc () <UITableViewDelegate, UITableViewDataSource, JGJGroupChatInfoMemberCellDelegate,JGJCusSwitchMsgCellDelegate, JGJEditNameVcDelegate, JGJAddTeamMemberDelegate, JGJUpgradeGroupVcDelegate, JGJCustomBottomCellDelegate,JGJGroupSetMemberCellDelegate,JGJTabHeaderAvatarViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *detailCreatInfos;
@property (nonatomic, strong) NSMutableArray *teamMemberModels;//存储成员模型
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (nonatomic, strong) JGJTeamGroupInfoDetailRequest *infoDetailRequest; //请求详情页
@property (nonatomic, strong) JGJTeamInfoModel *teamInfo;
@property (nonatomic, strong) JGJTeamMemberCommonModel *commonModel;
@property (nonatomic, strong) JGJModifyTeamInfoRequestModel *modifyTeamInfoRequestModel;
@property (nonatomic, copy) ModifyTeamInfoBlock modifyTeamInfoBlock;
@property (strong, nonatomic) JGJRemoveGroupMemberRequestModel *removeGroupMemberRequestModel;
@property (strong, nonatomic) NSMutableArray *removeMembers;//移除的成员
@property (strong, nonatomic) JGJAddGroupMemberRequestModel *addGroupMemberRequestModel;

@property (nonatomic, strong) NSMutableArray *checkAllMembers;//查看所有成员

@property (nonatomic, assign) NSInteger maxNum;

@property (nonatomic, strong) NSMutableArray *clearCache;//清除缓存组

@property (nonatomic, strong) JGJCusBottomButtonView *buttonView;

@property (nonatomic, strong) JGJTabHeaderAvatarView *avatarheaderView;

@end

@implementation JGJGroupChatDetailInfoVc

@synthesize teamMemberModels = _teamMemberModels;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聊天信息";
    [self.logoutButton.layer setLayerCornerRadius:JGJCornerRadius];
    JGJTeamMemberCommonModel *commonModel = [JGJTeamMemberCommonModel new];
    NSArray *mangerModels = [self accordTypeGetMangerModels:commonModel]; //根据条件得到添加删除选项
    if (!self.teamMemberModels) {
        self.teamMemberModels = [NSMutableArray array];
    }
    [self.teamMemberModels addObjectsFromArray:mangerModels];
    
    self.tableView.tableFooterView = self.buttonView;
    
    TYWeakSelf(self);
    
    self.buttonView.handleCusBottomButtonViewBlock = ^(JGJCusBottomButtonView *buttonView) {
        
        [weakself handleLogoutGroupChatButtonAction:nil];
    };
    
    [TYLoadingHub showLoadingWithMessage:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadGetGroupInfo];
}

- (void)setTeamMemberModels:(NSMutableArray *)teamMemberModels {
    _teamMemberModels = teamMemberModels;
    [self.tableView reloadData];
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.detailCreatInfos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 2;
    
    if (section == JGJGroupChatDetailInfoHeadCellType) {
        
//        count = (self.teamInfo.members_num.integerValue > _maxNum ) ? 2 : 1;
        
        count = 1;
        
    }else if (section == JGJGroupChatDetailInfoEditNameCellType) {
        
        count = 1;
        
    }else if (section == JGJGroupChatDetailInfoMangerAuthorCellType) {
        
        count = self.teamInfo.is_admin ? 2 : 0;
        
    }else if (section == JGJGroupChatDetailInfoMsgSwitchCellType){
        
        count = 3;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    NSArray *sectionTitles = nil;
    JGJCreatTeamCell *teamCell = [JGJCreatTeamCell cellWithTableView:tableView];
    switch (indexPath.section) {
        case JGJGroupChatDetailInfoHeadCellType:{
            if (indexPath.row == 0) {
                
                JGJGroupSetMemberCell *memberCell = [JGJGroupSetMemberCell cellWithTableView:tableView];
                
                self.commonModel.memberType = JGJProMemberType;
                
                memberCell.commonModel = self.commonModel;
                
                memberCell.delegate = self;
                
                memberCell.members = self.teamMemberModels;
                
                cell = memberCell;
                
            }else if (indexPath.row == 1) {
                //                sectionTitles = self.detailCreatInfos[indexPath.section];
                //                teamCell.creatTeamModel = sectionTitles[0];
                //                teamCell.lineView.hidden = indexPath.row == 1;
                cell = [self handleCheckAllMemberTableView:tableView indexpath:indexPath];
            }
        }
            break;
        case JGJGroupChatDetailInfoGroupNameCellType:
        case JGJGroupChatDetailInfoEditNameCellType:
        case JGJGroupChatDetailInfoMangerAuthorCellType:{
            sectionTitles = self.detailCreatInfos[indexPath.section];
            JGJCreatTeamModel *creatTeamModel = sectionTitles[indexPath.row];
            if (indexPath.section == JGJGroupChatDetailInfoGroupNameCellType && indexPath.row == 0) {
                creatTeamModel.isHiddenArrow = !self.teamInfo.is_admin;
            }
            teamCell.creatTeamModel = creatTeamModel;
            if (indexPath.section == JGJGroupChatDetailInfoMangerAuthorCellType && indexPath.row == 0) {
                UIFont *remarkTitleFont = [UIFont systemFontOfSize:AppFont24Size];
                [teamCell.title markLineText:@"升级为工作中的项目组，便于进行项目沟通管理" withLineFont:remarkTitleFont withColor:AppFont999999Color lineSpace:2.0];
                teamCell.title.textAlignment = NSTextAlignmentLeft;
            }
            
            teamCell.lineView.hidden = sectionTitles.count - 1 == indexPath.row;
            cell = teamCell;
        }
            break;
        case JGJGroupChatDetailInfoMsgSwitchCellType:{
            
            sectionTitles = self.detailCreatInfos[indexPath.section];
            
            if (sectionTitles.count == indexPath.row) {
                
                cell = [self registerComPaddingCellWithTableView:tableView indexpath:indexPath];
                
            }else {
                
                JGJCusSwitchMsgCell *switchMsgCell = [JGJCusSwitchMsgCell cellWithTableView:tableView];
                
                switchMsgCell.commonModel = sectionTitles[indexPath.row];
                
                if (switchMsgCell.workProListModel.isClosedTeamVc) {
                    
                    switchMsgCell.workProListModel = self.workProListModel;
                }
                
                switchMsgCell.delegate = self;
                
                switchMsgCell.lineView.hidden = indexPath.row == 1;
                
                cell = switchMsgCell;
                
            }
            
        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 50.0;
    if (indexPath.section == 0 && indexPath.row == 0) {
//        height = [self calculateCollectiveViewHeight:self.teamMemberModels memberFlagType:0];
        
         height = [JGJGroupSetMemberCell memberCellHeight];
        
    }else if (indexPath.section == 0 && indexPath.row == 1) {
        
        height = 50;
        
    }else if (indexPath.section == 4 && indexPath.row == 0) {
        
        height = 60;
        
    } else if(indexPath.section == JGJGroupChatDetailInfoMsgSwitchCellType && indexPath.row == 2) {
        
        height += 10;
        
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = CGFLOAT_MIN;
    switch (section) {
        case JGJGroupChatDetailInfoHeadCellType: {
            
            height = [NSString stringWithContentWidth:TYGetUIScreenWidth - 125 content:_teamInfo.group_full_name font:AppFont34Size] + 21;
            
            if (height < [JGJTabHeaderAvatarView headerHeight]) {
                
                height = [JGJTabHeaderAvatarView headerHeight];
            }
        }
            break;
        case JGJGroupChatDetailInfoGroupNameCellType:
        case JGJGroupChatDetailInfoEditNameCellType:
        case JGJGroupChatDetailInfoMsgSwitchCellType:
            height = 10;
            break;
        case JGJGroupChatDetailInfoMangerAuthorCellType: {
            height = self.teamInfo.is_admin ? 10 : CGFLOAT_MIN;
        }
            break;
        default:
            break;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.workProListModel.isClosedTeamVc) { //已关闭班组不能点击
        return;
    }
    switch (indexPath.section) {
        case JGJGroupChatDetailInfoHeadCellType: {
            if (indexPath.row == 1) {
                [self handleCheckAllMember];
            }
        }
            break;
        case JGJGroupChatDetailInfoGroupNameCellType:
            if (indexPath.row == 0 && self.teamInfo.is_admin) { //修改群昵称
                [self handleModifyGroupName];
            }else if (indexPath.row == 1) {
                [self handelGenerateQrcodeAction]; //群二维码
            }
            break;
        case JGJGroupChatDetailInfoEditNameCellType: {
            [self handleModifyNikeName];
        }
            break;
        case JGJGroupChatDetailInfoMsgSwitchCellType:{
            
            if (indexPath.row == 2) {
                
                [self registerClearCacheWithTableView:tableView didSelectRowAtIndexPath:indexPath];
            }
        }
            break;
        case JGJGroupChatDetailInfoMangerAuthorCellType: {
            if (indexPath.row == 0) { //升级项目组
                [self handleUpgradeGroup];
            }else if (indexPath.row == 1) { //转让管理权
                [self handleTransferAuthor];
            }
            
        }
            break;
        default:
            break;
    }
}

- (UITableViewCell *)registerComPaddingCellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath{
    
    JGJComPaddingCell *cell = [JGJComPaddingCell cellWithTableView:tableView];
    
    cell.infoDesModel = self.clearCache[0];
    
    cell.centerY.constant = 5;
    
    return cell;
}

#pragma mark - JGJGroupSetMemberCellDelegate

- (void)selMemberWithCell:(JGJGroupSetMemberCell *)cell memberModel:(JGJSynBillingModel *)memberModel {
    
    if (self.workProListModel.isClosedTeamVc) { //已关闭班组不能点击
        
        return;
    }
    
    if (memberModel.isMangerModel) {
        
        if (memberModel.isAddModel) {
            
            [self handleAddMember];
            
        }else if (memberModel.isRemoveModel) {
            
            [self handleRemoveMember];
            
        }
        
    }else {
        
        cell.commonModel.teamModelModel = memberModel;
        
//        [self checkPerInfoWithMemberModel:memberModel];
        
        [self handleCheckAllMember];
        
    }
}

- (void)checkPerInfoWithMemberModel:(JGJSynBillingModel *)memberModel {
    
    JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
    perInfoVc.jgjChatListModel.uid = memberModel.uid;
    perInfoVc.jgjChatListModel.group_id = self.workProListModel.group_id;
    perInfoVc.jgjChatListModel.class_type = self.workProListModel.class_type;
    [self.navigationController pushViewController:perInfoVc animated:YES];
}

#pragma mark - 注册查看全部群成员Cell
- (UITableViewCell *)handleCheckAllMemberTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath {
    
    JGJCheckAllMemberCell *checkMemberCell  = [JGJCheckAllMemberCell cellWithTableView:tableView];
    
    checkMemberCell.offset = 10;
    
    return checkMemberCell;
}

#pragma mark - 查看全部成员
- (void)handleCheckAllMember {
    JGJCheckGroupChatAllMemberVc *allMemberVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJCheckGroupChatAllMemberVc"];
    
    self.teamInfo.team_info.is_admin = self.teamInfo.is_admin;
    
    allMemberVc.teamInfo = self.teamInfo;
    
    allMemberVc.memberModels = self.checkAllMembers;
    self.workProListModel.cur_group_id = self.teamInfo.group_info.group_id; //获取当前群id
    self.workProListModel.cur_class_type = self.teamInfo.group_info.class_type; //当前群类型
    self.workProListModel.class_type = self.teamInfo.group_info.class_type;
    allMemberVc.workProListModel = self.workProListModel;
    [self.navigationController pushViewController:allMemberVc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        self.avatarheaderView.avatars = _teamInfo.members_head_pic;
        
        self.avatarheaderView.title = _teamInfo.group_info.group_name;
        
        self.avatarheaderView.num = _teamInfo.members_num;
        
        return self.avatarheaderView;
        
    }else {
        
        UIView *headerView = [[UIView alloc] init];
        
        headerView.backgroundColor = AppFontf1f1f1Color;
        
        return headerView;
        
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

#pragma mark - 修改群名字
- (void)handleModifyGroupName {
    JGJEditNameVc *editNameVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJEditNameVc"];
    editNameVc.title = @"群聊名称";
    editNameVc.delegate = self;
    editNameVc.editNameVcType = JGJEditGroupNameVcType;
    NSArray *groupNameArray = self.detailCreatInfos[1];
    JGJCreatTeamModel *groupNameInfoModel = groupNameArray[0];
    editNameVc.defaultName = groupNameInfoModel.detailTitle;
    editNameVc.namePlaceholder = @"请输入群聊名称";
    [self.navigationController pushViewController:editNameVc animated:YES];
}

#pragma mark - 修改昵称
- (void)handleModifyNikeName {
    JGJEditNameVc *editNameVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJEditNameVc"];
    editNameVc.delegate = self;
    editNameVc.editNameVcType = JGJEditContactedNameVcType;
    //    NSArray *myNameArray = self.detailCreatInfos[2];
    //    JGJCreatTeamModel *myNameInfoModel = myNameArray[0];
    editNameVc.namePlaceholder = @"该名字只在本群显示";
    
    editNameVc.title = @"我在本群的名字";
    
    editNameVc.defaultName = self.teamInfo.nickname?:@"";
    
    [self.navigationController pushViewController:editNameVc animated:YES];
}

#pragma mark - 升级当前群聊
- (void)handleUpgradeGroup {
    JGJUpgradeGroupVc *upgradeGroupVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJUpgradeGroupVc"];
    upgradeGroupVc.delegate = self;
    upgradeGroupVc.nameStr = self.teamInfo.group_info.group_name;
    [self.navigationController pushViewController:upgradeGroupVc animated:YES];
}

#pragma mark - JGJUpgradeGroupVcDelegate
- (void)upgradeGroupVc:(JGJUpgradeGroupVc *)upgradeGroupVc upgrageGroupModel:(JGJCreatTeamModel *)upgrageGroupModel {
    
    [self handleHasSameProNameWtihUpgrageGroupModel:upgrageGroupModel];
    
}

- (void)handleHasSameProNameWtihUpgrageGroupModel:(JGJCreatTeamModel *)upgrageGroupModel {
    JGJUpgradeGroupSelectedMangerVc *selectedMangerVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJUpgradeGroupSelectedMangerVc"];
    self.workProListModel.group_name =  upgrageGroupModel.group_name;
    self.workProListModel.pro_name = upgrageGroupModel.pro_name;
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"is_real_name == %@",@(YES)];
//    NSMutableArray *authorityMembers = [_teamInfo.member_list filteredArrayUsingPredicate:predicate].mutableCopy;
    selectedMangerVc.members = _teamInfo.member_list;
    selectedMangerVc.workProListModel = self.workProListModel;
    [self.navigationController pushViewController:selectedMangerVc animated:YES];
}

#pragma mark - 转让管理权
- (void)handleTransferAuthor {
    NSString *myTelephone = [TYUserDefaults objectForKey:JLGPhone];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"telephone != %@ && isMangerModel != %@", myTelephone,@(YES)];
    JGJTransferAuthorityVc *authorityVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJTransferAuthorityVc"];
    authorityVc.membersVcType = JGJTransferAuthorityVcType;
    authorityVc.workProListModel = self.workProListModel;
    authorityVc.members = [_teamInfo.member_list filteredArrayUsingPredicate:predicate].mutableCopy;
    if (authorityVc.members.count > 0) {
        [self.navigationController pushViewController:authorityVc animated:YES];
    }else {
        [TYShowMessage showSuccess:@"没有更多成员，不能转让管理权"];
    }
}
#pragma mark - JGJEditNameVcDelegate

- (void)editNameVc:(JGJEditNameVc *)editNameVc nameString:(NSString *)nameTF {
    if (editNameVc.editNameVcType == JGJEditContactedNameVcType) {
        
        self.modifyTeamInfoRequestModel.nickname = nameTF;
        
        if ([NSString isEmpty:nameTF]) {
            
            self.modifyTeamInfoRequestModel.nickname = @"";
        }
        
        [self modifyTeamInfo:self.modifyTeamInfoRequestModel];
        __weak typeof(self) weakSelf = self;
        self.modifyTeamInfoBlock = ^ {
            NSArray *groupNameArray = weakSelf.detailCreatInfos[1];
            JGJCreatTeamModel *groupNameInfoModel = groupNameArray[0];
            weakSelf.modifyTeamInfoRequestModel.group_name = groupNameInfoModel.detailTitle;
            
            NSArray *myNameInfoArray = weakSelf.detailCreatInfos[2];
            JGJCreatTeamModel *myNameInfoModel = myNameInfoArray[0];
            myNameInfoModel.detailTitle = nameTF ?:@"";
            [editNameVc.navigationController popViewControllerAnimated:YES];
        };
    }else if (editNameVc.editNameVcType == JGJEditGroupNameVcType) {
        
        NSArray *tips = @[@"吉工家", @"吉工宝", @"官方"];
        
        BOOL is_exist = NO;
        
        for (NSString *tip in tips) {
            
            if ([nameTF containsString:tip]) {
                
                is_exist = YES;
                
                break;
            }
        }
        
        if (is_exist) {
            
            [TYShowMessage showPlaint:@"群名称中不能包含吉工家、吉工宝、官方"];
            
            return;
        }
        
        self.modifyTeamInfoRequestModel.group_name = nameTF;
        [self modifyTeamInfo:self.modifyTeamInfoRequestModel];
        __weak typeof(self) weakSelf = self;
        self.modifyTeamInfoBlock = ^ {
            NSArray *groupNameArray = weakSelf.detailCreatInfos[1];
            JGJCreatTeamModel *groupNameInfoModel = groupNameArray[0];
            groupNameInfoModel.detailTitle = nameTF;
            [weakSelf refreshSection:1 row:0];
            [editNameVc.navigationController popViewControllerAnimated:YES];
        };
    }
}

#pragma mark - JGJGroupChatInfoMemberCellDelegate
- (void)handleJGJGroupChatInfoMemberCell:(JGJGroupChatInfoMemberCell *)cell commonModel:(JGJTeamMemberCommonModel *)commonModel memberModel:(JGJSynBillingModel *)memberModel {
    NSString *myTel = [TYUserDefaults objectForKey:JLGPhone];
    if (memberModel.isAddModel) {
        
        [self handleAddMember];
        
    }else if (memberModel.isRemoveModel) {
        
        [self handleRemoveMember];
        
    }else  { //全部能点击
        
        [self checkPerInfoWithMemberModel:memberModel];
        
    }
}

#pragma mark - 添加人员
- (void)handleAddMember {
    JGJGroupChatDetailInfoAddMemberVc *addMemberVc  = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJGroupChatDetailInfoAddMemberVc"];
    addMemberVc.contactedAddressBookVcType = JGJContactedAddressBookAddMembersVcType;//群聊详情添加人员
    self.workProListModel.cur_group_id = self.teamInfo.group_id; //获取当前群id
    self.workProListModel.cur_class_type = self.teamInfo.class_type; //当前群类型
    addMemberVc.workProListModel = self.workProListModel;
    
     addMemberVc.teamInfo = self.teamInfo;//获取人员，添加人员使用
    
    TYLog(@"%@ === %@ === %@", self.workProListModel.cur_group_id, self.workProListModel.cur_class_type, self.workProListModel.group_name);
    
    [self.navigationController pushViewController:addMemberVc animated:YES];
}

- (NSString *)getMembers {
    
    NSMutableString *uids = [[NSMutableString alloc] init];
    
    for (JGJSynBillingModel *member in _teamInfo.member_list) {
        
        NSString *uid = [NSString stringWithFormat:@"%@,",member.telephone];
        
        [uids appendFormat:@"%@", uid];
    }
    
    return uids;
}

#pragma mark - 移除人员
- (void)handleRemoveMember {
    JGJSynBillingCommonModel *synBillingCommonModel = [[JGJSynBillingCommonModel alloc] init];
    JGJAddTeamMemberVC *removeMemberVC = [[UIStoryboard storyboardWithName:@"JGJCreatTeam" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJAddTeamMemberVC"];
    removeMemberVC.delegate = self;
    synBillingCommonModel.synBillingTitle = @"删除成员";
    ;
    removeMemberVC.groupMemberMangeType = JGJGroupMemberMangeRemoveMemberType;
    removeMemberVC.currentTeamMembers = [self handleGetRemoveMembers];
    removeMemberVC.synBillingCommonModel = synBillingCommonModel;
    [self.navigationController pushViewController:removeMemberVC animated:YES];
}

#pragma mark - 处理得到移除的成员
- (NSArray *)handleGetRemoveMembers{
    NSString *myTel = [TYUserDefaults objectForKey:JLGPhone];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isMangerModel != %@ and telephone != %@", @(YES),myTel];
    NSArray *contacts = [self.teamMemberModels filteredArrayUsingPredicate:predicate];
    return contacts;
}

#pragma mark - 处理二维码生成
- (void)handelGenerateQrcodeAction {
    JGJCreateGroupVc *joinGroupVc = [JGJCreateGroupVc new];
    
    NSArray *groupNameArray = self.detailCreatInfos[1];
    
    self.workProListModel.team_name = nil;
    
    self.workProListModel.group_name = _teamInfo.group_info.group_name;
    
    if (self.teamInfo.members_head_pic.count > 0) {
        
        self.workProListModel.members_head_pic = self.teamInfo.members_head_pic;
    }
    
    joinGroupVc.workProListModel = self.workProListModel;
    
    [self.navigationController pushViewController:joinGroupVc animated:YES];
}

#pragma mark - JGJGroupMemberMangeDelegate 返回删除和添加的成员
- (void)handleJGJGroupMemberSelectedTeamMembers:(NSMutableArray *)teamsMembers groupMemberMangeType:(JGJGroupMemberMangeType)groupMemberMangeType {
    switch (groupMemberMangeType) {
        case JGJGroupMemberMangePushNotifyType:
        case JGJGroupMemberMangeAddMemberType:
            break;
        case JGJGroupMemberMangeRemoveMemberType:
            [self upLoadRemoveGroupMembers:teamsMembers groupMemberMangeType:JGJGroupMemberMangeRemoveMemberType];
            break;
        default:
            break;
    }
}

#pragma mark - 移除班组成员
- (void)upLoadRemoveGroupMembers:(NSMutableArray *)teamMembers groupMemberMangeType:(JGJGroupMemberMangeType)groupMemberMangeType {
    self.removeMembers = teamMembers;
    NSMutableString *appendMemberUid = [NSMutableString string];
    for (JGJSynBillingModel *teamMemberModel in teamMembers) {
        teamMemberModel.isSelected = NO;
        teamMemberModel.isAddedSyn = NO; //清楚返回的选择和添加状态
        [appendMemberUid appendString:teamMemberModel.uid ?: @""];
        [appendMemberUid appendString:@","];
    }
    if (appendMemberUid.length > 0) {
        [appendMemberUid deleteCharactersInRange:NSMakeRange(appendMemberUid.length - 1, 1)];
    }
    __weak typeof(self) weakSelf = self;
    
    self.removeGroupMemberRequestModel.uid = appendMemberUid;
    
    NSDictionary *parameters = [self.removeGroupMemberRequestModel mj_keyValues];
    
    [JLGHttpRequest_AFN PostWithNapi:JGJGroupDelMembersURL parameters:parameters success:^(id responseObject) {
        
        [TYShowMessage showSuccess:@"删除成功"];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - JGJCusSwitchMsgCellDelegate
- (void)cusSwitchMsgCell:(JGJCusSwitchMsgCell *)cell switchType:(JGJCusSwitchMsgCellType)switchType {
    switch (switchType) {
        case JGJCusSwitchRepulseMsgCell:{
            [self JGJCusSwitchRepulseMsgCell:cell switchType:switchType];
        }
            break;
        case JGJCusSwitchStickMsgCell:{
            [self JGJCusSwitchStickMsgCell:cell switchType:switchType];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 回置顶或者取消打扰
- (void)JGJCusSwitchRepulseMsgCell:(JGJCusSwitchMsgCell *)cell switchType:(JGJCusSwitchMsgCellType)switchType {
    TYLog(@"switchType=== %ld isOpen--- %@", switchType, @(cell.commonModel.isOpen));
    
    self.modifyTeamInfoRequestModel.is_not_disturbed = [NSString stringWithFormat:@"%@", @(cell.commonModel.isOpen)];
    [self modifyTeamInfo:self.modifyTeamInfoRequestModel];
    __weak typeof(self) weakSelf = self;
    self.modifyTeamInfoBlock = ^ {
        
        NSArray *msgDisturbArray = weakSelf.detailCreatInfos[3];
        JGJChatDetailInfoCommonModel *msgDisturbModel = msgDisturbArray[0];
        msgDisturbModel.isOpen = cell.commonModel.isOpen;
        
        //已删除并关闭聊聊表更新
        JGJChatGroupListModel *groupListModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:weakSelf.workProListModel.group_id classType:weakSelf.workProListModel.class_type];
        
        groupListModel.is_no_disturbed = cell.commonModel.isOpen;
        
        [JGJChatMsgDBManger updateChatGroupListTableWithJGJChatMsgListModel:groupListModel];
    };
}

- (void)JGJCusSwitchStickMsgCell:(JGJCusSwitchMsgCell *)cell switchType:(JGJCusSwitchMsgCellType)switchType {
    __weak typeof(self) weakSelf = self;
    
    NSString *status = cell.commonModel.isOpen ? @"0" : @"1";
    
    NSDictionary *parameters = @{
                                 @"status" : status,
                                 
                                 @"class_type" : self.workProListModel.class_type?:@"",
                                 
                                 @"group_id" : self.workProListModel.group_id?:@""
                                 
                                 };
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:@"chat/set-stick" parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        [JGJChatMsgDBManger updateIs_topToGroupTableWithIsTop:cell.commonModel.isOpen group_id:self.workProListModel.group_id class_type:self.workProListModel.class_type];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}

#pragma mark - ButtonAction
#pragma mark - 处理删除并退出按钮
- (void)handleLogoutGroupChatButtonAction:(UIButton *)sender {
    
    NSDictionary *parameters = @{
                                 @"class_type" : self.workProListModel.class_type?:@"",
                                 
                                 @"group_id" : self.workProListModel.group_id?:@""
                                 
                                 };
    
    CustomAlertView *alertView = [CustomAlertView showWithMessage:@"删除并退出后,将不再接收此群消息你确定要删除并退出此群吗?" leftButtonTitle:@"取消" midButtonTitle:nil rightButtonTitle:@"确定"];
    
    alertView.messageLabel.textAlignment = NSTextAlignmentLeft;
    
    __weak typeof(self) weakSelf = self;
    
    alertView.onOkBlock = ^{
        
        [TYLoadingHub showLoadingWithMessage:nil];
        
        [JLGHttpRequest_AFN PostWithNapi:JGJQuitMembersURL parameters:parameters success:^(id responseObject) {
            
            [TYShowMessage showSuccess:@"退出成功"];
            
            //删除数据
            [self delGroupListWithProListModel:self.workProListModel];
            
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            
            [TYLoadingHub hideLoadingView];
            
        } failure:^(NSError *error) {
            
            [TYShowMessage showHUDOnly:@"网络错误"];
            
            [TYLoadingHub hideLoadingView];
            
        }];
    };
}

//永久删除和退出
- (void)delGroupListWithProListModel:(JGJMyWorkCircleProListModel *)proListModel {
    
    // 删除聊聊列表数据
    
    JGJChatGroupListModel *groupModel = [JGJChatGroupListModel new];
    
    groupModel.class_type = proListModel.class_type;
    
    groupModel.group_id = proListModel.group_id;
    
    [JGJChatMsgDBManger deleteChatGroupListDataWithModel:groupModel];
}

#pragma mark - 加载班组详情信息
- (void)loadGetGroupInfo {
    
    NSDictionary *parameters = [self.infoDetailRequest mj_keyValues];
    
    [JLGHttpRequest_AFN PostWithNapi:JGJGetGroupInfoURL parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        JGJTeamInfoModel *teamInfoModel = [JGJTeamInfoModel mj_objectWithKeyValues:responseObject];
        
        self.teamInfo = teamInfoModel;
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)setTeamInfo:(JGJTeamInfoModel *)teamInfo {
    _teamInfo = teamInfo;
    NSArray *groupNameArray = self.detailCreatInfos[1];
    JGJCreatTeamModel *groupNameInfoModel = groupNameArray[0];
    groupNameInfoModel.detailTitle = _teamInfo.group_info.group_name;
    
    NSArray *myNameInfoArray = self.detailCreatInfos[2];
    JGJCreatTeamModel *myNameInfoModel = myNameInfoArray[0];
    myNameInfoModel.detailTitle = _teamInfo.nickname ?:@"";
    
    NSArray *msgDisturbArray = self.detailCreatInfos[3];
    JGJChatDetailInfoCommonModel *msgDisturbModel = msgDisturbArray[0];
    msgDisturbModel.isOpen = _teamInfo.is_no_disturbed;
    
    JGJChatDetailInfoCommonModel *msgStickModel = msgDisturbArray[1];
    msgStickModel.isOpen = _teamInfo.is_sticked;
    
    self.teamMemberModels = _teamInfo.member_list;
    
    //获得所有成员
    self.checkAllMembers = _teamInfo.team_group_members.mutableCopy;
    
    NSInteger line = ProSetMemberRow;
    
    if (_teamInfo.is_admin || self.workProListModel.teamMangerVcType == JGJProMangerType) {
        
//         _maxNum = TYIS_IPHONE_5_OR_LESS ? line * 4 - 2 : line * 5 - 2;
        
        _maxNum = [JGJGroupSetMemberCell headerCount] - 2;
        
    }else {
        
//        _maxNum = TYIS_IPHONE_5_OR_LESS ? line * 4 - 1 : line * 5 - 1;
        
        _maxNum = [JGJGroupSetMemberCell headerCount] - 1;
        
    }
    
    if (_teamInfo.member_list.count > _maxNum) {
        
        self.teamMemberModels = [_teamInfo.member_list subarrayWithRange:NSMakeRange(0, _maxNum)].mutableCopy;
    }
    
    _teamInfo.members_num = [NSString stringWithFormat:@"%@", @(_teamInfo.member_list.count)];
    
    self.workProListModel.members_num = [NSString stringWithFormat:@"%@", @(_teamInfo.member_list.count)];
    self.title = [NSString stringWithFormat:@"聊天信息(%@)", @(_teamInfo.member_list.count)];
    NSArray *mangerModels = [self accordTypeGetMangerModels:self.commonModel]; //根据条件得到添加删除选项
    if (!self.teamMemberModels) {
        self.teamMemberModels = [NSMutableArray array];
    }
    [self.teamMemberModels addObjectsFromArray:mangerModels];
    
    //添加加减符号
    [self.checkAllMembers addObjectsFromArray:mangerModels];
    
    [self.tableView reloadData];
    
    [self setChatTitleInfo:teamInfo];
    
    //拼接成员id
    self.workProListModel.member_uids = [self getMembers];
    
    //更新聊聊表
    [self updateGroupListDB];
}

#pragma mark - 更新聊聊表
- (void)updateGroupListDB {
    
    //更新聊聊表
    JGJChatGroupListModel *groupModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:self.workProListModel.group_id classType:self.workProListModel.class_type];
    
    groupModel.members_num = _teamInfo.members_num;
    
    groupModel.local_head_pic = [_teamInfo.members_head_pic mj_JSONString];
    
    groupModel.group_name =  _teamInfo.group_info.group_name;
    
    //更新聊聊表结束
    [JGJChatMsgDBManger updateChatGroupListTableWithJGJChatMsgListModel:groupModel];
}

#warning 3.2.0优化接口

- (void)setChatTitleInfo:(JGJTeamInfoModel *)teamInfo {
    
    self.workProListModel.group_name = [NSString stringWithFormat:@"%@",teamInfo.group_info.group_name]; //传入修改的名字
    
    self.workProListModel.team_name = nil; //模型getter方法判断，这里保证唯一
    
    self.workProListModel.members_num = teamInfo.members_num;
    
}

#pragma mark - 修改班组信息
- (void)modifyTeamInfo:(JGJModifyTeamInfoRequestModel *)modifyTeamInfoRequestModel {
    
    NSDictionary *parameters = [self.modifyTeamInfoRequestModel mj_keyValues];
    
    __weak typeof(self) weakSelf = self;
    
    [JLGHttpRequest_AFN PostWithNapi:JGJGroupModifyURL parameters:parameters success:^(id responseObject) {
        
        if (weakSelf.modifyTeamInfoBlock) {
            
            weakSelf.modifyTeamInfoBlock();
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (NSMutableArray *)detailCreatInfos {

    NSArray *allInfos = @[@[@"查看全部群成员"], @[@"群聊名称",@"群二维码"],@[@"我在本群的名字"],@[@"升级为项目组\n升级为工作中的项目组，便于进行项目沟通管理",@"转让管理权"]];
    NSArray *fourTitles = @[@"消息免打扰",@"置顶聊天"];
    NSArray *switchTypes = @[@(JGJCusSwitchRepulseMsgCell), @(JGJCusSwitchStickMsgCell)];
    if (!_detailCreatInfos) {
        _detailCreatInfos = [NSMutableArray array];
        [allInfos enumerateObjectsUsingBlock:^(NSArray  * titles, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableArray *sectionTitles = [NSMutableArray array];
            for (int indx = 0; indx < titles.count; indx++) {
                JGJCreatTeamModel *teamModel = [[JGJCreatTeamModel alloc] init];
                teamModel.title = titles[indx];
                teamModel.isShowQrcode = indx == 1 && idx == 1;
                [sectionTitles addObject:teamModel];
            }
            [_detailCreatInfos addObject:sectionTitles];
        }];
        NSMutableArray *fourSectionModels = [NSMutableArray array];
        for (int indx = 0; indx < fourTitles.count; indx ++) {
            JGJChatDetailInfoCommonModel *commonModel  = [JGJChatDetailInfoCommonModel new];
            commonModel.switchMsgType = [switchTypes[indx] integerValue];
            commonModel.title = fourTitles[indx];
            commonModel.isOpen = NO;
            [fourSectionModels addObject:commonModel];
        }
        [_detailCreatInfos insertObject:fourSectionModels atIndex:3];
    }
    return _detailCreatInfos;
}

- (CGFloat)calculateCollectiveViewHeight:(NSArray *)dataSource  memberFlagType:(MemberFlagType) memberFlagType {
    NSInteger lineCount = 0;
    if (memberFlagType == DefaultTeamMemberFlagType) {
        
        TYLog(@"-----%ld", (unsigned long)dataSource.count);
    }
    NSUInteger teamMemberCount = dataSource.count;
    
    CGFloat padding = 15;
    
    lineCount = ((teamMemberCount / MemberRowNum) + (teamMemberCount % MemberRowNum != 0 ? 1 : 0));
    
    CGFloat collectionViewHeight = lineCount * ItemHeight + padding;
    
    return collectionViewHeight;
}
#pragma mark - 根据条件类型返回添加和删除模型
- (NSMutableArray *)accordTypeGetMangerModels:(JGJTeamMemberCommonModel *)commonModel {
    NSMutableArray *dataSource = [NSMutableArray array];
    if (self.workProListModel.isClosedTeamVc == YES) {
        return dataSource;
    }
    NSArray *picNames = @[@"menber_add_icon", @"member_ minus_icon"];
    NSArray *titles = @[@"添加", @"删除"];
    NSInteger count = 2;
    if (self.teamInfo.is_admin) {
        count = self.teamInfo.member_list.count == 0 ? 1 : 2;
    }else {
        count = 1;
    }
    for (int idx = 0; idx < count; idx ++) {
        JGJSynBillingModel *memberModel = [[JGJSynBillingModel alloc] init];
        memberModel.isMangerModel = YES;
        if (idx == 0) {
            memberModel.addHeadPic = picNames[0];
            memberModel.isAddModel = YES;
        }
        if (idx == 1) {
            memberModel.removeHeadPic = picNames[1];
            memberModel.isRemoveModel = YES;
        }
        memberModel.real_name = titles[idx];
        [dataSource addObject:memberModel];
    }
    return dataSource;
}

#pragma mark - 刷新位置
- (void)refreshSection:(NSUInteger)section row:(NSUInteger)row {
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:section];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

- (JGJTeamGroupInfoDetailRequest *)infoDetailRequest {
    
    if (!_infoDetailRequest) {
        
        _infoDetailRequest = [[JGJTeamGroupInfoDetailRequest alloc] init];
        
        _infoDetailRequest.group_id = self.workProListModel.group_id;
        
        _infoDetailRequest.class_type = @"groupChat";
        
    }
    return _infoDetailRequest;
}

- (JGJTeamMemberCommonModel *)commonModel {
    
    if (!_commonModel) {
        _commonModel = [[JGJTeamMemberCommonModel alloc] init];
    }
    return _commonModel;
}

#pragma mark - 初始化修改班组信息模型 这里传入id
- (JGJModifyTeamInfoRequestModel *)modifyTeamInfoRequestModel {
    if (!_modifyTeamInfoRequestModel) {
        _modifyTeamInfoRequestModel = [[JGJModifyTeamInfoRequestModel alloc] init];
        _modifyTeamInfoRequestModel.ctrl = @"group";
        _modifyTeamInfoRequestModel.action = @"modifyGroupInfo";
        _modifyTeamInfoRequestModel.class_type = @"groupChat";
        _modifyTeamInfoRequestModel.group_id = self.workProListModel.group_id;
    }
    return _modifyTeamInfoRequestModel;
}

- (JGJRemoveGroupMemberRequestModel *)removeGroupMemberRequestModel {
    
    if (!_removeGroupMemberRequestModel) {
        _removeGroupMemberRequestModel = [[JGJRemoveGroupMemberRequestModel alloc] init];
        _removeGroupMemberRequestModel.ctrl = @"group";
        _removeGroupMemberRequestModel.group_id = self.workProListModel.group_id;
        _removeGroupMemberRequestModel.action = @"delMembers";
        _removeGroupMemberRequestModel.class_type = self.workProListModel.class_type ?:@"groupChat";
    }
    return _removeGroupMemberRequestModel;
}

#pragma mark - JGJCustomBottomCellDelegate
- (void)customBottomCellButtonPressed:(JGJCustomBottomCell *)cell {
    
    [self handleLogoutGroupChatButtonAction:nil];
}

- (NSMutableArray *)clearCache {
    
    if (!_clearCache) {
        
        _clearCache = [NSMutableArray array];
        
        NSArray *titles = @[@"清空聊天记录"];
        
        for (int indx = 0; indx < titles.count; indx ++) {
            
            JGJCommonInfoDesModel *infoDesModel = [[JGJCommonInfoDesModel alloc] init];
            
            infoDesModel.title = titles[indx];
            
            [_clearCache addObject:infoDesModel];
            
        }
    }
    
    return _clearCache;
}

- (void)registerClearCacheWithTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
    
    desModel.popDetail = @"确定清空聊天记录吗？";
    
    desModel.leftTilte = @"取消";
    
    desModel.rightTilte = @"确定";
    
    desModel.popTextAlignment = NSTextAlignmentCenter;
    
    JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
    
    TYWeakSelf(self);
    
    alertView.onOkBlock = ^{
        
        [weakself clearChatMsgDB];
        
    };
}

#pragma mark - JGJTabHeaderAvatarViewDelegate

- (void)tabHeaderAvatarView:(JGJTabHeaderAvatarView *)avatarView {
    
    [self handleCheckAllMember];
}

#pragma mark - 清除数据库缓存
- (void)clearChatMsgDB {
    
    JGJChatMsgListModel *msgModel = [[JGJChatMsgListModel alloc] init];
    
    msgModel.class_type = self.workProListModel.class_type;
    
    msgModel.group_id = self.workProListModel.group_id;
    
    //现将要清除的消息id存入数据库，然后再删除
    
    msgModel = [JGJChatMsgDBManger maxMsgListModelWithChatMsgListModel:msgModel];
    
    JGJChatClearCacheModel *cacheModel = [JGJChatClearCacheModel mj_objectWithKeyValues:[msgModel mj_keyValuesWithKeys:@[@"class_type",@"group_id",@"msg_id"]]];
    
    [JGJChatMsgDBManger insertToCacheModelTableWithCacheModel:cacheModel];
    
    //清除消息表
    [JGJChatMsgDBManger delGroupMsgModel:msgModel];
    
    //移除数据源
    JGJChatListAllVc *msgListVc = [self getAllMsgListVc];
    
    if (msgListVc.dataSourceArray.count > 0) {
        
        [msgListVc.dataSourceArray removeAllObjects];
    }
    
    if (msgListVc.muSendMsgArray.count > 0) {
        
        [msgListVc.muSendMsgArray removeAllObjects];
    }
    
    [msgListVc.tableView reloadData];
    
    [TYShowMessage showSuccess:@"清空成功！"];
}

- (JGJChatListAllVc *)getAllMsgListVc {
    
    JGJChatListAllVc *chatAllVc = nil;
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:[JGJChatRootVc class]]) {
            
            JGJChatRootVc *chatRootVc = (JGJChatRootVc *)vc;
            
            JGJChatRootChildVcModel *rootChildVcModel = (JGJChatRootChildVcModel *)chatRootVc.childVcs[0];
            
            chatAllVc = (JGJChatListAllVc *)rootChildVcModel.vc;
        }
    }
    
    return chatAllVc;
}

- (JGJCusBottomButtonView *)buttonView {
    
    if (!_buttonView) {
        
        CGFloat height = [JGJCusBottomButtonView cusBottomButtonViewHeight];
        
        _buttonView = [[JGJCusBottomButtonView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, height)];
        
        [_buttonView.actionButton setTitle:@"删除并退出" forState:UIControlStateNormal];
        
        _buttonView.backgroundColor = AppFontf1f1f1Color;
    }
    return _buttonView;
}

- (JGJTabHeaderAvatarView *)avatarheaderView {
    
    if (!_avatarheaderView) {
        
        _avatarheaderView = [[JGJTabHeaderAvatarView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, [JGJTabHeaderAvatarView headerHeight])];
        
        _avatarheaderView.delegate = self;
        
    }
    
    return _avatarheaderView;
}

@end


