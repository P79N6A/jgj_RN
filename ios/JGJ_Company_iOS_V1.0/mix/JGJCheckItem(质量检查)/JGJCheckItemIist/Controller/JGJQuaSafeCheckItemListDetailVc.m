//
//  JGJQuaSafeCheckItemListDetailVc.m
//  JGJCompany
//
//  Created by yj on 2017/11/21.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQuaSafeCheckItemListDetailVc.h"

#import "JGJQuaSafeCheckRecordCell.h"

#import "JGJQuaSafeCheckUnDealRecordCell.h"

#import "JGJQuaSafeCheckResultVc.h"

#import "JGJQuaCheckRecordHeaderView.h"

#import "JGJQuaSafeCheckRectVc.h"

#import "NSString+Extend.h"

#import "JGJQualityDetailVc.h"

#import "JGJCheckPhotoTool.h"

#import "JGJCustomPopView.h"

#import "JGJCheckPalnDetailExecuTimeCell.h"

#import "JGJCheckPlanCommonCell.h"

#import "JGJCustomLable.h"

#import "MJRefresh.h"

#import "JGJCheckModifyResultView.h"

#import "JGJQuaSafeCheckContentHeaderView.h"

#import "JGJQuaSafeCheckPathVc.h"

#import "JGJTaskViewController.h"

@interface JGJQuaSafeCheckItemListDetailVc () <

    UITableViewDelegate,

    UITableViewDataSource,

    JGJQuaSafeCheckRecordCellDelegate,

    JGJQuaSafeCheckUnDealRecordCellDelegate,

    JGJQuaSafeCheckContentHeaderViewDelegate

>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSIndexPath *lastIndexPath;

@property (nonatomic, strong) JGJQuaCheckRecordHeaderView *headerView;

//记录处理了的分项记录
@property (nonatomic, strong) JGJInspectPlanProInfoDotListModel *expandRecordListModel;

@property (nonatomic, strong) UIView *contentHeaderView;

@property (nonatomic, strong) JGJInspectPlanProInfoModel *proInfoModel;

//头部信息模型名称和位置
@property (nonatomic, strong) NSMutableArray *headerCommonModels;
@end

@implementation JGJQuaSafeCheckItemListDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"检查项";
    
    [self initialSubView];
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNetData)];
    
    self.tableView.estimatedRowHeight = 0;
    
    self.tableView.estimatedSectionHeaderHeight = 0;
    
    self.tableView.estimatedSectionFooterHeight = 0;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
//    [self.tableView.mj_header beginRefreshing];
    
    [self loadNetData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1 + self.proInfoModel.content_list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = 0;
    
    if (section == 0) {
        
        count = self.headerCommonModels.count;
        
    }else {
        
        JGJInspectPlanProInfoContentListModel *checkItemModel = self.proInfoModel.content_list[section - 1];
        
        count = !checkItemModel.isExpand ? 0 : checkItemModel.dot_list.count;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        
        cell = [self registerHeaderTableView:tableView cellForRowAtIndexPath:indexPath];
        
    }else {
        
        cell = [self registerCheckContentTableView:tableView cellForRowAtIndexPath:indexPath];
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CGFloat height = 50.0;
    
    if (section == 0) {
        
        height = CGFLOAT_MIN;
        
    }
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    JGJQuaSafeCheckContentHeaderView *headerVeiw = nil;
    
    if (section > 0) {
        
        headerVeiw = [JGJQuaSafeCheckContentHeaderView checkContentHeaderViewWithTableView:tableView];
        
        headerVeiw.delegate = self;
        
        JGJInspectPlanProInfoContentListModel *checkItemModel = self.proInfoModel.content_list[section - 1];
        
        headerVeiw.checkItemModel = checkItemModel;
    }
    
    return  headerVeiw;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    static NSString *resueId = @"JGJQuaSafeCheckContentFooterView";
    
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:resueId];
    
    if (!footerView) {
        
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:resueId];
    }
    
    footerView.contentView.backgroundColor = AppFontf1f1f1Color;
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    CGFloat height = 10.0;
    
    if (section == 0) {
        
        height = CGFLOAT_MIN;
        
    }
    
    return height;
}

#pragma mark - 注册头部cell标题、位置
- (UITableViewCell *)registerHeaderTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    JGJCheckPlanCommonCell *headerCell = [JGJCheckPlanCommonCell cellWithTableView:tableView];
    
    headerCell.commonModel = self.headerCommonModels[indexPath.row];
    
//    headerCell.lineView.hidden = indexPath.row == self.headerCommonModels.count - 1;
    
    return headerCell;
}

#pragma mark - 注册检查内容
- (UITableViewCell *)registerCheckContentTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJInspectPlanProInfoContentListModel *checkItemModel = self.proInfoModel.content_list[indexPath.section - 1];
    
    JGJInspectPlanProInfoDotListModel *checkDotListModel = checkItemModel.dot_list[indexPath.row];
    
    JGJInspectPlanProInfoDotReplyModel *replyModel = [JGJInspectPlanProInfoDotReplyModel new];
    
    if (checkDotListModel.dot_status_list.count > 0) {
        
        replyModel = checkDotListModel.dot_status_list.firstObject;
        
        checkDotListModel.status = replyModel.status;
        
        replyModel.is_operate = checkDotListModel.is_operate;
    }
    
    checkDotListModel.content_name = checkItemModel.content_name;
    
    checkDotListModel.content_id = checkItemModel.content_id;
    
    UITableViewCell *cell = nil;

    if (![checkDotListModel.status isEqualToString:@"0"]) {
        
        JGJQuaSafeCheckRecordCell *recordCell = [JGJQuaSafeCheckRecordCell cellWithTableView:tableView];
        
        recordCell.delegate = self;
        
        recordCell.listModel = checkDotListModel;
        
//        recordCell.lineView.hidden = checkItemModel.dot_list.count - 1 == indexPath.row;
        
        cell = recordCell;
        
    }else {
        
        JGJQuaSafeCheckUnDealRecordCell *unDealRecordCell = [JGJQuaSafeCheckUnDealRecordCell cellWithTableView:tableView];
        
        unDealRecordCell.delegate = self;
        
        unDealRecordCell.listModel = checkDotListModel;
                
//        unDealRecordCell.lineView.hidden = checkItemModel.dot_list.count - 1 == indexPath.row;
        
        cell = unDealRecordCell;
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 0;
    
    if (indexPath.section == 0) {

        height = indexPath.row == self.headerCommonModels.count - 1 ? 36.0 : 50.0;

    }else {
        
        JGJInspectPlanProInfoContentListModel *checkItemModel = self.proInfoModel.content_list[indexPath.section - 1];
        
        JGJInspectPlanProInfoDotListModel *listModel = checkItemModel.dot_list[indexPath.row];
        
        TYLog(@"heightForRow === %@  isExPand === %@  dot_id=%@", @(listModel.cellHeight), @(listModel.isExPand), listModel.dot_id);
        
        height = listModel.isExPand ? listModel.cellHeight : listModel.shrinkHeight;
        
    }

    return height;
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 150.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

#pragma mark - JGJQuaSafeCheckRecordCellDelegate

- (void)quaSafeCheckRecordCell:(JGJQuaSafeCheckRecordCell *)cell selectedListModel:(JGJInspectPlanProInfoDotListModel *)listModel buttonType:(QuaSafeDealResultViewButtonType)buttonType{
    
    if (self.proListModel.isClosedTeamVc) {
        
        [JGJComTool showCloseProPopViewWithClasstype:self.proListModel.class_type];
        
        return;
    }
    
    //记录点击的模型用于返回展开用
    self.expandRecordListModel = listModel;
    
    switch (buttonType) {
        case QuaSafeDealedResultViewcheckDetailButtonType:{
            
            JGJInspectPlanProInfoDotReplyModel *replyModel = nil;
            
            if (listModel.dot_status_list.count > 0) {
                
                replyModel = [listModel.dot_status_list firstObject];
            }
            
            if ([replyModel.msg_type isEqualToString:@"task"]) {
                
                [self checkTaskDetailWithReplyModel:replyModel];
                
            }else {
                
                [self checkQuaSafeDetailWithReplyModel:replyModel];
            }
        }
            
            break;
        case QuaSafeDealedResultViewModifyResultButtonType:{
            
            JGJCheckModifyResultViewModel *resultViewModel = [JGJCheckModifyResultViewModel new];
            
            JGJInspectPlanProInfoDotReplyModel *replyModel = nil;
            
            if (listModel.dot_status_list.count > 0) {
                
                replyModel = listModel.dot_status_list.firstObject;
            }
            
            resultViewModel.buttonType = [NSString stringWithFormat:@"%@", replyModel.status].integerValue;
            
            JGJCheckModifyResultView *resultView = [JGJCheckModifyResultView showWithMessage:resultViewModel];
            
            __weak typeof(self) weakSelf = self;
            
           __block JGJCheckModifyResultViewButtontype selModifyResultViewButtontype = resultViewModel.buttonType;
            
            resultView.modifyresultViewBlock = ^(JGJCheckModifyResultViewButtontype modifyResultViewButtontype) {
              
                selModifyResultViewButtontype = modifyResultViewButtontype;
            };
            
            resultView.confirmButtonBlock = ^{

                if (selModifyResultViewButtontype == JGJCheckModifyResultViewModifyButtontype) {
                    
                    [weakSelf selModifyButtonPressed:selModifyResultViewButtontype listModel:listModel];
                    
                }else {
                    
                    [weakSelf selModifyResultVcWithButtonType:selModifyResultViewButtontype listModel:listModel];
                    
                }

            };
        }
            
            break;
        
        case QuaSafeDealedResultViewCheckRecordButtonType:{
            
            JGJQuaSafeCheckPathVc *checkPathVc = [JGJQuaSafeCheckPathVc new];
            
            checkPathVc.listModel = listModel;
            
            [self.navigationController pushViewController:checkPathVc animated:YES];
            
        }
            
            break;
        
        default:
            break;
    }
    
}

#pragma mark - 查看任务详情
- (void)checkTaskDetailWithReplyModel:(JGJInspectPlanProInfoDotReplyModel *)replyModel {
    
    JGJChatMsgListModel *jgjChatListModel = [JGJChatMsgListModel new];
    
    jgjChatListModel.class_type = self.proInfoModel.class_type?:@"";;
    
    jgjChatListModel.group_id = self.proInfoModel.group_id?:@"";;
    
    jgjChatListModel.msg_type = replyModel.msg_type?:@"";
    
    jgjChatListModel.msg_id = replyModel.msg_id?:@"";
    
    JGJTaskViewController *taskVC = [JGJTaskViewController new];
    
    taskVC.taskDetail = YES;
    
    taskVC.jgjChatListModel = jgjChatListModel;
    
    [self.navigationController pushViewController:taskVC animated:YES];
}

#pragma mark - 质量安全详情页

- (void)checkQuaSafeDetailWithReplyModel:(JGJInspectPlanProInfoDotReplyModel *)replyModel {
    
    JGJQualityDetailVc *detailVc = [[JGJQualityDetailVc alloc] init];
    
    JGJQualitySafeListModel *detailListModel = [JGJQualitySafeListModel new];
    
    detailVc.proListModel = self.proListModel;
    
    detailListModel.msg_id = replyModel.msg_id;
    
    detailListModel.msg_type = replyModel.msg_type;
    
    detailVc.listModel = detailListModel;
    
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark - 进入对应通过和不用检查页面
- (void)selModifyResultVcWithButtonType:(JGJCheckModifyResultViewButtontype)buttontype listModel:(JGJInspectPlanProInfoDotListModel *)listModel {
    
    JGJQuaSafeCheckResultVc *checkResultVc = [JGJQuaSafeCheckResultVc new];
    //
    checkResultVc.dotListModel = listModel;
    
    checkResultVc.buttonType = buttontype;
    
    checkResultVc.proInfoModel = self.proInfoModel;
    
    [self.navigationController pushViewController:checkResultVc animated:YES];
}

#pragma mark - 待整改页面
- (void)selModifyButtonPressed:(JGJCheckModifyResultViewButtontype)buttontype listModel:(JGJInspectPlanProInfoDotListModel *)listModel {
    
    JGJQuaSafeCheckRectVc *recordVc = [[JGJQuaSafeCheckRectVc alloc] init];
    
    recordVc.commonModel = self.commonModel;
    
    recordVc.proListModel = self.proListModel;
    
    recordVc.proInfoModel = self.proInfoModel;
    
    recordVc.dotListModel = listModel;
    
    [self.navigationController pushViewController:recordVc animated:YES];
}

- (void)handelCheckRecordModel:(JGJQuaSafeCheckRecordListModel *)listModel {
    
    JGJQuaSafeCheckRecordReplyModel *replyModel = nil;
    
    if (listModel.reply_list.count > 0) {
        
        replyModel = [listModel.reply_list firstObject];
    }
    
    NSDictionary *parameters = @{@"reply_id" : replyModel.replyId?:@""};
    [JLGHttpRequest_AFN PostWithApi:@"v2/quality/delReplayInspectInfo" parameters:parameters success:^(id responseObject) {
        

        [self loadNetData];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)quaSafeCheckRecordCell:(JGJQuaSafeCheckRecordCell *)cell {
    
    [self freshIndexPathCell:cell];
}

#pragma mark - JGJQuaSafeCheckUnDealRecordCellDelegate
- (void)quaSafeCheckUnDealRecordCell:(JGJQuaSafeCheckUnDealRecordCell *)cell selectedListModel:(JGJInspectPlanProInfoDotListModel *)listModel buttonType:(QuaSafeUnDealedResultViewButtonType)buttonType {
    
    if (self.proListModel.isClosedTeamVc) {
        
        [JGJComTool showCloseProPopViewWithClasstype:self.proListModel.class_type];
        
        return;
    }
    
    listModel.buttonType = buttonType;
    
    //记录点击的模型用于返回展开用
    self.expandRecordListModel = listModel;

    switch (buttonType) {
        case QuaSafeUnDealedResultViewUnRelationButtonType:{
            
            [self selModifyResultVcWithButtonType:JGJCheckModifyResultViewUnCheckButtontype listModel:listModel];
        }
            
            break;
        case QuaSafeUnDealedResultViewModifyButtonType:{
            
            [self selModifyButtonPressed:JGJCheckModifyResultViewModifyButtontype listModel:listModel];
            
        }
            break;
        case QuaSafeUnDealedResultViewPassButtonType:{
            
            [self selModifyResultVcWithButtonType:JGJCheckModifyResultViewPassButtontype listModel:listModel];
            
        }
            
            break;
        default:
            break;
    }
    
}

#pragma mark - JGJDetailThumbnailCellDelegate

- (void)detailThumbnailCell:(JGJQuaSafeCheckRecordCell *)cell imageViews:(NSArray *)imageViews didSelectedIndex:(NSInteger)index {
    
    JGJInspectPlanProInfoDotReplyModel *replyModel = nil;

    if (cell.listModel.dot_status_list.count > 0) {

        replyModel = [cell.listModel.dot_status_list firstObject];

        [JGJCheckPhotoTool browsePhotoImageView:replyModel.imgs selImageViews:imageViews didSelPhotoIndex:index];
    }
    
}

- (void)quaSafeCheckUnDealRecordCell:(JGJQuaSafeCheckUnDealRecordCell *)cell {
    
    [self freshIndexPathCell:cell];
}

- (void)freshIndexPathCell:(UITableViewCell *)cell {
    
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//
//    NSIndexPath *temp = self.lastIndexPath;
    
//    if(temp && temp != indexPath) {
    
//        JGJInspectPlanProInfoContentListModel *checkItemModel = self.proInfoModel.content_list[self.lastIndexPath.section - 1];
//
//        JGJInspectPlanProInfoDotListModel *lastListModel = checkItemModel.dot_list[self.lastIndexPath.row];
//
//        lastListModel.isExPand = NO;
        
//        [self.tableView beginUpdates];
//        
//        [self.tableView reloadRowsAtIndexPaths:@[temp] withRowAnimation:UITableViewRowAnimationFade];
//        
//        [self.tableView endUpdates];
//    }
    //选中的修改为当前行
    
//    self.lastIndexPath = indexPath;
    
//    [self.tableView beginUpdates];
//
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//
//    [self.tableView endUpdates];
    
    [self.tableView reloadData];
    
}

- (void)JGJQuaSafeCheckContentHeaderView:(JGJQuaSafeCheckContentHeaderView *)header checkItemModel:(JGJInspectPlanProInfoContentListModel *)checkItemModel {
    
    [self.tableView reloadData];
    
}

- (void)loadNetData {
    
    NSDictionary *parameters = @{ @"pro_id": self.checkItemModel.pro_id?:@"",
                                 
                                 @"plan_id": self.checkItemModel.plan_id?:@""
                                 
                                 };
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/inspect/getPlanProInfo" parameters:parameters success:^(id responseObject) {
        
        self.proInfoModel = [JGJInspectPlanProInfoModel mj_objectWithKeyValues:responseObject];
        
        if ([NSString isEmpty:self.proInfoModel.plan_id]) {
            
            self.proInfoModel.plan_id = self.checkItemModel.plan_id;
        }
        
        [self.tableView.mj_header endRefreshing];
        
        [TYLoadingHub hideLoadingView];
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
}

- (void)setProInfoModel:(JGJInspectPlanProInfoModel *)proInfoModel {
    
    _proInfoModel = proInfoModel;
    
    [self setTopCheckItemWithProInfoModel:proInfoModel];
    
    if (![NSString isEmpty:self.expandRecordListModel.dot_id]) {
        
        JGJInspectPlanProInfoDotReplyModel *replyModel = [JGJInspectPlanProInfoDotReplyModel new];
        
        if (self.expandRecordListModel.dot_status_list.count > 0) {
            
            replyModel = self.expandRecordListModel.dot_status_list.firstObject;
            
        }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@==dot_id", self.expandRecordListModel.dot_id];
        
        for (JGJInspectPlanProInfoContentListModel *contentListModel in proInfoModel.content_list) {
            
            NSArray *replyModels =  [contentListModel.dot_list filteredArrayUsingPredicate:predicate];
            
            if (replyModels.count > 0) {
                
                JGJInspectPlanProInfoDotListModel *replyModel = replyModels.firstObject;
                
                replyModel.isExPand = YES;
                
                contentListModel.isExpand = YES;
                
                break;
            }
            
        }

    }
    
    [self.tableView reloadData];
}

- (void)setTopCheckItemWithProInfoModel:(JGJInspectPlanProInfoModel *)proInfoModel {
    
    UIColor *statusColor = AppFont999999Color;
    
    NSString *status = @"[未检查]";
    
    if ([proInfoModel.status isEqualToString:@"0"]) {
        
        status = @"[未检查]";
        
    }else if ([proInfoModel.status isEqualToString:@"1"]) {
        
        statusColor = AppFontFF0000Color;
        
        status = @"[待整改]";

    }else if ([proInfoModel.status isEqualToString:@"2"]) {
        
        status = @"[不用检查]";
        
    }else if ([proInfoModel.status isEqualToString:@"3"]) {
        
        statusColor = AppFont83C76EColor;
        
        status = @"[通过]";
    }
    
    NSInteger count = [NSString isEmpty:proInfoModel.location_text] ? 1 : 2;
    
    _headerCommonModels = [NSMutableArray new];
    
    for (NSInteger index = 0; index < count; index++) {
        
        JGJCheckPlanCommonCellModel *commonModel = [JGJCheckPlanCommonCellModel new];
        
        if (index == 0) {
            
            commonModel.title = proInfoModel.pro_name;
            
            commonModel.detailTitle = status;
            
            commonModel.detailColor = statusColor;
            
        }else {
            
            commonModel.title = @"位置";
            
            commonModel.detailTitle = proInfoModel.location_text;
            
        }
        
        [_headerCommonModels addObject:commonModel];
    }
    
    JGJCheckPlanCommonCellModel *commonModel = [JGJCheckPlanCommonCellModel new];
    
    commonModel.title = @"检查内容";
    
    commonModel.contentViewBackColor = AppFontf1f1f1Color;
    
    [_headerCommonModels addObject:commonModel];
    
}

- (void)initialSubView {
    
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.bottom.mas_equalTo(self.view);
        
    }];
    
    [JGJComTool showCloseProImageViewWithTargetView:self.view classtype:self.proListModel.class_type isClose:self.proListModel.isClosedTeamVc];
    
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = AppFontf1f1f1Color;
    }
    
    return _tableView;
    
}

@end

