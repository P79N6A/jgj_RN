//
//  JGJCreatProCompanyVC.m
//  JGJCompany
//
//  Created by yj on 16/9/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJCreatProCompanyVC.h"
#import "JGJCreatProNameCell.h"
#import "JGJCreatProAddMemberVC.h"
#import "NSString+Extend.h"
#import "JGJNewNotifyTool.h"

#import "JGJCustomAlertView.h"

#import "JGJChatMsgDBManger+JGJGroupDB.h"

#import "JGJChatMsgDBManger+JGJIndexDB.h"

@interface JGJCreatProCompanyVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) JGJCreatDiscussTeamRequest *discussTeamRequest;//项目组

/**
 *
 * 子类使用
 */
@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation JGJCreatProCompanyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新建项目";
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJCreatProNameCell *cell = [JGJCreatProNameCell cellWithTableView:tableView];
    __weak typeof(self) weakSelf = self;
    if (self.notifyModel) {
        cell.notifyModel = self.notifyModel;
    }
    cell.confirmCreatProBlock = ^(JGJCreatDiscussTeamRequest *discussTeamRequest){

        [weakSelf handleConfirmCreatProButtonAction:discussTeamRequest];
        
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [JGJCreatProNameCell creatProNameCellHeight];
}

#pragma mark - 确认创建项目
- (void)handleConfirmCreatProButtonAction:(JGJCreatDiscussTeamRequest *)discussTeamRequest {
    
    [self handleUpLoadMemberSuccess:discussTeamRequest];
    
}

#pragma mark - 聊天界面
- (void)handleUpLoadMemberSuccess:(JGJCreatDiscussTeamRequest *)discussTeamRequest {
    
    self.discussTeamRequest = discussTeamRequest;
    
    [self handleCreatTeamRequestModel];
    
    //工作消息创建项目
    if (![NSString isEmpty:self.notifyModel.target_uid]) {
        
        self.discussTeamRequest.msg_id = self.notifyModel.target_uid;
        
    }
    
    self.discussTeamRequest.group_name = discussTeamRequest.pro_name;
    
    self.discussTeamRequest.pro_name = nil;
    
    NSDictionary *parameters = [self.discussTeamRequest mj_keyValues];
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:@"group/create-team" parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];

        self.proListModel = [JGJMyWorkCircleProListModel mj_objectWithKeyValues:responseObject];
        
        self.proListModel.pro_name = self.discussTeamRequest.pro_name;
        
        self.proListModel.class_type = @"team";
        
        [TYShowMessage showSuccess:@"创建成功"];
        
        [self.view endEditing:YES];
        
        if (self.creatProSuccess) {
            
            self.creatProSuccess(responseObject);
        }
        [self insertGroupDBWithWorkProListModel:self.proListModel];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
    
}

#pragma mark - 插入数据库
- (void)insertGroupDBWithWorkProListModel:(JGJMyWorkCircleProListModel *)workProListModel {
    
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
    
    BOOL isHaveWorkVC = NO;
    JGJWorkingChatMsgViewController *workVC;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:[JGJWorkingChatMsgViewController class]]) {
            
            isHaveWorkVC = YES;
            workVC = (JGJWorkingChatMsgViewController *)vc;
            break;
        }
    }
    
    if (isHaveWorkVC) {
        
        [self.navigationController popToViewController:workVC animated:YES];
        
    }else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - 处理上传参数
- (void)handleCreatTeamRequestModel {

    //这里虽然只有一个人也用了数组，是因为之前的逻辑，加成员和来源人。后面需要添加多人的话按照模式将人员添加到数组就行了

    NSMutableArray *teamMemberModels = [NSMutableArray new];
    
    //新消息创建班组带入数据来源人的情况
    if (self.notifyModel) {
        JGJSynBillingModel *teamMemberModel = [[JGJSynBillingModel alloc] init];
        teamMemberModel.telphone = self.notifyModel.telphone;
        teamMemberModel.real_name = self.notifyModel.user_name;
        teamMemberModel.uid = self.notifyModel.uid;
        teamMemberModel.source_pro_id = self.notifyModel.source_pro_id;
        teamMemberModel.is_demand = @"0";
        if (self.notifyModel.members_head_pic.count == 1) {
            teamMemberModel.head_pic = [self.notifyModel.members_head_pic lastObject];
        }
        [teamMemberModels insertObject:teamMemberModel atIndex:0];
    }
    
    NSMutableArray *confirmSourceArray = [NSMutableArray array];
    NSMutableArray *allTeamMembers = [NSMutableArray array];
    NSMutableArray *sourceArray = [NSMutableArray array];
    NSMutableString *sourceProId = [NSMutableString string];
    
    for (JGJSynBillingModel *teamMemberModel in teamMemberModels) { //添加返回的成员需要上传的信息
        JGJGroupMembersRequestModel *membersModel = [[JGJGroupMembersRequestModel alloc] init];
        membersModel.real_name = teamMemberModel.real_name;
        membersModel.telephone = teamMemberModel.telephone;
        if (![NSString isEmpty:teamMemberModel.uid]) { //有数据源的联系人是否要求同步其他项目
            membersModel.is_demand = teamMemberModel.is_demand;
            [confirmSourceArray addObject:membersModel];//添加有源的联系人
            [sourceProId appendFormat:@"%@,", teamMemberModel.source_pro_id];
        }else {
            if (![NSString isEmpty:teamMemberModel.telephone]) {
                [sourceArray addObject:membersModel]; //没有源的来源人
            }
        }
    }
    
    if (sourceArray.count > 0) {
        [allTeamMembers addObjectsFromArray:sourceArray]; //添加数据源
    }
    if (confirmSourceArray.count > 0) {
        [allTeamMembers addObjectsFromArray:confirmSourceArray]; //添加有源的数据源
    }
    if (allTeamMembers.count > 0 || self.discussTeamRequest.team_members.count > 0) {
        [allTeamMembers addObjectsFromArray:self.discussTeamRequest.team_members];
    }
    self.discussTeamRequest.team_members = allTeamMembers; //全部成员
    self.discussTeamRequest.confirm_source_members = confirmSourceArray;//有源的联系人
    self.discussTeamRequest.source_members = sourceArray; //无源的联系人
    self.discussTeamRequest.source_pro_id = sourceProId; //所有的项目id
}


- (JGJCreatDiscussTeamRequest *)discussTeamRequest {
    if (!_discussTeamRequest) {
        _discussTeamRequest = [[JGJCreatDiscussTeamRequest alloc] init];
    }
    return _discussTeamRequest;
}

@end
