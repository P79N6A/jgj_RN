//
//  JGJNewNotifyDetailVC.m
//  mix
//
//  Created by yj on 16/8/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJNewNotifyDetailVC.h"
#import "JGJNewNotifyDetailHeadCell.h"
#import "JGJCreatTeamCell.h"
#import "JGJJoinTeamDescribeCell.h"
#import "JLGPickerView.h"
#import "JGJCreatTeamVC.h"
#import "CustomAlertView.h"
#import "JGJNewNotifyTool.h"
#import "YZGOnlyAddProjectViewController.h"
typedef enum : NSUInteger {
    JGJNewNotifyDetailHeadCellType = 0,
    JGJNewNotifyDetailProCellType,
    JGJNewNotifyDetailProDesCellType
} JGJNewNotifyDetailCellType;

typedef void(^HandleLoadProListBlock)();

@interface JGJNewNotifyDetailVC () <
    UITableViewDelegate,
    UITableViewDataSource,
    JLGPickerViewDelegate,
    YZGOnlyAddProjectViewControllerDelegate
>
@property (nonatomic, strong) JLGPickerView *jlgPickerView;
@property (nonatomic, strong) NSMutableArray *proNameArray;//存储所属项目
@property (weak, nonatomic) IBOutlet UIButton *joinTeamButton;
@property (nonatomic, strong) NSMutableArray *proInfoModels;
@property (strong, nonatomic) JGJProjectListModel *projectListModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) JGJAddGroupMemberRequestModel *addGroupMemberRequestModel;

@property (copy, nonatomic) HandleLoadProListBlock handleLoadProListBlock;
@end

@implementation JGJNewNotifyDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonSet];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self loadProNetData:indexPath];
}

- (void)commonSet {
    [self.joinTeamButton.layer setLayerCornerRadius:5.0];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case JGJNewNotifyDetailHeadCellType: {
             JGJNewNotifyDetailHeadCell *detailHeadCell = [JGJNewNotifyDetailHeadCell cellWithTableView:tableView];
            detailHeadCell.notifyModel = self.notifyModel;
            cell = detailHeadCell;
        }
            break;
        case JGJNewNotifyDetailProCellType: {
            JGJCreatTeamCell *creatTeamCell = [JGJCreatTeamCell cellWithTableView:tableView];
            creatTeamCell.creatTeamModel = self.proInfoModels[0];
            cell = creatTeamCell;
        }
            break;
        case JGJNewNotifyDetailProDesCellType: {
            JGJJoinTeamDescribeCell *teamDescribeCell = [JGJJoinTeamDescribeCell cellWithTableView:tableView];
            cell = teamDescribeCell;
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
        case JGJNewNotifyDetailHeadCellType: {
            height = 192.0;
        }
            break;
        case JGJNewNotifyDetailProCellType: {
            height = 50.0;
        }
            break;
        case JGJNewNotifyDetailProDesCellType: {
            height = 40;
        }
        default:
            break;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = AppFontf0f2f5Color;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.0;
    switch (section) {
        case JGJNewNotifyDetailProDesCellType:
        case JGJNewNotifyDetailHeadCellType: {
            height = CGFLOAT_MIN;
        }
            break;
        case JGJNewNotifyDetailProCellType: {
            height = 10.0;
        }
            break;
        default:
            break;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == JGJNewNotifyDetailProCellType ) {
        if (self.proNameArray.count > 0) {
            [self showJLGPickerView:indexPath];
        }else {
            [self loadProNetData:indexPath];
            
            __weak typeof(self) weakSelf = self;
            
            self.handleLoadProListBlock = ^{
            
                CustomAlertView *alertView = [CustomAlertView showWithMessage:@"暂时没有项目,确定创建项目吗?" leftButtonTitle:@"取消" midButtonTitle:nil rightButtonTitle:@"确定"];
                alertView.onOkBlock = ^{
                    YZGOnlyAddProjectViewController *editTeamNameVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"onlyAddProject"];
                    editTeamNameVc.delegate = weakSelf;
                    editTeamNameVc.isEditGroupName = YES;
                    editTeamNameVc.title = @"新建项目名称";
                    editTeamNameVc.proNameTFPlaceholder = @"输入项目名称";
                    [weakSelf.navigationController pushViewController:editTeamNameVc animated:YES];
                };
                
            };
            
        }
    }
}

#pragma mark - 所在项目
- (void)showJLGPickerView:(NSIndexPath *)indexPath{
    [self.jlgPickerView.leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.jlgPickerView setAllSelectedComponents:nil];
    [self.jlgPickerView showPickerByIndexPath:indexPath dataArray:self.proNameArray title:@"所在项目" isMulti:NO];
    self.jlgPickerView.editButton.hidden = YES;
    self.jlgPickerView.isShowEditButton = NO;
}

-(void)loadProNetData:(NSIndexPath *)indexPath{
    if (self.proNameArray.count > 0) {
        return;
    }
//    NSDictionary *parameters = @{@"ctrl" : @"group",
//                                 @"action" : @"groupProList"
//                                 };
//    __weak typeof(self) weakSelf = self;
//    [JGJSocketRequest WebSocketWithParameters:parameters success:^(id responseObject) {
//        [weakSelf.proNameArray removeAllObjects];
//        [responseObject enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            BOOL isCreatTeam = [obj[@"is_create_group"] integerValue];
//            NSString *pro_name = [NSString stringWithFormat:@"%@%@",obj[@"pro_name"],isCreatTeam ? @"(已有班组)" :@""];
//            JGJProjectListModel *proModel = [JGJProjectListModel mj_objectWithKeyValues:obj];
//            NSDictionary *proDic = @{@"id":obj[@"pro_id"],@"name":pro_name,@"projectListModel":proModel};
//            [weakSelf.proNameArray addObject:proDic];
//
//        }];
//
//        NSArray *proLists = (NSArray *)responseObject;
//
//        if (weakSelf.handleLoadProListBlock && proLists.count == 0) {
//
//            weakSelf.handleLoadProListBlock();
//        }
//
//    } failure:nil];
    
    __weak typeof(self) weakSelf = self;
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:@"group/group-pro-list" parameters:nil success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        [weakSelf.proNameArray removeAllObjects];
        
        [responseObject enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BOOL isCreatTeam = [obj[@"is_create_group"] integerValue];
            NSString *pro_name = [NSString stringWithFormat:@"%@%@",obj[@"pro_name"],isCreatTeam ? @"(已有班组)" :@""];
            JGJProjectListModel *proModel = [JGJProjectListModel mj_objectWithKeyValues:obj];
            NSDictionary *proDic = @{@"id":obj[@"pro_id"],@"name":pro_name,@"projectListModel":proModel};
            [weakSelf.proNameArray addObject:proDic];
            
        }];
        
        NSArray *proLists = (NSArray *)responseObject;
        
        if (weakSelf.handleLoadProListBlock && proLists.count == 0) {
            
            weakSelf.handleLoadProListBlock();
        }
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
    
}

#pragma mark - JLGPickerViewDelegate 选中以后做判断已创建的班组加入，创建的加入
- (void)JLGPickerViewSelect:(NSArray *)finishArray {
    NSDictionary *proDic = finishArray[0];
//    self.projectListModel.pro_name = proDic[@"name"];
//    self.projectListModel.pro_id = proDic[@"id"];
//    self.projectListModel.is_create_group = proDic[@"is_create_group"];
    self.projectListModel = proDic[@"projectListModel"];
    self.projectListModel.proType = [self.projectListModel.is_create_group isEqualToString:@"0"] ? JGJProCreatTeamType: JGJProExistedType;
    self.projectListModel.isModifyPro = NO;
    JGJCreatTeamModel *creatTeamModel = self.proInfoModels[0];
    creatTeamModel.detailTitle = self.projectListModel.pro_name;
    creatTeamModel.detailTitlePid = self.projectListModel.pro_id;
    JGJNewNotifyProType proType = [self.projectListModel.is_create_group integerValue] + 1;
    self.projectListModel.proType = proType;
//    添加通知信息进入创建项目需要添加时间2016.10.17.21:41
    self.projectListModel.notifyModel = self.notifyModel;
    self.notifyModel.pro_id = self.projectListModel.pro_id; //通知存储项目id
    [self.tableView reloadData];
}

#pragma mark - 加入班组
- (void)handleJoinTeam {
    self.addGroupMemberRequestModel.group_id = self.projectListModel.group_id;//加入选择班组group_id，，创建选择项目pro_id
    JGJGroupMembersRequestModel  *groupMemberRequestModel = [[JGJGroupMembersRequestModel alloc] init];
    groupMemberRequestModel.real_name = self.notifyModel.user_name; //新通知传过来的姓名
    groupMemberRequestModel.telephone = self.notifyModel.telphone;
    self.addGroupMemberRequestModel.group_members = @[groupMemberRequestModel];
    NSDictionary *parameters = [self.addGroupMemberRequestModel mj_keyValues];
    __weak typeof(self) weakSelf = self;
    [JGJSocketRequest WebSocketWithParameters:parameters success:^(id responseObject) {
//        加入成功回执服务器
        [weakSelf handleUploadReadedNotify];
    } failure:^(NSError *error,id values) {
        [TYShowMessage showPlaint:@"加入失败"];
    }];
}

#pragma mark - 加入成功回执服务器
- (void)handleUploadReadedNotify {
    NSDictionary *parameters = @{
                                 @"ctrl" : @"notice",
                                 @"action": @"noticeReaded",
                                 @"notice_id" : self.notifyModel.notice_id?:[NSNull null]
                                 };
    __weak typeof(self) weakSelf = self;
    [JGJSocketRequest WebSocketWithParameters:parameters success:^(id responseObject) {
        [weakSelf handleJoinTeamUpdateDataBase];
    } failure:nil];
}

#pragma mark - 处理加入班组成功更新数据库
- (void)handleJoinTeamUpdateDataBase {
    self.notifyModel.isJoinTeam = YES;//同步成功设置为YES
    [JGJNewNotifyTool updateNotifyModel:self.notifyModel];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 创建班组
- (void)handleCreatTeam {
    JGJCreatTeamVC *creatTeamVC = [[UIStoryboard storyboardWithName:@"JGJCreatTeam" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJCreatTeamVC"];
    creatTeamVC.notifyModel = self.notifyModel;
    self.projectListModel.proType = JGJProCreatTeamType;
    creatTeamVC.projectListModel = self.projectListModel;
    [self.navigationController pushViewController:creatTeamVC animated:YES];
}

#pragma mark - 处理加入班组按钮按下
- (IBAction)handleJoinTeamButtonPressed:(UIButton *)sender {
    switch (self.projectListModel.proType) {
        case JGJNewCreatPro:
        case JGJProCreatTeamType: {
            __weak typeof(self) weakSelf = self;
            CustomAlertView *alertView = [CustomAlertView showWithMessage:@"当前选择的项目还未创建班组,确定创建班组吗?" leftButtonTitle:@"取消" midButtonTitle:nil rightButtonTitle:@"确定"];
            alertView.onOkBlock = ^{
                [weakSelf handleCreatTeam];
            };
        }
            break;
        case JGJProExistedType:
            [self handleJoinTeam];
            break;
        default:
            break;
    }
}

#pragma mark -YZGOnlyAddProjectViewControllerDelegate

- (void)handleYZGOnlyAddProjectViewControllerEditName:(NSString *)editName editType:(EditNameType)editType {

    [self handleYZGOnlyAddProjectViewControllerEditName:editName];
}

- (void)handleYZGOnlyAddProjectViewControllerEditName:(NSString *)editName {
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/addpro" parameters:@{@"pro_name":editName?:[NSNull null]} success:^(id responseObject) {
        self.projectListModel = [JGJProjectListModel mj_objectWithKeyValues:responseObject];
        JGJCreatTeamModel *creatTeamModel = self.proInfoModels[0];
        creatTeamModel.detailTitle = self.projectListModel.pro_name;
        creatTeamModel.detailTitlePid = self.projectListModel.pid;
        self.projectListModel.pro_id = self.projectListModel.pid;
        self.projectListModel.proType = JGJNewCreatPro;
        [self.tableView reloadData];
    }];
}

#pragma mark - getter
- (NSMutableArray *)proInfoModels {
    NSArray *titles = @[@"将他加入项目"];
    NSArray *placeholders = @[@"请选择项目"];
    if (!_proInfoModels) {
        _proInfoModels = [NSMutableArray array];
        for (int indx = 0; indx < titles.count; indx ++) {
            JGJCreatTeamModel *teamModel = [[JGJCreatTeamModel alloc] init];
            teamModel.title = titles[indx];
            teamModel.placeholderTitle = placeholders[indx];
            [_proInfoModels addObject:teamModel];
        }
    }
    return _proInfoModels;
}

- (NSMutableArray *)proNameArray {
    if (!_proNameArray) {
        _proNameArray = [NSMutableArray array];
    }
    return _proNameArray;
}

- (JGJProjectListModel *)projectListModel {

    if (!_projectListModel) {
        _projectListModel = [[JGJProjectListModel alloc] init];
    }
    return _projectListModel;
}

- (JLGPickerView *)jlgPickerView
{
    if (!_jlgPickerView) {
        _jlgPickerView = [[JLGPickerView alloc] initWithFrame:TYGetUIScreenRect];
        _jlgPickerView.delegate = self;
    }
    return _jlgPickerView;
}

#pragma mark - 初始化添加班组成员网络请求模型
- (JGJAddGroupMemberRequestModel *)addGroupMemberRequestModel {
    if (!_addGroupMemberRequestModel) {
        _addGroupMemberRequestModel = [[JGJAddGroupMemberRequestModel alloc] init];
        _addGroupMemberRequestModel.ctrl = @"group";
        _addGroupMemberRequestModel.action = @"addMembers";
        _addGroupMemberRequestModel.client_type = @"person";
        _addGroupMemberRequestModel.is_qr_code = @"0";
    }
    return _addGroupMemberRequestModel;
}
@end
