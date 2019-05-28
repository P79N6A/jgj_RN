//
//  JGJGroupMangerVC.m
//  JGJCompany
//
//  Created by yj on 16/9/22.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJGroupMangerVC.h"
#import "JGJCreatTeamCell.h"
#import "JGJTeamMemberCell.h"
#import "JGJCreateGroupVc.h"
#import "YZGOnlyAddProjectViewController.h"
#import "JGJAddTeamMemberVC.h"
#import "NSString+Extend.h"
#import "CustomAlertView.h"
#import "JGJCustomAlertView.h"
#import "JGJCustomProInfoAlertVIew.h"
#import "JGJTeamDetailCommonPopView.h"
#import "JGJUnhandleSourceListVC.h"
#import "JGJSetAdministratorVc.h"
#import "JGJCusSwitchMsgCell.h"
#import "JGJPerInfoVc.h"
#import "JGJChatListAllVc.h"
#import "JGJChatRootVc.h"
#import "JGJChatListTool.h"
#import "JGJProMangeAddressVc.h"
#import "JGJProSetDesCell.h"

#import "JGJCusActiveSheetView.h"

#import "JGJCheckGroupChatAllMemberVc.h"

#import "JGJSureOrderListViewController.h"

#import "JGJCustomPopView.h"

#import "JGJGroupMangerTool.h"

#import "JGJTabBarViewController.h"

#import "JGJMemberSelTypeVc.h"

#import "JGJKnowledgeDaseTool.h"

#import "JGJCusSeniorPopView.h"

#import "JGJCheckAllMemberCell.h"

#import "JGJCusButtonSheetView.h"

#import "JGJTabPaddingView.h"

#import "JGJTabHeaderAvatarView.h"

#import "JGJComRemarkCell.h"

#import "JGJCommonTitleCell.h"

#import "JGJChatMsgDBManger+JGJClearCacheDB.h"

#import "JGJChatMsgDBManger+JGJGroupDB.h"

#import "JGJChatMsgDBManger.h"

#import "JGJComPaddingCell.h"
#import "NSDate+Extend.h"

#import "JGJGroupSetMemberCell.h"

#import "JGJMemberDesCell.h"

//#define MaxNum  TYIS_IPHONE_5_OR_LESS ? 10 : 13

typedef enum : NSUInteger {
    TeamMangerCellMemberType = 0,
    TeamMangerCellReporedMemberType,
    TeamMangerCellTeamInfoType,
    TeamMangerCellMineInfoType,
    TeamMangerCellDistubMsgInfoType,
    TeamMangerCellSetAdminType,
    TeamMangerCellServiceType, //服务类型
} TeamMangerType;

typedef enum : NSUInteger {
    ProRemarkCellType,
    ProQrcodeCellType,
    ProNameCellType,
    ProAddressCellType //项目地址
} GroupMangerCellType;

typedef void(^ModifyTeamInfoBlock)();

typedef void(^UploadSuccessPopVcBlock)();

@interface JGJGroupMangerVC () <
UITableViewDelegate,
UITableViewDataSource,
YZGOnlyAddProjectViewControllerDelegate,
JGJTeamMemberCellDelegate,
JGJAddTeamMemberDelegate,
JGJTeamDetailCommonPopViewDelagate,
JGJUnhandleSourceListVCDelegate,
JGJCusSwitchMsgCellDelegate,
JGJGroupSetMemberCellDelegate,
JGJTabHeaderAvatarViewDelegate
>
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *infoModels;//底部项目信息
@property (nonatomic, strong) NSMutableArray *teamMemberModels;//存储班组成员模型
@property (nonatomic, assign) MemberFlagType memberFlagType;
@property (nonatomic, strong) NSMutableArray *commonModels;//存储通用模型数据设置头部标题类型和数量
@property (weak, nonatomic) IBOutlet UIView *containBottomButtonView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containBottomButtonViewH;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightButtonItem;
@property (nonatomic, strong) JGJTeamInfoModel *teamInfo;
@property (nonatomic, copy) ModifyTeamInfoBlock modifyTeamInfoBlock;
@property (nonatomic, strong) NSMutableArray *creatTeamModels;//创建班组模型数组
@property (nonatomic, strong) JGJModifyTeamInfoRequestModel *modifyTeamInfoRequestModel;
@property (nonatomic, strong) JGJRemoveGroupMemberRequestModel *removeGroupMemberRequestModel;
@property (strong, nonatomic) JGJAddGroupMemberRequestModel *addGroupMemberRequestModel;
@property (nonatomic, strong) JGJTeamGroupInfoDetailRequest *infoDetailRequest; //请求详情页
@property (nonatomic, strong) JGJTeamMemberCommonModel *memberCommonModel; //存储当前选择项目或者班组成员模型，主要是区分添加或者删除人员后区分类型
@property (nonatomic, strong) NSMutableArray *mineInfos;//我在本组的名字
@property (nonatomic, strong) NSMutableArray *adminInfos;//设置管理员显示标签
@property (nonatomic, strong) NSMutableArray *msgDisturbInfos;//消息免打扰信息

@property (nonatomic, strong) NSMutableArray *checkAllMembers;//查看所有成员

@property (nonatomic, assign) NSInteger maxNum;

@property (nonatomic, strong) JGJServiceOverTimeRequest *serviceOverTimeRequest;

//分享菜单
@property (nonatomic, strong) JGJKnowledgeDaseTool *shareMenuTool;

//顶部免费试用
@property (nonatomic, strong) UIView *contentTopView;

//试用描述
@property (nonatomic, strong) UILabel *tryDes;

@property (nonatomic, strong) JGJTabHeaderAvatarView *avatarheaderView;

@property (nonatomic, strong) NSMutableArray *clearCache;//清除缓存组

//上传成功返回
@property (nonatomic, copy) UploadSuccessPopVcBlock uploadSuccessPopVcBlock;

@end

@implementation JGJGroupMangerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonSet];
    [self setNavBar];
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadGetGroupInfo]; //这里刷新数据主要是添加有数据源的数据来源人，更改状态
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    switch (section) {
        case TeamMangerCellMemberType:{
            
//            count = (self.teamInfo.members_num.integerValue > _maxNum) ? 2 : 1;
            
            count = 1;
            
        }
            
            break;
        case TeamMangerCellReporedMemberType: {
            
            count = self.workProListModel.teamMangerVcType == JGJProMangerType ? 2 : 0;
            
            if (self.workProListModel.teamMangerVcType == JGJProMangerType && self.teamInfo.source_members_num.integerValue > _maxNum) {
                
                count = 3;
            }
        }
            break;
        case TeamMangerCellTeamInfoType:
            count = self.creatTeamModels.count;
            break;
        case TeamMangerCellMineInfoType:
            count = self.mineInfos.count;
            break;
        case TeamMangerCellDistubMsgInfoType:
            count = self.msgDisturbInfos.count + self.clearCache.count;
            break;
        case TeamMangerCellSetAdminType:
            count = self.adminInfos.count;
            break;
            
        case TeamMangerCellServiceType:{
            
            count = self.teamInfo.current_server.count;
        }
            
            break;

        default:
            break;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case TeamMangerCellMemberType: {
            
            if (indexPath.row == 0) {
                
                cell = [self handleRegisterTeamMemberTableView:tableView indexpath:indexPath];
                
            }else {
                
                cell = [self handleCheckAllMemberTableView:tableView indexpath:indexPath];
            }
            
        }
            break;
        case TeamMangerCellReporedMemberType: {
            
            if (indexPath.row == 0) {
                
                cell = [self sourceDesCellWithTableView:tableView indexpath:indexPath];
                
            }else if (indexPath.row == 1) {
                
                cell = [self handleRegisterSourceReportTableView:tableView indexpath:indexPath];
                
            }else {
                
                cell = [self handleCheckAllMemberTableView:tableView indexpath:indexPath];
            }
            

        }
            break;
        case TeamMangerCellTeamInfoType: {
            cell = [self handleRegisterProInfoTableView:tableView indexpath:indexPath];
        }
            break;
        case TeamMangerCellMineInfoType: {
            cell = [self handleRegisterMineInfoTableView:tableView indexpath:indexPath];
        }
            break;
        case TeamMangerCellDistubMsgInfoType:{
  
            if (indexPath.row == self.msgDisturbInfos.count) {
                
                cell = [self registerComPaddingCellWithTableView:tableView indexpath:indexPath];
                
            }else {
                
                JGJCusSwitchMsgCell *switchMsgCell = [JGJCusSwitchMsgCell cellWithTableView:tableView];
                
                if (self.workProListModel.isClosedTeamVc || self.workProListModel.workCircleProType == WorkCircleExampleProType) {
                    switchMsgCell.workProListModel = self.workProListModel;
                }
                
                switchMsgCell.commonModel = self.msgDisturbInfos[indexPath.row];
                
                switchMsgCell.delegate = self;
                
                cell = switchMsgCell;
                
            }
            
        }
            break;
        case TeamMangerCellSetAdminType: {
            cell = [self handleRegisterSetAdminTableView:tableView indexpath:indexPath];
        }
            break;
            
        case TeamMangerCellServiceType:{
            
            cell = [self handleServiceTypeTableView:tableView indexpath:indexPath];
        }
            
            break;
        
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0;
    switch (indexPath.section) {
        case 0: {
            
            if (indexPath.row == 0) {
                
                height = [JGJGroupSetMemberCell memberCellHeight];
                
            }else {
                
                height = 35;
            }
            
        }
            break;
        case 1: {
            
            if (indexPath.row == 0) {
                
                height = 35;
                
            }else if (indexPath.row == 1) {
                
                height = self.workProListModel.isClosedTeamVc && _teamInfo.source_members_num == 0 ? 0 : [JGJGroupSetMemberCell memberCellHeight];
                
            }else {
                
                height = 35;
            }

        }
            break;
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:{
            
            height = 50.0;
            
            //2.3.0所在项目不要了
            if (indexPath.section == 2 && indexPath.row == 2) {
                
                height = CGFLOAT_MIN;
            }
            
            if(indexPath.section == TeamMangerCellDistubMsgInfoType && indexPath.row == 2) {
                
                height += 10;
                
            }
            
        }
            break;
            
        default:{
            
            
        }
            break;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = CGFLOAT_MIN;
    switch (section) {
        case 0: {
            
            height = [JGJTabHeaderAvatarView headerHeight];
            
        }
            break;
        case 1:
        case 2:
        case 3:
        case 4:
        case 5: {
            
            if (self.workProListModel.teamMangerVcType != JGJProMangerType && (section == 5 || section == 1)) {
                
                height = CGFLOAT_MIN;
                
            }else {
                
                height = 10;
                
            }
            
        }
            break;
            
        case 6:{
            
            height = self.teamInfo.current_server.count == 0 ? CGFLOAT_MIN : 36;
        }
            
            break;
            
        case 7:{
            
            height = 10;
        }
            
            break;
        default:
            break;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    
    //自后一段
    
    if (section == 0) {

        self.avatarheaderView.avatars = _teamInfo.members_head_pic;
        
        if ([NSString isEmpty:_teamInfo.group_info.team_all_comment]) {
            
            _teamInfo.group_info.team_all_comment = _teamInfo.group_info.group_name;
        }
        
        self.avatarheaderView.title = _teamInfo.group_info.team_all_comment;
        
        self.avatarheaderView.num = _teamInfo.members_num;
        
        headerView = self.avatarheaderView;
        
    }else if (section == 6 && self.teamInfo.current_server.count > 0) {
        
        headerView.backgroundColor = AppFontf0f2f5Color;
        
        UILabel *serviceTypeLable = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, TYGetUIScreenWidth, 30)];
        
        serviceTypeLable.font = [UIFont systemFontOfSize:AppFont30Size];
        
        serviceTypeLable.textColor = AppFont666666Color;
        
        serviceTypeLable.text = @"当前服务";
        
        [headerView addSubview:serviceTypeLable];
        
    }else {
        
        headerView = nil;
    }
    
    headerView.backgroundColor = AppFontf1f1f1Color;
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self JGJTableView:tableView handleDidSelectRowAtIndexPath:indexPath];
}

- (void)JGJTableView:(UITableView *)tableView handleDidSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.workProListModel.isClosedTeamVc) { //已关闭项目不能点击
        
        [self closeProTips];
        return;
    }
    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
        [self exampleProSingleTap:nil];
        return;
    }
    if (indexPath.section == TeamMangerCellTeamInfoType) {
        switch (indexPath.row) {
            case ProRemarkCellType: {
                //仅有创建者和普通管理员能修改名称
                BOOL isCanEditTeamName = !self.workProListModel.isClosedTeamVc && (self.teamInfo.is_admin || self.workProListModel.teamMangerVcType == JGJProMangerType);
                if (isCanEditTeamName) {
                    [self handleEditTeamName];
                }
            }
                break;
            case ProNameCellType:
                
                break;
            case ProQrcodeCellType: {
                if (self.workProListModel.isClosedTeamVc) {
                    [TYShowMessage showHUDOnly:@"当前页面已关闭"];
                } else {
                    [self handelGenerateQrcodeAction:nil]; //班组二维码
                }
            }
                break;
                
            case ProAddressCellType:{
                
                BOOL isClicked = (self.teamInfo.is_admin || [self.workProListModel.myself_group isEqualToString:@"1"]) && ![self.teamInfo.team_group_info.city_name isEqualToString:@"未设置"] && [NSString isEmpty:self.teamInfo.team_group_info.city_name];
                
                if (isClicked) {
                    
                    [self handleSelProAddress];
                }
                
            }
                break;
                
                
                
            default:
                break;
        }
        
    }else if (indexPath.section == TeamMangerCellMineInfoType) {
        
        [self handleEditMineName];
        
    }else if (indexPath.section == TeamMangerCellSetAdminType) {
        
        [self handleSetAdministrator];
        
    }else if (indexPath.section == TeamMangerCellMemberType && indexPath.row == 1) {
        
//        JGJTeamMemberCommonModel *commonModel = self.commonModels[0];
//
//        [self handleCheckAllMemberWithCommonModel:commonModel];
        
    }else if (indexPath.section == TeamMangerCellServiceType && self.teamInfo.current_server.count > 0) {
        
        //人数是500人升级人数不能点击
        if (self.teamInfo.buyer_person == 500 && (indexPath.row == 0)) {
            
            return;
        }
        
        JGJTeamServiceModel *serviceModel = self.teamInfo.current_server[indexPath.row];
        
        [self handleServiceTypeWithServiceModel:serviceModel];
        
    }else if (indexPath.section == TeamMangerCellReporedMemberType && indexPath.row == 2) { //数据来源人查看更多
        
        JGJTeamMemberCommonModel *commonModel = self.commonModels[1];
        
        [self handleCheckAllMemberWithCommonModel:commonModel];
        
    }else if (indexPath.section == TeamMangerCellDistubMsgInfoType && indexPath.row == 2) {
        
        [self registerClearCacheWithTableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (UITableViewCell *)registerClearCacheCellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath{
    
    JGJCommonTitleCell *cell = [JGJCommonTitleCell cellWithTableView:tableView];
    
    cell.lineView.hidden = YES;
    
    cell.desModel = self.clearCache[indexPath.row];
    
    return cell;
    
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

#pragma mark - 点击当前服务类型
- (void)handleServiceTypeWithServiceModel:(JGJTeamServiceModel *)serviceModel {
    
    //购买云服务 2，1升级续订
    if ([serviceModel.server_id isEqualToString:@"2"]) {
        
        [self handleOrderVcWithBuyGoodType:CloudNumType serviceModel:serviceModel];
        
    }else {
        
        [self handleOrderVcWithBuyGoodType:VIPServiceType serviceModel:serviceModel];
        
    }
    
}

#pragma mark - 处理二维码生成
- (void)handelGenerateQrcodeAction:(UIButton *)sender {
    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
        [self exampleProSingleTap:nil];
        return ;
    }
    
    JGJCreateGroupVc *joinGroupVc = [JGJCreateGroupVc new];
    JGJCreatTeamModel *teamModel = self.creatTeamModels[0];
    self.workProListModel.team_name = nil;
    self.workProListModel.group_name = teamModel.detailTitle;
    
    if (self.teamInfo.members_head_pic.count > 0) {
        
        self.workProListModel.members_head_pic = self.teamInfo.members_head_pic;
    }
    
    joinGroupVc.workProListModel = self.workProListModel;
    
    [self.navigationController pushViewController:joinGroupVc animated:YES];
}

#pragma mark - 选择项目地址

- (void)handleSelProAddress {
    
    JGJProMangeAddressVc *proMangeAddressVc = [[JGJProMangeAddressVc alloc] init];
    
    JLGCityModel *cityModel = [JLGCityModel new];
    
    cityModel.city_name = [TYUserDefaults objectForKey:JLGCityName];
    
    cityModel.provinceCityName = [TYUserDefaults objectForKey:JLGCityName];
    
    proMangeAddressVc.cityModel = cityModel;
    
    proMangeAddressVc.proName = _teamInfo.group_info.group_name;
    
    [self.navigationController pushViewController:proMangeAddressVc animated:YES];
    
}

- (void)setProDetailAddress:(NSString *)proDetailAddress {
    
    _proDetailAddress = proDetailAddress;
    
    JGJCreatTeamModel *teamModel = self.creatTeamModels[3];
    
    teamModel.isHiddenArrow = YES;
    
    teamModel.detailTitle = proDetailAddress;
    
    _teamInfo.team_group_info.city_name = proDetailAddress;
    
    
    JGJTeamInfoModel *teamInfo = _teamInfo;
    
    //处理改变地址的样式
    
    self.teamInfo = teamInfo;
    
    [self refreshIndexPathSection:2 indexPathrow:0];
    
    [self handleUploadProAddress:proDetailAddress];
}

- (void)handleUploadProAddress:(NSString *)proDetailAddress {
    
    self.modifyTeamInfoRequestModel.city_name = proDetailAddress;
    
    NSDictionary *parameters = [self.modifyTeamInfoRequestModel mj_keyValues];
    
    [self modifyTeamInfo:self.modifyTeamInfoRequestModel];
}

#pragma mark - 班组名称
- (void)handleEditTeamName {
    YZGOnlyAddProjectViewController *editTeamNameVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"onlyAddProject"];
    editTeamNameVc.delegate = self;
    editTeamNameVc.isEditGroupName = YES;
    editTeamNameVc.editType = EditProNameType;
    editTeamNameVc.title = @"修改项目组名称";
    editTeamNameVc.defaultProName = _teamInfo.group_info.team_all_comment;
    editTeamNameVc.proNameTFPlaceholder = @"请输入项目组名称";
    [self.navigationController pushViewController:editTeamNameVc animated:YES];
}

#pragma mark - 我的昵称
- (void)handleEditMineName {
    YZGOnlyAddProjectViewController *editTeamNameVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"onlyAddProject"];
    editTeamNameVc.delegate = self;
    editTeamNameVc.isEditGroupName = YES;
    editTeamNameVc.editType = EditMineNameType;
    editTeamNameVc.title = @"我在本组的名字";
    if (self.teamInfo.group_info.is_nickname) {
        
        editTeamNameVc.defaultProName = self.teamInfo.group_info.nickname;
    }else {
        
        editTeamNameVc.defaultProName = @"";
    }
    
    editTeamNameVc.proNameTFPlaceholder = @"该名字只会在本组显示";
    [self.navigationController pushViewController:editTeamNameVc animated:YES];
}

#pragma mark - 设置管理员
- (void)handleSetAdministrator {
    JGJSetAdministratorVc *setAdministratorVc = [[UIStoryboard storyboardWithName:@"JGJCreatTeam" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJSetAdministratorVc"];
    setAdministratorVc.teamInfo = self.teamInfo;
    setAdministratorVc.workProListModel = self.workProListModel;
    [self.navigationController pushViewController:setAdministratorVc animated:YES];
}

#pragma mark - 查看全部成员
- (void)handleCheckAllMemberWithCommonModel:(JGJTeamMemberCommonModel *)commonModel {
    
    JGJCheckGroupChatAllMemberVc *allMemberVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJCheckGroupChatAllMemberVc"];
    
    allMemberVc.commonModel = commonModel;
    
    self.workProListModel.cur_group_id = self.teamInfo.group_info.group_id; //获取当前群id
    self.workProListModel.cur_class_type = self.teamInfo.group_info.class_type; //当前群类型
    self.workProListModel.class_type = self.teamInfo.group_info.class_type;
    allMemberVc.workProListModel = self.workProListModel;
    
    allMemberVc.teamInfo = self.teamInfo;
    
    allMemberVc.allMemberVcType = CheckAllMemberVcGroupMangerType;
    
    [self.navigationController pushViewController:allMemberVc animated:YES];
    
}

#pragma mark - YZGOnlyAddProjectViewControllerDelegate
- (void)handleYZGOnlyAddProjectViewControllerEditName:(NSString *)editName editType:(EditNameType )editType{
    
    if (editType == EditMineNameType) {
        
        if (![NSString isEmpty:editName]) {
            
            self.modifyTeamInfoRequestModel.nickname = editName;
        }else {
            
            self.modifyTeamInfoRequestModel.nickname = @"";
        }
        
        self.modifyTeamInfoRequestModel.team_comment = nil;
        [self modifyTeamInfo:self.modifyTeamInfoRequestModel];
        __weak typeof(self) weakSelf = self;
        self.modifyTeamInfoBlock = ^ {
            JGJCreatTeamModel *teamNameModel = weakSelf.mineInfos[0];
            teamNameModel.detailTitle = editName;
            
            [weakSelf.tableView reloadData];
            
            [weakSelf handleModifCurGroupName];
            
            //成功才返回当前页面
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        };
    }else if(editType == EditProNameType){
        NSInteger proSectionIdx = 2;
        self.modifyTeamInfoRequestModel.group_name = editName;
        [self modifyTeamInfo:self.modifyTeamInfoRequestModel];
        __weak typeof(self) weakSelf = self;
        self.modifyTeamInfoBlock = ^ {
            
            JGJCreatTeamModel *teamModel = weakSelf.creatTeamModels[0];
            
            teamModel.detailTitle = editName;
            
            [weakSelf.tableView reloadData];
            
            //成功才返回当前页面
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
    TYLog(@"switchType=== %ld isOpen--- %@", (unsigned long)switchType, @(cell.commonModel.isOpen));
    self.modifyTeamInfoRequestModel.is_not_disturbed = [NSString stringWithFormat:@"%@", @(cell.commonModel.isOpen)];
    [self modifyTeamInfo:self.modifyTeamInfoRequestModel];
    __weak typeof(self) weakSelf = self;
    self.modifyTeamInfoBlock = ^ {
        JGJChatDetailInfoCommonModel *msgDisturbModel = weakSelf.msgDisturbInfos[0];
        msgDisturbModel.isOpen = cell.commonModel.isOpen;
        [weakSelf refreshIndexPathSection:4 indexPathrow:0];
        
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
        
        JGJChatDetailInfoCommonModel *msgDisturbModel = self.msgDisturbInfos[1];
        
        msgDisturbModel.isOpen = cell.commonModel.isOpen;
        
        [JGJChatMsgDBManger updateIs_topToGroupTableWithIsTop:cell.commonModel.isOpen group_id:self.workProListModel.group_id class_type:self.workProListModel.class_type];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}


#pragma mark - 添加人员包含类型
- (void)handleJGJTeamMemberCellAddMember:(JGJTeamMemberCommonModel *)commonModel {
    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
        [self exampleProSingleTap:nil];
        return ;
    }
    
    //是否弹出升级提示框
    
    if ([self showPopView]) {
        
        return;
    }
    
    //添加成员类型界面
    [self addMemberSelTypeVcCommonModel:commonModel];
    
    return;
    
    self.memberCommonModel = commonModel;//保存当前模型用于区分添加人员返回后的类型
    JGJSynBillingCommonModel *synBillingCommonModel = [[JGJSynBillingCommonModel alloc] init];
    JGJAddTeamMemberVC *addTeamMemberVC = [[UIStoryboard storyboardWithName:@"JGJCreatTeam" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJAddTeamMemberVC"];
    addTeamMemberVC.workProListModel = self.workProListModel; //获取当前班组信息，根据当前有哪些成员加载通信录
    synBillingCommonModel.synBillingTitle = commonModel.memberType == JGJProMemberType ? @"添加成员" : @"添加数据来源人";
    addTeamMemberVC.commonModel = commonModel;
    addTeamMemberVC.delegate = self;
    addTeamMemberVC.groupMemberMangeType = self.memberCommonModel.memberType == JGJProSourceMemberType ? JGJGroupMemberMangePushNotifyType : JGJGroupMemberMangeAddMemberType;
    addTeamMemberVC.contactedAddressBookVcType = JGJTeamMangerAddMembersVcType;//项目组添加
    
    NSArray *members = self.teamInfo.team_group_members;
    
    if (commonModel.memberType == JGJProMemberType) {
        
        members = self.teamInfo.team_group_members;
        
    }else if (commonModel.memberType == JGJProSourceMemberType) {
        
       members = self.teamInfo.source_report_members;
    }
    
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isMangerModel != %@", @(YES)];
    //
    //    members = [members filteredArrayUsingPredicate:predicate];
    
    addTeamMemberVC.currentTeamMembers = members;
    
    addTeamMemberVC.synBillingCommonModel = synBillingCommonModel;
    
    addTeamMemberVC.sortContactsModel = self.sortContactsModel;
    
    addTeamMemberVC.maxMemberNum = self.teamInfo.buyer_person;
    
    addTeamMemberVC.teamInfo = self.teamInfo;
    
    [self.navigationController pushViewController:addTeamMemberVC animated:YES];
}

#pragma mark - 添加成员
- (void)addMemberSelTypeVcCommonModel:(JGJTeamMemberCommonModel *)commonModel {
    
    JGJMemberSelTypeVc *selTypeVc = [JGJMemberSelTypeVc new];
    
    selTypeVc.workProListModel = self.workProListModel;
    
    selTypeVc.teamInfo = self.teamInfo;
    
    selTypeVc.commonModel = commonModel;
    
    selTypeVc.targetVc = self;
    
    selTypeVc.contactedAddressBookVcType = JGJTeamMangerAddMembersVcType;
    
    [self.navigationController pushViewController:selTypeVc animated:YES];
    
}

#pragma mark - 删除人员包含类型
- (void)handleJGJTeamMemberCellRemoveMember:(JGJTeamMemberCommonModel *)commonModel {
    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
        [self exampleProSingleTap:nil];
        return ;
    }
    
    self.memberCommonModel = commonModel;//保存当前模型用于区分删除人员返回后的类型
    JGJSynBillingCommonModel *synBillingCommonModel = [[JGJSynBillingCommonModel alloc] init];
    JGJAddTeamMemberVC *removeMemberVC = [[UIStoryboard storyboardWithName:@"JGJCreatTeam" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJAddTeamMemberVC"];
    removeMemberVC.delegate = self;
    synBillingCommonModel.synBillingTitle = commonModel.memberType == JGJProMemberType ? @"删除成员" : @"删除数据来源人";
    ;
    removeMemberVC.groupMemberMangeType = JGJGroupMemberMangeRemoveMemberType;
    
    NSArray *members = self.teamInfo.team_group_members;
    
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"is_creater != %@ AND uid != %@ AND isMangerModel != %@ AND is_source_member = %@", @"1", myUid, @(YES), @(NO)];
    BOOL is_creater = [self.teamInfo.creater_uid isEqualToString:myUid];
    
    if (commonModel.memberType == JGJProMemberType) {
        
        members = self.teamInfo.team_group_members;
        
        if (is_creater) {
            
            predicate = [NSPredicate predicateWithFormat:@"is_creater != %@ AND uid != %@ AND isMangerModel != %@", @"1", myUid, @(YES)];
        }else if (_teamInfo.is_admin) {
            
            predicate = [NSPredicate predicateWithFormat:@"is_creater != %@ AND is_admin != %@ AND uid != %@ AND isMangerModel != %@ AND is_source_member = %@", @"1", @(YES), myUid, @(YES), @(NO)];
        }
        
    }else if (commonModel.memberType == JGJProSourceMemberType) {
        
        members = self.teamInfo.source_report_members;
        
        predicate = [NSPredicate predicateWithFormat:@"is_creater != %@ AND uid != %@ AND isMangerModel != %@ AND is_source_member = %@", @"1", myUid, @(YES), @(YES)];
    }
    
    members = [members filteredArrayUsingPredicate:predicate];
    
    removeMemberVC.currentTeamMembers = members;
    
    removeMemberVC.synBillingCommonModel = synBillingCommonModel;
    
    [self.navigationController pushViewController:removeMemberVC animated:YES];
}

#pragma mark - 处理得到移除的成员
- (NSArray *)handleGetRemoveMembers{
    NSArray *contacts = nil;
    NSPredicate *predicate = nil;
    if (self.workProListModel.teamMangerVcType == JGJProMangerType) {
        contacts = self.teamMemberModels;
    }else {
        predicate = [NSPredicate predicateWithFormat:@"is_admin == %@", @(NO)];
        contacts = [self.teamMemberModels filteredArrayUsingPredicate:predicate];
    }
    predicate = [NSPredicate predicateWithFormat:@"is_source_member == %@", @(NO)];
    contacts = [contacts filteredArrayUsingPredicate:predicate];
    return contacts;
}

#pragma mark - JGJGroupMemberMangeDelegate 返回删除和添加的成员
- (void)handleJGJGroupMemberSelectedTeamMembers:(NSMutableArray *)teamsMembers groupMemberMangeType:(JGJGroupMemberMangeType)groupMemberMangeType {
    switch (groupMemberMangeType) {
        case JGJGroupMemberMangePushNotifyType:
        case JGJGroupMemberMangeAddMemberType:
            [self getAddTeamMembers:teamsMembers groupMemberMangeType:JGJGroupMemberMangeAddMemberType]; //上传班组成员信息
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
    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
        [self exampleProSingleTap:nil];
        return ;
    }
    
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
    
    NSString *requestApi = JGJGroupDelMembersURL;
    
    if (self.memberCommonModel.memberType == JGJProSourceMemberType) {
        
        requestApi = JGJGroupDelSourceMembersURL;
    }
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:requestApi parameters:parameters success:^(id responseObject) {
        
//        [weakSelf upLoadTeamMembersSuccessShowTeamsAllMembers:teamMembers groupMemberMangeType:groupMemberMangeType];
        
        [TYLoadingHub hideLoadingView];
        
        [TYShowMessage showSuccess:@"删除成功"];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
}

#pragma mark - 获取成员信息
- (void)getAddTeamMembers:(NSMutableArray *)teamMembers groupMemberMangeType:(JGJGroupMemberMangeType)groupMemberMangeType {
    NSMutableArray *groupMembersInfos = [NSMutableArray array];
    for (JGJSynBillingModel *teamMemberModel in teamMembers) { //添加返回的成员需要上传的信息
        JGJGroupMembersRequestModel *membersModel = [[JGJGroupMembersRequestModel alloc] init];
        membersModel.real_name = teamMemberModel.real_name;
        membersModel.telephone = teamMemberModel.telephone;
        membersModel.uid = teamMemberModel.uid;
        teamMemberModel.isAddedSyn = YES;
        teamMemberModel.isSelected = NO;
        [groupMembersInfos addObject:membersModel];
    } //获取姓名和电话
    [self handleUploadTeamMembers:groupMembersInfos groupMemberMangeType:groupMemberMangeType];
}

#pragma mark - 上传班组成员信息
- (void)handleUploadTeamMembers:(NSMutableArray *)groupMembersInfos groupMemberMangeType:(JGJGroupMemberMangeType)groupMemberMangeType {
    __weak typeof(self) weakSelf = self;
    if (self.memberCommonModel.memberType == JGJProMemberType) {
        self.addGroupMemberRequestModel.group_members = groupMembersInfos;
        self.addGroupMemberRequestModel.source_members = nil;
    } else {
        self.addGroupMemberRequestModel.source_members = groupMembersInfos;
        self.addGroupMemberRequestModel.team_members = nil;
    }
    NSDictionary *parameters = [self.addGroupMemberRequestModel mj_keyValues];

}

#pragma mark - 上传班组成员成功后显示数据
- (void)upLoadTeamMembersSuccessShowTeamsAllMembers:(NSArray *)teamMembers groupMemberMangeType:(JGJGroupMemberMangeType)groupMemberMangeType {
    
    [TYLoadingHub hideLoadingView];
    
    [self loadGetGroupInfo];
    
}

#pragma mark - 注册cell
#pragma mark - 注册顶部成员cell
- (UITableViewCell *)handleRegisterTeamMemberTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath {
    JGJGroupSetMemberCell *memberCell = [JGJGroupSetMemberCell cellWithTableView:tableView];
    
    JGJTeamMemberCommonModel *commonModel = self.commonModels[0];
    
    commonModel.memberType = JGJProMemberType;
    
    memberCell.commonModel = commonModel;
    
    memberCell.delegate = self;
    
    memberCell.members = self.teamMemberModels;
    
    return memberCell;
}

#pragma mark - JGJTabHeaderAvatarViewDelegate 查看更多成员

- (void)tabHeaderAvatarView:(JGJTabHeaderAvatarView *)avatarView {
    
    [self handleCheckAllMemberWithCommonModel:self.commonModels[0]];
    
}

#pragma mark - 注册查看全部群成员Cell
- (UITableViewCell *)handleCheckAllMemberTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath {
    
    JGJCheckAllMemberCell *checkMemberCell  = [JGJCheckAllMemberCell cellWithTableView:tableView];
    
    NSString *des = indexPath.section == 1 ? @"查看所有数据来源人" : @"查看所有成员";
    
    checkMemberCell.des = des;
    
    return checkMemberCell;
}

- (UITableViewCell *)sourceDesCellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath {
    
    JGJMemberDesCell *cell = [JGJMemberDesCell cellWithTableView:tableView];
    
    cell.commonModel = self.commonModels[1];
    
    cell.titleLable.text = [NSString stringWithFormat:@"数据来源人 (%@)", _teamInfo.source_members_num];
    
    return cell;
}

#pragma mark - 中部来源人、汇报者cell
- (UITableViewCell *)handleRegisterSourceReportTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath {
    
    JGJGroupSetMemberCell *memberCell = [JGJGroupSetMemberCell cellWithTableView:tableView];
    
    JGJTeamMemberCommonModel *commonModel = self.commonModels[1];
    
    commonModel.memberType = JGJProSourceMemberType;
    
    memberCell.commonModel = commonModel;
    
    memberCell.delegate = self;
    
    memberCell.members = commonModel.teamMemberModels;
    
    return memberCell;
}

#pragma mark - 注册查看全部数据来源人
- (UITableViewCell *)handleCheckSourceAllMemberTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath {
    
    JGJProSetDesCell *checkMemberCell  = [JGJProSetDesCell cellWithTableView:tableView];
    
    JGJProSetDesCellModel *desModel = [[JGJProSetDesCellModel alloc] init];
    
    desModel.title = @"查看所有数据来源人";
    
    desModel.isShowTopLineView = YES;
    
    desModel.isShowBottomLineView = NO;
    
    desModel.flagImageStr = @"";
    
    checkMemberCell.desModel = desModel;
    
    return checkMemberCell;
}

#pragma mark - 底部项目信息cell
- (UITableViewCell *)handleRegisterProInfoTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    
    JGJCreatTeamModel *teamModel = self.creatTeamModels[indexPath.row];
    
    if (indexPath.row == 0) {
        
        JGJProSetDesCell *checkMemberCell  = [JGJProSetDesCell cellWithTableView:tableView];
        
        JGJProSetDesCellModel *desModel = [[JGJProSetDesCellModel alloc] init];
        
        desModel.title = @"项目名称";
        
        desModel.detailTitle = teamModel.detailTitle;
        
        BOOL isEditProname = !(self.teamInfo.is_admin || (self.workProListModel.teamMangerVcType == JGJProMangerType));
        
        
        desModel.detailTitleColor = isEditProname ? AppFont999999Color : AppFont333333Color;
        
        
        //管理员和创建者可以修改
        desModel.isHiddenImageView = isEditProname;
        
        //        desModel.flagImageStr = self.teamInfo.is_senior ? @"pro_hight_level" : @"";
        
        //3.2.0去掉黄金版本标识
        
        //        desModel.flagImageStr = @"";
        
        checkMemberCell.desModel = desModel;
        
        cell = checkMemberCell;
        
    }else {
        
        JGJCreatTeamCell *teamCell = [JGJCreatTeamCell cellWithTableView:tableView];
        
        teamCell.title.hidden = indexPath.section == 2 && indexPath.row == 2;
        
        teamCell.creatTeamModel = self.creatTeamModels[indexPath.row];
        
        teamCell.lineView.hidden = indexPath.row == self.creatTeamModels.count - 1;
        
        cell = teamCell;
    }
    
    return cell;
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
            
            [self handleJGJTeamMemberCellRemoveMember:cell.commonModel];
            
        }
        
    }else {
        
        cell.commonModel.teamModelModel = memberModel;
        
        [self handleJGJTeamMemberCellUnRegisterTeamModel:cell.commonModel];
        
        
    }
}

#pragma mark - getter 2.3.0 去掉了所在项目
- (NSMutableArray *)creatTeamModels {
    NSArray *titles = @[@"项目名称", @"项目二维码",@"所在项目", @"项目地址"];
    NSArray *placeholders = @[@"编辑项目组名称", @"班组二维码",@"华侨城", @"未设置"];
    if (!_creatTeamModels) {
        _creatTeamModels = [NSMutableArray array];
        for (int indx = 0; indx < titles.count; indx ++) {
            JGJCreatTeamModel *teamModel = [[JGJCreatTeamModel alloc] init];
            teamModel.title = titles[indx];
            teamModel.placeholderTitle = placeholders[indx];
            //            teamModel.isHiddenArrow = indx == 2;
            [_creatTeamModels addObject:teamModel];
        }
    }
    return _creatTeamModels;
}

- (NSMutableArray *)mineInfos {
    NSString *telephone = [TYUserDefaults stringForKey:JLGPhone]?:@"";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"telephone == %@", telephone];
    JGJSynBillingModel *teamMemberModel = [self.teamInfo.member_list filteredArrayUsingPredicate:predicate].lastObject;
    if (!_mineInfos) {
        _mineInfos = [NSMutableArray array];
        NSArray *titles = @[@"我在本组的名字"];
        NSArray *detailTitles = @[teamMemberModel.real_name?:@""];
        for (int indx = 0; indx < titles.count; indx ++) {
            JGJCreatTeamModel *teamModel = [[JGJCreatTeamModel alloc] init];
            teamModel.title = titles[indx];
            teamModel.detailTitle = detailTitles[indx];
            [_mineInfos addObject:teamModel];
        }
    }
    return _mineInfos;
}

- (NSMutableArray *)adminInfos {
    NSUInteger count = (self.workProListModel.teamMangerVcType == JGJProMangerType) ? 1 : 0;
    if (!_adminInfos) {
        _adminInfos = [NSMutableArray array];
        NSArray *titles = @[@"设置管理员"];
        NSArray *detailTitles = @[@""];
        for (int indx = 0; indx < count; indx ++) {
            JGJCreatTeamModel *teamModel = [[JGJCreatTeamModel alloc] init];
            teamModel.title = titles[indx];
            teamModel.detailTitle = detailTitles[indx];
            [_adminInfos addObject:teamModel];
        }
    }
    return _adminInfos;
}

#pragma mark - 底部项目信息编辑名字
- (UITableViewCell *)handleRegisterMineInfoTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath{
    JGJCreatTeamCell *teamCell = [JGJCreatTeamCell cellWithTableView:tableView];
    teamCell.creatTeamModel = self.mineInfos[indexPath.row];
    teamCell.lineView.hidden = indexPath.row == self.mineInfos.count - 1;
    return teamCell;
}

- (UITableViewCell *)registerComPaddingCellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath{
    
    JGJComPaddingCell *cell = [JGJComPaddingCell cellWithTableView:tableView];
    
    cell.infoDesModel = self.clearCache[0];
    
    cell.centerY.constant = 5;
    
    return cell;
}

#pragma mark - 设置管理员
- (UITableViewCell *)handleRegisterSetAdminTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath{
    JGJCreatTeamCell *teamCell = [JGJCreatTeamCell cellWithTableView:tableView];
    teamCell.creatTeamModel = self.adminInfos[indexPath.row];
    teamCell.lineView.hidden = indexPath.row == self.adminInfos.count - 1;
    return teamCell;
}

#pragma mark - 服务类型
- (UITableViewCell *)handleServiceTypeTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath{
    JGJProSetDesCell *checkMemberCell  = [JGJProSetDesCell cellWithTableView:tableView];
    
    JGJTeamServiceModel *serviceModel = self.teamInfo.current_server[indexPath.row];
    
    JGJProSetDesCellModel *desModel = [[JGJProSetDesCellModel alloc] init];
    
    desModel.title = serviceModel.first_title_name;
    
    desModel.detailTitle = serviceModel.second_title_name;
    
    desModel.flagImageStr = @"";
    
    desModel.detailTitleColor = AppFontEB4E4EColor;
    
    desModel.isHiddenImageView = self.teamInfo.buyer_person == 500 && (indexPath.row == 0);
    
    checkMemberCell.desModel = desModel;
    
    checkMemberCell.bottomLineView.hidden = indexPath.row == self.teamInfo.current_server.count - 1;
    
    return checkMemberCell;
}

#pragma mark - 设置头部类型和是否显示删除按钮
- (NSMutableArray *)commonModels {
    if (!_commonModels) {
        _commonModels = [NSMutableArray array];
        NSArray *headerTitles = @[@"项目组成员", @"数据来源人"];
        for (int indx = 0; indx < 2; indx ++) {
            JGJTeamMemberCommonModel *commonModel = [[JGJTeamMemberCommonModel alloc] init];
            commonModel.isHiddenDeleteFlag = YES;
            commonModel.teamControllerType = JGJTeamMangerControllerType;
            commonModel.headerTitle = headerTitles[indx];
            [_commonModels addObject:commonModel];
        }
    }
    return _commonModels;
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
    self.workProListModel.is_admin = _teamInfo.is_admin; //自己的身份
    
    
    //iphone5 大于三行截取10个+两个加减号共12个.其余手机成员大于13个 + 2个加减号 共15个.管理员创建者少一个
    
    self.teamMemberModels = _teamInfo.team_group_members;
    
    //获得所有成员
    self.checkAllMembers = _teamInfo.team_group_members.mutableCopy;
    
    NSInteger line = ProSetMemberRow;
    
    if (_teamInfo.is_admin || self.workProListModel.teamMangerVcType == JGJProMangerType) {
        
//        _maxNum = TYIS_IPHONE_5_OR_LESS ? line * 4 - 2 : line * 5 - 2;
        
        _maxNum = [JGJGroupSetMemberCell headerCount] - 2;
        
    }else {
        
//        _maxNum = TYIS_IPHONE_5_OR_LESS ? line * 4 - 1 : line * 5 - 1;
        
        _maxNum = [JGJGroupSetMemberCell headerCount] - 1;
    }
    
    if (_teamInfo.team_group_members.count > _maxNum) {
        
        self.teamMemberModels = [_teamInfo.team_group_members subarrayWithRange:NSMakeRange(0, _maxNum)].mutableCopy;
    }
    
    _teamInfo.members_num = [NSString stringWithFormat:@"%@", @(_teamInfo.member_list.count)];
    
    self.workProListModel.members_num = [NSString stringWithFormat:@"%@", @(_teamInfo.member_list.count)];
    
    self.tableView.hidden = NO;
    
    JGJTeamMemberCommonModel *commonModel = self.commonModels[0];
    
    commonModel.teamMemberModels = _teamInfo.member_list;
    
    commonModel.count = _teamInfo.team_members.count;
    commonModel.memberType = JGJProMemberType;
    
    NSArray *mangerModels = [self accordTypeGetMangerModels:commonModel]; //根据条件得到添加删除选项
    for (JGJSynBillingModel *mangerModel in mangerModels) {
        [self.teamMemberModels removeObject:mangerModel];
    }
    
    //有可能是截取了的成员
    [self.teamMemberModels addObjectsFromArray:mangerModels];
    
    //得到所有成员
    [self.checkAllMembers addObjectsFromArray:mangerModels];
    
    JGJTeamMemberCommonModel *sourceCommonModel = self.commonModels[1];
    
    //获取数据来源人
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"is_source_member == %@", @(YES)];
    
    NSMutableArray *sourceMembers = [_teamInfo.member_list filteredArrayUsingPredicate:predicate].mutableCopy;
    
    _teamInfo.source_members = sourceMembers;
    
    _teamInfo.source_members_num = [NSString stringWithFormat:@"%@", @(sourceMembers.count)];
    
    sourceCommonModel.teamMemberModels = sourceMembers;
    
    if (!sourceCommonModel.teamMemberModels) {
        
        sourceCommonModel.teamMemberModels = [NSMutableArray array];
        
    }
    
    sourceCommonModel.count = sourceMembers.count;
    
    sourceCommonModel.memberType = JGJProSourceMemberType;
    
    NSArray *sourceMangerModels = [self accordTypeGetMangerModels:sourceCommonModel]; //根据条件得到添加删除选项
    
    JGJChatDetailInfoCommonModel *msgDisturbModel = self.msgDisturbInfos[0];
    
    msgDisturbModel.isOpen = _teamInfo.is_no_disturbed;
    
    JGJChatDetailInfoCommonModel *msgStickModel = self.msgDisturbInfos[1];
    
    msgStickModel.isOpen = _teamInfo.is_sticked;
    
    //更新聊聊表
    JGJChatGroupListModel *groupModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:self.workProListModel.group_id classType:self.workProListModel.class_type];
    
    groupModel.members_num = _teamInfo.members_num;
    
    groupModel.local_head_pic = [_teamInfo.members_head_pic mj_JSONString];
    
    groupModel.group_name =  _teamInfo.group_info.group_name;
    
    //更新聊聊表结束
    [JGJChatMsgDBManger updateChatGroupListTableWithJGJChatMsgListModel:groupModel];
    
    //数据来源人显示5行,只有创建者才显示
    if (self.workProListModel.teamMangerVcType == JGJProMangerType) {
        
//        _maxNum = TYIS_IPHONE_5_OR_LESS ? line * 4 - 2 : line * 5 - 2;
        
        _maxNum = [JGJGroupSetMemberCell headerCount] - 2;
        
        if (_teamInfo.source_report_members.count > _maxNum) {
            
            sourceCommonModel.teamMemberModels = [sourceCommonModel.teamMemberModels subarrayWithRange:NSMakeRange(0, _maxNum)].mutableCopy;
        }
        
    }
    
    [sourceCommonModel.teamMemberModels addObjectsFromArray:sourceMangerModels];
    
    [self handleProDetail:_teamInfo];
    
}

-(void)handleProDetail:(JGJTeamInfoModel *)teamInfo {
    
    JGJCreatTeamModel *proModel = self.creatTeamModels[0];
    proModel.teamMangerVcType = self.teamMangerVcType;
    
    //原用的这个字段
    _teamInfo.group_info.team_all_comment = _teamInfo.group_info.group_name;
    
    proModel.detailTitle = _teamInfo.group_info.team_all_comment;
    
    BOOL isCanEditProName = teamInfo.is_admin || self.workProListModel.teamMangerVcType == JGJProMangerType;
    
    proModel.isHiddenArrow = !isCanEditProName;
    
    JGJCreatTeamModel *qrcodeModel = self.creatTeamModels[1];
    //    qrcodeModel.detailTitle = self.workProListModel.group_id;//二维码编号
    qrcodeModel.teamMangerVcType = self.teamMangerVcType;
    qrcodeModel.isShowQrcode = YES;
    JGJCreatTeamModel *teamNameModel = self.creatTeamModels[2];
    teamNameModel.teamMangerVcType = self.teamMangerVcType;
    teamNameModel.detailTitle = _teamInfo.team_group_info.pro_name;
    teamNameModel.placeholderTitle = _teamInfo.team_group_info.pro_name;
    teamNameModel.isHiddenArrow = YES;
    //所在项目不能点击
    teamNameModel.isOnlyContent = YES;
    
    JGJCreatTeamModel *proNameModel = self.creatTeamModels[3];
    
    teamInfo.team_group_info.city_name = teamInfo.group_info.city_name;
    
    proNameModel.placeholderTitle = teamInfo.team_group_info.city_name;
    
    //成员为地址为空
    if (!([self.workProListModel.myself_group isEqualToString:@"1"] || self.teamInfo.is_admin) && [NSString isEmpty:teamInfo.team_group_info.city_name]) {
        
        proNameModel.placeholderTitle = @"未设置";
        
        proNameModel.isOnlyContent = YES; //成员只显示文字
    }
    
    if (![NSString isEmpty:teamInfo.team_group_info.city_name] && ![teamInfo.team_group_info.city_name isEqualToString:@"未设置"]) {
        
        proNameModel.isOnlyContent = YES;
    }
    
    //显示设置管理员
    
    if (self.adminInfos.count > 0) {
        
        JGJCreatTeamModel *teamModel = self.adminInfos[0];
        
        teamModel.detailTitle = [_teamInfo.admins_num isEqualToString:@"0"] || [NSString isEmpty:_teamInfo.admins_num] ? @"" : _teamInfo.admins_num;
    }
    
    //    //未购买过，显示试用
    //    if (!teamInfo.team_info.is_buyed) {
    //
    //        self.tableView.tableHeaderView = self.contentTopView;
    //
    //    }else {
    //
    //         UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, CGFLOAT_MIN)];
    //
    //        self.tableView.tableHeaderView = headerView;
    //    }
    //
    //    if (![NSString isEmpty:teamInfo.team_info.buyed_desc]) {
    //
    //        self.tryDes.text = teamInfo.team_info.buyed_desc?:@"";
    //    }
    
    //设置底部按钮
    [self setTabFooterSheetView];
    
    [self.tableView reloadData];
    
    [self setChatTitleInfo:teamInfo];
}

- (void)setChatTitleInfo:(JGJTeamInfoModel *)teamInfo {
    
    if (![NSString isEmpty:_teamInfo.team_info.team_all_comment]) {
        
        self.workProListModel.group_name = _teamInfo.team_info.team_all_comment; //传入修改的名字
        
        self.workProListModel.members_num = teamInfo.members_num;
    }
    
}

#pragma mark - 计算班组成员高度
- (CGFloat)calculateCollectiveViewHeight:(NSArray *)dataSource  memberFlagType:(MemberFlagType) memberFlagType {
    NSInteger lineCount = 0;
    if (memberFlagType == DefaultTeamMemberFlagType) {
        
        TYLog(@"-----%ld", (unsigned long)dataSource.count);
    }
    NSUInteger teamMemberCount = dataSource.count;
    
    CGFloat padding = 15;
    
    NSInteger rowNum = 5;
    
    lineCount = ((teamMemberCount / MemberRowNum) + (teamMemberCount % MemberRowNum != 0 ? 1 : 0));
    
    CGFloat collectionViewHeight = lineCount * ItemHeight + HeaderHegiht + padding;
    
    return collectionViewHeight;
}

#pragma mark - 点击不是我们平台成员弹框
- (void)handleJGJTeamMemberCellUnRegisterTeamModel:(JGJTeamMemberCommonModel *)commonModel {
    if(self.workProListModel.isClosedTeamVc){
        return;
    }
    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
        [self exampleProSingleTap:nil];
        return ;
    }
    
    if (commonModel.teamModelModel.isMangerModel) {
        
        return;
    }
    
    BOOL isActive = [commonModel.teamModelModel.is_active integerValue];
    if (commonModel.memberType == JGJProMemberType && !isActive) {
        
        JGJTeamMemberCommonModel *commonModel = self.commonModels[0];
        
        [self handleCheckAllMemberWithCommonModel:commonModel];
        
//        if ([commonModel.teamModelModel.is_active isEqualToString:@"0"]) {
//            commonModel.alertViewHeight = 210.0;
//            commonModel.alertmessage = @"该用户还未注册,赶紧邀请他下载[吉工家]一起使用吧！";
//            commonModel.alignment = NSTextAlignmentLeft;
//        } else {
//            commonModel.alertViewHeight = 147.0;
//            commonModel.alertmessage = @"";
//        }
//
//        JGJCustomProInfoAlertVIew *alertView = [JGJCustomProInfoAlertVIew alertViewWithCommonModel:commonModel];
//
//        if (!self.shareMenuTool) {
//
//            self.shareMenuTool = [[JGJKnowledgeDaseTool alloc] init];
//
//            self.shareMenuTool.targetVc  = self;
//
//            self.shareMenuTool.isUnCanShareCount = YES; //不清零
//        }
//
//        __weak typeof(self) weakSelf = self;
//
//        alertView.confirmButtonBlock = ^{
//
//            NSString *img = [NSString stringWithFormat:@"%@%@", JLGHttpRequest_IP_center, @"media/default_imgs/logo.jpg"];
//
//            NSString *uid = [TYUserDefaults objectForKey:JLGUserUid];
//
//            NSString *url =[NSString stringWithFormat:@"%@page/open-invite.html?uid=%@&plat=person", JGJWebDiscoverURL,uid];;
//
//            NSString *title = @"我正在用招工找活、记工记账神器：吉工家APP";
//
//            NSString *desc = @"100万建筑工友都在用！下载注册就送100积分抽百元话费！";
//
//            [weakSelf.shareMenuTool showShareBtnClick:img desc:desc title:title url:url];
//        };
    } else if(commonModel.memberType == JGJProSourceMemberType) {
        
        if ([commonModel.teamModelModel.synced isEqualToString:@"1"]) {
            commonModel.alertViewHeight = 190.0;
            commonModel.alertmessage = @"暂时还没有关联的项目";
            commonModel.alignment = NSTextAlignmentCenter;
            commonModel.isHidden = NO;
        } else {
            commonModel.alertmessage = @"该用户还未同意向你同步项目";
            commonModel.alertViewHeight = 150.0;
            commonModel.isHidden = YES;
            commonModel.alignment = NSTextAlignmentCenter;
        }
        commonModel.workProListModel = self.workProListModel;
        JGJTeamDetailCommonPopView *popView = [JGJTeamDetailCommonPopView popViewWithCommonModel:commonModel];
        popView.delegate = self;
    }else if (commonModel.memberType == JGJProMemberType && isActive) {
        //        NSString *myTel = [TYUserDefaults objectForKey:JLGPhone];
        //        if ([myTel isEqualToString:commonModel.teamModelModel.telephone]) { //点击是自己不操作
        //            return;
        //        }
        
//        [self handleDidSelectedMemberWithMemberModel:commonModel.teamModelModel];
        
        JGJTeamMemberCommonModel *commonModel = self.commonModels[0];
        
        [self handleCheckAllMemberWithCommonModel:commonModel];
    }
}

#pragma mark - 常用设置
- (void)commonSet {
    
    self.tableView.hidden = YES;
    self.containBottomButtonViewH.constant = 0;
    self.containBottomButtonView.hidden = YES;
    self.title = @"项目设置";
    [self.bottomButton.layer setLayerCornerRadius:5.0];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYTableViewFooterHeight)];
    
    footerView.backgroundColor = [UIColor clearColor];
    
    self.tableView.tableFooterView = footerView;
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
    JGJTabPaddingView *headerView = [JGJTabPaddingView tabPaddingView];
    
    headerView.topLineView.hidden = YES;
    
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - 根据情况关闭班组或者退出班组
- (IBAction)handleRightTeamButtonPressed:(UIBarButtonItem *)sender {
//    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
//        [self exampleProSingleTap:nil];
//        return;
//    }
//
//    [self showSheetView];
    
}

#pragma mark - 设置底部按钮
- (void)setTabFooterSheetView {
    
    [self showSheetView];
}

- (void)showSheetView{
    NSArray *buttons = nil;
    switch (self.workProListModel.teamMangerVcType) {
            
            //普通成员退出和取消
        case JGJNormalProMangerType:
        case JGJProInfoType: {
            
            buttons = @[@"退出项目组"];
        }
            break;
            
            //管理人员和关闭、删除、取消
        case JGJProMangerType: {
            
            if (self.workProListModel.isClosedTeamVc) {
                
                buttons = @[@"重新开启", @"彻底删除"];
                
            }else {
                
                buttons = @[@"暂时关闭项目组", @"关闭并删除项目组"];
            }
            
        }
            break;
            
            //数据来源人也是退出和取消
        case JGJNormalProMangerAndSourceMemberType:
        case JGJSourceMemberType: {
            //关闭同步
            
            buttons = @[@"退出项目组"];
        }
            break;
        default:{
            
            buttons = @[@"退出项目组组"];
        }
            break;
    }
    
    [self setSheetViewWithButtons:buttons];
}

- (void)setSheetViewWithButtons:(NSArray *)buttons {
    
    __weak typeof(self) weakSelf = self;
    JGJCusButtonSheetView *sheetView = [[JGJCusButtonSheetView alloc] initWithSheetViewType:JGJCusButtonSheetViewDefaultType chageColors:nil buttons:buttons buttonClick:^(JGJCusButtonSheetView *sheetView, NSInteger buttonIndex, NSString *title) {
        
        [weakSelf handleActionSheetViewWithButtonIndex:buttonIndex];
        
    }];
    
    self.tableView.tableFooterView = sheetView;
}

#pragma mark - 拆分按钮按下
- (IBAction)handleSpilitButtonPressed:(UIButton *)sender {
    UIViewController *creatProVC = [[UIStoryboard storyboardWithName:@"JGJSplitPro" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJSplitProVC"];
    if (self.teamInfo) {
        [creatProVC setValue:self.teamInfo forKey:@"teamInfo"];
    }
    [self.navigationController pushViewController:creatProVC animated:YES];
}

#pragma mark - JGJTeamDetailCommonPopViewDelagate  关联本地项目
- (void)teamDetailCommonPopView:(JGJTeamDetailCommonPopView *)popView {
    JGJUnhandleSourceListVC *sourceListVC = [[UIStoryboard storyboardWithName:@"JGJCreatTeam" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJUnhandleSourceListVC"];
    sourceListVC.synProFirstModel = popView.synProFirstModel;
    sourceListVC.teamMemberModel = popView.commonModel.teamModelModel;
    sourceListVC.skipVC = self;
    sourceListVC.delegate = self;
    sourceListVC.sourceTeamType = JGJExistSourceTeamType;
    [self.navigationController pushViewController:sourceListVC animated:YES];
}

- (void)teamDetailCommonPopViewCancelButtonPressed:(JGJTeamDetailCommonPopView *)popView {
    [self loadGetGroupInfo];
}

#pragma mark - 点击数据来源人姓名跳转到个人聊页面
- (void)teamDetailCommonPopViewWithpopView:(JGJTeamDetailCommonPopView *)popView didSelectedMember:(JGJSynBillingModel *)memberModel {
    if ([memberModel.is_active isEqualToString:@"0"]) {
        [TYShowMessage showPlaint:@"TA还没注册，没有更多资料了"];
        return;
    }
    [self handleDidSelectedMemberWithMemberModel:memberModel];
}

#pragma mark - JGJUnhandleSourceListVCDelegate
- (void)JGJUnhandleSourceListVcConfirmButtonPressed:(JGJUnhandleSourceListVC *)sourceListVC {
    JGJGroupMembersRequestModel *membersModel = [[JGJGroupMembersRequestModel alloc] init];
    membersModel.real_name = sourceListVC.teamMemberModel.real_name;
    membersModel.telephone = sourceListVC.teamMemberModel.telephone;
    membersModel.uid = sourceListVC.teamMemberModel.uid;
    membersModel.is_demand = sourceListVC.teamMemberModel.is_demand;
    self.addGroupMemberRequestModel.source_members = @[membersModel];
    self.addGroupMemberRequestModel.source_pro_id = sourceListVC.teamMemberModel.source_pro_id;

    NSMutableDictionary *parameters = [self.addGroupMemberRequestModel mj_keyValuesWithIgnoredKeys:@[@"source_members"]];
    
    NSString *source_members = [[JGJGroupMembersRequestModel mj_keyValuesArrayWithObjectArray:self.addGroupMemberRequestModel.source_members] mj_JSONString];
    
    if (![NSString isEmpty:source_members]) {
        
        parameters[@"source_members"] = source_members;
    }
    
    [JLGHttpRequest_AFN PostWithNapi:JGJGroupAddSourceMemberURL parameters:parameters success:^(id responseObject) {
        
        [self.navigationController popToViewController:sourceListVC.skipVC animated:YES];
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - 升级按钮按下
- (void)handleUpgradeActionWithCell:(JGJTeamMemberCell *)teamMemberCell {
    
    TYLog(@"升级按钮按下");
    JGJTeamServiceModel *serviceModel = [JGJTeamServiceModel new];
    
    serviceModel.buy_type = @"2";
    
    [self handleOrderVcWithBuyGoodType:VIPServiceType serviceModel:serviceModel];
    
}

#pragma mark - 关闭项目组
- (void)handleShutTeam {
    
    NSDictionary *parameters = @{
                                 @"class_type" : self.workProListModel.class_type?:@"",
                                 
                                 @"group_id" : self.workProListModel.group_id?:@""
                                 
                                 };
    
    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
    
    desModel.popDetail = @"1. 该项目组的所有项目数据自动归档；\n2. 已归档的项目数据只能被查看；\n3. 已关闭项目可在项目列表中重新打开。";
    
    desModel.title = @"关闭项目提醒";
    
    desModel.titleLableTop = 25;
    
    desModel.popTextAlignment = NSTextAlignmentLeft;
    
    desModel.contentViewHeight = 230;
    
    desModel.messageBottom = 20;
    
    desModel.lineSapcing = 3;
    
    desModel.messageFont = [UIFont systemFontOfSize:AppFont30Size];
    
    desModel.titleFont = [UIFont boldSystemFontOfSize:AppFont32Size];
    
    __weak typeof(self) weakSelf = self;
    
    JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
    
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

#pragma mark - 退出项目组
- (void)handleLogoutTeam {
    NSDictionary *parameters = @{@"class_type" : self.workProListModel.class_type?:@"",
                                 
                                 @"group_id" : self.workProListModel.group_id?:@""
                                 };
    
    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
    
    desModel.popDetail = @"确认退出项目组吗？";
    
    desModel.leftTilte = @"取消";
    
    desModel.rightTilte = @"确定";
    
    desModel.lineSapcing = 5.0;
    
    JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
    
    alertView.messageLable.textAlignment = NSTextAlignmentCenter;
    
    __weak typeof(self) weakSelf = self;
    
    alertView.onOkBlock = ^{
        
        [TYLoadingHub showLoadingWithMessage:nil];
        
        [JLGHttpRequest_AFN PostWithNapi:JGJQuitMembersURL parameters:parameters success:^(id responseObject) {
            
            [TYLoadingHub hideLoadingView];
            
            //删除数据
            [self delGroupListWithProListModel:self.workProListModel];
            
            [TYShowMessage showSuccess:@"退出成功"];
            
            [weakSelf popHomeVc];
            
        } failure:^(NSError *error) {
            
            [TYShowMessage showHUDOnly:@"网络错误"];
            
            [TYLoadingHub hideLoadingView];
            
        }];
    };
}

#pragma mark - 数据来源人关闭同步
- (void)handleShutSynPro {
    NSDictionary *parameters = @{@"class_type" :  self.workProListModel.class_type?:@"team",
                                 
                                 @"group_id" : self.workProListModel.group_id?:@""
                                 };
    CustomAlertView *alertView = [CustomAlertView showWithMessage:@"关闭同步同时也会退出此项目,确认关闭同步吗？" leftButtonTitle:@"取消" midButtonTitle:nil rightButtonTitle:@"确定"];
    __weak typeof(self) weakSelf = self;
    alertView.onOkBlock = ^{
        
        [JLGHttpRequest_AFN PostWithNapi:JGJGroupCloseSyncURL parameters:parameters success:^(id responseObject) {
            
            [weakSelf popHomeVc];
            
        } failure:^(NSError *error) {
            
        }];
    };

}

#pragma mark - 加载班组详情信息
- (void)loadGetGroupInfo {
    
    NSDictionary *parameters = @{
                                 @"group_id" : self.workProListModel.group_id?:@"",
                                 @"pro_id" : self.workProListModel.pro_id ?:@"",//项目的pro_id
                                 @"class_type" : self.workProListModel.class_type
                                 };
    
    [JLGHttpRequest_AFN PostWithNapi:@"group/get-group-info" parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        JGJTeamInfoModel *teamInfoModel = [JGJTeamInfoModel mj_objectWithKeyValues:responseObject];
        
        self.teamInfo = teamInfoModel;
        
        //成功后返回
        if (self.uploadSuccessPopVcBlock) {
            
            self.uploadSuccessPopVcBlock();
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
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

#pragma mark - 修改数据库我在本组的名字
- (void)handleModifCurGroupName {
    
    JGJChatListAllVc *chatAllVc = nil;
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:[JGJChatRootVc class]]) {
            
            JGJChatRootVc *chatRootVc = (JGJChatRootVc *)vc;
            
            JGJChatRootChildVcModel *rootChildVcModel = (JGJChatRootChildVcModel *)chatRootVc.childVcs[0];
            
            chatAllVc = (JGJChatListAllVc *)rootChildVcModel.vc;
        }
    }
    
    JGJChatMsgListModel *msgModel = [JGJChatMsgListModel new];
    
    JGJCreatTeamModel *teamModel = self.mineInfos[0];
    
    msgModel.user_name = teamModel.detailTitle;
    
    msgModel.real_name = teamModel.detailTitle;
    
    msgModel.uid = [TYUserDefaults objectForKey:JLGUserUid];
    
    msgModel.group_id = self.workProListModel.group_id;
    
    msgModel.class_type = self.workProListModel.class_type;
    
    [JGJChatListTool handleModifyTempDataArry:chatAllVc.dataSourceArray modifyChatModel:msgModel];
}

#pragma mark - 根据条件类型返回添加和删除模型
- (NSMutableArray *)accordTypeGetMangerModels:(JGJTeamMemberCommonModel *)commonModel {
    if (commonModel.memberType == JGJProMemberType) { //项目成员自己计算，手来源人后台返回。只统计同步了的数据来源人
        commonModel.count = commonModel.teamMemberModels.count;
    }
    NSMutableArray *dataSource = [NSMutableArray array];
    if (self.workProListModel.isClosedTeamVc == YES) {
        return dataSource;
    }
    NSArray *picNames = @[@"menber_add_icon", @"member_ minus_icon"];
    NSArray *titles = @[@"添加", @"删除"];
    NSInteger count = 0;
    switch (self.workProListModel.teamMangerVcType) {
        case JGJSourceMemberType:
        case JGJProInfoType: {
            count = 1;
        }
            break;
        case JGJNormalProMangerAndSourceMemberType:
        case JGJNormalProMangerType:
        case JGJProMangerType: {
            count = commonModel.teamMemberModels.count == 0 ? 1 : 2;
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

#pragma mark - 初始化添加班组成员网络请求模型
- (JGJAddGroupMemberRequestModel *)addGroupMemberRequestModel {
    
    if (!_addGroupMemberRequestModel) {
        _addGroupMemberRequestModel = [[JGJAddGroupMemberRequestModel alloc] init];
        _addGroupMemberRequestModel.ctrl = @"team";
        _addGroupMemberRequestModel.is_qr_code = self.memberCommonModel.memberType == JGJProMemberType ? @"0" : nil;
        
        _addGroupMemberRequestModel.group_id = self.workProListModel.group_id;
        
        
        _addGroupMemberRequestModel.class_type = self.workProListModel.class_type?:@"team";
    }

    _addGroupMemberRequestModel.action = self.memberCommonModel.memberType == JGJProMemberType ? @"addMembers" : @"addSourceMember";
    return _addGroupMemberRequestModel;
}

#pragma mark - 初始化修改班组信息模型 这里传入id
- (JGJModifyTeamInfoRequestModel *)modifyTeamInfoRequestModel {
    
    if (!_modifyTeamInfoRequestModel) {
        _modifyTeamInfoRequestModel = [[JGJModifyTeamInfoRequestModel alloc] init];

        _modifyTeamInfoRequestModel.group_id = self.workProListModel.team_id;
        
        _modifyTeamInfoRequestModel.class_type = self.workProListModel.class_type;
    }
    return _modifyTeamInfoRequestModel;
}

- (JGJRemoveGroupMemberRequestModel *)removeGroupMemberRequestModel {
    
    if (!_removeGroupMemberRequestModel) {
        _removeGroupMemberRequestModel = [[JGJRemoveGroupMemberRequestModel alloc] init];
        _removeGroupMemberRequestModel.ctrl = @"team";
        _removeGroupMemberRequestModel.group_id = self.workProListModel.team_id;
    }
    _removeGroupMemberRequestModel.action = self.memberCommonModel.memberType == JGJProMemberType ? @"delMembers" : @"delSourceMember";
    
    _removeGroupMemberRequestModel.class_type = self.workProListModel.class_type;
    
    return _removeGroupMemberRequestModel;
}

- (JGJTeamGroupInfoDetailRequest *)infoDetailRequest {
    
    if (!_infoDetailRequest) {
        _infoDetailRequest = [[JGJTeamGroupInfoDetailRequest alloc] init];
        _infoDetailRequest.pro_id = self.workProListModel.pro_id;
        _infoDetailRequest.team_id = self.workProListModel.team_id;
        _infoDetailRequest.ctrl = @"team";
        _infoDetailRequest.action = @"getTeamInfo";
    }
    return _infoDetailRequest;
}

- (JGJTeamMemberCommonModel *)memberCommonModel {
    if (!_memberCommonModel) {
        _memberCommonModel = [[JGJTeamMemberCommonModel alloc] init];
    }
    return _memberCommonModel;
}
#pragma mark - 设置导航栏
- (void)setNavBar {
    [self navigationleftItem];
}

- (void)navigationleftItem {
    SEL selector = NSSelectorFromString(@"getLeftNoTargetButton");
    IMP imp = [self.navigationController methodForSelector:selector];
    UIButton *(*func)(id, SEL) = (void *)imp;
    if (func) {
        UIButton *whiteLeftNoTargetButton = func(self.navigationController, selector);
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:whiteLeftNoTargetButton];
        [whiteLeftNoTargetButton addTarget:self action:@selector(popCurentVC:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)popCurentVC:(UIButton *)sender {
    
    for (UIViewController *chatvc in self.navigationController.viewControllers) {
        
        if ([chatvc isKindOfClass:NSClassFromString(@"JGJChatRootVc")]) {
            
            JGJCreatTeamModel *teamModel = self.creatTeamModels[0];
            
            if (![NSString isEmpty:teamModel.detailTitle]) {
                
                self.workProListModel.team_name = teamModel.detailTitle; //传入修改的名字
                
                self.workProListModel.group_name = nil; //模型getter方法判断，这里保证唯一
                
                [chatvc setValue:self.workProListModel forKey:@"workProListModel"];
            }
            
            break;
        }
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshIndexPathSection:(NSUInteger )section indexPathrow:(NSUInteger)row {
    
    [self.tableView reloadData];
}

#pragma mark - 提示
- (void)exampleProSingleTap:(UITapGestureRecognizer *)sender{
    if(self.workProListModel.workCircleProType == WorkCircleExampleProType){
        [TYShowMessage showPlaint:@"这些都是示范数据，无法操作，谢谢"];
    }
}

#pragma mark - 项目关闭提示语
- (void)closeProTips {
    
    if(self.workProListModel.isClosedTeamVc){
        [TYShowMessage showPlaint:@"项目已关闭无法点击"];
    }
    
}
#pragma mark -点击班组成员是我们平台注册人员进入资料页
- (void)handleDidSelectedMemberWithMemberModel:(JGJSynBillingModel *)memberModel {
    if(self.workProListModel.isClosedTeamVc){
        return;
    }
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


- (void)handleActionSheetViewWithButtonIndex:(NSInteger)buttonIndex{
    
    switch (self.workProListModel.teamMangerVcType) {
            
            //普通成员退出和取消
        case JGJNormalProMangerType:
        case JGJProInfoType: {
            
            [self handleNormalMemberActionSheetWithButtonIndex:buttonIndex];
        }
            break;
            
            //管理人员和关闭、删除、取消
        case JGJProMangerType: {
            
            [self handleMangerMemberActionSheetWithButtonIndex:buttonIndex];
        }
            break;
            
            //数据来源人也是退出和取消
        case JGJNormalProMangerAndSourceMemberType:
        case JGJSourceMemberType: {
            //关闭同步
            
            [self handleLogoutTeam];
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
    
    TYWeakSelf(self);
    
    //重新开启、关闭项目
    if (self.workProListModel.isClosedTeamVc) {
        
        if (buttonIndex == 0) {
            
            [self reopenGroup:self.workProListModel];
            
        }else if (buttonIndex == 1) {  //彻底删除
            
            TYWeakSelf(self);
            CustomAlertView *alertView = [CustomAlertView showWithMessage:@"注意：删除项目，同时将删除与本项目相关的所有数据，项目删除后将不能找回，请谨慎操作。你确定要删除吗？" leftButtonTitle:@"取消" midButtonTitle:nil rightButtonTitle:@"确定"];
            
            alertView.onOkBlock = ^{
                
                [weakself delGroup:weakself.workProListModel];
            };
        }
        
    }else {
        
        
        if (buttonIndex == 0) {
            
            [self handleShutTeam];
            
        }else if (buttonIndex == 1) {
            
            CustomAlertView *alertView = [CustomAlertView showWithMessage:@"注意：删除项目组，同时将删除与本项目组相关的所有数据，项目组删除后不能找回，请谨慎操作。你确定要删除吗？" leftButtonTitle:@"取消" midButtonTitle:nil rightButtonTitle:@"确定"];
            
            alertView.onOkBlock = ^{
                
                [weakself delCloseGroup:weakself.workProListModel];
            };
        }
        
        
    }
    
}

#pragma mark - 重新打开已关闭的班组、项目组
- (void)reopenGroup:(JGJMyWorkCircleProListModel *)groupModel {
    
    NSDictionary *parameters = @{
                                 @"class_type" : groupModel.class_type?:@""@"team",
                                 
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
        
        [self popHomeVc];
        
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
        
        //删除班组
        [self delGroupListWithProListModel:self.workProListModel];
        [TYShowMessage showSuccess:@"删除成功"];
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
}

- (void)popHomeVc {
    
    JGJTabBarViewController *vc = (JGJTabBarViewController *)self.navigationController.parentViewController;
    
    if ([vc isKindOfClass:[JGJTabBarViewController class]]) {
        
        vc.selectedIndex = 0;
        
    }
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark - 处理对应点的弹框

- (BOOL)showPopView {
    
    JGJGroupMangerTool *mangerTool = [[JGJGroupMangerTool alloc] init];
    
    __weak typeof(self) weakSelf = self;
    mangerTool.groupMangerToolBlock = ^(id response) {
        
        [weakSelf loadGetGroupInfo];
    };
    
    self.teamInfo.cur_member_num = self.teamInfo.members_num.integerValue;
    
    self.workProListModel.is_senior_expire = self.teamInfo.team_info.is_senior_expire;
    
    //    self.workProListModel.is_cloud_expire = self.teamInfo.team_info.is_cloud_expire;
    
    self.workProListModel.is_degrade = self.teamInfo.team_info.is_degrade;
    
    mangerTool.workProListModel = self.workProListModel;
    
    mangerTool.teamInfo = self.teamInfo;
    
    mangerTool.targetVc = self.navigationController;
    
    return mangerTool.isPopView;
}

#pragma mark - 进入购买页面
- (void)handleOrderVcWithBuyGoodType:(BuyGoodType)buyGoodType serviceModel:(JGJTeamServiceModel *)serviceModel {
    
    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
    
    BOOL is_empty_service = [NSString isEmpty:self.teamInfo.online_service.uid];
    
    if ([NSString isEmpty:serviceModel.server_type_tip]) {
        
        desModel.popDetail = @"如需升级人数，请点击[申请]客服将尽快与你联系。";
        
        self.serviceOverTimeRequest.server_type = @"2";
        
        if (is_empty_service) {
            
            desModel.popDetail = @"";
        }
        
    }else {
        
        desModel.popDetail = serviceModel.server_type_tip;
        
        self.serviceOverTimeRequest.server_type = serviceModel.server_type;
    }
    
    desModel.leftTilte = @"我知道了";
    desModel.rightTilte = @"申请";
    desModel.lineSapcing = 5.0;
    
    desModel.isShowOnlineChatButton = YES;
    
    desModel.onlineChatButtonH = 58.0;
    
    desModel.messageBottom = 46.0;
    
    desModel.isShowTitle = [serviceModel.buy_type isEqualToString:@"1"] || [serviceModel.buy_type isEqualToString:@"2"];
    
    desModel.popTextAlignment = NSTextAlignmentLeft;
    
    JGJCusSeniorPopView *alertView = [JGJCusSeniorPopView showWithMessage:desModel];
    
    __weak typeof(self) weakSelf = self;
    alertView.onOkBlock = ^{
        
        [JGJServiceOverTimeRequest serviceOverTimeRequest:weakSelf.serviceOverTimeRequest requestBlock:^(id response) {
            
            
        }];
    };
    
    alertView.onlineChatButtonBlock = ^{
        
        if (!is_empty_service) {
            
            [weakSelf onlineChat];
        }
    };
    
    //了解黄金服务版
    alertView.seniorServiceInfoBlock = ^{
        
        NSString *webUrl = [NSString stringWithFormat:@"%@help/hpDetail?id=%@", JGJWebDiscoverURL,@"176"];
        
        JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:webUrl];
        
        [weakSelf.navigationController pushViewController:webVc animated:YES];
    };
    
    
    //    JGJSureOrderListViewController *SureOrderListVC = [[UIStoryboard storyboardWithName:@"JGJSureOrderListViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJSureOrderListVC"];
    //
    //    SureOrderListVC.GoodsType = buyGoodType;
    //
    //    JGJOrderListModel *orderListModel = [JGJOrderListModel new];
    //
    //    orderListModel.group_id = self.workProListModel.group_id;
    //
    //    orderListModel.class_type = self.workProListModel.class_type;
    //    orderListModel.upgrade = YES;
    //    SureOrderListVC.orderListModel = orderListModel;
    //
    //    [self.navigationController pushViewController:SureOrderListVC animated:YES];
    
}

//永久删除和退出
- (void)delGroupListWithProListModel:(JGJMyWorkCircleProListModel *)proListModel {
    
    // 删除聊聊列表数据
    JGJChatGroupListModel *groupModel = [JGJChatGroupListModel new];
    
    groupModel.class_type = proListModel.class_type;
    
    groupModel.group_id = proListModel.group_id;
    
    [JGJChatMsgDBManger deleteChatGroupListDataWithModel:groupModel];
    
    [JGJChatGetOffLineMsgInfo http_getChatIndexList];
}

- (JGJServiceOverTimeRequest *)serviceOverTimeRequest {
    
    if (!_serviceOverTimeRequest) {
        
        _serviceOverTimeRequest = [JGJServiceOverTimeRequest new];
        
        _serviceOverTimeRequest.group_id = self.workProListModel.group_id;
        
        _serviceOverTimeRequest.class_type = self.workProListModel.class_type;
        
    }
    
    return _serviceOverTimeRequest;
}

- (UIView *)contentTopView {
    
    if (!_contentTopView) {
        
        CGFloat contentTopViewH = 45;
        
        _contentTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 45)];
        
        _contentTopView.backgroundColor = AppFontFEF1E1Color;
        
        [self.view addSubview:_contentTopView];
        
        UIButton *tryBtn = [UIButton new];
        
        [_contentTopView addSubview:tryBtn];
        
        [tryBtn setTitleColor:AppFontF18215Color forState:UIControlStateNormal];
        
        CGFloat tryBtnW = 71;
        
        tryBtn.frame = CGRectMake(TYGetUIScreenWidth - tryBtnW - 12, (contentTopViewH - 28) / 2.0, tryBtnW, 28);
        
        [tryBtn.layer setLayerBorderWithColor:AppFontF18215Color width:0.5 radius:2.5];
        
        [tryBtn addTarget:self action:@selector(tryBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        [tryBtn setTitle:@"立即体验" forState:UIControlStateNormal];
        
        tryBtn.titleLabel.font = [UIFont systemFontOfSize:AppFont26Size];
        
        UILabel *contentLable = [UILabel new];
        
        contentLable.text = @"恭喜你获得30天黄金服务版免费体验权";
        
        //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTaptopView)];
        //
        //        tap.numberOfTapsRequired = 1;
        //
        //        [contentLable addGestureRecognizer:tap];
        
        contentLable.frame = CGRectMake(10, 12.5, TYGetUIScreenWidth - 100, 20);
        
        [_contentTopView addSubview:contentLable];
        
        contentLable.font = [UIFont systemFontOfSize:AppFont26Size];
        
        if (TYIS_IPHONE_5) {
            
            contentLable.font = [UIFont systemFontOfSize:12.5];
        }
        
        contentLable.textColor = AppFontF18215Color;
        
    }
    
    return _contentTopView;
}

#pragma mark - 试用按钮按下
- (void)tryBtnAction {
    
    if (self.workProListModel.isClosedTeamVc) {
        
        [self closeProTips];
        
        return;
    }
    
    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
    desModel.popDetail = @"恭喜你获得30天黄金服务版免费体验权";
    desModel.leftTilte = @"取消";
    desModel.rightTilte = @"确认升级版本";
    desModel.lineSapcing = 5.0;
    JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
    alertView.messageLable.textAlignment = NSTextAlignmentLeft;
    __weak typeof(self) weakSelf = self;
    alertView.onOkBlock = ^{
        
        [weakSelf trySeniorVersionRequest];
    };
}

#pragma mark - 试用黄金服务版请求
- (void)trySeniorVersionRequest {
    
    NSDictionary *parameters = @{@"class_type" : self.workProListModel.class_type?:@"team",
                                 @"group_id" : self.workProListModel.group_id?:@""
                                 };
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/order/donateSeniorCloud" parameters:parameters success:^(id responseObject) {
        
        [TYShowMessage showSuccess:@"升级成功"];
        
        [self loadGetGroupInfo];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)delCloseGroup:(JGJMyWorkCircleProListModel *)groupModel {
    
    NSDictionary *parameters = @{
                                 @"class_type" : groupModel.class_type?:@"",
                                 
                                 @"group_id" :groupModel.group_id?:@"",
                                 
                                 };
    
    [JLGHttpRequest_AFN PostWithNapi:@"group/del-group" parameters:parameters success:^(id responseObject) {
        
        //删除班组
        [self delGroupListWithProListModel:self.workProListModel];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        [TYShowMessage showSuccess:@"删除成功"];
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
}

#pragma mark - 处理在线聊天
- (void)onlineChat {
    
    JGJChatRootVc *chatRootVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatRootCommonVc"];
    
    JGJMyWorkCircleProListModel *workProListModel = [JGJMyWorkCircleProListModel new];
    
    workProListModel.class_type = @"singleChat";
    
    workProListModel.team_id = self.teamInfo.online_service.uid?:@""; //个人uid
    
    workProListModel.group_id = self.teamInfo.online_service.uid?:@""; //个人uid
    
    workProListModel.team_name = self.teamInfo.online_service.real_name;
    
    workProListModel.group_name = self.teamInfo.online_service.real_name;
    
    chatRootVc.workProListModel = workProListModel;
    
    [self.navigationController pushViewController:chatRootVc animated:YES];
}

- (JGJTabHeaderAvatarView *)avatarheaderView {
    
    if (!_avatarheaderView) {
        
        _avatarheaderView = [[JGJTabHeaderAvatarView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, [JGJTabHeaderAvatarView headerHeight])];
        
        _avatarheaderView.delegate = self;
    }
    
    return _avatarheaderView;
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

@end

