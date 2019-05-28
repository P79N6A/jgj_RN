//
//  JGJTaskRootVc.m
//  mix
//
//  Created by yj on 2017/5/31.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJTaskRootVc.h"
#import "JGJCusActiveSheetView.h"
#import "JGJCusTopTitleView.h"
#import "JGJPublishTaskVc.h"
#import "JGJWaitTaskVc.h"
#import "MJRefresh.h"
#import "NSString+Extend.h"

#import "JGJCusBottomButtonView.h"

#import "JGJQualityMsgReplyListVc.h"

#import "JGJQuaSafeHomeTopCell.h"

#import "JGJQuaSafeAboutMeCell.h"

#import "JGJCreatPlansView.h"

#import "JGJQuaSafeHomeModel.h"

#import "JGJHelpCenterTitleView.h"
#import "JGJChatMsgDBManger+JGJIndexDB.h"
typedef enum : NSUInteger {
    JGJTaskRootVcAllTaskType, //全部任务
    JGJTaskRootVcMyTaskType //我的任务
    
} JGJTaskRootVcType;

@interface JGJTaskRootVc () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView *clocedImageView;

@property (nonatomic, strong) JGJWaitTaskVc *waitTaskVc;

//2.3.4
@property (nonatomic, strong) UITableView *tableView;

@property (strong ,nonatomic)JGJNodataDefultModel *creatDataModel;//用来显示创建按钮下面的文字的模型

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (nonatomic, strong) JGJTaskRequestModel *taskRequestModel; //新任务列表请求模型

@property (nonatomic, strong) JGJTaskListModel *taskListModel; //任务列表模型

@end

@implementation JGJTaskRootVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commonSetUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self delUnread_taskwork_count];
    [self loadNetData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0) {
        
        JGJQuaSafeHomeTopCell *topCell = [JGJQuaSafeHomeTopCell cellWithTableView:tableView];
        
        topCell.topInfos = self.dataSource[0];
        
        __weak typeof(self) weakSelf = self;
        
        topCell.quaSafeHomeTopCellBlock = ^(NSInteger indx) {
            
            JGJSelTaskType selType = (JGJSelTaskType) indx;
            
            [weakSelf selTaskType:selType];
        };
        
        cell = topCell;
        
    }else {
        
        JGJQuaSafeAboutMeCell *aboutMeCell = [JGJQuaSafeAboutMeCell cellWithTableView:tableView];
        
        aboutMeCell.typeModel = self.dataSource[indexPath.row];
        
        cell = aboutMeCell;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     return indexPath.row == 0 ? [JGJQuaSafeHomeTopCell JGJQuaSafeHomeTopCellHeight] :[JGJQuaSafeAboutMeCell JGJQuaSafeAboutMeCellHeight];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJSelTaskType taskType = MyMangeTaskType;
    
    if (indexPath.row == 0) {
        
        return;
    }
    
    if (indexPath.row == 1) {
        
        taskType = MyMangeTaskType;
        
    }else if (indexPath.row == 2) {
        
        taskType = MyJoinTaskType;
        
    }else if (indexPath.row == 3) {
        
        taskType = MyComitTaskType;
    }
    
    [self selTaskType:taskType];
}

- (void)selTaskType:(JGJSelTaskType)taskType {
    
    JGJWaitTaskVc *waitTaskVc = [[JGJWaitTaskVc alloc] init];
    
    self.waitTaskVc = waitTaskVc;
    
    self.waitTaskVc.proListModel = self.proListModel;
    
    self.waitTaskVc.waitTaskCellType = WaitTaskCellDefaultType;
    
    NSString *title = @"待处理";
    
    switch (taskType) {
        case WaitDealTaskType:{
            
            self.waitTaskVc.taskRequestModel.task_status = @"0";
            
            self.waitTaskVc.taskRequestModel.task_type = nil;
            
            title = @"待处理";
            
        }
            
            break;
        case CompletedTaskType:{
            
            self.waitTaskVc.waitTaskCellType = WaitTaskCellCompleteType;
            
            self.waitTaskVc.taskRequestModel.task_status = @"1";
            
            self.waitTaskVc.taskRequestModel.task_type = nil;
            
            title = @"已完成";
        }
            
            break;
        case MyMangeTaskType:{
            
            self.waitTaskVc.taskRequestModel.task_status = nil;
            
            self.waitTaskVc.taskRequestModel.task_type = @"1";

            title = @"我负责的";
        }
            
            break;
        case MyJoinTaskType:{
            
            title = @"我参与的";
            
            self.waitTaskVc.taskRequestModel.task_status = nil;

            self.waitTaskVc.taskRequestModel.task_type = @"3";
        }
            
            break;
        case MyComitTaskType:{
            
            self.waitTaskVc.taskRequestModel.task_status = nil;
            
            self.waitTaskVc.taskRequestModel.task_type = @"2";

            title = @"我提交的";
        }
            
            break;
        default:
            break;
    }
    
    self.waitTaskVc.title = title;
    
    self.waitTaskVc.taskType = taskType;
    
    [self.navigationController pushViewController:self.waitTaskVc animated:YES];
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        CGRect rect = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - 64);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = AppFontf1f1f1Color;
        
    }
    
    return _tableView;
    
}

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray new];
        
        NSMutableArray *topDataSource = [NSMutableArray new];
        
        NSArray *topTitles = @[@"待处理", @"已完成"];
        
        NSArray *topIcons = @[@"wait_deal_icon", @"task_completed_icon"];
        
        NSArray *typeTitles = @[@"我负责的", @"我参与的", @"我提交的"];
        
        NSArray *typeIcons = @[@"my_manger_icon", @"my_join_icon", @"my_com_icon"];
        
        for (NSInteger index = 0; index < topTitles.count; index++) {
            
            JGJQuaSafeHomeModel *topModel = [JGJQuaSafeHomeModel new];
            
            topModel.title = topTitles[index];
            
            topModel.icon = topIcons[index];
            
            [topDataSource addObject:topModel];
        }
        
        [_dataSource addObject:topDataSource];
        
        for (NSInteger index = 0; index < typeTitles.count; index++) {
            
            JGJQuaSafeHomeModel *typeModel = [JGJQuaSafeHomeModel new];
            
            typeModel.title = typeTitles[index];
            
            typeModel.icon = typeIcons[index];
            
            [_dataSource addObject:typeModel];
        }
    
    }
    
    return _dataSource;
}

- (void)commonSetUI {
    
    JGJHelpCenterTitleView *titleView = [JGJHelpCenterTitleView helpCenterTitleView];
    
    titleView.titleViewType = JGJHelpCenterTitleViewTaskType; //添加类型
    
    titleView.title = @"任务";//标题名字
    
    self.navigationItem.titleView = titleView;
    
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) weakSelf = self;
 
    if (!self.proListModel.isClosedTeamVc) {
        
        JGJNodataDefultModel *creatDataModel = [JGJNodataDefultModel new];
        
        creatDataModel.contentStr = @"发任务";
        
        [JGJCreatPlansView showView:self.view andModel:creatDataModel  andBlock:^(NSString *title) {
            
            [weakSelf handlePushTaskAction];
            
        }];
    }
    
    [JGJComTool showCloseProImageViewWithTargetView:self.view classtype:self.proListModel.class_type isClose:self.proListModel.isClosedTeamVc];
    
}

#pragma mark - 加载新消息
- (void)loadNetData {
    
    NSDictionary *parameter = [self.taskRequestModel mj_keyValues];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/task/taskHomepage" parameters:parameter success:^(id responseObject) {
        
        JGJTaskListModel *taskListModel = [JGJTaskListModel mj_objectWithKeyValues:responseObject];
        
        self.taskListModel = taskListModel;
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)delUnread_taskwork_count {
    
    JGJIndexDataModel *indexModel = [JGJChatMsgDBManger getTheIndexModelInIndexTable];
    indexModel.unread_task_count = @"0";
    [JGJChatMsgDBManger updateIndexModelToIndexTable:indexModel];
    
    // 清除聊聊列表对应的质量未读数
    JGJChatGroupListModel *originGroupModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:indexModel.group_id classType:indexModel.class_type];
    originGroupModel.unread_task_count = @"0";
    [JGJChatMsgDBManger updateChatGroupListTableTheUnread_work_countWithGroupListModel:originGroupModel group_id:indexModel.group_id class_type:indexModel.class_type];
}

- (void)setTaskListModel:(JGJTaskListModel *)taskListModel {
    
    _taskListModel = taskListModel;
    
    [self setTypeCountWithTaskListModel:taskListModel];
}

- (void)setTypeCountWithTaskListModel:(JGJTaskListModel *)taskListModel {
    
    NSArray *redFlags = @[taskListModel.is_admin_msg?:@"", taskListModel.is_join_msg?:@"", @"0"];
    
    for (NSInteger indx = 0; indx < self.dataSource.count; indx++) {
        
        NSArray *topInfos = self.dataSource[0];
        
        if (indx == 0) {
            
            for (NSInteger subIndex = 0; subIndex < topInfos.count; subIndex++) {
                
                JGJQuaSafeHomeModel *topModel = topInfos[subIndex];
                
                topModel.title = taskListModel.filterCounts[subIndex];
                
            }
            
        }else {
            
            JGJQuaSafeHomeModel *topModel = self.dataSource[indx];
            
            topModel.unReadMsgCount = redFlags[indx - 1];
            
            topModel.title = taskListModel.aboutMeCounts[indx - 1];
        }
        
    }
    
    [self.tableView reloadData];
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
        
        _taskRequestModel.pagesize = 10;
    }
    return _taskRequestModel;
}

- (UIImageView *)clocedImageView {
    
    if (!_clocedImageView) {
        
        if (self.proListModel.isClosedTeamVc) {
            
            _clocedImageView = [[UIImageView alloc] init];
            
            _clocedImageView.bounds = CGRectMake(0, 0, 126, 71);
            
            _clocedImageView.center = self.view.center;
            
            NSString *closeType = [self.proListModel.class_type isEqualToString:@"team"] ? @"pro_closedFlag_icon" : @"Chat_closedGroup";
            
            _clocedImageView.image = [UIImage imageNamed:closeType];
            
        }
    }
    
    return _clocedImageView;
    
}

- (void)handlePushTaskAction {
    
    JGJPublishTaskVc *publishTaskVc = [JGJPublishTaskVc new];
    
    publishTaskVc.proListModel = self.proListModel;
    
    [self.navigationController pushViewController:publishTaskVc animated:YES];
}

- (void)freshWaitTask{
    
    [self.waitTaskVc.tableView.mj_header beginRefreshing];
    
}

@end

