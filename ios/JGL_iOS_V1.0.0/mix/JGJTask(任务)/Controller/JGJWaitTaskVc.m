//
//  JGJWaitTaskVc.m
//  mix
//
//  Created by yj on 2017/5/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJWaitTaskVc.h"

#import "JGJTaskViewController.h"
#import "JGJTaskModel.h"

#import "MJRefresh.h"
#import "JGJDetailViewController.h"
#import "CFRefreshStatusView.h"

#import "JGJWaitTaskThumCell.h"

#import "NSString+Extend.h"

#import "JGJWaitTaskCell.h"

#import "JGJQualityMsgReplyListVc.h"

#import "JGJNoDataDefultView.h"

#import "JGJHelpCenterTitleView.h"

#import "JGJPublishTaskVc.h"

#define PageSize 20

@interface JGJWaitTaskVc () <

UITableViewDelegate,

UITableViewDataSource

>

@end

@interface JGJWaitTaskVc ()

@end

@implementation JGJWaitTaskVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 10)];
    
    header.backgroundColor = AppFontEBEBEBColor;
    
    self.tableView.tableHeaderView = header;
        
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadTaskListNetData)];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTaskNetData)];

    
    [self initialSubView];
    
    self.navigationItem.titleView = nil;
    
    [JGJComTool showCloseProImageViewWithTargetView:self.view classtype:self.proListModel.class_type isClose:self.proListModel.isClosedTeamVc];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.taskModels.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJTaskModel *taskModel = nil;
    
    if (self.taskModels.count > 0) {
        
        taskModel = self.taskModels[indexPath.row];
    }
    
    JGJWaitTaskCell *waitTaskCell = [JGJWaitTaskCell cellWithTableView:tableView];
    
    taskModel.waitTaskCellType = self.waitTaskCellType;
    
    waitTaskCell.taskModel = taskModel;
    
    return waitTaskCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJTaskModel *taskModel = self.taskModels[indexPath.row];
    
    JGJChatMsgListModel *msgModel = [JGJChatMsgListModel new];
    msgModel.msg_id = taskModel.task_id;
    msgModel.msg_text = taskModel.task_content;
    msgModel.task_finish_time = taskModel.task_finish_time;
    
    //发布者uid
    msgModel.uid = taskModel.pub_user_info.uid;
    msgModel.IsCloseTeam = taskModel.group_isclosed;
    
    //发布者头像
    msgModel.head_pic = taskModel.pub_user_info.head_pic;
    
    msgModel.create_time = taskModel.create_time;
    msgModel.group_id  = self.proListModel.group_id;
    msgModel.user_name = taskModel.pub_user_info.real_name;
    
    msgModel.from_group_name = self.taskListModel.from_group_name;
    msgModel.msg_src = taskModel.msg_src;
    msgModel.is_can_deal = taskModel.is_can_deal;
    msgModel.task_level = taskModel.task_level;
    msgModel.task_status = taskModel.task_status;
    msgModel.task_finish_time_type = taskModel.task_finish_time_type;
    msgModel.msg_type = @"task";
    msgModel.class_type = self.proListModel.class_type;
    
    JGJTaskViewController *taskVC = [JGJTaskViewController new];
    taskVC.taskDetail = YES;
    taskVC.jgjChatListModel = msgModel;
    
    taskVC.workProListModel = self.proListModel;
    
    [self.navigationController pushViewController:taskVC animated:YES];
    
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJTaskModel *taskModel = [JGJTaskModel new];
    
    taskModel.taskHeight = 100;
    
    if (self.taskModels.count > 0) {
        
        taskModel = self.taskModels[indexPath.row];
    }
    
    return taskModel.taskHeight;
}

#pragma mark - 加载新消息
- (void)loadTaskListNetData {
    
    [self.taskModels removeAllObjects];
    
    self.taskRequestModel.pg = 1;
    
    NSDictionary *parameter = [self.taskRequestModel mj_keyValues];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/task/taskList" parameters:parameter success:^(id responseObject) {
        
        JGJTaskListModel *taskListModel = [JGJTaskListModel mj_objectWithKeyValues:responseObject];
        
        self.taskListModel = taskListModel;
        
        [self.tableView.mj_header endRefreshing];
        
        if (taskListModel.task_list.count > 0) {
            
//            self.tableView.tableHeaderView = nil;
            
            NSRange range = NSMakeRange(0, taskListModel.task_list.count);
            
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            
            [self.taskModels insertObjects:taskListModel.task_list atIndexes:indexSet];
            
            self.taskRequestModel.pg++;
            
        }
        
        //是否显示缺省页
        [self showDefaultNoDataSource:self.taskModels];
        
        if (taskListModel.task_list.count >= PageSize) {
            
                self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTaskNetData)];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
    }];
    
}

- (void)setTaskListModel:(JGJTaskListModel *)taskListModel {
    
    _taskListModel = taskListModel;
    
}

#pragma mark - 加载更多
- (void)loadMoreTaskNetData {
    
    NSDictionary *parameter = [self.taskRequestModel mj_keyValues];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/task/taskList" parameters:parameter success:^(id responseObject) {
        
        
        JGJTaskListModel *taskListModel = [JGJTaskListModel mj_objectWithKeyValues:responseObject];
        
        self.taskListModel = taskListModel;
        
        [self.tableView.mj_footer endRefreshing];
        
        if (taskListModel.task_list.count > 0) {
            
            [self.taskModels addObjectsFromArray:taskListModel.task_list];
            
            self.taskRequestModel.pg++;
            
        }
        
        if (taskListModel.task_list.count < PageSize) {
            
            [self.tableView.mj_footer endRefreshing];
            
            self.tableView.mj_footer = nil;
        }
        
        //是否显示缺省页
        [self showDefaultNoDataSource:self.taskModels];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - 是否显示缺省页面
- (void)showDefaultNoDataSource:(NSArray *)dataSource {
    
    if ((dataSource.count == 0 && self.taskType != MyComitTaskType) || (dataSource.count == 0 && self.proListModel.isClosedTeamVc)) {
        
        CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:@"暂无记录哦~"];
        
        statusView.frame = self.tableView.bounds;
        
        self.tableView.tableHeaderView = statusView;
        
    }else if (dataSource.count == 0 && self.taskType == MyComitTaskType) {
        
        [self myCreatTaskWithDataSource:dataSource];
        
    }
    
}

#pragma mark -我创建的任务缺省页
- (void)myCreatTaskWithDataSource:(NSArray *)dataSource {
  
    if (dataSource.count == 0 && self.taskType == MyComitTaskType && !self.proListModel.isClosedTeamVc) {

        JGJNodataDefultModel *defultModel = [JGJNodataDefultModel new];

        defultModel.helpTitle = @"查看帮助";

        defultModel.pubTitle = @"立即创建";

        defultModel.contentStr = @"暂无提交的任务";

        __weak typeof(self) weakSelf = self;

        JGJNoDataDefultView *defultView = [[JGJNoDataDefultView alloc] initWithFrame:CGRectMake(0, 64, TYGetUIScreenWidth, TYGetUIScreenHeight - 64) andSuperView:nil andModel:defultModel helpBtnBlock:^(NSString *title){

            JGJHelpCenterTitleView *titleView = [JGJHelpCenterTitleView new];
            
            titleView.titleViewType = JGJHelpCenterTitleViewTaskType;
            
            titleView.proListModel = self.proListModel;
            
            [titleView helpCenterActionWithTitleViewType:JGJHelpCenterTitleViewTaskType target:weakSelf];

        } pubBtnBlock:^(NSString *title) {

            if (weakSelf.proListModel.isClosedTeamVc) {
                
                [JGJComTool showCloseProPopViewWithClasstype:weakSelf.proListModel.class_type];
                
                return ;
            }
            
            [weakSelf handlePushTaskAction];
        }];

        self.tableView.tableHeaderView = defultView;
    }
    
}

- (void)handlePushTaskAction {
    
    JGJPublishTaskVc *publishTaskVc = [JGJPublishTaskVc new];
    
    publishTaskVc.proListModel = self.proListModel;
    
    [self.navigationController pushViewController:publishTaskVc animated:YES];
}

- (NSMutableArray *)taskModels {
    
    if (!_taskModels) {
        
        _taskModels = [NSMutableArray new];
    }
    return _taskModels;
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

- (void)initialSubView {
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.bottom.mas_equalTo(self.view);
    }];
    
}

- (JGJTaskRequestModel *)taskRequestModel {
    
    TYLog(@"111taskRequestModel=====%@  22222self.proListModelclass_type ===== %@", self.proListModel.group_id, self.proListModel.class_type);
    if (!_taskRequestModel) {
        
        _taskRequestModel = [JGJTaskRequestModel new];
        
        _taskRequestModel.group_id = self.proListModel.group_id;
        
        _taskRequestModel.class_type = self.proListModel.class_type;
        
        _taskRequestModel.task_type = @"0";
        
        _taskRequestModel.task_status = @"0";
        
        _taskRequestModel.pg = 1;
        
        _taskRequestModel.pagesize = PageSize;
    }
    return _taskRequestModel;
}

@end

