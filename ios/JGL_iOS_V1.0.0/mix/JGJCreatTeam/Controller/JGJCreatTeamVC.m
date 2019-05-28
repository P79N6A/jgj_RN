
//
//  JGJCreatTeamVC.m
//  mix
//
//  Created by yj on 16/8/22.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJCreatTeamVC.h"
#import "JGJCreatTeamCell.h"
#import "JGJTeamMemberCell.h"
#import "YZGOnlyAddProjectViewController.h"
#import "JGJSelectedCurrentCityVC.h"
#import "NSString+Extend.h"
#import "TYShowMessage.h"
#import "JGJChatRootVc.h"
#import "JGJAddTeamMemberVC.h"
#import "JGJCreatTeamSelectedProVC.h"
#import "JGJChatRootVc.h"
#import "JGJNewNotifyTool.h"
#import "TYFMDB.h"

#import "JGJMemberSelTypeVc.h"

#import "JLGAppDelegate.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>

#import <BaiduMapAPI_Location/BMKLocationComponent.h>

#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "JGJChatMsgDBManger+JGJGroupDB.h"
#import "JGJChatMsgDBManger+JGJIndexDB.h"

#import "JGJNewMarkBillChoiceProjectViewController.h"

#import "JGJMyChatGroupsVc.h"

#define JGJCreatGroupNames @"示例: 华侨城木工班组"

typedef void(^HanldeCreatProBlock)(NSArray *);
@interface JGJCreatTeamVC () <
    UITableViewDelegate,
    UITableViewDataSource,
    YZGOnlyAddProjectViewControllerDelegate,
    JGJSelectedCurrentCityVCDelegate,
    JGJTeamMemberCellDelegate,
    JGJAddTeamMemberDelegate,
    JGJNewMarkBillChoiceProjectViewControllerDelgate
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *creatTeamModels;//创建班组模型数组
@property (nonatomic, strong) NSMutableArray *teamMemberModels;//存储班组成员模型数组
@property (nonatomic, assign) CGFloat collectionViewHeight;//班组成员高度
@property (nonatomic, strong) NSMutableArray *commonModels;//存储班组成员顶部数据
@property (nonatomic, strong) JGJCreatTeamRequest *creatTeamRequest;
@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;
@property (nonatomic, strong) JLGCityModel *cityModel;//显示当前选择的所在城市
@property (nonatomic, strong) NSMutableArray *groupMembersInfos;//存储上传班组成员模型数组
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (nonatomic, copy) HanldeCreatProBlock hanldeCreatProBlock;

//是否有项目

@property (nonatomic, strong) NSArray *proLists;

@end


@implementation JGJCreatTeamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commonSet];
    
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 1 ? 2 : 1;;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    JGJCreatTeamCell *teamCell = [JGJCreatTeamCell cellWithTableView:tableView];
    switch (indexPath.section) {
        case CreatTeamCellBloneProType: {
            teamCell.creatTeamModel = self.creatTeamModels[0];
            teamCell.lineView.hidden = YES;
            cell = teamCell;
        }
            break;
        case CreatTeamCellTeamInfoType: {
            teamCell.creatTeamModel = self.creatTeamModels[indexPath.row + 1];
            teamCell.lineView.hidden = indexPath.row == 1;
            cell = teamCell;
        }
            break;
        case CreatTeamCellTeamsType: {
            JGJTeamMemberCell *teamMemberCell  = [JGJTeamMemberCell cellWithTableView:tableView];
            teamMemberCell.delegate = self;
            teamMemberCell.memberFlagType = ShowAddTeamMemberFlagType;
            JGJTeamMemberCommonModel *commonModel = self.commonModels[0];
            
            teamMemberCell.commonModel = commonModel; //班组成员个数 和类型
            commonModel.teamMemberModels = self.teamMemberModels;
            commonModel.count = (self.teamMemberModels.count == 1 ? 0 : self.teamMemberModels.count - 1); //减去一个是去掉加号模型
            teamMemberCell.teamMemberModels = self.teamMemberModels;
            cell = teamMemberCell;
        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0;
    if (indexPath.section == CreatTeamCellTeamsType) {
        height = [self calculateCollectiveViewHeight:self.teamMemberModels];
    } else {
        height = 50.0;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.0;
    switch (section) {
        case CreatTeamCellBloneProType: {
            height = CGFLOAT_MIN;
        }
            break;
        case CreatTeamCellTeamInfoType:
        case CreatTeamCellTeamsType: {
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
    headerView.backgroundColor = AppFontf1f1f1Color;
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case CreatTeamCellBloneProType: {
            
            __weak typeof(self) weakSelf = self;
            
            [self loadGroupProListNetData];
            
            self.hanldeCreatProBlock = ^(NSArray *proList){
                
                if (proList.count > 0) {
                    
                    [weakSelf selProList];
                    
                }else {
                    
                    [weakSelf handleCreatPro];
                }
                
            };
            
        }
            break;
        case CreatTeamCellTeamInfoType: {
            if (indexPath.row == 0) {
                [self handleEditTeamName];
            } else {
                [self handleSelelctedCurrentCity];
            }
        }
            break;
        case CreatTeamCellTeamsType: {
        }
            break;
        default:
            break;
    }
}

#pragma mark - 确定创建按钮按下
- (IBAction)handleConfirmButtonPressed:(UIButton *)sender {
    [self upLoadCreatTeamInfo]; //上传班组信息
}

#pragma mark - privateMethod
#pragma mark - 所在项目

- (void)handleSelectedPro:(NSMutableArray *)proLists {
    JGJCreatTeamSelectedProVC *selectedProVC = [[UIStoryboard storyboardWithName:@"JGJCreatTeam" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJCreatTeamSelectedProVC"];
    
    selectedProVC.proLists = proLists;
    
    [self.navigationController pushViewController:selectedProVC animated:YES];
    
}

- (void)selProList {
    
    JGJNewMarkBillChoiceProjectViewController *projectVC = [[JGJNewMarkBillChoiceProjectViewController alloc] init];
    
    JGJCreatTeamModel *teamModel = self.creatTeamModels[0];
    NSString *pid = [NSString stringWithFormat:@"%@",teamModel.detailTitlePid];
    if (![NSString isEmpty:pid]) {
        
        YZGGetBillModel *billModel = [YZGGetBillModel new];
        
        billModel.pid = [teamModel.detailTitlePid longLongValue];
        
        billModel.proname = teamModel.detailTitle;
        
        projectVC.billModel = billModel;
    }
    
    projectVC.projectListVCDelegate = self;
    
    [self.navigationController pushViewController:projectVC animated:YES];
}

#pragma mark - JGJNewMarkBillChoiceProjectViewControllerDelgate

- (void)deleteProjectWithProjectModel:(JGJNewMarkBillProjectModel *)projectModel {
    
    JGJCreatTeamModel *existTeamModel = self.creatTeamModels[0];
    
    NSString *pro_id = [NSString stringWithFormat:@"%@", projectModel.pro_id];
    
    NSString *detailTitlePid = [NSString stringWithFormat:@"%@", existTeamModel.detailTitlePid];
    
    if ([pro_id isEqualToString:detailTitlePid]) {
        
        existTeamModel.detailTitlePid = nil;
        
        existTeamModel.detailTitle = @"选择项目";
        
        existTeamModel.isShowGrayDetailTitle = YES;
        
    }
        
    [self.tableView reloadData];
}

- (void)selectedProjectWithProjectModel:(JGJNewMarkBillProjectModel *)projectModel {
    
    JGJProjectListModel *projectListModel = [JGJProjectListModel new];
    
    projectListModel.pro_id = projectModel.pro_id;
    
    projectListModel.pro_name = projectModel.pro_name;
    
    self.projectListModel = projectListModel;

}

-(void)loadGroupProListNetData{
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:@"group/group-pro-list" parameters:nil success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        NSArray *proLists = [JGJProjectListModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        self.proLists = proLists;
        
        if (self.hanldeCreatProBlock) {
            
            self.hanldeCreatProBlock(proLists);
            
        }
        
    } failure:^(NSError *error) {
       
         [TYLoadingHub hideLoadingView];
    }];
}

- (void)handleCreatPro {

    YZGOnlyAddProjectViewController *editTeamNameVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"onlyAddProject"];
    editTeamNameVc.isCreatTeamEditProName = YES;
    editTeamNameVc.title = @"新建项目";
    editTeamNameVc.proNameTFPlaceholder = @"请输入项目名称";
    [self.navigationController pushViewController:editTeamNameVc animated:YES];
    
}

#pragma mark - 班组名称
- (void)handleEditTeamName {
    YZGOnlyAddProjectViewController *editTeamNameVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"onlyAddProject"];
    editTeamNameVc.delegate = self;
    editTeamNameVc.isEditGroupName = YES;
    
    editTeamNameVc.title = @"班组名称";
    
    editTeamNameVc.proNameTFPlaceholder = @"请输入班组名称";
    
    if (self.creatTeamModels.count > 1) {
        
        JGJCreatTeamModel *teamModel = self.creatTeamModels[1];
        
        if (![NSString isEmpty:teamModel.detailTitle] && ![teamModel.detailTitle isEqualToString:JGJCreatGroupNames]) {
            
            editTeamNameVc.defaultProName = teamModel.detailTitle;
            
        }
    }
    
    [self.navigationController pushViewController:editTeamNameVc animated:YES];
}

#pragma mark - 所在城市
- (void)handleSelelctedCurrentCity {
    JGJSelectedCurrentCityVC *currentCityVC = [[JGJSelectedCurrentCityVC alloc] init];
    currentCityVC.delegate = self;
    currentCityVC.cityModel = self.cityModel;
    [self.navigationController pushViewController:currentCityVC animated:YES];
}

#pragma mark - YZGOnlyAddProjectViewControllerDelegate
- (void)handleYZGOnlyAddProjectViewControllerEditName:(NSString *)editName editType:(EditNameType)editType{
    JGJCreatTeamModel *teamModel = self.creatTeamModels[1];
    teamModel.isShowGrayDetailTitle = NO;
    teamModel.detailTitle = editName;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - JGJSelectedCurrentCityVCDelegate

- (void)handleJGJSelectedCurrentCityModel:(JLGCityModel *)cityModel {
    JGJCreatTeamModel *teamModel = self.creatTeamModels[2];
    teamModel.detailTitle = cityModel.provinceCityName;
    teamModel.detailTitlePid = cityModel.city_code;
    self.cityModel = cityModel;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

#pragma mark - JGJTeamMemberCellDelegate 进入通信录添加班组成员
- (void)handleJGJTeamMemberCellAddTeamMember:(JGJTeamMemberCell *)teamMemberCell {
        
    [self addMemberSelTypeVcCommonModel:teamMemberCell.commonModel];
    
}

#pragma mark - 添加成员 3.3.1添加
- (void)addMemberSelTypeVcCommonModel:(JGJTeamMemberCommonModel *)commonModel {
    
    JGJMemberSelTypeVc *selTypeVc = [JGJMemberSelTypeVc new];
    
    selTypeVc.commonModel = commonModel;
    
    selTypeVc.targetVc = self;
    
    selTypeVc.currentTeamMembers = self.teamMemberModels;
    
    //创建班组添加
    selTypeVc.contactedAddressBookVcType = JGJCreatGroupAddMemberType;
    
    [self.navigationController pushViewController:selTypeVc animated:YES];
    
}

#pragma mark - 通讯录添加
- (void)addressBookAddMemberWithCell:(JGJTeamMemberCell *)cell {
    
    JGJSynBillingCommonModel *synBillingCommonModel = [[JGJSynBillingCommonModel alloc] init];
    JGJAddTeamMemberVC *addTeamMemberVC = [[UIStoryboard storyboardWithName:@"JGJCreatTeam" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJAddTeamMemberVC"];
    synBillingCommonModel.synBillingTitle = @"添加班组成员";
    addTeamMemberVC.delegate = self;
    addTeamMemberVC.groupMemberMangeType = JGJGroupMemberMangeAddMemberType;
    addTeamMemberVC.synBillingCommonModel = synBillingCommonModel;
    cell.commonModel.memberType = JGJGroupMemberType;
    addTeamMemberVC.commonModel = cell.commonModel;
    addTeamMemberVC.currentTeamMembers = self.teamMemberModels;
    //    addTeamMemberVC.sortFindResult = self.sortFindResult;
    [self.navigationController pushViewController:addTeamMemberVC animated:YES];
}

#pragma mark - 单个移除成员
- (void)handleJGJTeamMemberCellRemoveIndividualTeamMember:(JGJSynBillingModel *)teamMemberModel {
    [self.teamMemberModels removeObject:teamMemberModel];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    if (![NSString isEmpty:teamMemberModel.telephone]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"telephone contains %@", teamMemberModel.telephone];
        JGJSynBillingModel *removeTeamModel = [self.groupMembersInfos filteredArrayUsingPredicate:predicate].lastObject;
        [self.groupMembersInfos removeObject:removeTeamModel];
        self.creatTeamRequest.group_members = self.groupMembersInfos;
    }
    
}

#pragma mark - JGJGroupMemberMangeDelegate返回添加的成员
- (void)handleJGJGroupMemberSelectedTeamMembers:(NSMutableArray *)teamsMembers groupMemberMangeType:(JGJGroupMemberMangeType)groupMemberMangeType {
    NSMutableArray *groupMembersInfos = [NSMutableArray array];
    for (JGJSynBillingModel *teamMemberModel in teamsMembers) { //添加返回的成员需要上传的信息
        JGJGroupMembersRequestModel *membersModel = [[JGJGroupMembersRequestModel alloc] init];
        membersModel.real_name = teamMemberModel.real_name;
        membersModel.telephone = teamMemberModel.telephone;
        membersModel.uid = teamMemberModel.uid;
        teamMemberModel.isSelected = NO; //返回时取消之前已选中状态
        [groupMembersInfos addObject:membersModel];
    }
    [self.groupMembersInfos addObjectsFromArray:groupMembersInfos];
    self.creatTeamRequest.group_members = self.groupMembersInfos; //添加成员信息
    for (JGJSynBillingModel *mangerMemberModel in self.teamMemberModels) { //删除添加图片模型
        if (mangerMemberModel.isMangerModel) {
            [self.teamMemberModels removeObject:mangerMemberModel];
        }
    }
    
    JGJTeamMemberCommonModel *commonModel = self.commonModels[0];
    commonModel.teamMemberModels = self.teamMemberModels;
    switch (groupMemberMangeType) {
        case JGJGroupMemberMangeAddMemberType: {
            NSArray *picNames = @[@"menber_add_icon"];
            NSArray *titles = @[@"添加"];
            for (int idx = 0; idx < picNames.count; idx ++) {
                JGJSynBillingModel *memberModel = [[JGJSynBillingModel alloc] init];
                if (idx == 0) {
                    memberModel.addHeadPic = picNames[0];
                    memberModel.isAddModel = YES;
                }
                memberModel.isMangerModel = YES;
                memberModel.name = titles[idx];
                [teamsMembers addObject:memberModel];
            }
            [self.teamMemberModels addObjectsFromArray:teamsMembers];
            [self calculateCollectiveViewHeight:self.teamMemberModels];//数据发生改变，重新计算高度
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }
            break;
        case JGJGroupMemberMangeRemoveMemberType: { //创建班组只有添加成员
            
        }
            break;
        default:
            break;
    }
    
//    //添加成功返回
//    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter
- (NSMutableArray *)creatTeamModels {
    NSArray *titles = @[@"所在项目", @"班组名称", @"所在城市"];
    NSString *cityName = [TYUserDefaults objectForKey:JLGCityName];
    NSString *cityNo = [TYUserDefaults objectForKey:JLGCityNo];
    NSString *parent_id = [TYFMDB searchItemByTableName:TYFMDBCityDataName ByKey:@"city_code" byValue:cityNo byColume:@"parent_id"];
    NSString *province_name = [TYFMDB searchItemByTableName:TYFMDBCityDataName ByKey:@"city_code" byValue:parent_id byColume:@"city_name"];
    NSString *provinceCityName = [NSString stringWithFormat:@"%@ %@", province_name, cityName];
    if (!self.cityModel) {
        self.cityModel = [[JLGCityModel alloc] init];
        self.cityModel.provinceCityName = provinceCityName;
        self.cityModel.city_code = cityNo;
        self.cityModel.city_name = cityName;
        provinceCityName = [NSString isEmpty:cityName] ? @"选择城市":provinceCityName;
    }
    NSArray *placeholders = @[@"选择项目", JGJCreatGroupNames, provinceCityName];
    if (!_creatTeamModels) {
        _creatTeamModels = [NSMutableArray array];
        for (int indx = 0; indx < 3; indx ++) {
            JGJCreatTeamModel *teamModel = [[JGJCreatTeamModel alloc] init];
            teamModel.title = titles[indx];
            teamModel.detailTitle = placeholders[indx];
            teamModel.isShowGrayDetailTitle = indx != 2;
            
            teamModel.placeholderTitle = indx == 1 ? placeholders[1] : @"";
            
            teamModel.detailTitlePid = @"";
            
            if (indx == 2) {
                
                teamModel.detailTitlePid = indx == 2 ? cityNo : @"";
                teamModel.detailTitle = indx == 2 && ![NSString isEmpty:cityName] ? provinceCityName : @"";
                
            }
            [_creatTeamModels addObject:teamModel];
            teamModel.isHiddenArrow = NO;
        }
    }
    
    if (_creatTeamModels.count > 1) {
        
        JGJCreatTeamModel *teamModel = _creatTeamModels[1];
        
        if ([NSString isEmpty:teamModel.detailTitle]) {
            
            teamModel.placeholderTitle = JGJCreatGroupNames;
            
        }
    }
    
    return _creatTeamModels;
}

- (void)setProjectListModel:(JGJProjectListModel *)projectListModel {
    _projectListModel = projectListModel;
    JGJCreatTeamModel *teamModel = self.creatTeamModels[0];
    teamModel.isShowGrayDetailTitle = NO;
    teamModel.detailTitle = _projectListModel.pro_name;
    teamModel.detailTitlePid = _projectListModel.pro_id;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];

    
}

- (void)setAccountProModel:(JGJProjectListModel *)accountProModel {
    
    _accountProModel = accountProModel;
    
    JGJCreatTeamModel *teamModel = self.creatTeamModels[0];
    
    teamModel.isShowGrayDetailTitle = NO;
    
    teamModel.detailTitle = accountProModel.pro_name;
    
    teamModel.detailTitlePid = accountProModel.pro_id;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.tableView beginUpdates];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView endUpdates];
    
}

#pragma mark - 网络参数
- (JGJCreatTeamRequest *)creatTeamRequest {

    if (!_creatTeamRequest) {
        
        _creatTeamRequest = [[JGJCreatTeamRequest alloc] init];

    }
    return _creatTeamRequest;
}

#pragma mark - 设置头部类型和是否显示删除按钮
- (NSMutableArray *)commonModels {
    if (!_commonModels) {
        _commonModels = [NSMutableArray array];
        NSArray *headerTitles = @[@"班组成员"];
        for (int indx = 0; indx < headerTitles.count; indx ++) {
            JGJTeamMemberCommonModel *commonModel = [[JGJTeamMemberCommonModel alloc] init];
            commonModel.isHiddenDeleteFlag = NO;
            commonModel.headerTitle = headerTitles[indx];
            commonModel.teamControllerType = JGJCreatTeamControllerType;
            [_commonModels addObject:commonModel];
        }
    }
    return _commonModels;
}

- (void)setTeamMemberModels:(NSMutableArray *)teamMemberModels {
    _teamMemberModels = teamMemberModels;
    [self calculateCollectiveViewHeight:_teamMemberModels];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

#pragma mark - 计算班组成员高度
- (CGFloat)calculateCollectiveViewHeight:(NSMutableArray *)dataSource {
    
    NSInteger lineCount = 0;
    
    NSUInteger teamMemberCount = dataSource.count;
    
    CGFloat padding = LineMargin;
    
    lineCount = ((teamMemberCount / MemberRowNum) + (teamMemberCount % MemberRowNum != 0 ? 1 : 0));
    
    CGFloat collectionViewHeight = lineCount * ItemHeight + HeaderHegiht + padding;
    
    self.collectionViewHeight = collectionViewHeight;
    
    return collectionViewHeight;
    
}

#pragma mark - 上传创建班组信息
- (void)upLoadCreatTeamInfo {
    for (int idx = 0; idx < self.creatTeamModels.count; idx ++) {
        JGJCreatTeamModel *teamInfoModel = [[JGJCreatTeamModel alloc] init];
        if (idx == 0) {
            teamInfoModel = self.creatTeamModels[0];
            
            self.creatTeamRequest.pro_id = [NSString stringWithFormat:@"%@", teamInfoModel.detailTitlePid?:@""];
            
            if ([NSString isEmpty:self.creatTeamRequest.pro_id]) {
                [TYShowMessage showPlaint:@"请选择所在项目"];
                return;
            }
            
        }else if (idx == 1) {
            teamInfoModel = self.creatTeamModels[1];
            self.creatTeamRequest.group_name = teamInfoModel.detailTitle;
            
            if ([teamInfoModel.placeholderTitle isEqualToString:teamInfoModel.detailTitle]) {
                [TYShowMessage showPlaint:@"请输入班组名称"];
                return;
            }
            
        }else {
            teamInfoModel = self.creatTeamModels[2];
            self.creatTeamRequest.city_code = teamInfoModel.detailTitlePid;
            
            if ([NSString isEmpty:self.creatTeamRequest.city_code]) {
                
                [TYShowMessage showPlaint:@"请选择所在城市"];
                
                return;
            }
        }
        if ([NSString isEmpty:teamInfoModel.detailTitle]) {
            
            NSString *error = [NSString stringWithFormat:@"请选择%@", teamInfoModel.title];
            
            [TYShowMessage showError:error];
            
            return;
        }
    }
    
    NSMutableDictionary *parameters = [self.creatTeamRequest mj_keyValuesWithIgnoredKeys:@[@"group_members"]];
    
    NSString *group_members = [[JGJGroupMembersRequestModel mj_keyValuesArrayWithObjectArray:self.creatTeamRequest.group_members] mj_JSONString];
    
    if (![NSString isEmpty:group_members]) {

        parameters[@"group_members"] = group_members;
    }
    
    __weak typeof(self) weakSelf = self;
    
     [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:@"group/create-group" parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        JGJMyWorkCircleProListModel *workProListModel = [JGJMyWorkCircleProListModel mj_objectWithKeyValues:responseObject];
        
        weakSelf.workProListModel = workProListModel;
        
        weakSelf.workProListModel.myself_group = @"1"; //自己创建
        
        weakSelf.workProListModel.members_num = [NSString stringWithFormat:@"%@", @(weakSelf.teamMemberModels.count)]; //加一个创建者
        
        [weakSelf upLoadTeamInfoSussessWithWorkProListModel:weakSelf.workProListModel];
        
        [weakSelf insertGroupDBWithWorkProListModel:weakSelf.workProListModel];
        
    } failure:^(NSError *error) {
       
        [TYLoadingHub hideLoadingView];
    }];
}

#pragma mark - 插入数据库
- (void)insertGroupDBWithWorkProListModel:(JGJMyWorkCircleProListModel *)workProListModel {
    
//    JGJChatGroupListModel *groupModel = [JGJChatGroupListModel mj_objectWithKeyValues:[workProListModel mj_JSONObject]];
//
//    groupModel.max_asked_msg_id = @"0";
//
//    groupModel.sys_msg_type = @"normal";
//
//    groupModel.creater_uid = [TYUserDefaults objectForKey:JLGUserUid];
//
//    groupModel.user_id = [TYUserDefaults objectForKey:JLGUserUid];
//
//    groupModel.local_head_pic = [workProListModel.members_head_pic mj_JSONString];
    
    JGJChatGroupListModel *groupModel = [[JGJChatGroupListModel alloc] init];
    groupModel.user_id = [TYUserDefaults objectForKey:JLGUserUid];
    groupModel.group_id = workProListModel.group_id;
    groupModel.pro_id = workProListModel.pro_id;
    groupModel.group_name = workProListModel.group_name;
    groupModel.class_type = workProListModel.class_type;
    groupModel.local_head_pic = [workProListModel.members_head_pic mj_JSONString];
    groupModel.members_num = workProListModel.members_num;
    groupModel.chat_unread_msg_count = workProListModel.unread_msg_count;
    groupModel.creater_uid = [TYUserDefaults objectForKey:JLGUserUid];
    groupModel.is_no_disturbed = workProListModel.is_no_disturbed;
    groupModel.is_top = workProListModel.is_sticked;
    groupModel.all_pro_name = workProListModel.all_pro_name;
    groupModel.can_at_all = workProListModel.can_at_all;
    groupModel.is_sticked = workProListModel.is_sticked;
    groupModel.is_closed = workProListModel.isClosedTeamVc;
    groupModel.max_asked_msg_id = @"0";
    groupModel.sys_msg_type = @"normal";

    [JGJChatMsgDBManger insertGroupDBWithGroupModel:groupModel isHomeVc:NO];
    
}

#pragma mark - 上传参数成功之后
- (void)upLoadTeamInfoSussessWithWorkProListModel:(JGJMyWorkCircleProListModel *)workProListModel {
    
    UIViewController *popVc;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[JGJMyChatGroupsVc class]]) {
            popVc = vc;
            break;
        }
    }
    
    if (self.isPopVc) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if ([self.popVc isKindOfClass:[UIViewController class]]) {
        
        [self.navigationController popToViewController:self.popVc animated:YES];
    } else if (popVc){
        [self.navigationController popToViewController:popVc animated:YES];
    }
    
    else {
        
        JGJMyChatGroupsVc *groupsVc = [[JGJMyChatGroupsVc alloc] init];
        
        [self.navigationController pushViewController:groupsVc animated:YES];
    }
    
    [TYShowMessage showSuccess:@"创建成功"];
}

#pragma mark - 加入成功回执服务器
- (void)handleUploadReadedNotify {
//    NSDictionary *parameters = @{
//                                 @"ctrl" : @"notice",
//                                 @"action": @"noticeReaded",
//                                 @"notice_id" : self.notifyModel.notice_id?:[NSNull null]
//                                 };
//    __weak typeof(self) weakSelf = self;
//    [JGJSocketRequest WebSocketWithParameters:parameters success:^(id responseObject) {
//        [weakSelf handleJoinTeamUpdateDataBase];
//    } failure:nil];
}

#pragma mark - 处理加入班组成功更新数据库
- (void)handleJoinTeamUpdateDataBase {
    self.notifyModel.isJoinTeam = YES;//同步成功设置为YES
    [JGJNewNotifyTool updateNotifyModel:self.notifyModel];
    UIViewController *notifyVC = self.navigationController.viewControllers[1];
    [self.navigationController popToViewController:notifyVC animated:YES];
}

#pragma mark - 聊天界面
- (void)handleChatActionWithWorkProListModel:(JGJMyWorkCircleProListModel *)workProListModel{
    JGJChatRootVc *chatRootVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatRootVc"];
    
    chatRootVc.workProListModel = workProListModel;
    
    if (self.isPopVc) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else {
        
        [self.navigationController pushViewController:chatRootVc animated:YES];
    }
    
}

- (void)commonSet {
    [self.confirmButton.layer setLayerCornerRadius:JGJCornerRadius];
    NSMutableArray *dataSource = [NSMutableArray array];
    JGJSynBillingModel *memberModel = [[JGJSynBillingModel alloc] init];
    memberModel.addHeadPic = @"menber_add_icon";
    memberModel.name = @"添加";
    memberModel.isAddModel = YES;
    memberModel.isMangerModel = YES;
    [dataSource addObject: memberModel];
    if (!self.teamMemberModels) {
        self.teamMemberModels = [NSMutableArray array];
    }
    [self.teamMemberModels addObjectsFromArray:dataSource];
    //新消息加入班组没有项目和有项目创建班组的情况, /*需求不定同步项目没有项目时创建班组。通知同步项目没有，过来创建项目*/
    if (self.projectListModel.proType == JGJProCreatTeamType || self.proType == JGJProCreatTeamType) {
        NSMutableArray *inviters = [NSMutableArray array];
        JGJSynBillingModel *teamMemberModel = [[JGJSynBillingModel alloc] init];
        teamMemberModel.telephone = self.notifyModel.telphone;
        teamMemberModel.real_name = self.notifyModel.user_name;
        if (self.notifyModel.members_head_pic.count == 1) {
             teamMemberModel.head_pic = [self.notifyModel.members_head_pic lastObject];
        }
        self.creatTeamRequest.bill_id = self.notifyModel.bill_id;
        self.creatTeamRequest.pro_id = self.projectListModel.pro_id;
        [inviters addObject:teamMemberModel];
        [self handleJGJGroupMemberSelectedTeamMembers:inviters groupMemberMangeType:JGJGroupMemberMangeAddMemberType];
    }
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
    self.confirmButton.backgroundColor = AppFontEB4E4EColor;
}

- (NSMutableArray *)groupMembersInfos {
    if (!_groupMembersInfos) {
        _groupMembersInfos = [NSMutableArray array];
    }
    return _groupMembersInfos;
}

@end
