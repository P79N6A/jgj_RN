//
//  JGJWorkingChatMsgViewController.m
//  mix
//
//  Created by Tony on 2018/8/23.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJWorkingChatMsgViewController.h"
#import "JGJChatMsgDBManger.h"
#import "JGJChatMsgDBManger+JGJGroupDB.h"
#import "JGJChatSynInfoCell.h"

#import "JGJWorkingListNormalTypeCell.h"
#import "JGJActivityMsgCell.h"
#import "JGJChatMsgBaseCell.h"
#import "JGJRecruiteTableCell.h"
#import "JGJSocketRequest+ChatMsgService.h"
#import "LZChatRefreshHeader.h"
#import "JGJQualityDetailVc.h"
#import "JGJDetailViewController.h"
#import "JGJQuaSafeCheckPlanDetailVc.h"
#import "JGJTaskViewController.h"
#import "JGJWebAllSubViewController.h"
#import "JGJWorkingRoamRequestModel.h"
#import "JGJAddSynInfoVc.h"
#import "CFRefreshStatusView.h"
#import "UILabel+GNUtil.h"
#import "JGJSynToMyProVc.h"
#import "JGJSynRecordVc.h"
#import "JGJSocketRequest+GroupService.h"
#import "JGJMemberAppraiseDetailVc.h"

#import "JGJYunFileApplicationSuccessViewController.h"
#import "JGJGroupMangerTool.h"
#import "JGJSocketRequest+ChatMsgService.h"
#import "FDAlertView.h"

#import "JGJSynRecordParentVc.h"
#import "JGJDemandSyncProjectViewController.h"
#import "NSDate+Extend.h"
#import "JGJWorkingListBottomSpaceCell.h"
#import "JGJQuickCreatChatVc.h"
#import "JGJPerInfoVc.h"
#import "JGJChatRootVc.h"
#import "JGJSwitchMyGroupsTool.h"
#import "JGJRecruitmentSituationCell.h"
@interface JGJWorkingChatMsgViewController ()<UITableViewDelegate,UITableViewDataSource,JGJChatMsgBaseCellDelegate,FDAlertViewDelegate>
{
    BOOL _isSelected;
    
    JGJChatMsgListModel *_deleteMsgModel;
    
}
@property (nonatomic, strong) UITableView *workingList;
@property (nonatomic, strong) NSMutableArray *workingModelArr;
@property (nonatomic, strong) NSMutableArray *msg_id_sortArr;
@property (nonatomic, strong) UIWebView *integralWebView;
@property (nonatomic, strong) JGJChatMsgListModel *bottomSpaceModel;// 工作消息底部添加一个空白cell
@property (nonatomic, strong) JGJChatMsgListModel *recruitBottomSpaceModel;// 活动底部空白cell
@end

@implementation JGJWorkingChatMsgViewController

- (void)viewDidLoad {
    
    self.view.backgroundColor = AppFontf1f1f1Color;

    self.automaticallyAdjustsScrollViewInsets = NO;
    [super viewDidLoad];
    [self initializeAppearance];
    
    JGJSocketRequest *shareSocket = [JGJSocketRequest shareSocketConnect];
    
    TYWeakSelf(self);
    
    shareSocket.workTypeMsgCallBack = ^(NSArray *work_msg_array) {
    
        NSMutableArray *mutArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < work_msg_array.count; i ++) {
            
            JGJChatMsgListModel *msgModel = work_msg_array[i];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"msg_id=%@",msgModel.msg_id];
            NSArray *filterMsgs = [weakself.workingModelArr filteredArrayUsingPredicate:predicate];
    
            //已存在的消息，这不添加
            if (filterMsgs.count > 0) {
    
                return ;
            }
            if ([msgModel.group_id isEqualToString:self.groupModel.group_id] && [msgModel.class_type isEqualToString:self.groupModel.class_type]) {
               
                [mutArr addObject:msgModel];
            }
        }
        [weakself.workingModelArr addObjectsFromArray:mutArr];
        
        if ([_groupModel.class_type isEqualToString:@"work"]) {
            
            [self.workingModelArr removeObject:self.bottomSpaceModel];
            [self.workingModelArr addObject:self.bottomSpaceModel];
        }else if ([_groupModel.sys_msg_type isEqualToString:@"recruit"]) {
            
            [self.workingModelArr removeObject:self.recruitBottomSpaceModel];
            [self.workingModelArr addObject:self.recruitBottomSpaceModel];
            
        }
        
        [weakself.workingList reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (weakself.workingModelArr.count > 0) {
                    
                    [self scrollToBottom];
                }
                
            });
        });
    };
}


- (void)setNavigationLeftButtonItem {
    
    SEL getLeftButton = NSSelectorFromString(@"getLeftNoTargetButton");
    IMP imp = [self.navigationController methodForSelector:getLeftButton];
    UIButton* (*func)(id, SEL) = (void *)imp;
    UIButton *leftButton = func(self.navigationController, getLeftButton);
    
    [leftButton addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (void)backBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)initializeAppearance {
    
    [self.view addSubview:self.workingList];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    JGJChatMsgListModel *msgModel = [[JGJChatMsgListModel alloc] init];
    
    msgModel.group_id = _groupModel.group_id;
    msgModel.class_type = _groupModel.class_type;
    msgModel.sys_msg_type = _groupModel.class_type;
    
    JGJChatMsgListModel *exsitMsgModel;
    if ([_groupModel.sys_msg_type isEqualToString:@"activity"] || [_groupModel.sys_msg_type isEqualToString:@"recruit"]) {
        
        exsitMsgModel = self.workingModelArr.lastObject;
    }else {
        
        exsitMsgModel = [JGJChatMsgDBManger maxMsgListModelWithWorkChatMsgListModel:msgModel];
    }
    exsitMsgModel.group_id = _groupModel.group_id;
    exsitMsgModel.class_type = _groupModel.class_type;
    exsitMsgModel.sys_msg_type = _groupModel.class_type;
    
    if ([NSString isEmpty:exsitMsgModel.msg_id]) {
        
        //是否正在读消息
        [JGJSocketRequest readedMsgModel:msgModel isReaded:NO];
        
    }else {
        
        //是否正在读消息
        [JGJSocketRequest readedMsgModel:exsitMsgModel isReaded:NO];
        
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self setNavigationLeftButtonItem];
    [self.integralWebView removeFromSuperview];
    self.navigationController.tabBarController.tabBar.hidden = YES;

}

- (void)setGroupModel:(JGJChatGroupListModel *)groupModel {
    
    _groupModel = groupModel;
    
    // 更新最大已读msg_id
    [self updateMaxReadMsg_idWithGroupModel:_groupModel];
    JGJWorkingRoamRequestModel *requestModel = [[JGJWorkingRoamRequestModel alloc] init];
    if ([_groupModel.sys_msg_type isEqualToString:@"work"]) {// 工作消息
        
        self.title = @"工作消息";
        
    }else if ([_groupModel.sys_msg_type isEqualToString:@"activity"]) {// 活动消息
        
        self.title = @"活动消息";
        
    }else {// 招聘消息
        
        self.title = @"找活招工小助手";
        
    }
    [self getWorkingListWith:groupModel];
    
}

- (void)updateMaxReadMsg_idWithGroupModel:(JGJChatGroupListModel *)groupModel {
    
    JGJChatMsgListModel *msgModel = [[JGJChatMsgListModel alloc] init];

    msgModel.group_id = _groupModel.group_id;

    msgModel.class_type = _groupModel.class_type;

    msgModel.sys_msg_type = _groupModel.class_type;
    JGJChatMsgListModel *exsitMsgModel = [JGJChatMsgDBManger maxMsgListModelWithChatMsgListModel:msgModel];

    exsitMsgModel.group_id = _groupModel.group_id;
    exsitMsgModel.class_type = _groupModel.class_type;
    exsitMsgModel.sys_msg_type = _groupModel.class_type;
    
    if (![NSString isEmpty:exsitMsgModel.msg_id]) {

        [JGJSocketRequest readedMsgModel:exsitMsgModel isReaded:YES];

    }
}

- (void)getWorkingListWith:(JGJChatGroupListModel *)groupModel {
    
    JGJChatMsgListModel *msgModel = [JGJChatMsgListModel new];

    msgModel.group_id = groupModel.group_id;

    msgModel.class_type = groupModel.class_type;
    JGJWorkingRoamRequestModel *requestModel = [[JGJWorkingRoamRequestModel alloc] init];

    if ([groupModel.class_type isEqualToString:@"work"]) {// 工作
        
        msgModel.msg_total_type = JGJChatWorkMsgType;
        
        requestModel.group_id = @"-1";
        requestModel.class_type = @"work";
        
        
    }else if ([groupModel.class_type isEqualToString:@"activity"]) {// 活动
        
        msgModel.msg_total_type = JGJChatActivityMsgType;
        requestModel.group_id = @"-2";
        requestModel.class_type = @"activity";
        
    }else if ([groupModel.class_type isEqualToString:@"recruit"]) {// 招聘
        
        msgModel.msg_total_type = JGJChatRecruitMsgType;
        requestModel.group_id = @"-3";
        requestModel.class_type = @"recruit";
    }
    [self.workingModelArr removeAllObjects];
    [self.workingModelArr addObjectsFromArray:[JGJChatMsgDBManger getWorkMsgModelsWithChatMsgListModel:msgModel]];
    
    if (self.workingModelArr.count == 0) {
        
        requestModel.msg_id = @"0";
        [_workingList.mj_header beginRefreshing];
        [JLGHttpRequest_AFN PostWithNapi:@"chat/get-roam-message-list" parameters:[requestModel mj_keyValues] success:^(id responseObject) {
            
            NSArray *msgs = [JGJChatMsgListModel mj_objectArrayWithKeyValuesArray:responseObject];
            if (msgs.count > 0) {
                
                NSMutableArray *msgsModelArr = [[NSMutableArray alloc] initWithArray:msgs];
                for (int i = 0; i < msgsModelArr.count; i ++) {
                    
                    JGJChatMsgListModel *deletemsgModel = msgsModelArr[i];
                    if (deletemsgModel.chatListType == JGJChatListAgreeSyncProjectToYouType) {
                        
                        [msgsModelArr removeObject:deletemsgModel];
                    }
                }
                msgs = msgsModelArr.copy;
                // 漫游消息回执给服务器
                JGJMyWorkCircleProListModel *proList = [[JGJMyWorkCircleProListModel alloc] init];
                proList.class_type = _groupModel.class_type;
                proList.group_id = _groupModel.group_id;
                msgs = [JGJChatMsgDBManger sortActivity_RecruitMsgList:msgs];
                
                
                [self insertMsgDBWithMsgs:msgs];
                [self.workingModelArr addObjectsFromArray:msgs];
                
                [self filtrationActivityArrWithRoal_type:self.workingModelArr];
                self.msg_id_sortArr = [JGJChatMsgDBManger sortChatMsgModelToMsg_idAscendingWithMsgArr:self.workingModelArr];
                
                if ([_groupModel.class_type isEqualToString:@"work"]) {
                    
                    [self.workingModelArr addObject:self.bottomSpaceModel];
                }else if ([_groupModel.sys_msg_type isEqualToString:@"recruit"]) {
                    
                    [self.workingModelArr addObject:self.recruitBottomSpaceModel];
                    
                }
                
                [self.workingList reloadData];
                [JGJSocketRequest pullRoamMsgCallBackServiceWithMsgs:@[self.msg_id_sortArr.lastObject] proListModel:proList];
            }
            [self handleNoActiveGroup];
            [_workingList.mj_header endRefreshing];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               
                if (self.workingModelArr.count > 0) {
                    
                    [self scrollToBottom];
                }
            });
        } failure:^(NSError *error) {
            
            [self handleNoActiveGroup];
            [_workingList.mj_header endRefreshing];
            
        }];
        
    }else {
        
        [self filtrationActivityArrWithRoal_type:self.workingModelArr];
        self.msg_id_sortArr = [JGJChatMsgDBManger sortChatMsgModelToMsg_idAscendingWithMsgArr:self.workingModelArr];
        
        if ([_groupModel.class_type isEqualToString:@"work"]) {
            
            [self.workingModelArr addObject:self.bottomSpaceModel];
            
        }else if ([_groupModel.sys_msg_type isEqualToString:@"recruit"]) {
            
            [self.workingModelArr addObject:self.recruitBottomSpaceModel];
            
        }
        [self.workingList reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.workingModelArr.count > 0) {
                    
                    [self scrollToBottom];
                }
            });
        });
        
    }
    

}

- (void)scrollToBottom
{
    CGFloat yOffset = 0; //设置要滚动的位置 0最顶部 CGFLOAT_MAX最底部
    if (self.workingList.contentSize.height > self.workingList.bounds.size.height) {
        yOffset = self.workingList.contentSize.height - self.workingList.bounds.size.height;
    }
    [self.workingList setContentOffset:CGPointMake(0, yOffset) animated:NO];
}

- (void)loadWorkingMsgMoreData {

    CGSize beforeContentSize = self.workingList.contentSize;
    
    JGJWorkingRoamRequestModel *requestModel = [[JGJWorkingRoamRequestModel alloc] init];
    
    JGJChatMsgListModel *msgModel = self.msg_id_sortArr.firstObject;
    requestModel.msg_id = msgModel.msg_id;
    
    NSArray *listCount = [JGJChatMsgDBManger getWorkMsgModelsWithChatMsgListModel:msgModel];
    
    if ([_groupModel.sys_msg_type isEqualToString:@"work"]) {// 工作消息
        
        requestModel.group_id = @"-1";
        requestModel.class_type = @"work";
    }else if ([_groupModel.sys_msg_type isEqualToString:@"activity"]) {// 工作消息
        
        requestModel.group_id = @"-2";
        requestModel.class_type = @"activity";
        
    }else if ([_groupModel.sys_msg_type isEqualToString:@"recruit"]) {// 工作消息
        
        requestModel.group_id = @"-3";
        requestModel.class_type = @"recruit";
    }
    
    // 拉取是 先判断 listCount.count == 20 代表本地可能还有消息，去拉取本地消息 否则代表没有 去拉取漫游消息
    if (listCount.count == 0) { // 拉取漫游消息
        
        [JLGHttpRequest_AFN PostWithNapi:@"chat/get-roam-message-list" parameters:[requestModel mj_keyValues] success:^(id responseObject) {
            
            NSArray *msgs = [JGJChatMsgListModel mj_objectArrayWithKeyValuesArray:responseObject];

            if (msgs.count > 0) {
                
                NSMutableArray *msgsModelArr = [[NSMutableArray alloc] initWithArray:msgs];
                for (int i = 0; i < msgsModelArr.count; i ++) {
                    
                    JGJChatMsgListModel *deletemsgModel = msgsModelArr[i];
                    if (deletemsgModel.chatListType == JGJChatListAgreeSyncProjectToYouType) {
                        
                        [msgsModelArr removeObject:deletemsgModel];
                    }
                }
                msgs = msgsModelArr.copy;
                // 漫游消息回执给服务器
                JGJMyWorkCircleProListModel *proList = [[JGJMyWorkCircleProListModel alloc] init];
                proList.class_type = _groupModel.class_type;
                proList.group_id = _groupModel.group_id;
                
                msgs = [JGJChatMsgDBManger sortActivity_RecruitMsgList:msgs];
                
                
                [self insertMsgDBWithMsgs:msgs];
                self.workingModelArr = [msgs arrayByAddingObjectsFromArray:self.workingModelArr].mutableCopy;
                
                
                [self filtrationActivityArrWithRoal_type:self.workingModelArr];
                self.msg_id_sortArr = [JGJChatMsgDBManger sortChatMsgModelToMsg_idAscendingWithMsgArr:self.workingModelArr];
                [JGJSocketRequest pullRoamMsgCallBackServiceWithMsgs:@[self.msg_id_sortArr.lastObject] proListModel:proList];
            }
            //处理下拉刷新偏移问题
            //先刷新获取最新的大小
            dispatch_async(dispatch_get_main_queue(), ^{

                [self.workingList reloadData];
                [self handleTableViewOffset:beforeContentSize];

            });
            
            [_workingList.mj_header endRefreshing];
            
        } failure:^(NSError *error) {
            
            [_workingList.mj_header endRefreshing];
        }];
        
    }else {// 取本地
        
        self.workingModelArr = [listCount arrayByAddingObjectsFromArray:self.workingModelArr].mutableCopy;
        self.msg_id_sortArr = [JGJChatMsgDBManger sortChatMsgModelToMsg_idAscendingWithMsgArr:self.workingModelArr];
        //处理下拉刷新偏移问题
        
        [self handleTableViewOffset:beforeContentSize];
        
        [_workingList.mj_header endRefreshing];
        
    }
}

- (void)filtrationActivityArrWithRoal_type:(NSMutableArray *)mutableArr {
    
    if ([_groupModel.sys_msg_type isEqualToString:@"activity"]) {

        NSMutableArray *activityArr = [NSMutableArray array];

        for (int i = 0; i < self.workingModelArr.count; i ++) {

            JGJChatMsgListModel *msgModel = self.workingModelArr[i];
            if ([msgModel.role_type isEqualToString:@"0"]) {

                [activityArr addObject:msgModel];
            }else if (([msgModel.role_type isEqualToString:@"1"] && !JLGisLeaderBool) || ([msgModel.role_type isEqualToString:@"2"] && JLGisLeaderBool)) {// 1:表示工人端显示。2:表示工头端显示

                [activityArr addObject:msgModel];
            }
        }

        if (activityArr.count > 0) {
            
            self.workingModelArr = activityArr;
        }
        
    }
}


#pragma mark - 漫游消息存到数据库
- (void)insertMsgDBWithMsgs:(NSArray *)msgs {
    
    for (JGJChatMsgListModel *msgModel in msgs) {
        
        msgModel.sendType = JGJChatListSendSuccess;
        
        msgModel.user_unique = [TYUserDefaults objectForKey:JLGUserUid];
        
        NSString *wcdb_user_info = [msgModel.user_info mj_JSONString];
        
        msgModel.wcdb_msg_id = [msgModel.msg_id longLongValue];
        
        
        [JGJChatMsgDBManger insertAllPropertyChatMsgListModel:msgModel];
    }
    
}
#pragma mark - 处理tableView下拉刷新偏移问题
- (void)handleTableViewOffset:(CGSize)beforeContentSize {
    
    //先刷新获取最新的大小
    [self.workingList reloadData];
    CGSize afterContentSize = self.workingList.contentSize;
    
    CGPoint afterContentOffset = self.workingList.contentOffset;
    
    CGPoint newContentOffset = CGPointMake(afterContentOffset.x, afterContentOffset.y + afterContentSize.height - beforeContentSize.height);
    [self.workingList setContentOffset:newContentOffset animated:NO] ;
    
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.workingModelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJChatMsgBaseCell *baseCell;
    JGJChatMsgListModel *msgModel = self.workingModelArr[indexPath.row];
    if ([_groupModel.sys_msg_type isEqualToString:@"work"]) {
        
        if (msgModel.chatListType == JGJChatListQuality || msgModel.chatListType == JGJChatListSafe || msgModel.chatListType == JGJChatListNotice || msgModel.chatListType == JGJChatListMeeting || msgModel.chatListType == JGJChatListLog || msgModel.chatListType == JGJChatListTaskType || msgModel.chatListType == JGJChatListInspectType || msgModel.chatListType == JGJChatListApproveType || msgModel.chatListType == JGJChatListMeeting || msgModel.chatListType == JGJChatListJoinType || msgModel.chatListType == JGJChatListRemoveType|| msgModel.chatListType == JGJChatListCloseType || msgModel.chatListType == JGJChatListReopenType || msgModel.chatListType == JGJChatListSwitchgroupType || msgModel.chatListType == JGJChatListOssType || msgModel.chatListType == JGJChatListEvaluateType || msgModel.chatListType == JGJChatListDismissGroupType || msgModel.chatListType == JGJChatListFriendType) {
            
            baseCell = [JGJWorkingListNormalTypeCell cellWithTableView:tableView];
            
        }else if (msgModel.chatListType == JGJChatListCancellSyncBillType || msgModel.chatListType == JGJChatListCancellSyncProjectType || msgModel.chatListType == JGJChatListRefuseSyncBillType || msgModel.chatListType == JGJChatListRefuseSyncProjectType || msgModel.chatListType == JGJChatListDemandSyncBillType ||  msgModel.chatListType == JGJChatListDemandSyncProjectType || msgModel.chatListType == JGJChatListSyncBillToYouType || msgModel.chatListType == JGJChatListSyncProjectToYouType || msgModel.chatListType == JGJChatListAgreeSyncProjectType || msgModel.chatListType == JGJChatListagreeSyncBillType || msgModel.chatListType == JGJChatListCreateNewTeamType || msgModel.chatListType == JGJChatListJoinTeamType || msgModel.chatListType == JGJChatListAgreeSyncProjectToYouType) {// 同步项目类型
            
            baseCell = [JGJChatSynInfoCell cellWithTableView:tableView];
            
        }else if (msgModel.chatListType == JGJChatListBottomDefaultSpaceType) {
            
            JGJWorkingListBottomSpaceCell *spaceCell = [JGJWorkingListBottomSpaceCell cellWithTableViewNotXib:tableView];
            spaceCell.backgroundColor = AppFontf1f1f1Color;
            return spaceCell;
            
        }
        else if (msgModel.chatListType == JGJChatListUnKonownMsgType) {
            
            baseCell = [JGJWorkingListNormalTypeCell cellWithTableView:tableView];
        }
        else {
            
            baseCell = [JGJChatMsgBaseCell cellWithTableViewNotXib:tableView];
        }
        
    }else if ([_groupModel.sys_msg_type isEqualToString:@"activity"]) {
        
        if (msgModel.chatListType == JGJChatListIntegralType || msgModel.chatListType == JGJChatListLocalGroupChatType || msgModel.chatListType == JGJChatListWorkGroupChatType || msgModel.chatListType == JGJChatListPostCensorType) {
            
            baseCell = [JGJWorkingListNormalTypeCell cellWithTableView:tableView];
            
        }else if (msgModel.chatListType == JGJChatListUnKonownMsgType) {
            
            baseCell = [JGJWorkingListNormalTypeCell cellWithTableView:tableView];
        }
        else {
            
            baseCell = [JGJActivityMsgCell cellWithTableView:tableView];
        }
        
        
    }else {
        
        if (msgModel.chatListType == JGJChatListBottomDefaultSpaceType) {
            
            JGJWorkingListBottomSpaceCell *spaceCell = [JGJWorkingListBottomSpaceCell cellWithTableViewNotXib:tableView];
            spaceCell.backgroundColor = AppFontf1f1f1Color;
            return spaceCell;
            
        }else if (msgModel.chatListType == JGJChatListUnKonownMsgType) {
            
            baseCell = [JGJWorkingListNormalTypeCell cellWithTableView:tableView];
            
        }else if (msgModel.chatListType == JGJChatListProjectInfoType) {
            
            baseCell = [JGJRecruitmentSituationCell cellWithTableView:tableView];
        }
        else {
            
            baseCell = [JGJRecruiteTableCell cellWithTableView:tableView];
        }
        
    }
    
    baseCell.jgjChatListModel = msgModel;
    baseCell.delegate = self;
    return baseCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    JGJChatMsgListModel *msgModel = self.workingModelArr[indexPath.row];
    return msgModel.workCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJChatMsgListModel *msgModel = self.workingModelArr[indexPath.row];
    
    JGJChatGroupListModel *groupModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:msgModel.group_id classType:msgModel.class_type];
    JGJMyWorkCircleProListModel *proListModel = [[JGJMyWorkCircleProListModel alloc] init];
    proListModel.class_type = msgModel.origin_class_type;
    proListModel.group_id = msgModel.origin_group_id;
    proListModel.group_name = groupModel.group_name;
    proListModel.members_num = groupModel.members_num;
    proListModel.is_sticked = groupModel.is_top;
    proListModel.pro_id = groupModel.pro_id;
    proListModel.creater_uid = groupModel.creater_uid;
    proListModel.isClosedTeamVc = groupModel.is_closed;
    proListModel.bill_id = msgModel.bill_id;
    JGJQualitySafeListModel *listModel = [JGJQualitySafeListModel new];
    
    listModel.bill_id = msgModel.bill_id;
    listModel.msg_id = msgModel.msg_id;
    listModel.msg_type = msgModel.msg_type;
    
    JGJQualityDetailVc *detailVc = [JGJQualityDetailVc new];
    detailVc.isWorkListCommonIn = YES;
    detailVc.proListModel = proListModel;
    JGJQualitySafeCommonModel *commonModel = [JGJQualitySafeCommonModel new];
    detailVc.commonModel = commonModel;
    detailVc.listModel = listModel;
    
    if ([msgModel.msg_type isEqualToString:@"quality"] && ![msgModel.status isEqualToString:@"4"]) {

        commonModel.type = JGJChatListQuality;
        commonModel.msg_type = @"quality";
        [self.navigationController pushViewController:detailVc animated:YES];
        
    }else if ([msgModel.msg_type isEqualToString:@"safe"] && ![msgModel.status isEqualToString:@"4"]) {
        
        commonModel.type = JGJChatListSafe;
        commonModel.msg_type = @"safe";
        [self.navigationController pushViewController:detailVc animated:YES];
        
    }else if ([msgModel.msg_type isEqualToString:@"log"] && ![msgModel.status isEqualToString:@"4"]){
        
        JGJDetailViewController *allDetailVc = [JGJDetailViewController new];
        allDetailVc.chatRoomGo = YES;
        
        allDetailVc.IsClose = proListModel.isClosedTeamVc;
        
        allDetailVc.workProListModel = proListModel;
        
        //日志详情修改了msg_src这里得重新用个对象，可以copy对象但内部使用属性较多
        NSData *jgjChatListModelData = [NSKeyedArchiver archivedDataWithRootObject:msgModel];
        
        JGJChatMsgListModel *jgjChatListModel = [NSKeyedUnarchiver unarchiveObjectWithData:jgjChatListModelData];
        jgjChatListModel.bill_id = msgModel.bill_id;
        jgjChatListModel.group_id = msgModel.origin_group_id;
        jgjChatListModel.class_type = msgModel.origin_class_type;
        allDetailVc.jgjChatListModel = jgjChatListModel;
        [self.navigationController pushViewController:allDetailVc animated:YES];
        
    }else if ([msgModel.msg_type isEqualToString:@"inspect"]) {
        
        JGJMyWorkCircleProListModel *proListModel = [[JGJMyWorkCircleProListModel alloc] init];
        proListModel.class_type = msgModel.origin_class_type;
        proListModel.group_id = msgModel.origin_group_id;
        proListModel.isClosedTeamVc = msgModel.IsCloseTeam;
        
        JGJInspectListModel *inspectListModel = [[JGJInspectListModel alloc] init];
        inspectListModel.class_type = msgModel.origin_class_type;
        inspectListModel.group_id = msgModel.origin_group_id;
        inspectListModel.plan_id = msgModel.bill_id;
        
        JGJQuaSafeCheckPlanDetailVc *detailVc = [JGJQuaSafeCheckPlanDetailVc new];
        
        detailVc.proListModel = proListModel;

        detailVc.inspectListModel = inspectListModel;
        
        [self.navigationController pushViewController:detailVc animated:YES];
    
    }else if ([msgModel.msg_type isEqualToString:@"task"]) {
        
        JGJChatMsgListModel *jgjChatListModel = [[JGJChatMsgListModel alloc] init];
        NSDictionary *dic = [msgModel mj_keyValues];
        jgjChatListModel = [JGJChatMsgListModel mj_objectWithKeyValues:dic];
        jgjChatListModel.msg_id = msgModel.bill_id;
        JGJTaskViewController *taskVC = [JGJTaskViewController new];
        taskVC.taskDetail = YES;
        taskVC.jgjChatListModel = jgjChatListModel;
        
        JGJMyWorkCircleProListModel *proListModel = [[JGJMyWorkCircleProListModel alloc] init];
        
        proListModel.class_type = msgModel.origin_class_type;
        
        proListModel.group_id = msgModel.origin_group_id;
        
        taskVC.workProListModel = proListModel;
        
        [self.navigationController pushViewController:taskVC animated:YES];
        
    }else if ([msgModel.msg_type isEqualToString:@"notice"]) {

        
        JGJMyWorkCircleProListModel *proListModel = [[JGJMyWorkCircleProListModel alloc] init];
        proListModel.class_type = msgModel.origin_class_type;
        proListModel.group_id = msgModel.origin_group_id;
        proListModel.isClosedTeamVc = msgModel.IsCloseTeam;

        JGJDetailViewController *allDetailVc = [JGJDetailViewController new];

        allDetailVc.workProListModel = proListModel;
        NSDictionary *dic = [msgModel mj_keyValues];
        allDetailVc.jgjChatListModel = [JGJChatMsgListModel mj_objectWithKeyValues:dic];
        allDetailVc.IsClose = msgModel.IsCloseTeam;

        [self.navigationController pushViewController:allDetailVc animated:YES];
        
    }else if ([msgModel.msg_type isEqualToString:@"approval"] || [msgModel.msg_type isEqualToString:@"meeting"]) {

        
        [self pushToWebVcWithWebUrl:msgModel.url];
        
    }else if ([msgModel.msg_type isEqualToString:@"agreeSyncProjectToYou"]) {// 记工报表
        
        __weak typeof(self) weakSelf = self;
        
        NSString *statisticsStr = [NSString stringWithFormat:@"%@statistical/charts?is_demo=%@&talk_view=1&team_id=%@",JGJWebDiscoverURL, @"0", msgModel.origin_group_id];
        JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:statisticsStr];
        [self.navigationController pushViewController:webVc animated:YES];
        
    }else if ([msgModel.msg_type isEqualToString:@"syncBillToYou"]) {// 同步记工给我
        
        JGJSynRecordParentVc *synToMyProVc = [[JGJSynRecordParentVc alloc] init];
        
        //同步给我的记工
        synToMyProVc.synType = JGJSynToMeRecordType;
        
        [self.navigationController pushViewController:synToMyProVc animated:YES];
        
    }else if ([msgModel.msg_type isEqualToString:@"agreeSyncProject"]) {// 同意同步项目详情
        
        JGJSynRecordParentVc *synToMyProVc = [[JGJSynRecordParentVc alloc] init];
        //同步记工
        synToMyProVc.synType = JGJSynRecordType;
        
        [self.navigationController pushViewController:synToMyProVc animated:YES];
        
    }else if ([msgModel.msg_type isEqualToString:@"agreeSyncBill"]) {// 同意同步记工详情
        
        JGJSynRecordParentVc *synToMyProVc = [[JGJSynRecordParentVc alloc] init];
        //同步记工
        synToMyProVc.synType = JGJSynRecordType;
        [self.navigationController pushViewController:synToMyProVc animated:YES];
        
    }else if (msgModel.chatListType == JGJChatListDemandSyncProjectType || msgModel.chatListType == JGJChatListDemandSyncBillType) {// 要求同步项目/同步记工 推送
        
        _deleteMsgModel = msgModel;
        JGJDemandSyncProjectViewController *syncProject = [[JGJDemandSyncProjectViewController alloc] init];
        syncProject.msgModel = msgModel;
        [self.navigationController pushViewController:syncProject animated:YES];
        
        TYWeakSelf(self);
        // 拒绝同步项目或拒绝同步记工
        syncProject.refuseDemandSyncProjectOrBill = ^(id info) {
          
            JGJChatMsgListModel *reMsgModel = [JGJChatMsgListModel mj_objectWithKeyValues:info];
            _deleteMsgModel.msg_type = reMsgModel.msg_type;
            _deleteMsgModel.msg_text = reMsgModel.msg_text;
            _deleteMsgModel.title = reMsgModel.title;
            
            [JGJChatMsgDBManger updateMsgModelTableWithWorkTypeJGJChatMsgListModel:_deleteMsgModel];
            _deleteMsgModel.workCellHeight = 0;
            [weakself.workingList reloadData];
        };
        
        // 同步项目成功或同步记工成功
        syncProject.successDemandSyncProjectOrBill = ^(id info) {
          
            JGJChatMsgListModel *reMsgModel = [JGJChatMsgListModel mj_objectWithKeyValues:info];
            msgModel.msg_type = reMsgModel.msg_type;
            msgModel.msg_text = reMsgModel.msg_text;
            msgModel.title = reMsgModel.title;
            
            [JGJChatMsgDBManger updateMsgModelTableWithWorkTypeJGJChatMsgListModel:msgModel];
            
            msgModel.workCellHeight = 0;
            [weakself.workingList reloadData];
        };
        
        
    }else if ([msgModel.msg_type isEqualToString:@"oss"]) {// 云盘推送
        
        JGJServiceOverTimeRequest *request = [JGJServiceOverTimeRequest new];

        request.group_id = msgModel.origin_group_id;

        request.class_type = msgModel.origin_class_type;

        request.server_type = msgModel.status;

        JGJChatGroupListModel *origin_groupModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:msgModel.origin_group_id classType:msgModel.origin_class_type];
        [TYLoadingHub showLoadingWithMessage:nil];
        [JGJServiceOverTimeRequest serviceOverTimeRequest:request requestBlock:^(id response) {

            [TYLoadingHub hideLoadingView];
            NSString *record = [NSString stringWithFormat:@"%@", response[@"record_id"]];
            if ([record isEqualToString:@"1"]) {

                JGJYunFileApplicationSuccessViewController *yunFileVC = [[JGJYunFileApplicationSuccessViewController alloc] init];
                yunFileVC.status = msgModel.status;
                yunFileVC.projectName = origin_groupModel.group_name;
                [self.navigationController pushViewController:yunFileVC animated:YES];
            }

        }];
        

    }else if ([msgModel.msg_type isEqualToString:@"evaluate"]) {// 评价推送
        
        JGJMemberAppraiseDetailVc *detailVc = [[JGJMemberAppraiseDetailVc alloc] init];
        
        JGJSynBillingModel *memberModel = [[JGJSynBillingModel alloc] init];
        
        NSString *user_id = [TYUserDefaults objectForKey:JLGUserUid];
        
        memberModel.uid = user_id;
        
        //查看服务给的对应角色
        
        detailVc.cur_role = msgModel.status;
        
        detailVc.memberModel = memberModel;
        
        [self.navigationController pushViewController:detailVc animated:YES];
        
    }else if ([msgModel.msg_type isEqualToString:@"present_integral"]) {// 积分推送
        
//        [self.view addSubview:self.integralWebView];
//        NSURL *url = [NSURL URLWithString:msgModel.url];//创建URL
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];//创建
//        [_integralWebView loadRequest:request];
    
        NSString *webUrl = [NSString stringWithFormat:@"%@%@", JGJWebDiscoverURL,msgModel.url];
        JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:webUrl];
        [self.navigationController pushViewController:webVc animated:YES];
        
        
    }else if (msgModel.chatListType == JGJChatListLocalGroupChatType || msgModel.chatListType == JGJChatListWorkGroupChatType) {
        
        JGJQuickCreatChatVc *creatChatVc = [[JGJQuickCreatChatVc alloc] init];
        [self.navigationController pushViewController:creatChatVc animated:YES];
        
    }else if (msgModel.chatListType == JGJChatListFriendType) {
        
        JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
        
        perInfoVc.jgjChatListModel.uid = msgModel.msg_sender;
        
        perInfoVc.jgjChatListModel.group_id = msgModel.msg_sender;
        
        perInfoVc.jgjChatListModel.class_type = @"singleChat";
        
        [self.navigationController pushViewController:perInfoVc animated:YES];
        
    }else if (msgModel.chatListType == JGJChatListActivityType && [groupModel.class_type isEqualToString:@"activity"]) {
        
        if ([NSString isEmpty:msgModel.url]) {
            
            return;
        }
        NSString *webUrl = @"";
        if ([msgModel.url containsString:JGJWebDomainURL]) {// 用H5的头子
            
            webUrl = msgModel.url;
            JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:webUrl];
            [self.navigationController pushViewController:webVc animated:YES];
            
            
        }else {// 用自己的头子
            
            webUrl = [NSString stringWithFormat:@"%@%@", JGJWebDiscoverURL,msgModel.url];
            JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeExternalThirdPartBannerType URL:webUrl];
            
            [self.navigationController pushViewController:webVc animated:YES];
        }
    }else if (msgModel.chatListType == JGJChatListSwitchgroupType) {// 收到转让管理员通知，跳转到聊天页面
        
        JGJChatGroupListModel *oringGroupModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:msgModel.origin_group_id classType:msgModel.origin_class_type];
        // 清除未读数
        [JGJChatMsgDBManger cleadGroupUnReadMsgCountWithModel:oringGroupModel];
        
        JGJMyWorkCircleProListModel *proListModel = [[JGJMyWorkCircleProListModel alloc] init];
        proListModel.group_id = oringGroupModel.group_id;
        proListModel.class_type = oringGroupModel.class_type;
        proListModel.group_name = oringGroupModel.group_name;
        proListModel.members_num = oringGroupModel.members_num;
        proListModel.is_sticked = oringGroupModel.is_top;
        proListModel.pro_id = oringGroupModel.pro_id;
        proListModel.creater_uid = oringGroupModel.creater_uid;
        proListModel.isClosedTeamVc = oringGroupModel.is_closed;
        proListModel.extent_msg = oringGroupModel.extent_msg;
        proListModel.can_at_all = [[TYUserDefaults objectForKey:JLGUserUid] isEqualToString:oringGroupModel.creater_uid];
        
        [self handleJoinChatRootVcWithProListModel:proListModel didSelectRowAtIndexPath:indexPath];
        
    }else if (msgModel.chatListType == JGJChatListReopenType || msgModel.chatListType == JGJChatListJoinType) {// 收到班组或者项目重启推送 --- 收到加入班组或者项目推送
        
        
        JGJSwitchMyGroupsTool *tool = [JGJSwitchMyGroupsTool switchMyGroupsTool];
        
        [tool switchMyGroupsWithGroup_id:msgModel.origin_group_id?:@"" class_type:msgModel.origin_class_type?:@"" targetVc:self];
        
    }else if (msgModel.chatListType == JGJChatListPostCensorType) {
        
        if ([NSString isEmpty:msgModel.url]) {
            
            return;
        }
        NSString *webUrl = @"";
        if ([msgModel.url containsString:JGJWebDomainURL]) {// 用H5的头子
            
            webUrl = msgModel.url;
            JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:webUrl];
            [self.navigationController pushViewController:webVc animated:YES];
            
            
        }else {// 用自己的头子
            
            webUrl = [NSString stringWithFormat:@"%@%@", JGJWebDiscoverURL,msgModel.url];
            JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeExternalThirdPartBannerType URL:webUrl];
            
            [self.navigationController pushViewController:webVc animated:YES];
        }
    }
    
    if ([groupModel.class_type isEqualToString:@"recruit"]) {
        
        if (![NSString isEmpty:msgModel.url]) {
            
            [self pushToWebVcWithWebUrl:msgModel.url];
        }
        
        if (msgModel.chatListType == JGJChatListProjectInfoType) {
            
            if (![NSString isEmpty:msgModel.extend.msg_content.jump_url]) {
                
                [self tapRecruitmentSituationCellWithJumpUrl:msgModel.extend.msg_content.jump_url];
            }
        }

    }
   
}

#pragma mark - 进入聊天页面
- (void)handleJoinChatRootVcWithProListModel:(JGJMyWorkCircleProListModel *)proListModel didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJChatRootVc *chatRootVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatRootCommonVc"];
    
    //转换对象
    JGJMyWorkCircleProListModel *archProListModel = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:proListModel]];
    
    chatRootVc.workProListModel = archProListModel; //聊天页面
    
    [self.navigationController pushViewController:chatRootVc animated:YES];
    
}

- (void)pushToWebVcWithWebUrl:(NSString *)url {
    
    NSString *webUrl = [NSString stringWithFormat:@"%@%@", JGJWebDiscoverURL,url];
    if ([url rangeOfString:JGJWebDomainURL].location != NSNotFound) {

        JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeExternalThirdPartBannerType URL:webUrl];
        [self.navigationController pushViewController:webVc animated:YES];
        
    }else {
        
        JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:webUrl];
        [self.navigationController pushViewController:webVc animated:YES];
    }
}

#pragma mark - JGJChatMsgBaseCellDelegate
- (void)tapRecruitmentSituationCellWithJumpUrl:(NSString *)jumpUrl {
    
    if (![NSString isEmpty:jumpUrl]) {
        
        NSString *webUrl = [NSString stringWithFormat:@"%@%@", JGJWebDiscoverURL,jumpUrl];
        if ([jumpUrl rangeOfString:JGJWebDomainURL].location != NSNotFound) {
            
            JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeExternalThirdPartBannerType URL:webUrl];
            webVc.isRecruitmentSituationMsgComeIn = YES;// 招聘小助手里面的招工详情消息，跳转至H5隐藏底部
            [self.navigationController pushViewController:webVc animated:YES];
            
        }else {
            
            JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:webUrl];
            webVc.isRecruitmentSituationMsgComeIn = YES;// 招聘小助手里面的招工详情消息，跳转至H5隐藏底部
            [self.navigationController pushViewController:webVc animated:YES];
        }

    }
}

- (void)handleNoActiveGroup  {
    
    if (self.workingModelArr.count == 0) {
       
        CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:@"暂无记录哦~"];
        
        statusView.frame = self.workingList.bounds;
        
        self.workingList.tableHeaderView = statusView;
        
    } else {
        
        self.workingList.tableHeaderView = nil;
    }
}

- (UITableView *)workingList {
    
    if (!_workingList) {
        
        _workingList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - 64 - JGJ_IphoneX_BarHeight) style:(UITableViewStylePlain)];
        _workingList.backgroundColor = AppFontf1f1f1Color;
        _workingList.delegate = self;
        _workingList.dataSource = self;
        _workingList.separatorStyle = UITableViewCellSeparatorStyleNone;
        _workingList.tableFooterView = [[UIView alloc] init];
        _workingList.mj_header = [LZChatRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadWorkingMsgMoreData)];
        _workingList.showsVerticalScrollIndicator = YES;
        
        _workingList.estimatedRowHeight = 0;
        _workingList.estimatedSectionFooterHeight = 0;
        _workingList.estimatedSectionHeaderHeight = 0;
        
        
    }
    return _workingList;
}

- (NSMutableArray *)workingModelArr {
    
    if (!_workingModelArr) {
        
        _workingModelArr = [[NSMutableArray alloc] init];
    }
    return _workingModelArr;
}

- (NSMutableArray *)msg_id_sortArr {
    
    if (!_msg_id_sortArr) {
        
        _msg_id_sortArr = [[NSMutableArray alloc] init];
    }
    return _msg_id_sortArr;
}

- (UIWebView *)integralWebView {
    
    if (!_integralWebView) {
        
        _integralWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
    }
    return _integralWebView;
}

- (JGJChatMsgListModel *)bottomSpaceModel {
    
    if (!_bottomSpaceModel) {
        
        _bottomSpaceModel = [[JGJChatMsgListModel alloc] init];
        _bottomSpaceModel.sys_msg_type = @"work";
        _bottomSpaceModel.class_type = @"work";
        _bottomSpaceModel.msg_type = @"bottomDefaultSpace";
    }
    return _bottomSpaceModel;
}

- (JGJChatMsgListModel *)recruitBottomSpaceModel {
    
    if (!_recruitBottomSpaceModel) {
        
        _recruitBottomSpaceModel = [[JGJChatMsgListModel alloc] init];
        _recruitBottomSpaceModel.sys_msg_type = @"recruit";
        _recruitBottomSpaceModel.class_type = @"recruit";
        _recruitBottomSpaceModel.msg_type = @"bottomDefaultSpace";
    }
    return _recruitBottomSpaceModel;
}
@end
