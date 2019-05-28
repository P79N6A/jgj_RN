//
//  JGJQuickCreatChatVc.m
//  mix
//
//  Created by yj on 2018/12/12.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJQuickCreatChatVc.h"

#import "JGJQuickCreatChatCell.h"

#import "JGJQuickCreatChatHeaderView.h"

#import "JGJCustomPopView.h"

#import "JGJQuickCreatChatTabHeaderView.h"

#import "JGJWebAllSubViewController.h"

#import "JGJQuickCreatChatFooterView.h"

#define JGJLocalGroupType @"JGJLocalGroupType"

#define JGJWorkGroupType @"JGJWorkGroupType"

@interface JGJQuickCreatChatVc ()<

UITableViewDelegate,

UITableViewDataSource,

JGJQuickCreatChatCellDelegate

>

@property (nonatomic, strong) JGJRefreshTableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) JGJQuickCreatChatModel *creatChatModel;

//已经加入的工群聊
@property (nonatomic, strong) JGJQuickCreatChatListModel *joinedWorkGroupChat;

//已经加入的地点群
@property (nonatomic, strong) JGJQuickCreatChatListModel *joinedLocalGroupChat;

@property (nonatomic, strong) JGJQuickCreatChatTabHeaderView *tabHeaderView;

@property (nonatomic, copy) JGJQuickCreatChatFooterView *tabFooterView;

@end

@implementation JGJQuickCreatChatVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"快速加群";
    
//    [self.view addSubview:self.tabHeaderView];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadFastGroupList)];
    
    JGJChatGroupListModel *localGroupModel = [[JGJChatGroupListModel alloc] init];
    
    localGroupModel.extent_type = JGJLocalGroupType;
    
    localGroupModel = [JGJChatMsgDBManger getChatGroupListModel:localGroupModel];
    
    self.joinedLocalGroupChat = [self coverChatListModel:localGroupModel];
    
    JGJChatGroupListModel *workGroupModel = [[JGJChatGroupListModel alloc] init];
    
    workGroupModel.extent_type = JGJWorkGroupType;
    
    workGroupModel = [JGJChatMsgDBManger getChatGroupListModel:workGroupModel];
    
    self.joinedWorkGroupChat = [self coverChatListModel:workGroupModel];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 59;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *chatList = self.dataArray[section];
    
    return chatList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    JGJQuickCreatChatCell *cell = [JGJQuickCreatChatCell cellWithTableView:tableView];
    
    NSArray *chatList = self.dataArray[indexPath.section];
    
    JGJQuickCreatChatListModel *chatListModel = chatList[indexPath.row];
    
    cell.lineLeading.constant = chatList.count - 1 == indexPath.row ? 0 : 37;
    
    cell.chatListModel = chatListModel;
    
    cell.delegate = self;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footer = [[UIView alloc] init];
    
    footer.backgroundColor = AppFontf1f1f1Color;
    
    return footer;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    JGJQuickCreatChatHeaderView *header = [[JGJQuickCreatChatHeaderView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 60)];
    
    header.headerViewModel = self.creatChatModel.headerModels[section];
    
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

}

#pragma mark - JGJQuickCreatChatCellDelegate

- (void)quickCreatChatCell:(JGJQuickCreatChatCell *)cell chatListModel:(JGJQuickCreatChatListModel *)chatListModel {
    
    NSString *type = [self quickTypeWithChatListModel:chatListModel];
    
    if ([type isEqualToString:JGJWorkGroupType]) {
        
        [self joinWorkGroupChatCreatChatCell:cell chatListModel:chatListModel];
        
    }else if ([type isEqualToString:JGJLocalGroupType]) {
        
        [self joinLocaljoinedWorkGroupChatCreatChatCell:cell chatListModel:chatListModel];
        
    }
    
}

#pragma mark - 是否加入工种群
- (void)joinWorkGroupChatCreatChatCell:(JGJQuickCreatChatCell *)cell chatListModel:(JGJQuickCreatChatListModel *)chatListModel {
    
    if (![NSString isEmpty:self.joinedWorkGroupChat.group_id] && ![NSString isEmpty:self.joinedWorkGroupChat.class_type]) {
        
        if ([self.joinedWorkGroupChat.group_id isEqualToString:chatListModel.group_id] && [self.joinedWorkGroupChat.class_type isEqualToString:chatListModel.class_type]) {
            
            return;
        }
        
        [TYShowMessage showPlaint:@"你已加入了一个工种群，不能再加入其它工种群啦！"];
        
    }else {
        
        [self unJoinGroupChatWithCreatChatCell:cell chatListModel:chatListModel];
        
    }
    
}

#pragma mark - 是否加入地方群
- (void)joinLocaljoinedWorkGroupChatCreatChatCell:(JGJQuickCreatChatCell *)cell chatListModel:(JGJQuickCreatChatListModel *)chatListModel {
    
    if (![NSString isEmpty:self.joinedLocalGroupChat.group_id] && ![NSString isEmpty:self.joinedLocalGroupChat.class_type]) {
        
        if ([self.joinedLocalGroupChat.group_id isEqualToString:chatListModel.group_id] && [self.joinedLocalGroupChat.class_type isEqualToString:chatListModel.class_type]) {
            
            return;
        }
        
        [TYShowMessage showPlaint:@"你已加入了一个地方群，不能再加入其它地方群啦！"];
        
    }else {
        
//        [self unJoinGroupChatWithCreatChatCell:cell chatListModel:chatListModel];
        
        if (self.creatChatModel.local_list.count >= 2) {
            
            JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
            
            desModel.popDetail = @"只能加入一个地方群，请谨慎选择。确定加入选择的地方群吗？";
            
            desModel.leftTilte = @"取消";
            
            desModel.rightTilte = @"确定";
            
            JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
            
            alertView.messageLable.textAlignment = NSTextAlignmentLeft;
            
            __weak typeof(self) weakSelf = self;
            
            alertView.onOkBlock = ^{
                
                [weakSelf handleJoinGroupChatWithChatListModel:chatListModel creatChatCell:cell];
            };
            
        }else {
            
            [self handleJoinGroupChatWithChatListModel:chatListModel creatChatCell:cell];
        }
    
    }
    
}

//加入过群聊

- (void)joinedGroupChatWithCreatChatCell:(JGJQuickCreatChatCell *)cell chatListModel:(JGJQuickCreatChatListModel *)chatListModel {
    
    [TYShowMessage showPlaint:@"你已加入了一个工种群，不能再加入其它工种群啦！"];
    
}

//未加入过群聊

- (void)unJoinGroupChatWithCreatChatCell:(JGJQuickCreatChatCell *)cell chatListModel:(JGJQuickCreatChatListModel *)chatListModel {
    
    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
    
    desModel.popDetail = @"只能加入一个工种群。\n确定加入选择的工种群吗？";
    
    desModel.leftTilte = @"取消";
    
    desModel.rightTilte = @"确定";
    
    JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
    
    alertView.messageLable.textAlignment = NSTextAlignmentLeft;
    
    __weak typeof(self) weakSelf = self;
    
    alertView.onOkBlock = ^{
        
        [weakSelf handleJoinGroupChatWithChatListModel:chatListModel creatChatCell:cell];
        
    };
}

- (void)loadFastGroupList {
    
    [JLGHttpRequest_AFN PostWithNapi:@"group/fast-group-chat-list" parameters:nil success:^(id responseObject) {
        
        JGJQuickCreatChatModel *creatChatModel = [JGJQuickCreatChatModel mj_objectWithKeyValues:responseObject];
        
        //这里处理了数据替换
        
        self.creatChatModel = creatChatModel;
        
        [self showCompleInfoViewWithChatModel:creatChatModel];
        
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        
    }];
    
//    JGJQuickCreatChatModel *creatChatModel = [[JGJQuickCreatChatModel alloc] init];
//
//    self.creatChatModel = creatChatModel;
    
////测试数据---st
//
//    NSMutableArray *groups = [[NSMutableArray alloc] init];
//
//    for (NSInteger indx = 0; indx < 5; indx++) {
//
//        JGJQuickCreatChatListModel *chatListModel = [[JGJQuickCreatChatListModel alloc] init];
//
//        chatListModel.class_type = @"groupChat";
//
//        chatListModel.member_num = @"100";
//
//        chatListModel.group_name = [NSString stringWithFormat:@"建筑工友[木工]群建筑工友[木工]群建筑工友群%@",@(indx+1000)];
//
//        chatListModel.group_id = [NSString stringWithFormat:@"%@",@(indx+1000)];
//
//        [groups addObject:chatListModel];
//
//    }
//
//    creatChatModel.work_list = groups;
//
//    JGJQuickCreatChatListModel *localChatListModel = [[JGJQuickCreatChatListModel alloc] init];
//
//    localChatListModel.class_type = @"groupChat";
//
//    localChatListModel.member_num = @"100";
//
//    localChatListModel.is_exist = NO;
//
//    localChatListModel.type = @"-1";
//
//    localChatListModel.group_name = [NSString stringWithFormat:@"1建筑工友[木工]群建筑工友[木工]群建筑工友群%@",@(10000000)];
//
//    localChatListModel.group_id = [NSString stringWithFormat:@"%@",@(1000000)];
//
//    creatChatModel.local_list = @[localChatListModel];
//
////测试数据---end
    
//获取服务器给的已添加数据
    
}

- (void)showCompleInfoViewWithChatModel:(JGJQuickCreatChatModel *)creatChatModel {
    
    if (creatChatModel.work_list.count > 0) {
        
//        self.tabHeaderView.hidden = YES;
//
//        self.tabHeaderView.height = 0;
//
//        self.tableView.frame = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - JGJ_NAV_HEIGHT);
        
        self.tableView.tableFooterView = nil;
        
    }else {
        
//         self.tabHeaderView.hidden = NO;
//
//        self.tabHeaderView.frame = CGRectMake(0, 0, TYGetUIScreenWidth, [JGJQuickCreatChatTabHeaderView headerHeight]);
//
//        CGFloat oriY = self.tabHeaderView.height;
//
//        CGRect rect = CGRectMake(0, oriY, TYGetUIScreenWidth, TYGetUIScreenHeight - JGJ_NAV_HEIGHT - oriY);
//
//        self.tableView.frame = rect;
        
        self.tableView.tableFooterView = self.tabFooterView;
        
    }
    
}

- (void)setCreatChatModel:(JGJQuickCreatChatModel *)creatChatModel {
    
    _creatChatModel = creatChatModel;
    
    NSPredicate *existPredicate = [NSPredicate predicateWithFormat:@"is_exist=%@",@(YES)];
    
    if (![NSString isEmpty:self.joinedWorkGroupChat.group_id] && ![NSString isEmpty:self.joinedWorkGroupChat.class_type]) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"group_id=%@&&class_type=%@",self.joinedWorkGroupChat.group_id,self.joinedWorkGroupChat.class_type];
        
        NSArray *list = [creatChatModel.work_list filteredArrayUsingPredicate:predicate];
        
        //工种群
        NSMutableArray *work_list = [creatChatModel.work_list mutableCopy];
        
        if (list.count > 0) {
            
            JGJQuickCreatChatListModel *groupChatModel = list.firstObject;
            
            groupChatModel.is_exist = YES;
            
            [work_list removeObject:groupChatModel];
            
            [work_list insertObject:groupChatModel atIndex:0];
            
            creatChatModel.work_list = work_list;
            
        }else {
            
            [work_list insertObject:self.joinedWorkGroupChat atIndex:0];
            
            creatChatModel.work_list = work_list;
            
        }
        
    }
    
    //地方群
    
    if (![NSString isEmpty:self.joinedLocalGroupChat.group_id] && ![NSString isEmpty:self.joinedLocalGroupChat.class_type]) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"group_id=%@&&class_type=%@",self.joinedLocalGroupChat.group_id,self.joinedLocalGroupChat.class_type];
        
        NSArray *list = [creatChatModel.local_list filteredArrayUsingPredicate:predicate];

        if (list.count > 0) {
            
            JGJQuickCreatChatListModel *groupChatModel = list.firstObject;
            
            groupChatModel.is_exist = YES;
            
        }else {
            
            NSMutableArray *local_list = creatChatModel.local_list.mutableCopy;
            
            if (local_list.count > 0) {
                
                [local_list replaceObjectAtIndex:0 withObject:self.joinedLocalGroupChat];
                
            }
            
            creatChatModel.local_list = local_list;
        }
        
    }
    
    
    if (creatChatModel.local_list.count > 0 && creatChatModel.work_list.count > 0) {
        
        self.dataArray = @[creatChatModel.local_list,creatChatModel.work_list];
        
    }else if (creatChatModel.local_list.count == 0 && creatChatModel.work_list.count > 0) {
        
        self.dataArray = @[creatChatModel.work_list];
        
    }else if (creatChatModel.local_list.count > 0 && creatChatModel.work_list.count == 0) {
        
        self.dataArray = @[creatChatModel.local_list];
        
    }else if (creatChatModel.local_list.count == 0 && creatChatModel.work_list.count == 0) {
        
        self.dataArray = @[];
        
    }
    
    [self.tableView reloadData];
    
}

#pragma mark - 模型转换 JGJChatGroupListModel 转 JGJQuickCreatChatListModel

- (JGJQuickCreatChatListModel *)coverChatListModel:(JGJChatGroupListModel *)groupModel {
    
    JGJQuickCreatChatListModel *joinGroupModel = [JGJQuickCreatChatListModel mj_objectWithKeyValues:[groupModel mj_JSONObject]];
    
    NSString *type = [self quickTypeWithChatListModel:joinGroupModel];
    
    if ([type isEqualToString:JGJWorkGroupType]) {
        
         self.joinedWorkGroupChat = joinGroupModel;
        
    }else if ([type isEqualToString:JGJLocalGroupType]) {
        
        self.joinedLocalGroupChat = joinGroupModel;
        
    }
    
    return joinGroupModel;
    
}

#pragma mark - 加入群聊
- (void)handleJoinGroupChatWithChatListModel:(JGJQuickCreatChatListModel *)chatListModel creatChatCell:(JGJQuickCreatChatCell *)cell{
    
    JGJAddGroupMemberRequestModel *addGroupMemberRequestModel = [[JGJAddGroupMemberRequestModel alloc] init];

    addGroupMemberRequestModel.class_type = chatListModel.class_type;

    addGroupMemberRequestModel.is_qr_code = @"0";//0通信录加入

    addGroupMemberRequestModel.group_id = chatListModel.group_id;

    NSMutableArray *groupMembersInfos = [NSMutableArray array];

    JGJGroupMembersRequestModel *membersModel = [[JGJGroupMembersRequestModel alloc] init];
    
    membersModel.real_name = [TYUserDefaults objectForKey:JLGRealName];
    
    membersModel.telephone = [TYUserDefaults objectForKey:JLGPhone];
    
    membersModel.uid = [TYUserDefaults objectForKey:JLGUserUid];
    
    [groupMembersInfos addObject:membersModel];
    
    
    addGroupMemberRequestModel.group_members = groupMembersInfos;

    NSString *group_members = [[JGJGroupMembersRequestModel mj_keyValuesArrayWithObjectArray:addGroupMemberRequestModel.group_members] mj_JSONString];

    NSMutableDictionary *parameters = [addGroupMemberRequestModel mj_keyValues];

    [parameters setObject:@"1" forKey:@"fast_add_group"];
    
    if (![NSString isEmpty:group_members]) {

        [parameters setValue:group_members forKey:@"group_members"];
    }
    
    [TYLoadingHub showLoadingWithMessage:nil];

    [JLGHttpRequest_AFN PostWithNapi:JGJAddMembersURL parameters:parameters success:^(id responseObject) {
        
        [self insetGroupInfoWithChatListModel:chatListModel];
        
        chatListModel.is_exist = YES;
        
        cell.chatListModel = chatListModel;
        
        [TYLoadingHub hideLoadingView];

    } failure:^(NSError *error) {

        [TYLoadingHub hideLoadingView];
        
    }];
}

#pragma mark - 插入群组到聊聊列表信息
- (void)insetGroupInfoWithChatListModel:(JGJQuickCreatChatListModel *)chatListModel {

    JGJChatGroupListModel *groupModel = [JGJChatGroupListModel mj_objectWithKeyValues:[chatListModel mj_JSONObject]];
    
    groupModel.max_asked_msg_id = @"0";
    
    groupModel.sys_msg_type = @"normal";
    
    groupModel.local_head_pic = [chatListModel.members_head_pic mj_JSONString];
    
    NSString *extent_type = [self quickTypeWithChatListModel:chatListModel];
    
    groupModel.extent_type = extent_type;
    
    groupModel.list_sort_time = [JGJChatMsgDBManger localTime];
    
    JGJChatGroupListModel *existGroupModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:chatListModel.group_id classType:chatListModel.class_type];
    
    if (![NSString isEmpty:existGroupModel.group_id] && ![NSString isEmpty:existGroupModel.class_type]) {
        
        [JGJChatMsgDBManger updateQuickJoinGroupExtentTypeWithChatGroupListModel:groupModel];
        
    }else {
        
       [JGJChatMsgDBManger insertGroupDBWithGroupModel:groupModel isHomeVc:NO];
    }
    
    if ([extent_type isEqualToString:JGJLocalGroupType]) {
        
        self.joinedLocalGroupChat = chatListModel;
        
    }
    
    if ([extent_type isEqualToString:JGJWorkGroupType]) {
        
        self.joinedWorkGroupChat = chatListModel;
        
    }
    
}

- (NSString *)quickTypeWithChatListModel:(JGJQuickCreatChatListModel *)chatListModel {
    
    NSString *extent_type = @"JGJWorkGroupType";
    
    if ([chatListModel.type isEqualToString:@"-1"]) {
        
        extent_type = @"JGJLocalGroupType";
    }
    
    return extent_type;
    
}

#pragma mark - 点击完善资料按钮

- (void)compleInfoBtnAction {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", JGJWebDiscoverURL,@"my/resume"];
    
    JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:url];
    
    [self.navigationController pushViewController:webVc animated:YES];
    
}

- (JGJRefreshTableView *)tableView {
    
    if (!_tableView) {
        
        CGRect rect = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - JGJ_NAV_HEIGHT);
        
        _tableView = [[JGJRefreshTableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        
        _tableView.backgroundColor = AppFontf1f1f1Color;
        
    }
    
    return _tableView;
}

- (JGJQuickCreatChatTabHeaderView *)tabHeaderView {
    
    if (!_tabHeaderView) {
        
        _tabHeaderView = [[JGJQuickCreatChatTabHeaderView alloc] init];
        
        _tabHeaderView.hidden = YES;
        
        TYWeakSelf(self);
        
        _tabHeaderView.tabHeaderViewBlock = ^{
          
            [weakself compleInfoBtnAction];
        };
        
    }
    
    return _tabHeaderView;
}

- (JGJQuickCreatChatFooterView *)tabFooterView {
    
    if (!_tabFooterView) {
        
        _tabFooterView = [[JGJQuickCreatChatFooterView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 100)];
        
        TYWeakSelf(self);
        
        _tabFooterView.actionBlock = ^{
          
            [weakself compleInfoBtnAction];
        };
        
    }
    
    return _tabFooterView;
}

@end
