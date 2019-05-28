//
//  JGJNewNotify.m
//  mix
//
//  Created by yj on 16/8/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

/**
 *  新通知
 *  界面：加入班组、同步项目按钮重用一个，根据类型区分
 *  1.进入该页面除需要加入班组、同步项目操作外其余数据回执服务器，告知该信息已读
 *  2.回执信息，之前已回执的不需要再次回执。每次回执的信息是新数据，已读的数据
 *  3.带按钮操作(加入班组、同步项目按钮)的需要操作成功回执服务器
 *  4.每次进入页面，客户端请求数据
 *  5.接受客户端返回的数据
 *  6.添加每一条数据的操作,已读标记isReaded标记为NO,读了之后标记为YES
 */

#import "JGJNewNotifyVC.h"
#import "JGJNewNotifyCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "JGJNewNotifyDetailVC.h" //详情页测试
#import "JGJNewNotifySynProDetailVC.h" //同步项目详情
#import "JGJNewNotifyTool.h"
#import "JGJSocketRequest.h"
#import "NSString+Extend.h"
#import "JGJChatRootVc.h"
#import "CFRefreshStatusView.h"

#import "JGJProiClodInsuffRemindCell.h"

#import "JGJSureOrderListViewController.h"

#import "JGJGroupMangerTool.h"

#import "MJRefresh.h"

#import "JGJWebAllSubViewController.h"

#import "JGJNotifySynProCell.h"

#import "JGJAddSynInfoVc.h"

#import "JGJSynToMyProVc.h"

typedef void(^HandleIsMemberBlock)(BOOL, BOOL, id);
typedef void(^HandleUploadUnReadedNotifyBlock)();
@interface JGJNewNotifyVC () <UITableViewDataSource, UITableViewDelegate, JGJNewNotifyCellDelegate, JGJProiClodInsuffRemindCellDelegate, JGJNotifySynProCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataSource;
@property (copy, nonatomic) HandleIsMemberBlock handleIsMemberBlock;
@property (copy, nonatomic) HandleUploadUnReadedNotifyBlock handleUploadUnReadedNotifyBlock;
@end

@implementation JGJNewNotifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self comonSet];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
    
    //H5返回时保证显示头子
    self.navigationController.navigationBar.hidden = NO;
    
//    [self testNetData];
    
//    [self loadNoticeListNetData];

}

- (void)comonSet {
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNoticeListNetData)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JGJNewNotifyCell" bundle:nil] forCellReuseIdentifier:@"JGJNewNotifyCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JGJProiClodInsuffRemindCell" bundle:nil] forCellReuseIdentifier:@"JGJProiClodInsuffRemindCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JGJNotifySynProCell" bundle:nil] forCellReuseIdentifier:@"JGJNotifySynProCell"];
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = AppFontf1f1f1Color;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJNewNotifyModel *notifyModel = self.dataSource[indexPath.row];
    CGFloat height = 0;
    
    if (notifyModel.notifyType == CloudExpiredNotice || notifyModel.notifyType == Cloud_lack || notifyModel.notifyType == ServiceExpiredNotice || notifyModel.notifyType == superior_work_leader || notifyModel.notifyType == work_leader_certify || notifyModel.notifyType == syncGroupToGroup || notifyModel.notifyType == syncedSyncGroupToGroup || notifyModel.notifyType == SyncProjectType) {
        
        height = notifyModel.cellHeight;
        
    } 
    
    else {
        
        height = [tableView fd_heightForCellWithIdentifier:@"JGJNewNotifyCell" configuration:^(JGJNewNotifyCell *newNotifyCell) {
            
            newNotifyCell.notifyModel = notifyModel;
            
        }];
        
        switch (notifyModel.notifyType) {
                
//            case CloseGroupType:
//            case CloseTeamType:
            case JoinGroupType:
            case JoinTeamType:{
                
                if (height < 100) {
                    
                    height = 100;
                }
                
            }
                break;
                
            default:
                break;
        }
        
    }
    
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJNewNotifyModel *notifyModel = self.dataSource[indexPath.row];
    __weak typeof(self) weakSelf = self;
    if ([notifyModel.can_click isEqualToString:@"1"]) {
        [self handleIsMember:notifyModel];
        self.handleIsMemberBlock = ^(BOOL isClosed, BOOL isMember, id response){
            BOOL isClicked = !isClosed && isMember;
            if (isClicked) {
                JGJChatRootVc *chatRootVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatRootCommonVc"];
                JGJMyWorkCircleProListModel *workProListModel = [JGJMyWorkCircleProListModel mj_objectWithKeyValues:[notifyModel mj_keyValues]];
                workProListModel.myself_group = @"0"; //备注只能作为成员
                workProListModel.class_type = ![NSString isEmpty:notifyModel.team_id] ? @"team" : @"group";
                chatRootVc.workProListModel = workProListModel;
                [weakSelf.navigationController pushViewController:chatRootVc animated:YES];
            } else if (!isMember){
                [TYShowMessage showPlaint:@"你已不是成员"];
            }else if (isClosed){
                [TYShowMessage showPlaint:@"已关闭"];
                [JGJNewNotifyTool removeCollectNotify:notifyModel];
                weakSelf.dataSource = [JGJNewNotifyTool allNotifies];
            }
        };
    }
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJNewNotifyModel *notifyModel = self.dataSource[indexPath.row];
    
    UITableViewCell *cell = nil;
    
    if (notifyModel.notifyType == CloudExpiredNotice || notifyModel.notifyType == Cloud_lack || notifyModel.notifyType == ServiceExpiredNotice || notifyModel.notifyType == work_leader_certify || notifyModel.notifyType == superior_work_leader ) {
        
        JGJProiClodInsuffRemindCell *insuffRemindCell = [tableView dequeueReusableCellWithIdentifier:@"JGJProiClodInsuffRemindCell" forIndexPath:indexPath];
        
        insuffRemindCell.delegate = self;
        
        insuffRemindCell.notifyModel = notifyModel;
        
        insuffRemindCell.lineView.hidden = self.dataSource.count - 1 == indexPath.row;
        
        cell = insuffRemindCell;
        
    } else if (notifyModel.notifyType == syncGroupToGroup || notifyModel.notifyType == syncedSyncGroupToGroup || notifyModel.notifyType == SyncProjectType) {
        
        JGJNotifySynProCell *synCell = [tableView dequeueReusableCellWithIdentifier:@"JGJNotifySynProCell" forIndexPath:indexPath];
        
        synCell.notifyModel = notifyModel;
        
        synCell.delegate = self;
        
        cell = synCell;
        
    } else {
        
        JGJNewNotifyCell *newNotifyCell = [tableView dequeueReusableCellWithIdentifier:@"JGJNewNotifyCell" forIndexPath:indexPath];
        
        newNotifyCell.notifyModel = notifyModel;
        
        newNotifyCell.delegate = self;
        
        newNotifyCell.lineView.hidden = self.dataSource.count - 1 == indexPath.row;
        
        cell = newNotifyCell;
        
    }
    return cell;
}

- (void)loadNoticeListNetData {
    NSDictionary *body = @{
                           @"ctrl" : @"notice",
                           @"action": @"noticeList"
                           };
    __weak typeof(self) weakSelf = self;
//    [TYLoadingHub showLoadingWithMessage:nil];
   [JGJSocketRequest WebSocketWithParameters:body success:^(id responseObject) {
       TYLog(@"responseObject---- %@", responseObject);
//       [TYLoadingHub hideLoadingView];
       [weakSelf handleSuccessGetNoticeList:responseObject];
       [weakSelf.tableView.mj_header endRefreshing];
    } failure:^(NSError *error,id values) {
//        [TYLoadingHub hideLoadingView];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - 处理是否是成员
- (void)handleIsMember:(JGJNewNotifyModel *)notifyModel {
    JGJCheckIsMemberRequest *request = [[JGJCheckIsMemberRequest alloc] init];
    request.team_id = notifyModel.team_id;
    request.group_id = notifyModel.group_id;
    request.ctrl = @"group";
    request.action = @"isMember";
    NSDictionary *body = [request mj_keyValues];
    __weak typeof(self) weakSelf = self;
    [TYLoadingHub showLoadingWithMessage:nil];
    [JGJSocketRequest WebSocketWithParameters:body success:^(id responseObject) {
        TYLog(@"responseObject---- %@", responseObject);
        [TYLoadingHub hideLoadingView];
        BOOL isMember = [responseObject[@"is_member"] isEqualToString:@"1"];
        BOOL isClosed = [responseObject[@"is_closed"] isEqualToString:@"1"];
        weakSelf.handleIsMemberBlock(isClosed, isMember, responseObject);
        [weakSelf handleSuccessGetNoticeList:responseObject];
    } failure:^(NSError *error,id values) {
        [TYLoadingHub hideLoadingView];
    }];
}

#pragma mark - 成功得到通知信息后存储新数据、返回未读的数据
- (void)handleSuccessGetNoticeList:(id)responseObject {
    NSArray *arr = [JGJNewNotifyModel mj_objectArrayWithKeyValuesArray:responseObject];
    for (JGJNewNotifyModel *notifyModel in arr) {
        BOOL isExist = [JGJNewNotifyTool isExistNotifyModel:notifyModel];
        if (!isExist) {
            [JGJNewNotifyTool addCollectNotifies:notifyModel];
        }
    }
    self.dataSource = [JGJNewNotifyTool allNotifies];
   [self handleUploadUnReadedNotify];
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    if (_dataSource.count == 0) {
        CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"notice_default_icon") withTips:@"暂时还没有关于项目的消息"];
        statusView.frame = self.view.bounds;
        self.tableView.tableHeaderView = statusView;
    } else {
        self.tableView.tableHeaderView = nil;
    }
    [self.tableView reloadData];
}

#pragma mark - JGJNewNotifyCellDelegate 处理通知类型的按钮事件
- (void)handleJGJNewNotifyCellNotifyModel:(JGJNewNotifyModel *)notifyModel buttonType:(NotifyCellButtonType)buttonType {
    switch (notifyModel.notifyType) {
        case SyncProjectType: {
            switch (buttonType) {
                case NotifyCellSyncButtonType: { //同步按钮
                    [self handleSynButtonPressed:notifyModel buttonType:buttonType];
                }
                    break;
                case NotifyCellRefuseButtonType: { //拒绝按钮
                    [self handleRefuseButtonPressed:notifyModel buttonType:buttonType];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case NewBillingType: { //加入班组
            if (buttonType != NotifyCellDeleteButtonType) {
                 [self handleJoinTeamButtonPressed:notifyModel buttonType:buttonType];   
            }
        }
            break;
            
        default:
            break;
    }
//    处理删除按钮公用
    if (buttonType == NotifyCellDeleteButtonType) {
        [self handleDeleteButtonPressed:notifyModel buttonType:buttonType];
    }else if (buttonType == NotifyCellChangeProButtonType) {
        
        [self handleChangeProButtonPressed:notifyModel buttonType:buttonType];
    }
}

#pragma mark - JGJNotifySynProCellDelegate 记工同步请求3.2.0添加

- (void)handleSynProCellNotifyModel:(JGJNewNotifyModel *)notifyModel buttonType:(NotifyCellButtonType)buttonType {

    switch (buttonType) {
        case NotifyCellSyncedSyncProjectType://记工同步通知
        case NotifyCellSyncedSyncGroupToGroup: //记工记账同步通知
        case NotifyCellSyncButtonType: { //同步按钮
            
//            [self handleSynButtonPressed:notifyModel buttonType:buttonType];
            
            [self setNotifyTypeWithNotifyModel:notifyModel buttonType:buttonType];
            
        }
            break;
        case NotifyCellRefuseButtonType: { //拒绝按钮
            
            [self handleRefuseButtonPressed:notifyModel buttonType:buttonType];
        }
            break;
        
        case NotifyCellDeleteButtonType: { //删除
        
            [self handleDeleteButtonPressed:notifyModel buttonType:buttonType];
        }
            break;
            
        default:
            break;
    }
    
    
}

#pragma mark - 进入按钮按下，切换项目请求接口

- (void)handleChangeProButtonPressed:(JGJNewNotifyModel *)notifyModel buttonType:(NotifyCellButtonType)buttonType {
    
    NSString *classType = [notifyModel.class_type isEqualToString:@"closeTeam"] ? @"team" : @"group";
    
    if ([notifyModel.class_type isEqualToString:@"closeTeam"] || [notifyModel.class_type isEqualToString:@"closeGroup"] ) {
        
        JGJMyWorkCircleProListModel *proListModel = [JGJMyWorkCircleProListModel new];
        
        proListModel.group_name = notifyModel.team_name;
        
        proListModel.group_id = notifyModel.group_id;
        
        proListModel.class_type = classType;
        
        [self setIndexProListModel:proListModel];
        
        return;
    }
    
    [self handleIsMember:notifyModel];
    
    __weak typeof(self) weakSelf = self;
    
    self.handleIsMemberBlock = ^(BOOL isClosed, BOOL isMember, id response){
        
        JGJMyWorkCircleProListModel *proListModel = [JGJMyWorkCircleProListModel mj_objectWithKeyValues:response];
        
        if (![NSString isEmpty:response[@"group_name"]]) {
            
            proListModel.group_name = response[@"group_name"];
            
            notifyModel.group_name = response[@"group_name"];
            
            notifyModel.team_name = response[@"group_name"];
            
            if ([JGJNewNotifyTool updateNotifyModel:notifyModel]) {
                
                weakSelf.dataSource = [JGJNewNotifyTool allNotifies];
            }
        }
        
        [weakSelf setIndexProListModel:proListModel];
    };
    
}

#pragma mark - 选中之后切换项目，首页项目改变
- (void)setIndexProListModel:(JGJMyWorkCircleProListModel *)proListModel {
        
    __weak typeof(self) weakSelf = self;
    
    [JGJChatGetOffLineMsgInfo http_gotoTheGroupHomeVCWithGroup_id:proListModel.group_id?:@"" class_type:proListModel.class_type?:@"" isNeedChangToHomeVC:YES isNeedHttpRequest:YES success:^(BOOL isSuccess) {
        
        [TYShowMessage showSuccess:@"已切换到该项目首页，你可以在首页进行各模块的使用"];
        
        [weakSelf.navigationController popToRootViewControllerAnimated:NO];
        
    }];
    
}

#pragma mark - 处理拒绝按钮按下 拒绝成功隐藏拒绝按钮显示同步账单按钮，显示删除按钮
- (void)handleRefuseButtonPressed:(JGJNewNotifyModel *)notifyModel buttonType:(NotifyCellButtonType)buttonType {
    
//项目成员点击拒绝
    
    if (![NSString isEmpty:notifyModel.group_id] || ![NSString isEmpty:notifyModel.team_id]) {
        
        [self proMemberRepuseSyncRequestWithNotifyModel:notifyModel];
        
    }else {
        
//3.2.0 新类型添加
        
        switch (notifyModel.notifyType) {
                
            case syncGroupToGroup:{
                
                notifyModel.sync_type = @"1";
                
                [self repulseSyncRequestWithNotifyModel:notifyModel];
                
            }
                break;
                
            case SyncProjectType:{
                
                notifyModel.sync_type = @"2";
                
                [self repulseSyncRequestWithNotifyModel:notifyModel];
                
            }
                
                break;
                
            default:
                
                break;
        }
        
    }
    
}

#pragma mark - 项目成员点击拒绝
- (void)proMemberRepuseSyncRequestWithNotifyModel:(JGJNewNotifyModel *)notifyModel {
    
    [self handleIsMember:notifyModel];
    
    __weak typeof(self) weakSelf = self;
    
    self.handleIsMemberBlock = ^(BOOL isClosed, BOOL isMember, id response) {
        if (!isClosed) {
            
            [weakSelf repulseSyncRequestWithNotifyModel:notifyModel];
            
        }else if (!isMember){
            
            [weakSelf handleUploadUnReadedNotify:notifyModel];
            
            weakSelf.handleUploadUnReadedNotifyBlock = ^{
                
                [JGJNewNotifyTool removeCollectNotify:notifyModel];
                
            };
            
            [TYShowMessage showPlaint:@"你已不是成员"];
            
        }else if (isClosed){
            
            [weakSelf handleUploadUnReadedNotify:notifyModel];
            
            weakSelf.handleUploadUnReadedNotifyBlock = ^{
                
                [JGJNewNotifyTool removeCollectNotify:notifyModel];
                
            };
            
            [TYShowMessage showPlaint:@"已被关闭"];
        }
    };
    
}

#pragma mark - 拒绝同步请求

- (void)repulseSyncRequestWithNotifyModel:(JGJNewNotifyModel *)notifyModel {
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *parameters = @{
                                 @"ctrl" : @"team",
                                 @"action": @"repulseSync",
                                 @"target_uid" : notifyModel.target_uid ?:[NSNull null],
                                 @"team_id" : notifyModel.team_id ?:[NSNull null],
                                 @"sync_type" : notifyModel.sync_type?:@""
                                 };
    [JGJSocketRequest WebSocketWithParameters:parameters success:^(id responseObject) {
        [weakSelf handleUploadUnReadedNotify:notifyModel];
        weakSelf.handleUploadUnReadedNotifyBlock = ^{
            
            notifyModel.isRefused = YES; //拒绝成功设置YES,本地操作
            
            if ([JGJNewNotifyTool updateNotifyModel:notifyModel]) {
                
                weakSelf.dataSource = [JGJNewNotifyTool allNotifies];
                
            }
        };
        
    } failure:^(NSError *error, id values) {
        
        
    }];
    
}

#pragma mark - 处理同步按钮按下 同步成功隐藏拒绝按钮、同步账单按钮，显示删除按钮
- (void)handleSynButtonPressed:(JGJNewNotifyModel *)notifyModel buttonType:(NotifyCellButtonType)buttonType {
    
     __weak typeof(self) weakSelf = self;
    
    [self handleIsMember:notifyModel];
    
    self.handleIsMemberBlock = ^(BOOL isClosed, BOOL isMember, id response){
        if (!isClosed) {
            
            [weakSelf setNotifyTypeWithNotifyModel:notifyModel buttonType:buttonType];
            
        } else if (isClosed) {
            
            [JGJNewNotifyTool removeCollectNotify:notifyModel];
            
            [TYShowMessage showPlaint:@"已被关闭!"];
            
        } else if (!isMember) {
            
            [JGJNewNotifyTool removeCollectNotify:notifyModel];
            
            [TYShowMessage showPlaint:@"你已不是成员!"];
            
        }
    };
    
}

#pragma mark - 处理同步按钮情况
- (void)setNotifyTypeWithNotifyModel:(JGJNewNotifyModel *)notifyModel buttonType:(NotifyCellButtonType)buttonType{
    
    switch (notifyModel.notifyType) {
            
        case SyncProjectType:{
            
            TYLog(@"同步记工");
            
            [self synProDetailVcWithNotifyModel:notifyModel];
        }
            
            break;
            
        case syncGroupToGroup:{
            
            TYLog(@"记工同步请求");
            
            [self syncGroupToGroupWithNotifyModel:notifyModel];
        }
            
            break;
            
        case syncedSyncGroupToGroup:{
            
            TYLog(@"记工同步通知");
            
            [self syncedSyncGroupToGroupWithNotifyModel:notifyModel];
            
        }
            break;
            
        case NotifyCellSyncedSyncProjectType:{ //查看记工报表
            
            [self checkRecordFormWithNotifyModel:notifyModel];
        }
            
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 查看记工报表
- (void)checkRecordFormWithNotifyModel:(JGJNewNotifyModel *)notifyModel {
    
    NSString *statisticsStr = [NSString stringWithFormat:@"%@statistical/charts?talk_view=1&team_id=%@",JGJWebDiscoverURL, notifyModel.source_pro_id];
    
    JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:statisticsStr];
    
    [self.navigationController pushViewController:webVc animated:YES];
    
}

#pragma mark - 处理到同步项目详情页面
- (void)synProDetailVcWithNotifyModel:(JGJNewNotifyModel *)notifyModel {
    
//    JGJNewNotifySynProDetailVC *notifyDetailVC = [[UIStoryboard storyboardWithName:@"JGJNewNotify" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJNewNotifySynProDetailVC"];
//
//    notifyDetailVC.notifyModel = notifyModel;
//
//    [self.navigationController pushViewController:notifyDetailVC animated:YES];
    
    [self synVcWithSynType:JGJSyncRecordWorkType notifyModel:notifyModel];
}

#pragma mark - 记工同步请求
- (void)syncGroupToGroupWithNotifyModel:(JGJNewNotifyModel *)notifyModel {
    
    [self synVcWithSynType:JGJSyncRecordWorkAndAccountsType notifyModel:notifyModel];
    
}

#pragma mark - 记工同步通知
- (void)syncedSyncGroupToGroupWithNotifyModel:(JGJNewNotifyModel *)notifyModel {
    
    JGJSynToMyProVc *synToMyProVc = [[JGJSynToMyProVc alloc] init];
    
    [self.navigationController pushViewController:synToMyProVc animated:YES];
    
}

- (void)synVcWithSynType:(JGJSyncType)synType notifyModel:(JGJNewNotifyModel *)notifyModel {
    
    JGJAddSynInfoVc *synInfoVc = [[JGJAddSynInfoVc alloc] init];
    
    synInfoVc.syncType = synType;
    
    synInfoVc.notifyModel = notifyModel;
    
    [self.navigationController pushViewController:synInfoVc animated:YES];
    
    TYWeakSelf(self);
    
    synInfoVc.synSuccessBlock = ^(NSDictionary *res){
      
        [weakself.navigationController popViewControllerAnimated:YES];
        
    };
    
    
}

#pragma mark - 处理删除按钮按下 同步成功隐藏拒绝按钮、同步账单按钮，显示删除按钮
- (void)handleDeleteButtonPressed:(JGJNewNotifyModel *)notifyModel buttonType:(NotifyCellButtonType)buttonType {
    __weak typeof(self) weakSelf = self;
    [self handleUploadUnReadedNotify:notifyModel];
    self.handleUploadUnReadedNotifyBlock = ^ {
        if ([JGJNewNotifyTool removeCollectNotify:notifyModel]) {
            weakSelf.dataSource = [JGJNewNotifyTool allNotifies];
        }
    };
}

#pragma mark - 处理同步按钮按下 同步成功隐藏拒绝按钮、同步账单按钮，显示删除按钮
- (void)handleJoinTeamButtonPressed:(JGJNewNotifyModel *)notifyModel buttonType:(NotifyCellButtonType)buttonType {
    JGJNewNotifyDetailVC *joinTeamDetailVC = [[UIStoryboard storyboardWithName:@"JGJNewNotify" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJNewNotifyDetailVC"];
    joinTeamDetailVC.notifyModel = notifyModel;
    [self.navigationController pushViewController:joinTeamDetailVC animated:YES];
}

#pragma mark - 处理已读的消息,除同步项目和加入班组，需点击按钮操作的操作成功后反馈给服务器
- (void)handleUploadUnReadedNotify {
    NSArray *readedNotifies = [JGJNewNotifyTool allReadedNofies];
    NSString *noticeIDStr=[readedNotifies componentsJoinedByString:@","];
    if ([NSString isEmpty:noticeIDStr]) {
        return;
    }
    NSDictionary *parameters = @{
                           @"ctrl" : @"notice",
                           @"action": @"noticeReaded",
                           @"notice_id" : noticeIDStr?:[NSNull null]
                           };
    [JGJSocketRequest WebSocketWithParameters:parameters success:^(id responseObject) {
    } failure:nil];
}

- (void)handleUploadUnReadedNotify:(JGJNewNotifyModel *)notifyModel {
    if ([NSString isEmpty:notifyModel.notice_id]) {
        return;
    }
    NSDictionary *parameters = @{
                                 @"ctrl" : @"notice",
                                 @"action": @"noticeReaded",
                                 @"notice_id" : notifyModel.notice_id?:[NSNull null]
                                 };
    __weak typeof(self) weakSelf = self;
    [JGJSocketRequest WebSocketWithParameters:parameters success:^(id responseObject) {
        if (weakSelf.handleUploadUnReadedNotifyBlock) {
            weakSelf.handleUploadUnReadedNotifyBlock();
        }
    } failure:nil];
}

#pragma mark - 过期和云盘不足服务
- (void)handleJGJProiClodInsuffRemindCellWithNotifyModel:(JGJNewNotifyModel *)notifyModel buttonType:(ProiClodInsuffRemindCellButtonType)buttonType {
    
    __weak typeof(self) weakSelf = self;
    
    switch (buttonType) {
            
        case ProiClodInsuffRemindCellDelButtonType:{
            
            TYLog(@"删除按钮按下");
            
            [self handleUploadUnReadedNotify:notifyModel];
            
            self.handleUploadUnReadedNotifyBlock = ^ {
                
                if ([JGJNewNotifyTool removeCollectNotify:notifyModel]) {
                    
                    weakSelf.dataSource = [JGJNewNotifyTool allNotifies];
                }
            };
        }
            
            break;
            
        case ProiClodInsuffRemindCellOrderButtonType:{
            
            //弹框申请
            JGJServiceOverTimeRequest *request = [JGJServiceOverTimeRequest new];
            
            request.group_id = self.proListModel.group_id;
            
            request.class_type = self.proListModel.class_type;
            
            request.server_type = @"1";
            
            [JGJServiceOverTimeRequest serviceOverTimeRequest:request requestBlock:^(id response) {
                
                
            }];
            
//            JGJSureOrderListViewController *SureOrderListVC = [[UIStoryboard storyboardWithName:@"JGJSureOrderListViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJSureOrderListVC"];
//
//            if (notifyModel.notifyType == Cloud_lack || notifyModel.notifyType == CloudExpiredNotice) {
//
//                SureOrderListVC.GoodsType = CloudNumType;
//
//            }else {
//
//                SureOrderListVC.GoodsType = VIPServiceType;
//            }
//
//            JGJOrderListModel *orderListModel = [JGJOrderListModel new];
//
//            orderListModel.group_id = notifyModel.group_id;
//
//            orderListModel.upgrade = YES;
//
//            orderListModel.class_type = @"team";
//
//            SureOrderListVC.orderListModel = orderListModel;
//
//            [self.navigationController pushViewController:SureOrderListVC animated:YES];
//
//            __block JGJNewNotifyModel *notifyBlockModel = notifyModel ;
//
//            SureOrderListVC.notifyServiceSuccessBlock = ^(JGJOrderListModel *orderListModel) {
//
//                if ([notifyModel.group_id isEqualToString:orderListModel.group_id]) {
//
//                    TYLog(@"订购成功");
//
//                    if (orderListModel.paySucees) {
//
//                        notifyBlockModel.isSuccessSyn = orderListModel.paySucees;
//
//                        if ([JGJNewNotifyTool updateNotifyModel:notifyBlockModel]) {
//
//                            weakSelf.dataSource = [JGJNewNotifyTool allNotifies];
//                        }
//
//                        [weakSelf handleUploadUnReadedNotify:notifyBlockModel];
//                    }
//
//
//                }else {
//
//                    TYLog(@"订购不是当前项目失败");
//                }
//
//            };
            
        }
            
            break;
            
            
        case CheckDetailButtonType:{
            
            NSString *webUrl = nil;
            
            if (notifyModel.notifyType == work_leader_certify) {
                
                NSString *url = [NSString stringWithFormat:@"%@%@", JGJWebDiscoverURL, @"my/attest"];
                
                JGJWebAllSubViewController *webVc = [[ JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:url];
                
                [self.navigationController pushViewController:webVc animated:YES];
                
            }else if (notifyModel.notifyType == superior_work_leader) {
                

                
            }
            
            if (![NSString isEmpty:webUrl]) {
                
                webUrl = [NSString stringWithFormat:@"%@", JGJWebDiscoverURL];
                
                JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc]
                                                     initWithWebType:JGJWebTypeInnerURLType URL:webUrl];
                
                [self.navigationController pushViewController:webVc animated:YES];
            }
            
        }
            
            break;
            
        default:
            break;
    }
    
}

- (void)testNetData {
    
    //    CloseGroupType,
    //    CloseTeamType,
    //    JoinGroupType,
    //    JoinTeamType,
    //    #define Class_types @[@"removeGroupMember", @"removeTeamMember", @"closeGroup", @"closeTeam", @"joinGroup", @"joinTeam", @"reopenGroup", @"reopenTeam", @"mergeTeam", @"splitTeam", @"syncProject", @"repulseSync", @"syncCreateTeamNotice", @"syncNoticeTarget", @"createSyncTeam", @"delSyncProject", @"syncedSyncProject", @"ProiClodInsuffRemind"]
    
    NSDictionary *dic = @{
                          @"state": @"1",
                          @"ctrl@@":@"notice",
                          @"action":@"noticeList",
                          @"values": @[
                                  //对您同步项目
//                                  @{
//                                      @"notice_id":@"109",
//                                      @"class_type":@"closeGroup",
//                                      @"title":@"关闭班组",
//                                      @"members_head_pic":@[
//                                              @"pic1.png"
//                                              ],
//                                      @"date":@"2016-02-21",
//                                      @"user_name":@"代强0",
//                                      @"group_name":@"龙湖清波龙湖龙湖清波热饭饭 的GV个",
//                                      @"source_pro_id":@"0,3,6",
//                                      @"uid" : @"123423",
//                                      @"telphone" :@"13912345678"
//                                      },
                                  //                                  //对您同步项目
                                  //                                  @{
                                  //                                      @"notice_id":@"109",
                                  //                                      @"class_type":@"closeTeam",
                                  //                                      @"title":@"关闭项目",
                                  //                                      @"members_head_pic":@[
                                  //                                              @"pic1.png"
                                  //                                              ],
                                  //                                      @"date":@"2016-02-21",
                                  //                                      @"user_name":@"代强0",
                                  //                                      @"team_name":@"龙湖清波我让王若冰",
                                  //                                      @"source_pro_id":@"0,3,6",
                                  //                                      @"uid" : @"123423",
                                  //                                      @"telphone" :@"13912345678"
                                  //                                      },
                                  //                                  //对您同步项目
                                  //                                  @{
                                  //                                      @"notice_id":@"109",
                                  //                                      @"class_type":@"joinGroup",
                                  //                                      @"title":@"加入班组",
                                  //                                      @"members_head_pic":@[
                                  //                                              @"pic1.png"
                                  //                                              ],
                                  //                                      @"date":@"2016-02-21",
                                  //                                      @"user_name":@"代强0",
                                  //                                      @"group_name":@"龙湖清波我让王若冰",
                                  //                                      @"source_pro_id":@"0,3,6",
                                  //                                      @"uid" : @"123423",
                                  //                                      @"telphone" :@"13912345678"
                                  //                                      },
                                  //
                                  //                                  //对您同步项目
                                  //                                  @{
                                  //                                      @"notice_id":@"109",
                                  //                                      @"class_type":@"joinTeam",
                                  //                                      @"title":@"加入项目",
                                  //                                      @"members_head_pic":@[
                                  //                                              @"pic1.png"
                                  //                                              ],
                                  //                                      @"date":@"2016-02-21",
                                  //                                      @"user_name":@"代强0",
                                  //                                      @"team_name":@"龙湖清波我让王若冰",
                                  //                                      @"source_pro_id":@"0,3,6",
                                  //                                      @"uid" : @"123423",
                                  //                                      @"telphone" :@"13912345678"
                                  //                                      },
                                  //                                  @{
                                  //                                      @"notice_id":@"108",
                                  //                                      @"class_type":@"syncNoticeTarget",
                                  //                                      @"title":@"对您同步项目",
                                  //                                      @"members_head_pic":@[
                                  //                                              @"pic1.png"
                                  //                                              ],
                                  //                                      @"date":@"2016-02-21",
                                  //                                      @"user_name":@"代强1",
                                  //                                      @"pro_name":@"龙湖3432清波、龙湖三千里、大碗454村",
                                  //                                      @"source_pro_id":@"0,3,6",
                                  //                                      @"uid" : @"12354653",
                                  //                                      @"telphone" :@"13912345678"
                                  //                                      },
                                  //                                  //对您同步项目
                                  //                                  @{
                                  //                                      @"notice_id":@"107",
                                  //                                      @"class_type":@"syncNoticeTarget",
                                  //                                      @"title":@"对您同步项目",
                                  //                                      @"members_head_pic":@[
                                  //                                              @"pic1.png"
                                  //                                              ],
                                  //                                      @"date":@"2016-02-21",
                                  //                                      @"user_name":@"代强2",
                                  //                                      @"pro_name":@"龙湖34清波、龙湖4545三千里、大碗村",
                                  //                                      @"source_pro_id":@"0,3,6",
                                  //                                      @"uid" : @"123543434",
                                  //                                      @"telphone" :@"13912345678"
                                  //                                      },
                                  //                                  @{
                                  //                                      @"notice_id":@"106",
                                  //                                      @"class_type":@"syncNoticeTarget",
                                  //                                      @"title":@"对您同步项目",
                                  //                                      @"members_head_pic":@[
                                  //                                              @"pic1.png"
                                  //                                              ],
                                  //                                      @"date":@"2016-02-21",
                                  //                                      @"user_name":@"代强3",
                                  //                                      @"pro_name":@"龙湖34波1、龙34湖4354三千里2、大碗村3",
                                  //                                      @"source_pro_id":@"0,3,6",
                                  //                                      @"uid" : @"1242434",
                                  //                                      @"telphone" :@"13912345678"
                                  //                                      },
                                  //                                  @{
                                  //                                      @"notice_id":@"106",
                                  //                                      @"class_type":@"syncNoticeTarget",
                                  //                                      @"title":@"对您同步项目",
                                  //                                      @"members_head_pic":@[
                                  //                                              @"pic1.png"
                                  //                                              ],
                                  //                                      @"date":@"2016-02-21",
                                  //                                      @"user_name":@"代强4",
                                  //                                      @"pro_name":@"龙湖清波1、龙湖43er三千里2、大碗村347",
                                  //                                      @"source_pro_id":@"0,3,6",
                                  //                                      @"uid" : @"346565656",
                                  //                                      @"telphone" :@"13912345678"
                                  //                                      }
                                  //                                  ,
                                  //                                  //讨论组拆分
                                  //                                  @{
                                  //                                      @"notice_id":@"104",
                                  //                                      @"class_type":@"syncProject",
                                  //                                      @"title":@"要求同步项目2",
                                  //                                      @"members_head_pic":@[
                                  //                                              @"pic1.png"
                                  //                                              ],
                                  //                                      @"date":@"2016-10-10",
                                  //                                      @"user_name":@"张扬34",
                                  //                                      @"telphone" :@"13912345678"
                                  //                                      }
                                  //
                                  //                                  ,
                                  //
                                  //                                  //讨论组拆分
                                  //                                  @{
                                  //                                      @"notice_id":@"104t45",
                                  //                                      @"class_type":@"syncProject",
                                  //                                      @"title":@"要求同步项目2454",
                                  //                                      @"members_head_pic":@[
                                  //                                              @"pic1.png"
                                  //                                              ],
                                  //                                      @"date":@"2016-10-10",
                                  //                                      @"user_name":@"张扬34rtrt",
                                  //                                      @"telphone" :@"13912345678"
                                  //                                      }
                                  //                                  ,
                                  //
                                  //                                  //讨论组拆分
                                  //                                  @{
                                  //                                      @"notice_id":@"104r5445",
                                  //                                      @"class_type":@"syncProject",
                                  //                                      @"title":@"要求同步项目343454",
                                  //                                      @"members_head_pic":@[
                                  //                                              @"pic1.png"
                                  //                                              ],
                                  //                                      @"date":@"2016-11-10",
                                  //                                      @"user_name":@"张扬",
                                  //                                      @"telphone" :@"13912345678"
                                  //                                      }
                                  //                                  ,
                                  //                                  //新记账
                                  //                                  @{
                                  //                                      @"notice_id":@"21",
                                  //                                      @"class_type":@"newBilling",
                                  //                                      @"title":@"新记账人",
                                  //                                      @"members_head_pic":@[
                                  //                                              @"pic1.png"
                                  //                                              ],
                                  //                                      @"date":@"2016-12-25",
                                  //                                      @"user_name":@"张扬",
                                  //                                      @"telphone" :@"13912345678"
                                  //                                      }
                                  //                                  
                                  //                                  ,
                                  //                                  
                                  //                                  //新记账
                                  //                                  @{
                                  //                                      @"notice_id":@"24",
                                  //                                      @"class_type":@"newBilling",
                                  //                                      @"title":@"新记账人343",
                                  //                                      @"members_head_pic":@[
                                  //                                              @"pic1.png"
                                  //                                              ],
                                  //                                      @"date":@"2016-12-26",
                                  //                                      @"user_name":@"张为",
                                  //                                      @"telphone" :@"13912345678"
                                  //                                      },
                                  
                                  //过期提醒
                                  
                                  @{
                                      @"notice_id":@"2343545",
                                      @"class_type":@"syncGroupToGroup",
                                      @"title":@"记工同步请求",
                                      @"members_head_pic":@[
                                              @"pic1.png"
                                              ],
                                      @"date":@"2016-02-21",
                                      @"user_name":@"代强4",
                                      @"pro_name":@"龙湖清波1、龙湖43er三千里2、大碗村347",
                                      @"source_pro_id":@"0,3,6",
                                      @"uid" : @"346565656",
                                      @"telphone" :@"13912345678",
                                      @"des" : @"王伟（班组长）向你请求同步记工记账数据"
                                      }
                                  
                                  ,
                                  
                                  @{
                                      @"notice_id":@"213123",
                                      @"class_type":@"syncedSyncGroupToGroup",
                                      @"title":@"记工同步通知",
                                      @"members_head_pic":@[
                                              @"pic1.png"
                                              ],
                                      @"date":@"2016-11-10",
                                      @"user_name":@"张扬",
                                      @"telphone" :@"13912345678",
                                      @"des" : @"王伟向你同步了记工记账数据"
                                      },
                                  
//                                  @{
//                                      @"notice_id":@"1232213",
//                                      @"class_type":@"syncNoticeTarget",
//                                      @"title":@"对您同步项目",
//                                      @"members_head_pic":@[
//                                              @"pic1.png"
//                                              ],
//                                      @"date":@"2016-02-21",
//                                      @"user_name":@"代强4",
//                                      @"pro_name":@"龙湖清波1、龙湖43er三千里2、大碗村347",
//                                      @"source_pro_id":@"0,3,6",
//                                      @"uid" : @"346565656",
//                                      @"telphone" :@"13912345678"
//                                      },
                                  
//                                  @{
//                                      @"notice_id":@"1123",
//                                      @"class_type":@"syncNoticeTarget",
//                                      @"title":@"对您同步项目",
//                                      @"members_head_pic":@[
//                                              @"pic1.png"
//                                              ],
//                                      @"date":@"2016-02-21",
//                                      @"user_name":@"代强4",
//                                      @"pro_name":@"龙湖清波1、龙湖43er三千里2、大碗村347",
//                                      @"source_pro_id":@"0,3,6",
//                                      @"uid" : @"346565656",
//                                      @"telphone" :@"13912345678"
//                                      },
                                  
                                  @{
                                      @"notice_id":@"213123",
                                      @"class_type":@"syncProject",
                                      @"title":@"要求同步项目343454",
                                      @"members_head_pic":@[
                                              @"pic1.png"
                                              ],
                                      @"date":@"2016-11-10",
                                      @"user_name":@"张扬",
                                      @"telphone" :@"13912345678"
                                      }
                                  ,
                                  
//                                @{
//                                    @"notice_id":@"1232213",
//                                    @"class_type":@"syncNoticeTarget",
//                                    @"title":@"对您同步项目",
//                                    @"members_head_pic":@[
//                                            @"pic1.png"
//                                            ],
//                                    @"date":@"2016-02-21",
//                                    @"user_name":@"代强4",
//                                    @"pro_name":@"龙湖清波1、龙湖43er三千里2、大碗村347",
//                                    @"source_pro_id":@"0,3,6",
//                                    @"uid" : @"346565656",
//                                    @"telphone" :@"13912345678"
//                                    }
//                                    ,
//
//                                  @{
//                                        @"notice_id":@"13546",
//                                        @"class_type":@"syncProject",
//                                        @"title":@"要求同步项目343454",
//                                        @"members_head_pic":@[
//                                                @"pic1.png"
//                                                ],
//                                        @"date":@"2016-11-10",
//                                        @"user_name":@"张扬",
//                                        @"telphone" :@"13912345678"
//                                        },
//
//                                  @{
//                                      @"notice_id":@"9",
//                                      @"class_type":@"serviceExpiredNotice",
//                                      @"title":@"高级版即将过期",
//                                      @"members_head_pic":@[
//                                              @"pic1.png"
//                                              ],
//                                      @"date":@"2016-12-26",
//                                      @"user_name":@"张为",
//
//                                      @"info"  : @"“一号车”的黄金服务版有效期还剩15天，为了不影响正常使用，请及时续订。",
//
//                                      @"telphone" :@"13912345678",
//
//                                      @"group_id" : @"2",
//                                      },
//
//                                  @{
//                                      @"notice_id":@"86",
//                                      @"class_type":@"cloudExpiredNotice",
//                                      @"title":@"云盘过期",
//                                      @"members_head_pic":@[
//                                              @"pic1.png"
//                                              ],
//                                      @"date":@"2016-12-26",
//                                      @"user_name":@"张为",
//
//                                      @"info"  : @"“ 人数上线5人”的黄金服务版有效期还剩15天，为了不影响正常使用，请及时续订。",
//                                      @"group_id" : @"86",
//                                      @"telphone" :@"13912345678"
//                                      },
//
//                                  @{
//                                      @"notice_id":@"23434",
//                                      @"class_type":@"cloud_lack",
//                                      @"title":@"云盘不足",
//                                      @"members_head_pic":@[
//                                              @"pic1.png"
//                                              ],
//                                      @"date":@"2016-12-26",
//                                      @"user_name":@"张为",
//
//                                      @"info"  : @"“555666”的黄金服务版有效期还剩15天，为了不影响正常使用，请及时续订。",
//                                      @"group_id" : @"163",
//
//                                      @"telphone" :@"13912345678"
//                                      },
//
//                                  @{
//                                      @"notice_id":@"564342343",
//                                      @"class_type":@"superior_work_leader",
//                                      @"title":@"班组长认证审核通知",
//                                      @"members_head_pic":@[
//                                              @"pic1.png"
//                                              ],
//                                      @"date":@"2016-12-26",
//                                      @"user_name":@"张为",
//
//                                      @"info"  : @"恭喜你通过了班组长认证！点击查看认证详情",
//                                      @"group_id" : @"86",
//                                      @"telphone" :@"13912345678"
//                                      },
//
//                                  @{
//                                      @"notice_id":@"22343434",
//                                      @"class_type":@"work_leader_certify",
//                                      @"title":@"班组长认证审核通知",
//                                      @"members_head_pic":@[
//                                              @"pic1.png"
//                                              ],
//                                      @"date":@"2016-12-26",
//                                      @"user_name":@"张为",
//
//                                      @"info"  : @"你申请的认证已被拒绝！点击查看认证详情",
//                                      @"group_id" : @"163",
//
//                                      @"telphone" :@"13912345678"
//                                      },
//
//                                  @{
//                                      @"notice_id":@"23452",
//                                      @"class_type":@"superior_work_leader",
//                                      @"title":@"优质班组长推荐通知",
//                                      @"members_head_pic":@[
//                                              @"pic1.png"
//                                              ],
//                                      @"date":@"2016-12-26",
//                                      @"user_name":@"张为",
//
//                                      @"info"  : @"你已被平台推荐为优质班组长！点击查看详情",
//                                      @"group_id" : @"86",
//                                      @"telphone" :@"13912345678"
//                                      },
//
//                                  @{
//                                      @"notice_id":@"22343434",
//                                      @"class_type":@"work_leader_certify",
//                                      @"title":@"优质工人推荐通知",
//                                      @"members_head_pic":@[
//                                              @"pic1.png"
//                                              ],
//                                      @"date":@"2016-12-26",
//                                      @"user_name":@"张为",
//
//                                      @"info"  : @"你已被平台推荐为优质工人！切换班组长身份可查看",
//                                      @"group_id" : @"163",
//
//                                      @"telphone" :@"13912345678"
//                                      }
                                  
                                  
                                  ],
                          
                          
                          };
    
    NSArray *dataSource = [JGJNewNotifyModel mj_objectArrayWithKeyValuesArray:dic[@"values"]];
    
    self.dataSource = dataSource;
    
//
//    self.dataSource = [JGJNewNotifyTool allNotifies];
//    if (self.dataSource.count == 0) {
//        for (JGJNewNotifyModel *newNotifyModel in dataSource) {
//            [JGJNewNotifyTool addCollectNotifies:newNotifyModel];
//        }
//    }
//    self.dataSource = [JGJNewNotifyTool allNotifies];
}


@end
