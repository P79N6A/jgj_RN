//
//  JGJNewNotifySynProDetailVC.m
//  mix
//
//  Created by yj on 16/8/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJNewNotifySynProDetailVC.h"
#import "JGJNewNotifyDetailHeadCell.h"
#import "JGJNewAddProlistCell.h"
#import "CFRefreshTableView.h"
#import "CustomAlertView.h"
#import "JGJSynProPopMessageView.h"
#import "JGJNewNotifyTool.h"
#import "JGJShareProDesView.h"
#import "JGJSynProDefaultCell.h"
#import "YZGOnlyAddProjectViewController.h"
#import "JGJCreatTeamVC.h"
#define HeaderH 27
#define DetailHeadCell 192.0
#define ButtomHeight 63.0
#define ProlistCellHeight 50.0
typedef enum : NSUInteger {
    JGJNewNotifySynProDetailHeadCell,
    JGJNewNotifySynProDetailSelectedProCell
} JGJNewNotifySynProDetailCellType;

typedef enum : NSUInteger {
    JGJSynProButtonType = 1,
    JGJCreatProButtonType
} JGJSynBottomButtonType;
@interface JGJNewNotifySynProDetailVC () <JGJSynProDefaultCellDelegate, YZGOnlyAddProjectViewControllerDelegate>
@property (weak, nonatomic) IBOutlet CFRefreshTableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *synProButton;
@property (strong, nonatomic) NSMutableArray *selectedProlist;
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) NSArray *mergecheckModels;//同步项目班组 项目组合并提示
@property (strong, nonatomic) CustomAlertView *alertView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containViewH;
@property (weak, nonatomic) IBOutlet UIView *containView;
@property (assign, nonatomic) JGJSynBottomButtonType buttonType;
@end

@implementation JGJNewNotifySynProDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonSet];
    [self loadNetData];
}

- (void)commonSet {
    [self.synProButton.layer setLayerCornerRadius:5.0];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.dataSource.count > 0 ? (section == JGJNewNotifySynProDetailHeadCell ? 1 : self.dataSource.count) : 1 ;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case JGJNewNotifySynProDetailHeadCell: {
            JGJNewNotifyDetailHeadCell *detailHeadCell = [JGJNewNotifyDetailHeadCell cellWithTableView:tableView];
            detailHeadCell.notifyModel = self.notifyModel;
            cell = detailHeadCell;
        }
            break;
        case JGJNewNotifySynProDetailSelectedProCell: {
            
            if (self.dataSource.count == 0) {
                JGJSynProDefaultCell *proDefaultCell = [JGJSynProDefaultCell cellWithTableView:tableView];
                proDefaultCell.delegate = self;
                cell = proDefaultCell;
            } else {
                JGJNewAddProlistCell *synProlistCell = [JGJNewAddProlistCell cellWithTableView:tableView];
                synProlistCell.syncProlistModel = self.dataSource[indexPath.row];
                cell = synProlistCell;
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count == 0) {
        return;
    }
    JGJSyncProlistModel *syncProlistModel = self.dataSource[indexPath.row];
    syncProlistModel.isSelected = !syncProlistModel.isSelected;
    if (syncProlistModel.isSelected) {
        [self.selectedProlist addObject:syncProlistModel];
    } else {
        [self.selectedProlist removeObject:syncProlistModel];
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0;
    switch (indexPath.section) {
        case JGJNewNotifySynProDetailHeadCell: {
            height = DetailHeadCell;
        }
            break;
        case JGJNewNotifySynProDetailSelectedProCell: {
            height = self.dataSource.count == 0 ? TYGetUIScreenHeight - DetailHeadCell - ButtomHeight : ProlistCellHeight;
        }
            break;
        default:
            break;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = nil;
    if (section == JGJNewNotifySynProDetailSelectedProCell) {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 40.0)];
        headerView.hidden = !self.dataSource.count;
        headerView.backgroundColor = AppFontf1f1f1Color;
        UILabel *contentLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, TYGetUIScreenWidth, 40.0)];
        contentLable.text = @"请选择要同步的项目";
        contentLable.font = [UIFont systemFontOfSize:AppFont24Size];
        contentLable.textColor = AppFont999999Color;
        [headerView addSubview:contentLable];
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.0;
    switch (section) {
        case JGJNewNotifySynProDetailHeadCell: {
            height = CGFLOAT_MIN;
        }
            break;
        case JGJNewNotifySynProDetailSelectedProCell: {
            height = self.dataSource.count == 0 ? 0 : 40;
        }
            break;
        default:
            break;
    }
    return height;
}

#pragma mark - 同步项目按钮按下
- (IBAction)synProlistButtonPressed:(UIButton *)sender {
    switch (self.buttonType) {
        case JGJSynProButtonType: {
            if (self.selectedProlist.count == 0) {
                [TYShowMessage showPlaint:@"请选择要同步的项目!"];
                return;
            }
            [self loadMergeSynProData];
        }
            break;
        case JGJCreatProButtonType: {
            [self handleCreatProAction];
        }
            break;
        default:
            break;
    }
}

- (void)upLoadProlistWithProlist:(NSArray *)prolist {
    NSMutableString *upLoadProinfoStr = [NSMutableString string];
    for (JGJSyncProlistModel *syncProlistModel in prolist) {
        [upLoadProinfoStr appendFormat:@"%@,%@,%@;",self.notifyModel.target_uid, syncProlistModel.pid,syncProlistModel.pro_name];
    }
    //    删除末尾的分号
    if (upLoadProinfoStr.length > 0 && upLoadProinfoStr != nil) {
        [upLoadProinfoStr deleteCharactersInRange:NSMakeRange(upLoadProinfoStr.length - 1, 1)];
    }
    __weak typeof(self) weakSelf = self;
    NSDictionary *parameters = @{@"pro_info" : upLoadProinfoStr ?: [NSNull null],
                                 @"team_id" : self.notifyModel.team_id?:[NSNull null]
                                 };
    CustomAlertView *alertView = [CustomAlertView showWithMessage:nil leftButtonTitle:nil midButtonTitle:nil rightButtonTitle:nil];
    self.alertView = alertView;
    [alertView showProgressImageView];
    [JLGHttpRequest_AFN PostWithApi:@"jlworksync/syncpro" parameters:parameters success:^(NSDictionary *responseObject) {
        [self handleAgreeSyncPro];
//        [alertView showSuccessImageView];
        [weakSelf.tableView reloadData];
    }failure:^(NSError *error) {
        [alertView removeFromSuperview];
        [TYShowMessage showPlaint:@"同步失败!"];
    }];
}

#pragma mark - 同步项目成功回执服务器
- (void)handleUploadReadedNotify {
    NSDictionary *parameters = @{
                                 @"ctrl" : @"notice",
                                 @"action": @"noticeReaded",
                                 @"notice_id" : self.notifyModel.notice_id?:[NSNull null]
                                 };
    __weak typeof(self) weakSelf = self;
    [JGJSocketRequest WebSocketWithParameters:parameters success:^(id responseObject) {
        [weakSelf.alertView showSuccessImageView];
        [weakSelf handleSynProUpDateDataBase];//更新数据库
        weakSelf.alertView.onOkBlock = ^{
//            [weakSelf.navigationController popViewControllerAnimated:YES];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        };
    } failure:^(NSError *error,id values) {
        [weakSelf.alertView removeFromSuperview];
    }];
}

#pragma mark-处理同意同步项目(上传成功之后才是真的同步成功)
- (void)handleAgreeSyncPro {
    if (self.selectedProlist.count < 1) {
        [TYShowMessage showPlaint:@"请选择项目"];
        return;
    }
    NSMutableString *proInfoStr = [NSMutableString string];
    for (JGJSyncProlistModel *prolistModel in self.selectedProlist) {
        [proInfoStr appendFormat:@"%@,",prolistModel.pid];
    }
    [proInfoStr replaceCharactersInRange:NSMakeRange(proInfoStr.length - 1, 1) withString:@""];
    NSDictionary *parameters = @{
                                 @"ctrl" : @"team",
                                 @"action": @"agreeSync",
                                 @"team_id" : self.notifyModel.team_id?:[NSNull null],
                                 @"pro_id" : proInfoStr?:[NSNull null]
                                 };
    __weak typeof(self) weakSelf = self;
    [JGJSocketRequest WebSocketWithParameters:parameters success:^(id responseObject) {
        [weakSelf handleUploadReadedNotify];
    } failure:^(NSError *error,id values) {
        [weakSelf.alertView removeFromSuperview];
    }];
}

#pragma mark - 处理同步账单成功更新数据库
- (void)handleSynProUpDateDataBase {
    self.notifyModel.isSuccessSyn = YES;//同步成功设置为YES
    [JGJNewNotifyTool updateNotifyModel:self.notifyModel];
}

- (void)loadNetData {
    NSMutableDictionary *parameters = @{@"uid" :self.notifyModel.target_uid ?:[NSNull null],
                                        @"synced" : @(0)}.mutableCopy;
    self.tableView.parameters = parameters;
    self.tableView.currentUrl = @"jlworksync/prolist";
    [self.tableView loadWithViewOfStatus:^UIView *(CFRefreshTableView *tableView, ERefreshTableViewStatus status) {
        CFRefreshStatusView *view;
        status = RefreshTableViewStatusNormal;
        view = [CFRefreshStatusView defaultViewWithStatus:status];
        [self jsonWithModel];
        view.textColor = AppFontccccccColor;
        return view;
        
    }];
}

- (void)loadMergeSynProData {
    if (self.selectedProlist.count < 1) {
        [TYShowMessage showPlaint:@"请选择项目"];
        return;
    }
    NSMutableString *proInfoStr = [NSMutableString string];
    for (JGJSyncProlistModel *prolistModel in self.selectedProlist) {
        [proInfoStr appendFormat:@"%@,%@;",prolistModel.pid, prolistModel.pro_name];
    }
    [proInfoStr replaceCharactersInRange:NSMakeRange(proInfoStr.length - 1, 1) withString:@""];
    NSDictionary *parameters = @{@"pro_str" : proInfoStr ?:[NSNull null],
                                 @"team_id" : self.notifyModel.team_id ?:[NSNull null]};
    [JLGHttpRequest_AFN PostWithApi:@"v2/worksync/mergecheck" parameters:parameters success:^(id responseObject) {
//                NSArray *arr =  @[
//                                 @{
//                                     @"from_pro_name": @"天府新区集团",
//                                     @"from_team_name": @"感慨万千国际项目",
//                                     @"to_pro_name": @"盛邦国际集团"
//                                 },
//                                 @{
//                                     @"from_pro_name": @"天府新区集团",
//                                     @"from_team_name": @"感慨万千国际项目",
//                                     @"to_pro_name": @"天府三街"
//                                 },
//                                 @{
//                                     @"from_pro_name": @"天府新1",
//                                     @"from_team_name": @"感慨3434际项目",
//                                     @"to_pro_name": @"盛邦国际集团"
//                                     },
//                                 @{
//                                     @"from_pro_name": @"23新区集团",
//                                     @"from_team_name": @"感343千国际项目",
//                                     @"to_pro_name": @"天3434街"
//                                     }
//                                 ];
//                self.mergecheckModels = [JGJSynMergecheckModel mj_objectArrayWithKeyValuesArray:arr];
        self.mergecheckModels = [JGJSynMergecheckModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        if (self.mergecheckModels.count) {
            JGJSynProPopMessageView *popMesageView = [[JGJSynProPopMessageView alloc] initWithFrame:self.view.bounds mergecheckModels:self.mergecheckModels];
            [[[UIApplication sharedApplication] delegate].window addSubview:popMesageView];
            __weak typeof(self) weakSelf = self;
            popMesageView.messageViewBlock = ^{
                [weakSelf upLoadProlistWithProlist:self.selectedProlist];
            };
        } else {
            [self upLoadProlistWithProlist:self.selectedProlist];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 创建项目
- (void)handleCreatProAction {
//    JGJCreatTeamVC *creatTeamVC = [[UIStoryboard storyboardWithName:@"JGJCreatTeam" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJCreatTeamVC"];
//    creatTeamVC.notifyModel = self.notifyModel;
//    creatTeamVC.proType = JGJProCreatTeamType;
//    [self.navigationController pushViewController:creatTeamVC animated:YES];
    YZGOnlyAddProjectViewController *editTeamNameVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"onlyAddProject"];
    editTeamNameVc.delegate = self;
    editTeamNameVc.isEditGroupName = YES;
    editTeamNameVc.title = @"新建项目";
    [self.navigationController pushViewController:editTeamNameVc animated:YES];
}

- (void)handleYZGOnlyAddProjectViewControllerEditName:(NSString *)editName {
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/addpro" parameters:@{@"pro_name":editName ?:@""} success:^(id responseObject) {
        JGJSyncProlistModel *prolistModel = [JGJSyncProlistModel mj_objectWithKeyValues:responseObject];
        self.dataSource = [NSArray arrayWithObject:prolistModel];
        self.proSynType = CreatProSynType;
        if (self.proSynType == CreatProSynType && _dataSource.count > 0) { //没有项目创建项目回来选中创建项目
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
        }
    }];
}

- (void)jsonWithModel {
    self.dataSource = [JGJSyncProlistModel mj_objectArrayWithKeyValuesArray:self.tableView.dataArray];
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    self.buttonType = self.dataSource.count > 0 ? JGJSynProButtonType : JGJCreatProButtonType;
    NSString *buttonTitle = self.dataSource.count == 0 ? @"新建项目" : @"同步项目";
    [self.synProButton setTitle:buttonTitle forState:UIControlStateNormal];
    [self.tableView reloadData];
    if (self.proSynType == CreatProSynType && _dataSource.count > 0) { //没有项目创建项目回来选中创建项目
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)handleSynProDefaultCellAction:(JGJSynProDefaultCell *)cell {
    JGJShareProDesModel *shareProDesModel = [[JGJShareProDesModel alloc] init];
    shareProDesModel.popTitle = @"同步的项目从哪儿来？";
    shareProDesModel.popDetail = @"1.给工人记工后便生成了项目数据，然后就可以同步项目给别人\n2.你可以要求手下记工人员将记工数据同步给你，你就拥有了同步的项目，可以继续同步该项目给别人";
    shareProDesModel.contentViewHeight = 230.0;
    shareProDesModel.popTextAlignment = NSTextAlignmentLeft;
    [JGJShareProDesView shareProDesViewWithProDesModel:shareProDesModel];
}

- (NSMutableArray *)selectedProlist {
    if (!_selectedProlist) {
        _selectedProlist = [NSMutableArray array];
    }
    return _selectedProlist;
}

@end
