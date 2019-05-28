//
//  JGJCreatProAddDataSourceVC.m
//  JGJCompany
//
//  Created by yj on 16/9/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJCreatProAddDataSourceVC.h"
#import "JGJChatRootVc.h"
#import "JGJNewNotifyTool.h"
#import "NSString+Extend.h"
#import "CustomAlertView.h"
@interface JGJCreatProAddDataSourceVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *joinProButton;
@property (assign, nonatomic) BOOL isSuccessRequest;
@end

@implementation JGJCreatProAddDataSourceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonSet];
}

- (void)commonSet {
    [self.joinProButton.layer setLayerCornerRadius:4.0];
    NSMutableArray *dataSource = [NSMutableArray array];
    JGJSynBillingModel *memberModel = [[JGJSynBillingModel alloc] init];
    memberModel.addHeadPic = @"menber_add_icon";
    memberModel.name = @"添加来源人";
    memberModel.isMangerModel = YES;
    [dataSource addObject: memberModel];
    self.teamMemberModels = dataSource;
    JGJCreatProDecModel *proDecModel= [[JGJCreatProDecModel alloc] init];
    proDecModel.title = @"选择一个联系人，系统将发送消息通知他向你同步项目的相关数据，你就可以得到:";
    proDecModel.desc = @"1.实时的用工统计详情，方便你对项目用工做出分析和管理\n2.来自他人汇报的安全和质量报告，及时的对项目进度、安全隐患有详细的了解\n3.数据来源可以是工人、班组长或者企业端的其他用户";
    self.proDecModel = proDecModel;
    JGJTeamMemberCommonModel *commonModel = [[JGJTeamMemberCommonModel alloc] init];
    commonModel.isHiddenDeleteFlag = NO;
    commonModel.headerTitle = @"选择项目数据的联系人";
    commonModel.teamControllerType = JGJAddProSourceMemberControllerType; //当前类型是创建项目，添加人员
    commonModel.headerTitleColor = AppFontf7f7f7Color;
    commonModel.headerTitleTextColor = AppFont999999Color;
    commonModel.headerTitleFont = [UIFont systemFontOfSize:AppFont24Size];
    commonModel.memberType = JGJProSourceMemberType;
    self.commonModel = commonModel;
    self.groupMemberMangeType = JGJGroupMemberMangePushNotifyType;
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
        [self.teamMemberModels insertObject:teamMemberModel atIndex:0];
    }
    [self.tableView reloadData];
}

#pragma mark - 聊天界面
- (void)handleUpLoadMemberSuccess {
    [self handleCreatTeamRequestModel];
    NSDictionary *parameters = [self.discussTeamRequest mj_keyValues];
    __weak typeof(self) weakSelf = self;
    [TYLoadingHub showLoadingWithMessage:nil];
    [JGJSocketRequest WebSocketWithParameters:parameters success:^(id responseObject) {
        [TYLoadingHub hideLoadingView];
        [responseObject setObject:@"1" forKey:@"myself_group"]; //自己创建
        self.proListModel = [JGJMyWorkCircleProListModel mj_objectWithKeyValues:responseObject];
        self.proListModel.pro_name = self.discussTeamRequest.pro_name; //
        self.proListModel.class_type = @"team";
        if (self.notifyModel) { //新通知进入回传服务器
            [weakSelf handleUploadReadedNotify];
        }else {
            [weakSelf handleSkipJGJChatRootVc];
        }
    } failure:^(NSError *error,id values) {
        [TYLoadingHub hideLoadingView];
    }];
}

#pragma mark - 处理上传参数
- (void)handleCreatTeamRequestModel {
    NSMutableArray *confirmSourceArray = [NSMutableArray array];
    NSMutableArray *allTeamMembers = [NSMutableArray array];
    NSMutableArray *sourceArray = [NSMutableArray array];
    NSMutableString *sourceProId = [NSMutableString string];
    for (JGJSynBillingModel *teamMemberModel in self.teamMemberModels) { //添加返回的成员需要上传的信息
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

#pragma mark - buttonAction
#pragma mark - 进入项目组
- (IBAction)handleJoinProButtonAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    if (self.teamMemberModels.count == 1) {
        JGJSynBillingModel *teamMemberModel = [self.teamMemberModels lastObject];
        if (teamMemberModel.isMangerModel) {
            CustomAlertView *alertView = [CustomAlertView showWithMessage:@"可以今后再添加数据来源人" leftButtonTitle:nil midButtonTitle:nil rightButtonTitle:@"我知道了"];
            alertView.messageLabel.font = [UIFont systemFontOfSize:AppFont32Size];
            alertView.messageLabel.textAlignment = NSTextAlignmentCenter;
            alertView.onOkBlock = ^{
                [weakSelf handleUpLoadMemberSuccess];
            };
        }
    }else {
        [self handleUpLoadMemberSuccess];
    }
}

#pragma mark - 处理跳过按钮事件
- (IBAction)handelStepButtomItemAction:(UIBarButtonItem *)sender {
    __weak typeof(self) weakSelf = self;
    if (self.teamMemberModels.count == 1) {
        JGJSynBillingModel *teamMemberModel = [self.teamMemberModels lastObject];
        if (teamMemberModel.isMangerModel) {
            CustomAlertView *alertView = [CustomAlertView showWithMessage:@"可以今后再添加数据来源人" leftButtonTitle:nil midButtonTitle:nil rightButtonTitle:@"我知道了"];
            alertView.messageLabel.font = [UIFont systemFontOfSize:AppFont32Size];
            alertView.messageLabel.textAlignment = NSTextAlignmentCenter;
            alertView.onOkBlock = ^{
                [weakSelf handleUpLoadMemberSuccess];
            };
        }
    }else {
        [self handleUpLoadMemberSuccess];
    }
}

#pragma mark - 通知创建项目组成功回执服务器
- (void)handleUploadReadedNotify {
    NSDictionary *parameters = @{
                                 @"ctrl" : @"notice",
                                 @"action": @"noticeReaded",
                                 @"notice_id" : self.notifyModel.notice_id?:[NSNull null]
                                 };
    __weak typeof(self) weakSelf = self;
    [JGJSocketRequest WebSocketWithParameters:parameters success:^(id responseObject) {
        [weakSelf handleNotifyCreatTeamTeamUpdateDataBase];
        [weakSelf handleSkipJGJChatRootVc];
    } failure:nil];
}

#pragma mark - 处理加入班组成功更新数据库
- (void)handleNotifyCreatTeamTeamUpdateDataBase {
    self.notifyModel.iSNotifySynCreatTeam = YES;//创建成功设置为YES
    self.notifyModel.myself_group = @"1";
    self.notifyModel.team_name = self.proListModel.team_name;
    self.notifyModel.can_click = @"1";
    self.notifyModel.team_id = self.proListModel.team_id;
    self.notifyModel.pro_id = self.proListModel.pro_id;
    self.notifyModel.members_num = self.proListModel.members_num;
    [JGJNewNotifyTool updateNotifyModel:self.notifyModel];
}

#pragma mark - 处理跳转聊天页面
- (void)handleSkipJGJChatRootVc {
    __block UIViewController *newNotifySynProVc = nil;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"JGJNewNotifySynProDetailVC")]) {
            newNotifySynProVc = obj;
            [obj setValue:@1 forKey:@"proSynType"];
            *stop = YES;
        }
    }];
    //包含就返回
    if (newNotifySynProVc) {
        [self.navigationController popToViewController:newNotifySynProVc animated:YES];
    }else{
        JGJChatRootVc *chatRootVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatRootVc"];
        chatRootVc.workProListModel = self.proListModel;
        [self.navigationController pushViewController:chatRootVc animated:YES];
    }
}

@end
