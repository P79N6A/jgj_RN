//
//  JGJTeamMangerVC.m
//  mix
//
//  Created by YJ on 16/8/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJTeamMangerVC.h"
#import "JGJCreatTeamCell.h"
#import "JGJTeamMemberCell.h"
#import "JGJCreateGroupVc.h"
#import "YZGOnlyAddProjectViewController.h"
#import "JGJSelectedCurrentCityVC.h"
#import "JGJAddTeamMemberVC.h"
#import "NSString+Extend.h"
#import "CustomAlertView.h"
#import "JGJCustomAlertView.h"
#import "TYFMDB.h"
#import "NSString+JSON.h"
#import "NSString+File.h"
#import "JGJCustomProInfoAlertVIew.h"
#import "JGJCusSwitchMsgCell.h"
#import "JGJPerInfoVc.h"
#import "JGJChatListTool.h"
#import "JGJChatRootVc.h"
#import "JGJChatListAllVc.h"

#import "JGJCusActiveSheetView.h"

#import "JGJProSetDesCell.h"

#import "JGJCheckGroupChatAllMemberVc.h"

#import "JGJMemberSelTypeVc.h"

#import "JGJKnowledgeDaseTool.h"

#import "JGJCheckAllMemberCell.h"

#import "JGJCusButtonSheetView.h"

#import "JGJTabHeaderAvatarView.h"

#import "JGJTabPaddingView.h"

#import "JGJComRemarkCell.h"

#import "JGJSetAgentMonitorController.h"

#import "JGJCommonTitleCell.h"

#import "JGJCustomPopView.h"

#import "JGJChatMsgDBManger.h"

#import "JGJChatMsgDBManger+JGJClearCacheDB.h"

#import "JGJChatMsgDBManger+JGJGroupDB.h"
#import "JGJChatGetOffLineMsgInfo.h"
#import "NSDate+Extend.h"

#import "JGJGroupSetMemberCell.h"

#import "JGJMemberDesCell.h"

typedef enum : NSUInteger {
    TeamMangerBloneProType,
    TeamMangerQrcodeType,
    TeamMangerTeamNameType,
    TeamMangerTeamPlaceType,
    TeamMangerTeamAgencyType //代理班组长
} TeamMangerCellType;

typedef enum : NSUInteger {
    TeamMangerCellMemberType = 0,//成员组
    TeamMangerCellReporedMemberType,//汇报对象
    TeamMangerCellTeamInfoType,//项目信息
    TeamMangerCellMineInfoType,//我的信息组
    TeamMangerCellDistubMsgInfoType,//免打扰
    TeamMangerCellClearCacheType, //清除缓存组
    TeamMangerCellSetAdminType,
    TeamMangerCellServiceType //服务类型
} TeamMangerType;

typedef void(^ModifyTeamInfoBlock)();

typedef void(^UploadSuccessPopVcBlock)();

@interface JGJTeamMangerVC ()  <
    UITableViewDelegate,
    UITableViewDataSource,
    YZGOnlyAddProjectViewControllerDelegate,
    JGJSelectedCurrentCityVCDelegate,
    JGJTeamMemberCellDelegate,
    JGJAddTeamMemberDelegate,
    JGJCusSwitchMsgCellDelegate,
    JGJCustomProInfoAlertViewDelegate,
    JGJGroupSetMemberCellDelegate,
    JGJTabHeaderAvatarViewDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *creatTeamModels;//创建班组模型数组
@property (nonatomic, strong) NSMutableArray *proNameArray;//存储所属项目
@property (nonatomic, strong) NSMutableArray *teamMemberModels;//存储班组成员模型
@property (nonatomic, assign) MemberFlagType memberFlagType;
@property (nonatomic, strong) NSMutableArray *commonModels;//存储通用模型数据设置头部标题类型和数量
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containBottomButtonViewH;

@property (unsafe_unretained, nonatomic) IBOutlet UIBarButtonItem *rightItemButton;
@property (strong, nonatomic) JGJAddGroupMemberRequestModel *addGroupMemberRequestModel;
@property (nonatomic, strong) JGJTeamInfoModel *teamInfo;
@property (nonatomic, strong) JGJModifyTeamInfoRequestModel *modifyTeamInfoRequestModel;
@property (nonatomic, strong) JGJRemoveGroupMemberRequestModel *removeGroupMemberRequestModel;
@property (nonatomic, copy) ModifyTeamInfoBlock modifyTeamInfoBlock;
@property (nonatomic, strong) JLGCityModel *cityModel;//显示当前选择的所在城市

@property (nonatomic, strong) NSMutableArray *mineInfos;//我在本组的名字

@property (nonatomic, strong) NSMutableArray *msgDisturbInfos;//消息免打扰信息

@property (nonatomic, strong) NSMutableArray *checkAllMembers;//查看所有成员

@property (nonatomic, strong) NSMutableArray *clearCache;//清除缓存组

@property (nonatomic, assign) NSInteger maxNum;

//分享菜单
@property (nonatomic, strong) JGJKnowledgeDaseTool *shareMenuTool;

@property (nonatomic, strong) JGJTabHeaderAvatarView *avatarheaderView;

//上传成功返回
@property (nonatomic, copy) UploadSuccessPopVcBlock uploadSuccessPopVcBlock;

@end

@implementation JGJTeamMangerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonSet];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYTableViewFooterHeight)];
    footerView.backgroundColor = [UIColor clearColor];
    
    self.tableView.tableFooterView = footerView;
    
    JGJTabPaddingView *headerView = [JGJTabPaddingView tabPaddingView];
    
    headerView.topLineView.hidden = YES;
    
    self.tableView.tableHeaderView = headerView;
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
    [TYLoadingHub showLoadingWithMessage:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadGetGroupInfo];
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    switch (section) {
        case TeamMangerCellMemberType:{
            
//            count = (self.teamInfo.members_num.integerValue > _maxNum ) ? 2 : 1;
            
            count = 1;
        }

            break;
        case TeamMangerCellReporedMemberType:
            count = self.teamInfo.report_user_list.count > 0 ? 2 : 0; //汇报者对象
            break;
        case TeamMangerCellTeamInfoType:{
            
            count = self.creatTeamModels.count;
            
        }
            break;
        case TeamMangerCellMineInfoType:
            
            count = self.mineInfos.count;
            
            break;
        case TeamMangerCellDistubMsgInfoType:
            
            count = self.msgDisturbInfos.count;
            
            break;
        
        case TeamMangerCellClearCacheType:
            
            count = self.clearCache.count;
            
            break;
        default:
            break;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    JGJCreatTeamCell *teamCell = [JGJCreatTeamCell cellWithTableView:tableView];
    switch (indexPath.section) {
        case TeamMangerCellMemberType: {
            
            if (indexPath.row == 0) {

                JGJGroupSetMemberCell *memberCell = [JGJGroupSetMemberCell cellWithTableView:tableView];
                
                JGJTeamMemberCommonModel *commonModel = self.commonModels[0];
                
                commonModel.memberType = JGJProMemberType;
                
                memberCell.commonModel = commonModel;
                
                memberCell.delegate = self;
                
                memberCell.members = self.teamMemberModels;
                
                cell = memberCell;
                
            }else {
            
                cell = [self handleCheckAllMemberTableView:tableView indexpath:indexPath];
                
            }
            
        }
            break;
        case TeamMangerCellReporedMemberType: {
            
            if (indexPath.row == 0) {
                
                cell = [self sourceDesCellWithTableView:tableView indexpath:indexPath];
                
            }else if (indexPath.row == 1) {
                
                cell = [self registerReporedMemberCellWithtableView:tableView cellForRowAtIndexPath:indexPath];
            }
            
        }
            break;
        case TeamMangerCellTeamInfoType: {
            
            if ((indexPath.row == self.creatTeamModels.count - 1) && (self.teamMangerVcType == JGJCreaterTeamMangerVcType || [self isAgency])) {
                
                JGJComRemarkCell *agencyCell = [JGJComRemarkCell cellWithTableView:tableView];
                
                JGJCreatTeamModel *agencyModel = self.creatTeamModels.lastObject;
                
                agencyCell.isAgency = [self isAgency];
                
                agencyCell.teamModel = agencyModel;
                
                cell = agencyCell;
                
            }else {
                
                teamCell.lineView.hidden = indexPath.row == self.creatTeamModels.count - 1;
                teamCell.creatTeamModel = self.creatTeamModels[indexPath.row];
                cell = teamCell;
                
            }
            
        }
            break;
        case TeamMangerCellMineInfoType: {
            cell = [self handleRegisterMineInfoTableView:tableView indexpath:indexPath];
        }
            break;
        case TeamMangerCellDistubMsgInfoType:{
            JGJCusSwitchMsgCell *switchMsgCell = [JGJCusSwitchMsgCell cellWithTableView:tableView];
            switchMsgCell.commonModel = self.msgDisturbInfos[indexPath.row];
            if (self.workProListModel.isClosedTeamVc || self.workProListModel.workCircleProType == WorkCircleExampleProType) {
                switchMsgCell.workProListModel = self.workProListModel;
            }
            switchMsgCell.delegate = self;
            cell = switchMsgCell;
        }
            break;
            
        case TeamMangerCellClearCacheType:{
            
            cell = [self registerClearCacheCellWithTableView:tableView indexpath:indexPath];
        }
            break;
        default:
            break;
    }

    return cell;
}

- (UITableViewCell *)sourceDesCellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath {
    
    JGJMemberDesCell *cell = [JGJMemberDesCell cellWithTableView:tableView];
    
    cell.commonModel = self.commonModels[1];
    
    cell.titleLable.text = @"汇报对象";
    
    cell.desLable.text = [NSString stringWithFormat:@"%@人",@((_teamInfo.report_user_list.count))];
    
    cell.desLable.hidden = NO;
    
    cell.desBtn.hidden = YES;
    
    cell.redLineView.hidden = YES;
    
    return cell;
}

- (UITableViewCell *)registerReporedMemberCellWithtableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJGroupSetMemberCell *memberCell = [JGJGroupSetMemberCell cellWithTableView:tableView];
    
    JGJTeamMemberCommonModel *commonModel = self.commonModels[1];
    
    commonModel.memberType = JGJProMemberType;
    
    memberCell.commonModel = commonModel;
    
    memberCell.delegate = self;
    
    memberCell.members = self.teamInfo.report_user_list;
    
    return memberCell;
}

//点击成员

#pragma mark - JGJGroupSetMemberCellDelegate

- (void)selMemberWithCell:(JGJGroupSetMemberCell *)cell memberModel:(JGJSynBillingModel *)memberModel {
    
    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
        [self exampleProSingleTap:nil];
        return ;
    }
    
    if (memberModel.isMangerModel) {
        
        if (memberModel.isAddModel) {
         
            [self addMemberSelTypeVcCommonModel:cell.commonModel];
            
        }else if (memberModel.isRemoveModel) {
            
            [self removeMember];
            
        }
        
    }else {
        
        cell.commonModel.teamModelModel = memberModel;
        
        [self handleJGJTeamMemberCellUnRegisterTeamModel:cell.commonModel];
        
        
    }
}


#pragma mark - JGJTabHeaderAvatarViewDelegate 查看更多成员

- (void)tabHeaderAvatarView:(JGJTabHeaderAvatarView *)avatarView {
    
    [self handleCheckAllMember];
    
}

#pragma mark - 注册查看全部群成员Cell
- (UITableViewCell *)handleCheckAllMemberTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath {
    
    JGJCheckAllMemberCell *checkMemberCell  = [JGJCheckAllMemberCell cellWithTableView:tableView];
    
    return checkMemberCell;
}

#pragma mark - 底部项目信息cell
- (UITableViewCell *)handleRegisterMineInfoTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath{
    JGJCreatTeamCell *teamCell = [JGJCreatTeamCell cellWithTableView:tableView];
    teamCell.lineView.hidden = indexPath.row == self.mineInfos.count - 1;
    teamCell.creatTeamModel = self.mineInfos[indexPath.row];
    return teamCell;
}

- (UITableViewCell *)registerClearCacheCellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath{
    
    JGJCommonTitleCell *cell = [JGJCommonTitleCell cellWithTableView:tableView];
    
    cell.lineView.hidden = YES;
    
    cell.desModel = self.clearCache[indexPath.row];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0;
    switch (indexPath.section) {
        case 0: {
            
            if (indexPath.row == 0) {
              
//                height = [self calculateCollectiveViewHeight:self.teamMemberModels memberFlagType:ShowAddAndRemoveTeamMemberFlagType] - HeaderHegiht / 2.0;
                
                height = [JGJGroupSetMemberCell memberCellHeight];
                
            }
            else {
            
                height = 35;
            }
        }
            break;
        case 1: {
            
            
            if (indexPath.row == 0) {
                
                height = 35;
                
            }else if (indexPath.row == 1) {
                
                height = [JGJGroupSetMemberCell memberCellHeight];
            }
            
            else {
                
                height = 35;
            }
        }
            break;
        case 2:{
            
            height = 50.0;
            
            if (self.creatTeamModels.count - 1 == indexPath.row) {
                
                height = self.teamMangerVcType == JGJCreaterTeamMangerVcType || [self isAgency] ? [JGJComRemarkCell cellHeight] : 0;
                
            }
            
            break;
        }
        case 3:
        case 4:
        case 5:
            height = 50.0;
            break;
        default:
            break;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.0;
    switch (section) {
        case 0: {
            
            height = [NSString stringWithContentWidth:TYGetUIScreenWidth - 125 content:_teamInfo.group_full_name font:AppFont34Size] + 21;
            
            if (height < [JGJTabHeaderAvatarView headerHeight]) {
                
                height = [JGJTabHeaderAvatarView headerHeight];
            }
            
        }
            break;
        case 1:
        case 2:
        case 3:
        case 4:
        case 5: {
            
            if (section == 1 && _teamInfo.report_user_list.count == 0) {
                
                height = CGFLOAT_MIN;
                
            }else {
                
                height = 10;
                
            }

        }
            break;
        default:
            break;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   
    if (section == 0) {
        
        self.avatarheaderView.avatars = _teamInfo.members_head_pic;
        
        self.avatarheaderView.title = _teamInfo.group_full_name;
        
        self.avatarheaderView.num = _teamInfo.members_num;
        
        return self.avatarheaderView;
        
    }else if (section == 1 && _teamInfo.report_user_list.count == 0) {
        
        return nil;
    }
    
    else {
        
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.workProListModel.isClosedTeamVc) { //已关闭班组不能点击
        
        [self closeProTips];
        
        return;
    }
    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
        [self exampleProSingleTap:nil];
        return;
    }
    
    if (indexPath.section == 2) {
        switch (indexPath.row) {
            case TeamMangerBloneProType: //不做处理 所属项目
                
                break;
            case TeamMangerQrcodeType: {
                if (self.workProListModel.isClosedTeamVc) {
                    
                    [TYShowMessage showHUDOnly:@"当前页面已关闭"];
                    
                } else {
                    
                    [self handelGenerateQrcodeAction:nil]; //班组二维码
                    
                }
            }
                break;
            case TeamMangerTeamNameType:
                
                if (self.teamMangerVcType == JGJCreaterTeamMangerVcType && !self.workProListModel.isClosedTeamVc) {
                    
                    [self handleEditTeamName];
                    
                }
                break;
            case TeamMangerTeamPlaceType:
                if (self.teamMangerVcType == JGJCreaterTeamMangerVcType && !self.workProListModel.isClosedTeamVc) {
                    
                    [self handleSelelctedCurrentCity];
                    
                }
                break;
                
            case TeamMangerTeamAgencyType:{
                
                //代理班组长
                [self handleSetAgencyAction];
            }
                
                break;
            default:
                break;
        }
        
    }else if (indexPath.section == TeamMangerCellMineInfoType) {
        
        [self handleEditMineName];
        
    }else if (indexPath.section == TeamMangerCellMemberType && indexPath.row == 1) {
        
        [self handleCheckAllMember];
        
    }else if (indexPath.section == TeamMangerCellClearCacheType && indexPath.row == 0) {
        
        [self registerClearCacheWithTableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)registerClearCacheWithTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
    
    desModel.popDetail = @"确定清空聊天记录吗？";
    
    desModel.leftTilte = @"取消";
    
    desModel.rightTilte = @"确定";
    
    JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
    
    TYWeakSelf(self);
    
    alertView.onOkBlock = ^{
        
        [weakself clearChatMsgDB];
        
    };
}

#pragma mark - 班组关闭提示语
- (void)closeProTips {
    
    if(self.workProListModel.isClosedTeamVc){
        
        [TYShowMessage showPlaint:@"班组已关闭无法点击"];
    }
    
}


#pragma mark - 我的昵称
- (void)handleEditMineName {
    YZGOnlyAddProjectViewController *editTeamNameVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"onlyAddProject"];
    editTeamNameVc.delegate = self;
    editTeamNameVc.editType = EditMineNameType;
    editTeamNameVc.isEditGroupName = YES;
    editTeamNameVc.title = @"我在本组的名字";
    if (self.teamInfo.group_info.is_nickname) {// 标识在班组内设置过名称
        
        editTeamNameVc.defaultProName = self.teamInfo.group_info.nickname;
        
    }else {
        
        editTeamNameVc.defaultProName = @"";
    }
    
    editTeamNameVc.proNameTFPlaceholder = @"该名字只会在本组显示";
    [self.navigationController pushViewController:editTeamNameVc animated:YES];
}

#pragma mark - 处理二维码生成
- (void)handelGenerateQrcodeAction:(UIButton *)sender {
    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
        [self exampleProSingleTap:nil];
        return ;
    }
    
    JGJCreateGroupVc *joinGroupVc = [JGJCreateGroupVc new];
    self.workProListModel.pro_name = _teamInfo.group_info.pro_name;
    
    //setter方法时保证team_name、group_name只有一个值。因为全局用team_name、group_name是一个值。

    self.workProListModel.team_name = nil;
    
    self.workProListModel.group_full_name = _teamInfo.group_full_name;
    
    if (self.teamInfo.members_head_pic.count > 0) {
        
        self.workProListModel.members_head_pic = self.teamInfo.members_head_pic;
    }
    
    joinGroupVc.workProListModel = self.workProListModel;
    [self.navigationController pushViewController:joinGroupVc animated:YES];
}

#pragma mark - 班组名称
- (void)handleEditTeamName {
    YZGOnlyAddProjectViewController *editTeamNameVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"onlyAddProject"];
    editTeamNameVc.delegate = self;
    editTeamNameVc.isEditGroupName = YES;
    editTeamNameVc.editType = EditProNameType;
    editTeamNameVc.title = @"班组名称";
    JGJCreatTeamModel *teamModel = self.creatTeamModels[2];
    editTeamNameVc.defaultProName = teamModel.detailTitle;
    [self.navigationController pushViewController:editTeamNameVc animated:YES];
}

#pragma mark - 选择所在城市
- (void)handleSelelctedCurrentCity {
    JGJSelectedCurrentCityVC *currentCityVC = [[JGJSelectedCurrentCityVC alloc] init];
    currentCityVC.delegate = self;
    currentCityVC.cityModel = self.cityModel;
    [self.navigationController pushViewController:currentCityVC animated:YES];
}

#pragma mark - 设置代班组长
- (void)handleSetAgencyAction {
    
    if ([self isAgency]) {
        
        return;
    }
    
    JGJSetAgentMonitorController *agentMonitorVC = [[JGJSetAgentMonitorController alloc] init];
    
    agentMonitorVC.agency_group_user = self.teamInfo.agency_group_user;
    
    agentMonitorVC.proListModel = self.workProListModel;
    
    [self.navigationController pushViewController:agentMonitorVC animated:YES];
    
    TYWeakSelf(self);
    
    agentMonitorVC.setAgentMonSuccessBlock = ^(JGJSynBillingModel *agency_group_user) {
        
        [weakself setAgencyInfoWithAgencyInfo:agency_group_user];
        
    };
}

-(void)loadNetQueryPro:(NSIndexPath *)indexPath {
    if (self.proNameArray.count > 0) {
        return;
    }
    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/querypro" parameters:nil success:^(NSArray * responseObject) {
        [self.proNameArray removeAllObjects];
        [responseObject enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *proDic = @{@"id":obj[@"pid"],@"name":obj[@"pro_name"]};
            [self.proNameArray addObject:proDic];
        }];
        [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}

#pragma mark - YZGOnlyAddProjectViewControllerDelegate
- (void)handleYZGOnlyAddProjectViewControllerEditName:(NSString *)editName editType:(EditNameType)editType{
    if (editType == EditMineNameType) {

        self.modifyTeamInfoRequestModel.nickname = editName;
        
        if ([NSString isEmpty:editName]) {
            
            self.modifyTeamInfoRequestModel.nickname = @"";
        }
        
        self.modifyTeamInfoRequestModel.city_code = nil; //当前城市代码不上传
//        JGJCreatTeamModel *teamModel = self.creatTeamModels[2];
//        self.modifyTeamInfoRequestModel.group_name = teamModel.detailTitle;
        [self modifyTeamInfo:self.modifyTeamInfoRequestModel];
        __weak typeof(self) weakSelf = self;
        self.modifyTeamInfoBlock = ^ {
            JGJCreatTeamModel *teamModel = weakSelf.mineInfos[0];
            teamModel.detailTitle = editName;
            
            //修改我在当前组的名字
            [weakSelf handleModifCurGroupName];
            [weakSelf loadGetGroupInfo]; //重新获取数据
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        
    }else if (editType == EditProNameType) {
        self.modifyTeamInfoRequestModel.group_name = editName;
        self.modifyTeamInfoRequestModel.city_code = nil; //当前城市代码不上传
        [self modifyTeamInfo:self.modifyTeamInfoRequestModel];
        __weak typeof(self) weakSelf = self;
        self.modifyTeamInfoBlock = ^ {
            JGJCreatTeamModel *teamModel = weakSelf.creatTeamModels[2];
            teamModel.detailTitle = editName;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:2];
            [weakSelf.tableView beginUpdates];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf.tableView endUpdates];
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
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
        
        JGJChatDetailInfoCommonModel *msgDisturbModel = weakSelf.msgDisturbInfos[0];
        
        msgDisturbModel.isOpen = cell.commonModel.isOpen;
        
        [weakSelf refreshSection:4 row:0];
        
        //已删除并关闭聊聊表更新
        JGJChatGroupListModel *groupListModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:weakSelf.workProListModel.group_id classType:weakSelf.workProListModel.class_type];
        
        groupListModel.is_no_disturbed = cell.commonModel.isOpen;
        
        [JGJChatMsgDBManger updateChatGroupListTableWithJGJChatMsgListModel:groupListModel];
    };
}

- (void)JGJCusSwitchStickMsgCell:(JGJCusSwitchMsgCell *)cell switchType:(JGJCusSwitchMsgCellType)switchType {
    TYLog(@"switchType=== %ld isOpen--- %@", switchType, @(cell.commonModel.isOpen));
    
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
        
        JGJChatDetailInfoCommonModel *msgDisturbModel = self.msgDisturbInfos[1];
        
        msgDisturbModel.isOpen = cell.commonModel.isOpen;
        
        [self refreshSection:4 row:1];
        
        [JGJChatMsgDBManger updateIs_topToGroupTableWithIsTop:cell.commonModel.isOpen group_id:self.workProListModel.group_id class_type:self.workProListModel.class_type];
        
    } failure:^(NSError *error) {
       
        [TYLoadingHub hideLoadingView];
    }];
}

#pragma mark - JGJSelectedCurrentCityVCDelegate
- (void)handleJGJSelectedCurrentCityModel:(JLGCityModel *)cityModel {
    self.modifyTeamInfoRequestModel.city_code = cityModel.city_code;
    self.modifyTeamInfoRequestModel.group_name = nil; //可以选择不上传group_name
    self.cityModel = cityModel;
    [self modifyTeamInfo:self.modifyTeamInfoRequestModel];
    __weak typeof(self) weakSelf = self;
    self.modifyTeamInfoBlock = ^{
        JGJCreatTeamModel *teamModel = weakSelf.creatTeamModels[3];
        teamModel.detailTitle = cityModel.provinceCityName;
        
        [weakSelf.tableView reloadData];
    };
}

#pragma mark - JGJTeamMemberCellDelegate
- (void)handleJGJTeamMemberCellAddTeamMember:(JGJTeamMemberCell *)teamMemberCell {
    
    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
        
        [self exampleProSingleTap:nil];
        
        return ;
    }
    
    [self addMemberSelTypeVcCommonModel:teamMemberCell.commonModel];
    
}

#pragma mark - 添加成员
- (void)addMemberSelTypeVcCommonModel:(JGJTeamMemberCommonModel *)commonModel {
    
    JGJMemberSelTypeVc *selTypeVc = [JGJMemberSelTypeVc new];
    
    selTypeVc.workProListModel = self.workProListModel;
    
    selTypeVc.teamInfo = self.teamInfo;
    
    selTypeVc.commonModel = commonModel;
    
    selTypeVc.targetVc = self;
    
    //班组添加，项目添加需要
    selTypeVc.contactedAddressBookVcType = JGJGroupMangerAddMembersVcType;
    
    [self.navigationController pushViewController:selTypeVc animated:YES];
    
}

#pragma mark - 删除班组成员
- (void)handleJGJTeamMemberCellRemoveTeamMember:(NSMutableArray *)teamMemberModels {

    [self removeMember];
}

#pragma mark - 移除成员

- (void)removeMember {
    
    if(self.workProListModel.workCircleProType == WorkCircleExampleProType){
        [TYShowMessage showPlaint:@"这些都是示范数据，无法操作，谢谢"];
        return;
    }
    JGJSynBillingCommonModel *synBillingCommonModel = [[JGJSynBillingCommonModel alloc] init];
    JGJAddTeamMemberVC *removeMemberVC = [[UIStoryboard storyboardWithName:@"JGJCreatTeam" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJAddTeamMemberVC"];
    removeMemberVC.delegate = self;
    synBillingCommonModel.synBillingTitle = @"删除成员";
    removeMemberVC.groupMemberMangeType = JGJGroupMemberMangeRemoveMemberType;
    NSArray *members = _teamInfo.member_list;
    
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"is_creater != %@ AND uid != %@ AND isMangerModel != %@ AND is_agency != %@", @"1", myUid, @(YES), @(YES)];
    
    NSString *isCreaterUid = [TYUserDefaults objectForKey:JLGUserUid];
    
    if ([self.workProListModel.creater_uid isEqualToString:isCreaterUid]) {
        
        predicate = [NSPredicate predicateWithFormat:@"is_creater != %@ AND uid != %@ AND isMangerModel != %@", @"1", myUid, @(YES)];
        
    }else
        
        if (self.teamInfo.is_admin && ![self.workProListModel.creater_uid isEqualToString:isCreaterUid]) {
            
            predicate = [NSPredicate predicateWithFormat:@"is_creater != %@ AND uid != %@ AND isMangerModel != %@ AND is_admin == %@", @"1", myUid, @(YES), @(NO)];
        }
    
    members = [members filteredArrayUsingPredicate:predicate];
    
    removeMemberVC.currentTeamMembers = members;
    
    removeMemberVC.synBillingCommonModel = synBillingCommonModel;
    
    [self.navigationController pushViewController:removeMemberVC animated:YES];
}

#pragma mark - JGJGroupMemberMangeDelegate 返回删除和添加的成员
- (void)handleJGJGroupMemberSelectedTeamMembers:(NSMutableArray *)teamsMembers groupMemberMangeType:(JGJGroupMemberMangeType)groupMemberMangeType {
    switch (groupMemberMangeType) {
        case JGJGroupMemberMangeAddMemberType:
             [self upLoadAddTeamMembers:teamsMembers groupMemberMangeType:JGJGroupMemberMangeAddMemberType]; //上传班组成员信息
            break;
        case JGJGroupMemberMangeRemoveMemberType:
            [self upLoadRemoveTeamMembers:teamsMembers groupMemberMangeType:JGJGroupMemberMangeRemoveMemberType];
            break;
        default:
            break;
    }
}

#pragma mark - 移除班组成员
- (void)upLoadRemoveTeamMembers:(NSMutableArray *)teamMembers groupMemberMangeType:(JGJGroupMemberMangeType)groupMemberMangeType {

    NSMutableArray *uidArr = [NSMutableArray array];
    
    for (JGJSynBillingModel *teamMemberModel in teamMembers) {
        
        teamMemberModel.isSelected = NO;
        
        teamMemberModel.isAddedSyn = NO; //清楚返回的选择和添加状态
        
        if (![NSString isEmpty:teamMemberModel.uid]) {
            
            [uidArr addObject:teamMemberModel.uid];
        }

    }
    
    NSString *uids = [uidArr componentsJoinedByString:@","];
    
    __weak typeof(self) weakSelf = self;
    
    self.removeGroupMemberRequestModel.uid = uids;
    
    NSDictionary *parameters = [self.removeGroupMemberRequestModel mj_keyValues];
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:JGJGroupDelMembersURL parameters:parameters success:^(id responseObject) {
        
        [weakSelf upLoadTeamMembersSuccessShowTeamsAllMembers:teamMembers groupMemberMangeType:groupMemberMangeType];
        
        [TYShowMessage showSuccess:@"删除成功"];
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
//        [self loadGetGroupInfo];
//
//        weakSelf.uploadSuccessPopVcBlock = ^{
//
//            [TYLoadingHub hideLoadingView];
//
//            [TYShowMessage showSuccess:@"删除成功"];
//
//            [weakSelf.navigationController popViewControllerAnimated:YES];
//
//        };
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
    
}

#pragma mark - 上传班组成员信息
- (void)upLoadAddTeamMembers:(NSMutableArray *)teamMembers groupMemberMangeType:(JGJGroupMemberMangeType)groupMemberMangeType {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *groupMembersInfos = [NSMutableArray array];
    for (JGJSynBillingModel *teamMemberModel in teamMembers) { //添加返回的成员需要上传的信息
        JGJGroupMembersRequestModel *membersModel = [[JGJGroupMembersRequestModel alloc] init];
        membersModel.real_name = teamMemberModel.real_name;
        membersModel.telephone = teamMemberModel.telephone;
        membersModel.uid = teamMemberModel.uid;
        teamMemberModel.isAddedSyn = NO;
        teamMemberModel.isSelected = NO;
        [groupMembersInfos addObject:membersModel];
    } //获取姓名和电话
    self.addGroupMemberRequestModel.group_id = self.workProListModel.group_id;
    self.addGroupMemberRequestModel.group_members = groupMembersInfos;
    NSDictionary *parameters = [self.addGroupMemberRequestModel mj_keyValues];
    [JLGHttpRequest_AFN PostWithNapi:JGJAddMembersURL parameters:parameters success:^(id responseObject) {
        
        NSArray *members = responseObject[@"member_list"];
        
        [TYShowMessage showSuccess:@"添加成功"];
        
        if (members.count > 0) {
            
            members = [JGJSynBillingModel mj_objectArrayWithKeyValuesArray:responseObject[@"member_list"]];
            
            [weakSelf upLoadTeamMembersSuccessShowTeamsAllMembers:members groupMemberMangeType:groupMemberMangeType];
            
        }
        
    } failure:^(NSError *error) {
       
        
    }];
    
}

#pragma mark - 上传班组成员成功后显示数据
- (void)upLoadTeamMembersSuccessShowTeamsAllMembers:(NSArray *)teamMembers groupMemberMangeType:(JGJGroupMemberMangeType)groupMemberMangeType {
    
    NSArray *members = self.teamMemberModels.copy;
    JGJTeamMemberCommonModel *commonModel = self.commonModels[0];
    commonModel.teamMemberModels = self.teamMemberModels;
    switch (groupMemberMangeType) {
        case JGJGroupMemberMangeAddMemberType: {
            for (JGJSynBillingModel *teamMemberModel in members) {  //将之前的添加和删除模型去掉
                if (teamMemberModel.isMangerModel) {
                    [self.teamMemberModels removeObject:teamMemberModel];
                }
            }
            [self.teamMemberModels addObjectsFromArray:teamMembers];
        }
            break;
        case JGJGroupMemberMangeRemoveMemberType: {
            for (JGJSynBillingModel *teamMemberModel in teamMembers) {
                [self.teamMemberModels removeObject:teamMemberModel];
            }
        }
            break;
        default:
            break;
    }
//    NSArray *mangerModels = [self accordTypeGetMangerModels];
//    [self.teamMemberModels addObjectsFromArray:mangerModels];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

#pragma mark - getter
- (NSMutableArray *)creatTeamModels {
    NSArray *titles = @[@"所在项目", @"班组二维码", @"班组名称", @"班组地点",@""];
    NSString *cityName = [TYUserDefaults objectForKey:JLGCityName];
    cityName = cityName.length == 0 ?@"暂未获取当前地址": cityName;
    NSArray *placeholders = @[@"选择项目", @"班组二维码", @"华侨城木班组", cityName,@""];
    if (!_creatTeamModels && self.teamInfo) {
        _creatTeamModels = [NSMutableArray array];
        
        NSInteger count = titles.count;
        
        BOOL isAgency = [self isAgency];
        
        //创建者和代理班组长显示
        if (self.teamMangerVcType != JGJCreaterTeamMangerVcType && !isAgency) {
            
            count --;
        }
        
        for (int indx = 0; indx < titles.count; indx ++) {
            
            JGJCreatTeamModel *teamModel = [[JGJCreatTeamModel alloc] init];
            
            teamModel.title = titles[indx];
            
            teamModel.placeholderTitle = placeholders[indx];
            
            teamModel.isHiddenArrow = (indx == 0) || (indx == count - 1 && isAgency);
            
            [_creatTeamModels addObject:teamModel];
            
        }
    }
    return _creatTeamModels;
}

- (BOOL)isAgency {
    
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    
    BOOL isAgency = [myUid isEqualToString:_teamInfo.agency_group_user.uid];
    
    return isAgency;
}

#pragma mark - 设置头部类型和是否显示删除按钮
- (NSMutableArray *)commonModels {
    if (!_commonModels) {
        _commonModels = [NSMutableArray array];
        NSArray *headerTitles = @[@"成员", @"汇报对象"];
        for (int indx = 0; indx < 2; indx ++) {
            JGJTeamMemberCommonModel *commonModel = [[JGJTeamMemberCommonModel alloc] init];
            commonModel.isHiddenDeleteFlag = YES;
            commonModel.teamControllerType = JGJGroupMangerControllerType;
            commonModel.headerTitle = headerTitles[indx];
            [_commonModels addObject:commonModel];
        }
    }
    return _commonModels;
}

#pragma mark - 初始化添加班组成员网络请求模型
- (JGJAddGroupMemberRequestModel *)addGroupMemberRequestModel {

    if (!_addGroupMemberRequestModel) {
        
        _addGroupMemberRequestModel = [[JGJAddGroupMemberRequestModel alloc] init];
        _addGroupMemberRequestModel.ctrl = @"group";
        _addGroupMemberRequestModel.action = @"addMembers";
        _addGroupMemberRequestModel.client_type = @"person";
        _addGroupMemberRequestModel.is_qr_code = @"0";//0通信录加入
    }
    return _addGroupMemberRequestModel;
}

- (void)setTeamMemberModels:(NSMutableArray *)teamMemberModels {
    _teamMemberModels = teamMemberModels;
    [self.tableView reloadData];
}

#pragma mark - 返回的班组信息刷新页面
- (void)setTeamInfo:(JGJTeamInfoModel *)teamInfo {
    
    _teamInfo = teamInfo;
    JGJCreatTeamModel *minInfoModel = self.mineInfos[0];
    minInfoModel.detailTitle = _teamInfo.nickname ?:@"";
    self.teamMemberModels = _teamInfo.member_list;
    self.tableView.hidden = NO;
    
//    NSInteger line = ProSetMemberRow;
    
    NSString *myuid = [TYUserDefaults objectForKey:JLGUserUid];
    
    if (_teamInfo.is_admin || self.workProListModel.teamMangerVcType == JGJCreaterTeamMangerVcType || [myuid isEqualToString:_teamInfo.agency_group_user.uid]) {
        
//        _maxNum = TYIS_IPHONE_5_OR_LESS ? line * 4 - 2 : line * 5 - 2;
        
        _maxNum = [JGJGroupSetMemberCell headerCount] - 2;
        
    }else {
        
//        _maxNum = TYIS_IPHONE_5_OR_LESS ? line * 4 - 1 : line * 5 - 1;
        
        _maxNum = [JGJGroupSetMemberCell headerCount] - 1;
        
    }
    
    //获取汇报者
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"is_report == %@", @"1"];
    
    NSMutableArray *report_user_list = [_teamInfo.member_list filteredArrayUsingPredicate:predicate].mutableCopy;
    
    _teamInfo.report_user_list = report_user_list;
    
    if (_teamInfo.member_list.count > _maxNum) {
        
        self.teamMemberModels = [_teamInfo.member_list subarrayWithRange:NSMakeRange(0, _maxNum)].mutableCopy;
    }
    
    _teamInfo.members_num = [NSString stringWithFormat:@"%@", @(_teamInfo.member_list.count)];
    
    self.workProListModel.members_num = [NSString stringWithFormat:@"%@", @(_teamInfo.member_list.count)];
        
    NSArray *mangerModels = [self accordTypeGetMangerModels]; //根据条件得到添加删除选项
    for (JGJSynBillingModel *mangerModel in mangerModels) {
        [self.teamMemberModels removeObject:mangerModel];
    }
    [self.teamMemberModels addObjectsFromArray:mangerModels];
    JGJCreatTeamModel *proModel = self.creatTeamModels[0];
    proModel.teamMangerVcType = self.teamMangerVcType;
    
    _teamInfo.group_full_name = [NSString stringWithFormat:@"%@-%@",_teamInfo.group_info.pro_name, _teamInfo.group_info.group_name];
    
    self.workProListModel.group_full_name = _teamInfo.group_full_name;
    
    proModel.detailTitle = _teamInfo.group_info.pro_name;
    
    JGJCreatTeamModel *qrcodeModel = self.creatTeamModels[1];
    qrcodeModel.teamMangerVcType = self.teamMangerVcType;
    qrcodeModel.detailTitle = @"";
    qrcodeModel.isShowQrcode = YES;
    JGJCreatTeamModel *teamNameModel = self.creatTeamModels[2];
    
    teamNameModel.detailTitle = _teamInfo.group_info.group_name;
    
    teamNameModel.teamMangerVcType = self.teamMangerVcType;
    
    teamNameModel.isHiddenArrow = self.workProListModel.teamMangerVcType != JGJCreaterTeamMangerVcType;
    
    JGJCreatTeamModel *teamCityModel = self.creatTeamModels[3];
    
    if ([NSString isEmpty:teamCityModel.detailTitle]) {
        
        teamCityModel.detailTitle = _teamInfo.group_info.city_name;
        
    }
    
    teamCityModel.teamMangerVcType = self.teamMangerVcType;
    
    teamCityModel.isHiddenArrow = self.workProListModel.teamMangerVcType != JGJCreaterTeamMangerVcType;
    
    //获取代理人信息
    
    [self setAgencyInfoWithAgencyInfo:_teamInfo.agency_group_user];
    
    JGJChatDetailInfoCommonModel *msgDisturbModel = self.msgDisturbInfos[0];
    msgDisturbModel.isOpen = _teamInfo.is_no_disturbed;
    JGJChatDetailInfoCommonModel *msgStickModel = self.msgDisturbInfos[1];
    msgStickModel.isOpen = _teamInfo.is_sticked;
    
    JGJTeamMemberCommonModel *commonModel = self.commonModels[1];
    commonModel.teamMemberModels = _teamInfo.report_user_list.mutableCopy;
    commonModel.count = _teamInfo.report_user_list.count;
    
    NSString *parent_id = [TYFMDB searchItemByTableName:TYFMDBCityDataName ByKey:@"city_code" byValue:self.teamInfo.group_info.city_code byColume:@"parent_id"];
    NSString *province_name = [TYFMDB searchItemByTableName:TYFMDBCityDataName ByKey:@"city_code" byValue:parent_id byColume:@"city_name"];
    NSString *provinceCityName = [NSString stringWithFormat:@"%@%@", province_name, self.teamInfo.group_info.city_name];
    
    self.cityModel = [[JLGCityModel alloc] init];
    self.cityModel.city_name = _teamInfo.group_info.city_name;
    self.cityModel.provinceCityName = provinceCityName;
    self.cityModel.city_code = _teamInfo.group_info.city_code;

    //设置底部按钮3.2.0
    [self setTabFooterSheetView];
    
    [self.tableView reloadData];
    
    //这是聊天页面标题
    [self setChatTitleInfo:teamInfo];
    
    // v3.4 cc添加 添加或删除成员之后 更新聊聊列表数据库的成员信息
    [self updateChatGroupTableMembers_head_picAndMembers_numWithTeamInfoModel:teamInfo];
    
    //更新聊聊表
    JGJChatGroupListModel *groupModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:self.workProListModel.group_id classType:self.workProListModel.class_type];
    
    groupModel.members_num = _teamInfo.members_num;
    
    groupModel.local_head_pic = [_teamInfo.members_head_pic mj_JSONString];
    
    groupModel.group_name =  [NSString stringWithFormat:@"%@-%@",_teamInfo.group_info.pro_name,_teamInfo.group_info.group_name];
    
    //更新聊聊表结束
    [JGJChatMsgDBManger updateChatGroupListTableWithJGJChatMsgListModel:groupModel];
    
}

- (void)updateChatGroupTableMembers_head_picAndMembers_numWithTeamInfoModel:(JGJTeamInfoModel *)teamInfo {
    
    JGJChatGroupListModel *chatGroupModel = [[JGJChatGroupListModel alloc] init];
    
    chatGroupModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:teamInfo.group_info.group_id classType:teamInfo.group_info.class_type];
    chatGroupModel.members_num = teamInfo.members_num;
    chatGroupModel.local_head_pic = [teamInfo.members_head_pic mj_JSONString];
    chatGroupModel.group_name = _teamInfo.group_full_name;
    
    // 代理人信息
    NSMutableDictionary *agencyDic = [NSMutableDictionary dictionary];
    [agencyDic setValue:_teamInfo.agency_group_user.uid forKey:@"uid"];
    [agencyDic setValue:_teamInfo.agency_group_user.end_time forKey:@"end_time"];
    [agencyDic setValue:@(_teamInfo.agency_group_user.is_expire) forKey:@"is_expire"];
    [agencyDic setValue:@(_teamInfo.agency_group_user.is_start) forKey:@"is_start"];
    [agencyDic setValue:_teamInfo.agency_group_user.start_time forKey:@"start_time"];
    [agencyDic setValue:_teamInfo.agency_group_user.real_name forKey:@"real_name"];
    
    chatGroupModel.agency_group_user = [agencyDic mj_JSONString];
    [JGJChatMsgDBManger updateChatGroupListTableWithJGJChatMsgListModel:chatGroupModel];
}

#pragma mark - 设置聊聊顶部标题

#warning 3.2.0优化接口

- (void)setChatTitleInfo:(JGJTeamInfoModel *)teamInfo {
    
    self.workProListModel.group_name = [NSString stringWithFormat:@"%@-%@", teamInfo.group_info.pro_name,teamInfo.group_info.group_name]; //传入修改的名字

    self.workProListModel.team_name = nil; //模型getter方法判断，这里保证唯一
    
    self.workProListModel.members_num = teamInfo.members_num;
    
}

#pragma mark - 计算班组成员高度
- (CGFloat)calculateCollectiveViewHeight:(NSArray *)dataSource  memberFlagType:(MemberFlagType) memberFlagType {
    NSInteger lineCount = 0;

    NSUInteger teamMemberCount = dataSource.count;
    
    CGFloat padding = 15;
    
    lineCount = ((teamMemberCount / MemberRowNum) + (teamMemberCount % MemberRowNum != 0 ? 1 : 0));
    
    CGFloat collectionViewHeight = lineCount * ItemHeight + HeaderHegiht + padding;
    
    return collectionViewHeight;
}

#pragma mark - 点击不是我们平台成员弹框
- (void)handleJGJTeamMemberCellUnRegisterTeamModel:(JGJTeamMemberCommonModel *)commonModel {
    if (self.workProListModel.isClosedTeamVc) { //已关闭班组不能点击
        return;
    }
    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
        [self exampleProSingleTap:nil];
        return;
    }
    
    if (commonModel.teamModelModel.isMangerModel) {
        
        return;
    }
    
    //汇报对象直接进入他的资料
    if (commonModel.memberType == JGJReportMemberType) {
        
        [self handleDidSelectedMemberWithMemberModel:commonModel.teamModelModel];
        
        return;
    }
    
    if (commonModel.memberType == JGJProMemberType) {
        if ([commonModel.teamModelModel.is_active isEqualToString:@"0"]) {
            
            [self handleCheckAllMember];
            
//            commonModel.alertViewHeight = 210.0;
//            commonModel.alertmessage = @"该用户还未注册,赶紧邀请他下载[吉工家]一起使用吧！";
//            commonModel.alignment = NSTextAlignmentLeft;
//
//            JGJCustomProInfoAlertVIew *alertView = [JGJCustomProInfoAlertVIew alertViewWithCommonModel:commonModel];
//
//            if (!self.shareMenuTool) {
//
//                self.shareMenuTool = [[JGJKnowledgeDaseTool alloc] init];
//
//                self.shareMenuTool.targetVc  = self;
//
//                self.shareMenuTool.isUnCanShareCount = YES; //不清零
//            }
//
//            __weak typeof(self) weakSelf = self;
//
//            alertView.confirmButtonBlock = ^{
//
//                NSString *img = [NSString stringWithFormat:@"%@%@", JLGHttpRequest_IP_center, @"media/default_imgs/logo.jpg"];
//
//                NSString *uid = [TYUserDefaults objectForKey:JLGUserUid];
//
//                NSString *url =[NSString stringWithFormat:@"%@page/open-invite.html?uid=%@&plat=person", JGJWebDiscoverURL,uid];;
//
//                NSString *title = @"我正在用招工找活、记工记账神器：吉工家APP";
//
//                NSString *desc = @"1200万建筑工友都在用！下载注册就送100积分抽百元话费！";
//
//                [weakSelf.shareMenuTool showShareBtnClick:img desc:desc title:title url:url];
//            };
            
        } else {
            commonModel.alertViewHeight = 147.0;
            commonModel.alertmessage = @"";

//            [self handleDidSelectedMemberWithMemberModel:commonModel.teamModelModel];
            
            [self handleCheckAllMember];
        }
    } else {
        commonModel.alertViewHeight = 147.0;
        commonModel.alertmessage = @"";
        JGJCustomProInfoAlertVIew *alertView = [JGJCustomProInfoAlertVIew alertViewWithCommonModel:commonModel];
        
        alertView.delegate = self;
        
        if (!self.shareMenuTool) {
            
            self.shareMenuTool = [[JGJKnowledgeDaseTool alloc] init];
            
            self.shareMenuTool.targetVc  = self;
            
            self.shareMenuTool.isUnCanShareCount = YES; //不清零
        }
        
        __weak typeof(self) weakSelf = self;
        
        alertView.confirmButtonBlock = ^{
            
            NSString *img = [NSString stringWithFormat:@"%@%@", JLGHttpRequest_IP_center, @"media/default_imgs/logo.jpg"];
            
            NSString *uid = [TYUserDefaults objectForKey:JLGUserUid];
            
            NSString *url =[NSString stringWithFormat:@"%@page/open-invite.html?uid=%@&plat=person", JGJWebDiscoverURL,uid];;
            
            NSString *title = @"我正在用招工找活、记工记账神器：吉工家APP";
            
            NSString *desc = @"1200万建筑工友都在用！下载注册就送100积分抽百元话费！";
            
            [weakSelf.shareMenuTool showShareBtnClick:img desc:desc title:title url:url];
        };
        
    }
}

- (void)selUnRegisterTeamModel:(JGJSynBillingModel *)memberModel {
    
    
}

#pragma mark  -JGJCustomProInfoAlertVIewDelegate

- (void)customProInfoAlertViewWithalertView:(JGJCustomProInfoAlertVIew *)alertView didSelectedMember:(JGJSynBillingModel *)memberModel {
//    if ([memberModel.is_active isEqualToString:@"0"]) {
//        [TYShowMessage showPlaint:@"TA还没加入吉工家，没有更多资料了"];
//        return;
//    }
    [self handleDidSelectedMemberWithMemberModel:memberModel];
    
}

#pragma mark - 常用设置
- (void)commonSet {
    self.teamMangerVcType = [self.workProListModel.myself_group isEqualToString:@"1"] ? JGJCreaterTeamMangerVcType : JGJNormalMemberTeamInfoVcType;
    self.tableView.hidden = YES;
    self.containBottomButtonViewH.constant = 0;
    self.title = @"班组设置";
//    self.rightItemButton.title = self.teamMangerVcType == JGJNormalMemberTeamInfoVcType ? @"退出班组" : @"关闭班组";
    
//    self.rightItemButton.image = [UIImage imageNamed:@"more_red"];
    
    self.commonModels = [NSMutableArray array];
    NSArray *headerTitles = @[@"成员", @"汇报对象"];
    for (int indx = 0; indx < 2; indx ++) {
        JGJTeamMemberCommonModel *commonModel = [[JGJTeamMemberCommonModel alloc] init];
        commonModel.isHiddenDeleteFlag = YES;
        commonModel.headerTitle = headerTitles[indx];
        commonModel.teamControllerType = JGJGroupMangerControllerType;
        [self.commonModels addObject:commonModel];
    }
}

#pragma mark - 根据情况关闭班组或者退出班组
- (IBAction)handleRightItemButtonPressed:(UIBarButtonItem *)sender {
//    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
//        [self exampleProSingleTap:nil];
//        return;
//    }
//    switch (self.teamMangerVcType) {
//        case JGJNormalMemberTeamInfoVcType: {
//            [self handleLogoutTeam];
//        }
//            break;
//        case JGJCreaterTeamMangerVcType: {
//             [self handleShutTeam];
//        }
//            break;
//        default:
//            break;
//    }
    
//     [self showSheetView];
}

#pragma mark - 关闭班组
- (void)handleShutTeam {
    NSDictionary *parameters = @{
                                 @"class_type" :self.workProListModel.class_type?:@"",
                                 
                                 @"group_id" : self.workProListModel.group_id?:@""
                                 
                                 };
    CustomAlertView *alertView = [CustomAlertView showWithMessage:@"关闭后仍然可以查看班组的数据,但不能进行工作通知、工作汇报等操作;被关闭的班组可以重新打开,确认要关闭吗？" leftButtonTitle:@"取消" midButtonTitle:nil rightButtonTitle:@"确定"];
    alertView.messageLabel.font = [UIFont systemFontOfSize:AppFont32Size];
    alertView.messageLabel.textAlignment = NSTextAlignmentLeft;
    __weak typeof(self) weakSelf = self;
    alertView.onOkBlock = ^{
        
        [TYLoadingHub showLoadingWithMessage:nil];

        [JLGHttpRequest_AFN PostWithNapi:JGJCloseGroupURL parameters:parameters success:^(id responseObject) {
            
            [TYLoadingHub hideLoadingView];
            
            [TYShowMessage showSuccess:@"关闭成功"];
            
            //已关闭聊聊表更新
            JGJChatGroupListModel *groupListModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:weakSelf.workProListModel.group_id classType:weakSelf.workProListModel.class_type];
            
            groupListModel.is_closed = YES;
            groupListModel.close_time = [NSDate stringFromDate:[NSDate date] format:@"YYYY-MM-dd hh:mm:ss"];
            [JGJChatMsgDBManger updateChatGroupListTableWithJGJChatMsgListModel:groupListModel];
            [JGJChatMsgDBManger updateIs_ClosedToIndexTableWithGroup_id:self.workProListModel.group_id class_type:self.workProListModel.class_type is_closed:YES];
            
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            
            [TYShowMessage showHUDOnly:@"网络错误"];
            
            [TYLoadingHub hideLoadingView];
            
        }];
    };
    
}

#pragma mark - 退出班组
- (void)handleLogoutTeam {
   
    NSDictionary *parameters = @{@"class_type" : self.workProListModel.class_type?:@"",
                                 
                                 @"group_id" : self.workProListModel.group_id?:@""
                                 };
    CustomAlertView *alertView = [CustomAlertView showWithMessage:@"确认退出班组吗？" leftButtonTitle:@"取消" midButtonTitle:nil rightButtonTitle:@"确定"];
    
    alertView.messageLabel.textAlignment = NSTextAlignmentCenter;
    
    __weak typeof(self) weakSelf = self;
    alertView.onOkBlock = ^{
        [TYLoadingHub showLoadingWithMessage:nil];
        
        [JLGHttpRequest_AFN PostWithNapi:JGJQuitMembersURL parameters:parameters success:^(id responseObject) {
            
            [TYShowMessage showSuccess:@"退出成功"];
            
            [weakSelf deleteAllMessageProListModel:weakSelf.workProListModel];
            
            [TYLoadingHub hideLoadingView];
            
        } failure:^(NSError *error) {
            
            [TYShowMessage showHUDOnly:@"网络错误"];
            
            [TYLoadingHub hideLoadingView];
            
        }];
    };
}

- (void)deleteAllMessageProListModel:(JGJMyWorkCircleProListModel *)proListModel {
    
    [self delGroupListWithProListModel:proListModel];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

//永久删除和退出
- (void)delGroupListWithProListModel:(JGJMyWorkCircleProListModel *)proListModel {
    
    // 删除聊聊列表数据
    JGJChatGroupListModel *groupModel = [JGJChatGroupListModel new];
    
    groupModel.class_type = proListModel.class_type;
    
    groupModel.group_id = proListModel.group_id;
    
    BOOL deleteSuccess = [JGJChatMsgDBManger deleteChatGroupListDataWithModel:groupModel];
    if (deleteSuccess) { // 首页切换到 项目创建时间最新的项目
        
        [JGJChatGetOffLineMsgInfo http_getChatIndexList];
    }
}



#pragma mark - 加载班组详情信息
- (void)loadGetGroupInfo {

    NSDictionary *parameters = @{
                                 @"group_id" : self.workProListModel.group_id?:@"",
                                 @"pro_id" : self.workProListModel.pro_id ?:@"",//项目的pro_id
                                 @"class_type" : self.workProListModel.class_type
                                 };
    
    [JLGHttpRequest_AFN PostWithNapi:JGJGetGroupInfoURL parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        JGJTeamInfoModel *teamInfoModel = [JGJTeamInfoModel mj_objectWithKeyValues:responseObject];
        
        self.teamInfo = teamInfoModel;
        
        if (self.uploadSuccessPopVcBlock) {
            
            self.uploadSuccessPopVcBlock();
            
        }
        
    } failure:^(NSError *error) {
       
        
    }];
}

#pragma mark - 修改数据库我在本组的名字
- (void)handleModifCurGroupName {
    
    JGJChatListAllVc *chatAllVc = [self getAllMsgListVc];;
    
    JGJChatMsgListModel *msgModel = [JGJChatMsgListModel new];
    
    JGJCreatTeamModel *teamModel = self.mineInfos[0];

    msgModel.user_name = teamModel.detailTitle;
    
    msgModel.real_name = teamModel.detailTitle;
    
    msgModel.uid = [TYUserDefaults objectForKey:JLGUserUid];
    
    msgModel.group_id = self.workProListModel.group_id;
    
    msgModel.class_type = self.workProListModel.class_type;
    
    [JGJChatListTool handleModifyTempDataArry:chatAllVc.dataSourceArray modifyChatModel:msgModel];
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

#pragma mark - 根据条件类型返回添加和删除模型
- (NSMutableArray *)accordTypeGetMangerModels {
    
    NSString *myuid = [TYUserDefaults objectForKey:JLGUserUid];
    
    if ([myuid isEqualToString:_teamInfo.agency_group_user.uid]) {
        
        self.teamMangerVcType = JGJAgencyMemberType;
    }
    
    JGJTeamMemberCommonModel *commonModel = self.commonModels[0];
    commonModel.count = self.teamInfo.members_num.integerValue;
    NSMutableArray *dataSource = [NSMutableArray array];
    if (self.workProListModel.isClosedTeamVc == YES) {
        return dataSource;
    }
    NSArray *picNames = @[@"menber_add_icon", @"member_ minus_icon"];
    NSArray *titles = @[@"添加", @"删除"];
    NSInteger count = 0;
    switch (self.teamMangerVcType) {
        case JGJNormalMemberTeamInfoVcType: {
            count = 1;
        }
            break;
            
        case JGJAgencyMemberType:
        case JGJCreaterTeamMangerVcType: {
            count = self.teamMemberModels.count == 0 ? 1 : 2;
        }
            break;
        default:
            break;
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
        memberModel.name = titles[idx];
        [dataSource addObject:memberModel];
    }
    
    return dataSource;
}

- (NSMutableArray *)mineInfos {
    if (!_mineInfos) {
        _mineInfos = [NSMutableArray array];
        NSArray *titles = @[@"我在本组的名字"];
        NSArray *detailTitles = @[self.teamInfo.nickname?:@""];
        for (int indx = 0; indx < titles.count; indx ++) {
            JGJCreatTeamModel *teamModel = [[JGJCreatTeamModel alloc] init];
            teamModel.title = titles[indx];
            teamModel.detailTitle = detailTitles[indx];
            [_mineInfos addObject:teamModel];
        }
    }
    return _mineInfos;
}

- (NSMutableArray *)clearCache {
    
    if (!_clearCache) {
        
        _clearCache = [NSMutableArray array];
        
        NSArray *titles = @[@"清空聊天记录"];

        for (int indx = 0; indx < titles.count; indx ++) {
            
            JGJCreatTeamModel *teamModel = [[JGJCreatTeamModel alloc] init];
            
            teamModel.title = titles[indx];
                        
            [_clearCache addObject:teamModel];
            
        }
    }
    
    return _clearCache;
}

#pragma mark - 初始化修改班组信息模型 这里传入id
- (JGJModifyTeamInfoRequestModel *)modifyTeamInfoRequestModel {

    if (!_modifyTeamInfoRequestModel) {
        
        _modifyTeamInfoRequestModel = [[JGJModifyTeamInfoRequestModel alloc] init];

        _modifyTeamInfoRequestModel.group_id = self.workProListModel.group_id;
        
        _modifyTeamInfoRequestModel.class_type = self.workProListModel.class_type;
    }
    return _modifyTeamInfoRequestModel;
}


- (JGJRemoveGroupMemberRequestModel *)removeGroupMemberRequestModel {

    if (!_removeGroupMemberRequestModel) {
        
        _removeGroupMemberRequestModel = [[JGJRemoveGroupMemberRequestModel alloc] init];
        
        _removeGroupMemberRequestModel.group_id = self.workProListModel.group_id;
        
        _removeGroupMemberRequestModel.class_type = self.workProListModel.class_type;
        
    }
    return _removeGroupMemberRequestModel;
}

#pragma mark - 提示
- (void)exampleProSingleTap:(UITapGestureRecognizer *)sender{
    if(self.workProListModel.workCircleProType == WorkCircleExampleProType){
        [TYShowMessage showPlaint:@"这些都是示范数据，无法操作，谢谢"];
    }
}

#pragma mark - 刷新位置
- (void)refreshSection:(NSUInteger)section row:(NSUInteger)row {
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:section];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

#pragma mark -点击班组成员是我们平台注册人员进入资料页
- (void)handleDidSelectedMemberWithMemberModel:(JGJSynBillingModel *)memberModel {
    JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
    perInfoVc.jgjChatListModel.uid = memberModel.uid;
    perInfoVc.jgjChatListModel.group_id = self.workProListModel.group_id;
    perInfoVc.jgjChatListModel.class_type = self.workProListModel.class_type;
    [self.navigationController pushViewController:perInfoVc animated:YES];
}

- (NSMutableArray *)msgDisturbInfos {
    if (!_msgDisturbInfos) {
        _msgDisturbInfos = [NSMutableArray array];
        NSArray *titles = @[@"消息免打扰",@"置顶聊天"];
        NSArray *switchTypes = @[@(JGJCusSwitchRepulseMsgCell), @(JGJCusSwitchStickMsgCell)];
        for (int indx = 0; indx < titles.count; indx ++) {
            JGJChatDetailInfoCommonModel *commonModel  = [JGJChatDetailInfoCommonModel new];
            commonModel.switchMsgType = [switchTypes[indx] integerValue];
            commonModel.title = titles[indx];
            commonModel.isOpen = NO;
            [_msgDisturbInfos addObject:commonModel];
        }
    }
    return _msgDisturbInfos;
}

#pragma mark - 设置底部按钮
- (void)setTabFooterSheetView {
    
    [self showSheetView];
}

- (void)showSheetView{
    NSArray *buttons = nil;
    switch (self.workProListModel.teamMangerVcType) {
            
            //普通成员退出和取消
        case JGJNormalMemberTeamInfoVcType: {
            
            buttons = @[@"退出班组"];
        }
            break;
            
            //管理人员和关闭、删除、取消
        case JGJCreaterTeamMangerVcType: {
            
            if (self.workProListModel.isClosedTeamVc) {
                
                buttons = @[@"重新开启", @"彻底删除"];
                
            }else {

                buttons = @[@"暂时关闭班组", @"关闭并删除班组"];
            }
            
        }
            break;
            
        default:{
            
            buttons = @[@"退出班组"];
        }
            break;
    }
    
//    __weak typeof(self) weakSelf = self;
//    JGJCusActiveSheetView *sheetView = [[JGJCusActiveSheetView alloc] initWithTitle:@"" sheetViewType:JGJCusActiveSheetViewBoldPaddingType chageColors:@[@""] buttons:buttons buttonClick:^(JGJCusActiveSheetView *sheetView, NSInteger buttonIndex, NSString *title) {
//
//        [weakSelf handleActionSheetViewWithButtonIndex:buttonIndex];
//
//    }];
//
//    [sheetView showView];
    

    [self setSheetViewWithButtons:buttons];
}

- (void)setSheetViewWithButtons:(NSArray *)buttons {
    
    __weak typeof(self) weakSelf = self;
    JGJCusButtonSheetView *sheetView = [[JGJCusButtonSheetView alloc] initWithSheetViewType:JGJCusButtonSheetViewDefaultType chageColors:nil buttons:buttons buttonClick:^(JGJCusButtonSheetView *sheetView, NSInteger buttonIndex, NSString *title) {
        
        [weakSelf handleActionSheetViewWithButtonIndex:buttonIndex];
        
    }];
    
    self.tableView.tableFooterView = sheetView;
}

- (void)handleActionSheetViewWithButtonIndex:(NSInteger)buttonIndex{
    
    switch (self.workProListModel.teamMangerVcType) {
            
            //普通成员退出和取消
        case JGJNormalProMangerType:
        case JGJNormalMemberTeamInfoVcType: {
            
            [self handleNormalMemberActionSheetWithButtonIndex:buttonIndex];
        }
            break;
            
            //管理人员和关闭、删除、取消
        case JGJCreaterTeamMangerVcType: {
            
            [self handleMangerMemberActionSheetWithButtonIndex:buttonIndex];
        }
            break;
            
        default:{
            
            [self handleLogoutTeam];
        }
            break;
    }
    
}

#pragma mark - 处理普通成员点击事件
- (void)handleNormalMemberActionSheetWithButtonIndex:(NSInteger)buttonIndex {
    
    //    buttons = @[@"退出项目组", @"取消"];
    
    if (buttonIndex == 0) {
        
        [self handleLogoutTeam];
    }
    
}

#pragma mark - 处理创建者点击事件
- (void)handleMangerMemberActionSheetWithButtonIndex:(NSInteger)buttonIndex {
    
    //重新开启、关闭项目
    
    TYWeakSelf(self);
    
    if (self.workProListModel.isClosedTeamVc) {
        
        if (buttonIndex == 0) {
            
            [self reopenGroup:self.workProListModel];
            
        }else if (buttonIndex == 1) {
            
            CustomAlertView *alertView = [CustomAlertView showWithMessage:@"注意：删除班组，将删除与本班组相关的所有数据，同时也将取消该班组对他人的同步，班组删除后不能找回。你确定要删除吗？" leftButtonTitle:@"取消" midButtonTitle:nil rightButtonTitle:@"确定"];
            
            alertView.onOkBlock = ^{
                
                [weakself delGroup:weakself.workProListModel];
            };
            
        }
        
    }else {
        
        if (buttonIndex == 0) {

            [self handleShutTeam]; //关闭班组
            
        }else if (buttonIndex == 1) {
            
            CustomAlertView *alertView = [CustomAlertView showWithMessage:@"注意：删除班组，将删除与本班组相关的所有数据，同时也将取消该班组对他人的同步，班组删除后不能找回。你确定要删除吗？" leftButtonTitle:@"取消" midButtonTitle:nil rightButtonTitle:@"确定"];
            
            alertView.onOkBlock = ^{
                
                [weakself delCloseGroup:weakself.workProListModel];
            };
        }
    
    }
    
}

#pragma mark - 重新打开已关闭的班组、项目组
- (void)reopenGroup:(JGJMyWorkCircleProListModel *)groupModel {
    NSDictionary *parameters = @{
                                 @"class_type" : @"group",
                                 
                                 @"group_id" :groupModel.group_id?:@""
                                 
                                 };
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:@"group/reenable-group" parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        [TYShowMessage showSuccess:@"开启成功"];
        
        //已删除并关闭聊聊表更新
        JGJChatGroupListModel *groupListModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:self.workProListModel.group_id classType:self.workProListModel.class_type];
        
        groupListModel.is_closed = NO;
        
        [JGJChatMsgDBManger updateChatGroupListTableWithJGJChatMsgListModel:groupListModel];
        [JGJChatMsgDBManger updateIs_ClosedToIndexTableWithGroup_id:self.workProListModel.group_id class_type:self.workProListModel.class_type is_closed:NO];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)delGroup:(JGJMyWorkCircleProListModel *)groupModel {
    
    NSDictionary *parameters = @{
                                 @"class_type" : groupModel.class_type?:@"",
                                 
                                 @"group_id" :groupModel.group_id?:@""
                                 
                                 };
    
    [JLGHttpRequest_AFN PostWithNapi:JGJDelGroupURL parameters:parameters success:^(id responseObject) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        [self delGroupListWithProListModel:self.workProListModel];
        [TYShowMessage showSuccess:@"删除成功"];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)delCloseGroup:(JGJMyWorkCircleProListModel *)groupModel {
    
    NSDictionary *parameters = @{
                                 @"class_type" : groupModel.class_type?:@"",
                                 
                                 @"group_id" :groupModel.group_id?:@"",
                                 
                                 };
    
    [JLGHttpRequest_AFN PostWithNapi:@"group/del-group" parameters:parameters success:^(id responseObject) {
        

        [self deleteAllMessageProListModel:self.workProListModel];
        
        [TYShowMessage showSuccess:@"删除成功"];
        
    } failure:^(NSError *error) {
        
        
    }];

}

#pragma mark - 查看全部成员
- (void)handleCheckAllMember {
    JGJCheckGroupChatAllMemberVc *allMemberVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJCheckGroupChatAllMemberVc"];
    
    allMemberVc.memberModels = self.checkAllMembers;
    self.workProListModel.cur_group_id = self.teamInfo.group_info.group_id; //获取当前群id
    self.workProListModel.cur_class_type = self.teamInfo.group_info.class_type; //当前群类型
    self.workProListModel.class_type = self.teamInfo.group_info.class_type;
    allMemberVc.workProListModel = self.workProListModel;
    
    allMemberVc.teamInfo = self.teamInfo;
    
    allMemberVc.allMemberVcType = CheckAllMemberVcTeamMangerType;
    
    JGJTeamMemberCommonModel *commonModel = self.commonModels[0];
    
    allMemberVc.commonModel = commonModel;
    
    [self.navigationController pushViewController:allMemberVc animated:YES];
}

- (JGJTabHeaderAvatarView *)avatarheaderView {
    
    if (!_avatarheaderView) {
        
        _avatarheaderView = [[JGJTabHeaderAvatarView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, [JGJTabHeaderAvatarView headerHeight])];
        
        _avatarheaderView.delegate = self;
        
    }
    
    return _avatarheaderView;
}

#pragma mark - 设置代理人信息
- (void)setAgencyInfoWithAgencyInfo:(JGJSynBillingModel *)agency_group_user {
    
    if (self.creatTeamModels.count > 4 && (self.teamMangerVcType == JGJCreaterTeamMangerVcType || [self isAgency])) {
        
        JGJCreatTeamModel *agencyModel = self.creatTeamModels[4];
        
        agencyModel.title = agency_group_user.name?:@"";
        
        NSString *st_time = [agency_group_user.start_time stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        
        NSString *en_time = [_teamInfo.agency_group_user.end_time stringByReplacingOccurrencesOfString:@"-" withString:@"."];;
        
        NSString *detitle = @"";
        
        if ([NSString isEmpty:st_time] && [NSString isEmpty:en_time]) {
            
            detitle = @"";
            
        }else if ([NSString isEmpty:st_time] && ![NSString isEmpty:en_time]) {
            
            detitle = [NSString stringWithFormat:@"到%@", en_time];
            
        }else if (![NSString isEmpty:st_time] && [NSString isEmpty:en_time]) {
            
            detitle = [NSString stringWithFormat:@"%@起", st_time];
            
        }else if (![NSString isEmpty:st_time] && ![NSString isEmpty:en_time]) {
            
            detitle = [NSString stringWithFormat:@"%@-%@", st_time,en_time];
            
        }
        
        if ([NSString isEmpty:detitle] && ![NSString isEmpty:_teamInfo.agency_group_user.uid]) {
            
            detitle = @"无代班时间限制";
        }
        
        agencyModel.detailTitle = detitle;
        //设置了代班长调首页接口
        [JGJChatGetOffLineMsgInfo http_getChatIndexList];
    }
    
    [self.tableView reloadData];
    
    
    
}

@end
