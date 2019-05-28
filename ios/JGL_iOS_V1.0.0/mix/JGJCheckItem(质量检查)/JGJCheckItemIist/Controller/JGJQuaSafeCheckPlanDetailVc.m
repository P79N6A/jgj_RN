//
//  JGJQuaSafeCheckPlanDetailVc.m
//  JGJCompany
//
//  Created by yj on 2017/11/21.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQuaSafeCheckPlanDetailVc.h"

#import "JGJCheckPlanDetailTitleCell.h"

#import "JGJCheckPalnDetailExecuTimeCell.h"

#import "JGJTeamMemberCell.h"

#import "JGJCheckPlanDetailListCell.h"

#import "JGJCustomLable.h"

#import "JGJPerInfoVc.h"

#import "JGJCusActiveSheetView.h"

#import "JGJQuaSafeCheckItemListDetailVc.h"

#import "MJRefresh.h"

#import "JGJCustomPopView.h"

#import "JGJCheckPlanViewController.h"

#import "UILabel+GNUtil.h"
#import "CFRefreshStatusView.h"
typedef enum : NSUInteger {
    
    JGJQuaSafeCheckPlanDetailTitleCellType,
    
    JGJQuaSafeCheckPlanDetailExecuTimeCellType,
    
    JGJQuaSafeCheckPlanDetailExecuMemberCellType,
    
    JGJQuaSafeCheckPlanDetailListCellType
    
} JGJQuaSafeCheckPlanDetailCellType;

@interface JGJQuaSafeCheckPlanDetailVc ()

<
    UITableViewDataSource,

    UITableViewDelegate,

    JGJTeamMemberCellDelegate
>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JGJInspectListDetailModel *inspectListDetailModel;

@end

@implementation JGJQuaSafeCheckPlanDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"检查计划";
    
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadInspectDeailNetData)];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSUInteger count = 1;
    
    switch (section) {
            
        case JGJQuaSafeCheckPlanDetailTitleCellType:
        case JGJQuaSafeCheckPlanDetailExecuTimeCellType:
        case JGJQuaSafeCheckPlanDetailExecuMemberCellType:{
            
            count = 1;
        }
            break;
            
        case JGJQuaSafeCheckPlanDetailListCellType:{
            
            count = self.inspectListDetailModel.pro_list.count;
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
        case JGJQuaSafeCheckPlanDetailTitleCellType:{
            
            cell = [self registerCheckPlanTitleTableView:tableView didSelectRowAtIndexPath:indexPath];
        }

            break;
            
        case JGJQuaSafeCheckPlanDetailExecuTimeCellType:{
            
            cell = [self registerExecuTimeTableView:tableView didSelectRowAtIndexPath:indexPath];
        }
            
            break;
            
        case JGJQuaSafeCheckPlanDetailExecuMemberCellType:{
            
            cell = [self registerExecuMemberTableView:tableView didSelectRowAtIndexPath:indexPath];
        }
            
            break;
            
        case JGJQuaSafeCheckPlanDetailListCellType:{
            
            cell = [self registerCheckPlanListTableView:tableView didSelectRowAtIndexPath:indexPath];
        }
            
            break;
            
        default:
            break;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *heights = @[@(45.0), @(45.0), @(100), @(115)];
    
    CGFloat height = [heights[indexPath.section] floatValue];
    
    if (indexPath.section == JGJQuaSafeCheckPlanDetailExecuMemberCellType) {
        
        height = [JGJTeamMemberCell calculateCollectiveViewHeight:self.inspectListDetailModel.member_list headerHeight:CheckPlanHeaderHegiht];
        
    }else if (indexPath.section == JGJQuaSafeCheckPlanDetailListCellType) {
        
        JGJInspectListDetailCheckItemModel *checkItemModel = self.inspectListDetailModel.pro_list[indexPath.row];
        
        if (([NSString isEmpty:checkItemModel.update_time] && [NSString isEmpty:checkItemModel.real_name])) {
            
            height -= 17;
            
        }
    }
    
    return height;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CGFloat height = 36.0;
    
    JGJCustomLable *headerLable = [[JGJCustomLable alloc] initWithFrame:CGRectMake(10, 0, 120, height)];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, height)];
    
    contentView.backgroundColor = AppFontf1f1f1Color;
    
    [contentView addSubview:headerLable];
    
    headerLable.textInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    
    headerLable.backgroundColor = AppFontf1f1f1Color;
    
    headerLable.textColor = AppFont333333Color;
    
    headerLable.font = [UIFont systemFontOfSize:AppFont30Size];
    
    NSArray *headerTiltes = @[@"", @"执行时间", @"执行人（点击头像可查看）", @"检查项"];
    
    if (section > 0 && section < headerTiltes.count) {
        
        headerLable.text = headerTiltes[section];
        
        if (section == 2) {
            
            [headerLable markText:@"（点击头像可查看）" withColor:AppFont999999Color];
            
        }else if (section == 3) {
            
            if (self.inspectListDetailModel.pro_list.count == 0) {
                
                headerLable.text = @"";
                
            }
        }
    }
    
    headerLable.backgroundColor = AppFontf1f1f1Color;
    
    return headerLable;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CGFloat height = 35.0;
    
    if (section == 0) {
        
        height = CGFLOAT_MIN;
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 3) {
        
        JGJQuaSafeCheckItemListDetailVc *detailVc = [JGJQuaSafeCheckItemListDetailVc new];
        
        detailVc.proListModel = self.proListModel;
        
        JGJInspectListDetailCheckItemModel *checkItemModel = self.inspectListDetailModel.pro_list[indexPath.row];
        
        checkItemModel.plan_id = self.inspectListDetailModel.plan_id;
        
        detailVc.checkItemModel = checkItemModel;
        
        [self.navigationController pushViewController:detailVc animated:YES];
    }
    
}

#pragma mark - 检查计划标题
- (UITableViewCell *)registerCheckPlanTitleTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    JGJCheckPlanDetailTitleCell *cell = [JGJCheckPlanDetailTitleCell cellWithTableView:tableView];
    
    cell.inspectListDetailModel = self.inspectListDetailModel;
    
    return cell;
}

#pragma mark - 执行时间
- (UITableViewCell *)registerExecuTimeTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    JGJCheckPalnDetailExecuTimeCell *cell = [JGJCheckPalnDetailExecuTimeCell cellWithTableView:tableView];
    
    cell.inspectListDetailModel = self.inspectListDetailModel;
    
    return cell;
}

#pragma mark - 执行人
- (UITableViewCell *)registerExecuMemberTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    JGJTeamMemberCell *cell  = [JGJTeamMemberCell cellWithTableView:tableView];
    
    cell.delegate = self;
    
    cell.isCheckPlanHeader = YES; //使用当前页面的头部高度，内部只做顶部间隔调整
    
    cell.memberFlagType = DefaultTeamMemberFlagType;
    
    cell.teamMemberModels = self.inspectListDetailModel.member_list.mutableCopy;
        
    return cell;
}

#pragma mark - 检查项
- (UITableViewCell *)registerCheckPlanListTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJCheckPlanDetailListCell *cell = [JGJCheckPlanDetailListCell cellWithTableView:tableView];
    
    cell.checkItemModel = self.inspectListDetailModel.pro_list[indexPath.row];
    
    return cell;
}

#pragma mark - JGJTeamMemberCellDelegate

- (void)handleJGJTeamMemberCellUnRegisterTeamModel:(JGJTeamMemberCommonModel *)commonModel {

    JGJSynBillingModel*memberModel = commonModel.teamModelModel;
    
    JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
    
    perInfoVc.jgjChatListModel.uid = memberModel.uid;
    
    perInfoVc.jgjChatListModel.group_id = self.proListModel.group_id;
    
    perInfoVc.jgjChatListModel.class_type = self.proListModel.class_type;
    
    [self.navigationController pushViewController:perInfoVc animated:YES];

}

- (void)loadInspectDeailNetData {
    
    NSDictionary *parameter = @{@"plan_id" : self.inspectListModel.plan_id?:@""
                                };
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/inspect/getInspectPlanInfo" parameters:parameter success:^(id responseObject) {
        
        self.inspectListDetailModel = [JGJInspectListDetailModel mj_objectWithKeyValues:responseObject];
        
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
        if ([error isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)error;
            [TYShowMessage showError:dic[@"errmsg"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)setInspectListDetailModel:(JGJInspectListDetailModel *)inspectListDetailModel {
    
    _inspectListDetailModel = inspectListDetailModel;
    
    if ([inspectListDetailModel.is_operate isEqualToString:@"1"] && !self.proListModel.isClosedTeamVc) {
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemPressed)];
        
    }
    
    [self.tableView reloadData];
    
    self.tableView.hidden = NO;
}

- (void)showSheetView{
    
    NSArray *buttons = @[@"修改", @"删除",@"取消"];
    
    __weak typeof(self) weakSelf = self;
    
    JGJCusActiveSheetView *sheetView = [[JGJCusActiveSheetView alloc] initWithTitle:@"" sheetViewType:JGJCusActiveSheetViewBoldPaddingType chageColors:@[@""] buttons:buttons buttonClick:^(JGJCusActiveSheetView *sheetView, NSInteger buttonIndex, NSString *title) {
        
        if ([weakSelf.inspectListDetailModel.is_operate isEqualToString:@"1"]) {
            
            [weakSelf handleActionSheetViewWithButtonIndex:buttonIndex];
            
        }else {
            
            [weakSelf handleNormalMemberActionSheetViewWithButtonIndex:buttonIndex];
        }
        
    }];
    
    [sheetView showView];
}

#pragma mark - 普通成员等操作权限
- (void)handleNormalMemberActionSheetViewWithButtonIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:{
            
            [self shareButtonPressed];
        }
            
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 管理员等操作权限
- (void)handleActionSheetViewWithButtonIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
          
        case 0:{
            
            [self modifyButtonPressed];
        }
            
            break;
            
        case 1:{
            
            JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
            desModel.popDetail = @"是否删除该检查计划？";
            desModel.leftTilte = @"取消";
            desModel.rightTilte = @"确定";
            desModel.lineSapcing = 5.0;
            JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
            alertView.messageLable.textAlignment = NSTextAlignmentCenter;
            __weak typeof(self) weakSelf = self;
            alertView.onOkBlock = ^{
                
                [weakSelf delButtonPressed];
            };
            
        }
            
            break;
            
        case 2:
            
            break;
        default:
            break;
    }
    
}

#pragma mark - 分享按钮按下
- (void)shareButtonPressed {
    
    
}

#pragma mark - 修改按钮按下
- (void)modifyButtonPressed {
    
    JGJCheckPlanViewController *planVC = [[UIStoryboard storyboardWithName:@"JGJCheckPlanViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJCheckPlanVC"];
    planVC.inspectListDetailModel = self.inspectListDetailModel;
    
    planVC.CheckPlanType = JGJEditeCheckPlanType;
    
//    planVC.editePlan = YES;
    
    planVC.WorkproListModel = self.proListModel;
    
    [self.navigationController pushViewController:planVC animated:YES];
}

#pragma mark - 删除按钮按下
- (void)delButtonPressed {
    
    NSDictionary *parameter = @{@"plan_id" : self.inspectListModel.plan_id?:@""
                                };
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/inspect/delInspectPlan" parameters:parameter success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
    
}

- (void)rightBarButtonItemPressed {
    
    [self showSheetView];
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        CGRect rect = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - 64);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = AppFontf1f1f1Color;
        _tableView.hidden = YES;
    }
    
    return _tableView;
    
}

@end
