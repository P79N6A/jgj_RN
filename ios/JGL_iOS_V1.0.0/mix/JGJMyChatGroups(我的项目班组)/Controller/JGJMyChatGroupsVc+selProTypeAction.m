//
//  JGJMyChatGroupsVc+selProTypeAction.m
//  mix
//
//  Created by yj on 2019/3/6.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJMyChatGroupsVc+selProTypeAction.h"

#import "AFNetworkReachabilityManager.h"

//日志
#import "JGJChatListLogVc.h"

//通知
#import "JGJChatListNoticeVc.h"

//质量
#import "JGJChatListQualityVc.h"

//安全
#import "JGJChatListSafeVc.h"

//签到
#import "JGJChatListSignVc.h"

//记账
#import "JGJChatListRecordVc.h"

//导入聊天模型

#import "JGJChatRootVc.h"

#import "JGJChatListBaseVc.h"

#import "JGJCheckProListVc.h"

#import "JGJMorePeopleViewController.h"
#import "PopoverView.h"

#import "JGJTaskRootVc.h"

#import "JLGAppDelegate.h"
#import "JGJAdvertisementShowView.h"

#import <UMAnalytics/MobClick.h>

#import "JGJLeaderRecordsViewController.h"
#import "JGJWorkMatesRecordsViewController.h"

#import "JGJProicloudRootVc.h"

#import "JGJGroupMangerTool.h"

#import "JGJWebUnSeniorPayVc.h"

#import "JGJRecordBillDetailViewController.h"

#import "JGJModifyBillListViewController.h"

#import "JGJQuaSafeHomeVc.h"

#import "JGJCustomAlertView.h"

#import "JGJCustomPopView.h"

#import "JGJRecordWorkpointsVc.h"

#import "JGJSurePoorbillViewController.h"

#import "JGJQuaSafeCheckHomeVc.h"

#import "JGJWebAllSubViewController.h"

#import "JGJSummerViewController.h"

#import "JGJKnowRepoVc.h"

#import "JLGCustomViewController.h"

#import "JGJMarkBillViewController.h"

#import "YZGSelectedRoleViewController.h"

#import "JGJRecordWorkpointsChangeViewController.h"
#import "JGJChatMsgDBManger+JGJGroupDB.h"
#import "JGJChatMsgDBManger+JGJIndexDB.h"

#import "JGJTabBarViewController.h"

#import "JGJCheckGroupChatAllMemberVc.h"

#import "JYSlideSegmentController.h"

#import "JGJWorkCircleProTypeTableViewCell.h"

@implementation JGJMyChatGroupsVc (selProTypeAction)

- (void)selProTypeModel:(JGJWorkCircleMiddleInfoModel *)proTypeModel {
    
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    
    AFNetworkReachabilityStatus status = manger.networkReachabilityStatus;
    
    if (status == AFNetworkReachabilityStatusNotReachable) {
        
        [TYShowMessage showPlaint:@"当前网络不可用"];
        
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    JGJMyWorkCircleProListModel *workProListModel = self.proListModel.group_info;
    
    //当前点击的批量记工,添加记工
    BOOL isClosedType = proTypeModel.cellType == 0;
    
    if (workProListModel.isClosedTeamVc && isClosedType && [workProListModel.class_type isEqualToString:@"group"]) {
        
        NSString *showPlaint = [workProListModel.class_type isEqualToString:@"team"] ? @"项目已关闭，不能执行此操作":@"班组已关闭，不能执行此操作";
        
        [TYShowMessage showPlaint:showPlaint];
        
        return;
    }
    
    JGJChatRootRequestModel *chatRootRequestModel = [JGJChatRootRequestModel new];
    chatRootRequestModel.group_id = workProListModel.group_id;
    chatRootRequestModel.action = @"groupMessageList";
    chatRootRequestModel.class_type = workProListModel.class_type;
    
    chatRootRequestModel.ctrl = @"message";
    
    chatRootRequestModel.pageturn = @"next";
    
    
    BOOL isTeam = [workProListModel.class_type isEqualToString:@"team"];
    
    UIViewController *nextVc = [UIViewController new];
    
    //是班组情况
    if (!isTeam) {
        
        BOOL is_myCreater = [workProListModel.myself_group isEqualToString:@"1"];
        
        BOOL is_agency_author = workProListModel.is_myAgency_group && !isTeam; //是否具有代理权限
        
        BOOL is_myset_agency = workProListModel.is_agency_group && is_myCreater; //创建者已设代理权限
        
        //没有设置代理班组长
        
        
        if (!is_myCreater && !is_agency_author && !is_myset_agency) {
            
            nextVc = [self normalGroupProTypeModel:proTypeModel chatRootRequestModel:chatRootRequestModel];
            
        }else if (is_agency_author) {
            
            BOOL is_can_sel = [self canDidSelectedListType:proTypeModel];
            
            if (!is_can_sel) {
                
                return;
            }
            
            nextVc = [self normalAgencyGroupProTypeModel:proTypeModel chatRootRequestModel:chatRootRequestModel];
            
        }else if (is_myset_agency) {
            
            nextVc = [self createrSetAgencyGroupProTypeModel:proTypeModel chatRootRequestModel:chatRootRequestModel];
        }else {
            
            nextVc = [self normalGroupProTypeModel:proTypeModel chatRootRequestModel:chatRootRequestModel];
        }
        
        if (!nextVc) {
            
            return;
        }
        
    }else {
        
        switch (proTypeModel.cellType) {
                
            case 0: {
                
                JGJQuaSafeHomeVc *qualityVc = [self selQualityVc];
                
                chatRootRequestModel.msg_type = @"quality";
                
                nextVc = qualityVc;
                
                
            }
                
                break;
                
            case 1: {
                
                JGJQuaSafeHomeVc *quaSafeHomeVc = [self selSafeVc];
                
                chatRootRequestModel.msg_type = @"safe";
                
                nextVc = quaSafeHomeVc;
                
            }
                
                break;
                
            case 2:{
                
                nextVc = [self selCheckVc];
                
            }
                
                break;
                
            case 3:{
                
                nextVc = [self selTaskVc];
                
            }
                
                break;
                
            case 4:{
                
                JGJChatListNoticeVc *noticeVc = [self selNoticeVc];
                
                chatRootRequestModel.msg_type = @"notice";
                
                nextVc = noticeVc;
                
                
                
            }
                
                break;
                
            case 5:{
                
                JGJChatListSignVc *signVc = [self selSignVc];
                
                chatRootRequestModel.msg_type = @"signIn";
                
                nextVc = signVc;
                
                
            }
                
                break;
                
            case 6:{
                
                nextVc = [self selMeetingVc];
                
                TYLog(@"会议 -----");
            }
                
                break;
                
                
            case 7:{
                
                nextVc = [self selApplyVc];
                
                TYLog(@"--------审批");
                
            }
                
                break;
                
            case 8:{
                
                JGJChatListLogVc *logVc = [self selLogVc];
                
                chatRootRequestModel.msg_type = @"log";
                
                nextVc = logVc;
                
            }
                
                break;
                
            case 9:{
                
                JGJSummerViewController *weatherVC = [JGJSummerViewController new];
                
                //创建者和记录员is_report都是1
                
                if ([self.proListModel.group_info.myself_group isEqualToString:@"1"]) {
                    
                    self.proListModel.group_info.is_report = @"1";
                }
                
                weatherVC.WorkCicleProListModel = self.proListModel.group_info;
                
                nextVc = weatherVC;
                
                TYLog(@"--------晴雨表");
                
            }
                
                break;
                
            case 10:{
                
                nextVc = [self selRepoVc];
                
            }
                
                break;
                
            case 11:{
                
                nextVc = [self selCloudVc];
                
            }
                
                break;
                
            case 12:{
                
                nextVc = [self selOfficialWebc];
                
            }
                
                break;
                
            case 13:{
                
                nextVc = [self selEquipmentWebVc];
                
            }
                
                break;
                
            case 14:{
                
                nextVc = [self selRecordStaWebc];
                //
            }
                
                break;
                
            case 15:{
                
                nextVc = [self handleCheckAllMember];
            }
                
                break;
                
            case 16:{
                
                nextVc = [self selSettingVc];
                
            }
                
                break;
                
                
            default:
                break;
        }
        
    }
    
    if ([nextVc isKindOfClass:[JGJChatListBaseVc class]]) {
        JGJChatListBaseVc *baseVc = (JGJChatListBaseVc *)nextVc;
        
        baseVc.workProListModel = workProListModel;
        
        TYLog(@"=========%@", [baseVc.workProListModel mj_keyValues]);
        
        baseVc.chatListRequestModel = chatRootRequestModel;
        
        //进入下一个界面
        baseVc.skipToNextVc = ^(UIViewController *nextVc){
            [weakSelf.navigationController pushViewController:nextVc animated:YES];
        };
    }else if([nextVc isKindOfClass:[JGJChatListRecordVc class]]){
        JGJChatListRecordVc *recordVc = (JGJChatListRecordVc *)nextVc;
        recordVc.chatListRequestModel = chatRootRequestModel;
        recordVc.workProListModel = workProListModel;
        
        //进入下一个界面
        recordVc.skipToNextVc = ^(UIViewController *nextVc){
            [weakSelf.navigationController pushViewController:nextVc animated:YES];
        };
    }else if([nextVc isKindOfClass:[JGJWebAllSubViewController class]]){
        JGJWebAllSubViewController *webVc = (JGJWebAllSubViewController *)nextVc;
        
        //进入下一个界面
        webVc.skipToNextVc = ^(UIViewController *nextVc){
            [weakSelf.navigationController pushViewController:nextVc animated:YES];
        };
    }
    
    //是项目情况,不是知识库都需要完成姓名（,班组记工进去完善姓名）
    if ((proTypeModel.cellType != 10 && isTeam) || (proTypeModel.cellType != 6 && proTypeModel.cellType != 0  && !isTeam)) {
        
        if (![self checkIsRealName]) {
            
            TYWeakSelf(self);
            if ([self.navigationController isKindOfClass:NSClassFromString(@"JLGCustomViewController")]) {
                
                JLGCustomViewController *customVc = (JLGCustomViewController *) self.navigationController;
                
                customVc.customVcBlock = ^(id response) {
                    
                    //检查、设备管理
                    if ((proTypeModel.cellType != 13 && proTypeModel.cellType != 2) && isTeam) {
                        
                        [weakself.navigationController pushViewController:nextVc animated:YES];
                        
                    } else if (!isTeam) {
                        
                        [weakself.navigationController pushViewController:nextVc animated:YES];
                    }
                    
                };
                
            }
            
            return;
            
        }else {
            
            [self.navigationController pushViewController:nextVc animated:YES];
        }
        
    }else {
        
        [self.navigationController pushViewController:nextVc animated:YES];
        
    }
}

- (UIViewController *)handleClickedMulRecordListType:(JGJWorkCircleMiddleInfoModel *)proTypeModel {
    
    JGJMyWorkCircleProListModel *workProListModel = self.proListModel.group_info;
    
    UIViewController *recordVc = [UIViewController new];
    
    if ([workProListModel.myself_group isEqualToString:@"1"]) {
        
        JgjRecordlistModel *listModel = [JgjRecordlistModel new];
        JGJMorePeopleViewController *morePepleRecordVc = [[JGJMorePeopleViewController alloc]init];
        
        listModel.group_id = workProListModel.group_id;
        listModel.members_num = workProListModel.members_num;
        listModel.pro_id   = workProListModel.pro_id;
        listModel.pro_name = workProListModel.pro_name;
        listModel.group_name = workProListModel.group_name;
        listModel.all_pro_name = workProListModel.all_pro_name;
        morePepleRecordVc.isMinGroup = YES;
        
        morePepleRecordVc.recordSelectPro = listModel;
        
        recordVc = morePepleRecordVc;
        
    }else {
        
        
        JYSlideSegmentController *slideSegmentVC = [[JYSlideSegmentController alloc] init];
        slideSegmentVC.is_Home_ComeIn = YES;
        slideSegmentVC.workProListModel = workProListModel;
        slideSegmentVC.segmentType = JYSlideSegmentTinyAndContractType;
        slideSegmentVC.title = @"记工记账";
        recordVc = slideSegmentVC;
        
    }
    
    return recordVc;
    
}

#pragma mark - 切换身份
- (void)changeRoleWithType:(NSInteger)type {
    
    [JGJComTool changeRoleWithType:type successBlock:^{
        
    }];
}

- (void)closeGroupFlag:(UIViewController *)targetVc {
    
    if (self.proListModel.group_info.isClosedTeamVc) {
        
        UIImageView *clocedImageView = [[UIImageView alloc] init];
        
        NSString *closeType = @"Chat_closedGroup";
        
        if ([self.proListModel.group_info.class_type isEqualToString:@"team"]) {
            
            closeType = @"pro_closedFlag_icon";
        }
        
        clocedImageView.image = [UIImage imageNamed:closeType];
        
        [targetVc.view addSubview:clocedImageView];
        
        [clocedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.mas_equalTo(targetVc.view);
            make.width.mas_equalTo(126);
            make.height.mas_equalTo(70);
        }];
        
    }
    
}

#pragma mark - 过期提示

#pragma mark - 全局取消黄金服务版(4个位置修改了，搜索这句话)

-(BOOL)overTimeTip {
    
    JGJGroupMangerTool *groupMangerTool = [[JGJGroupMangerTool alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
    groupMangerTool.groupMangerToolBlock = ^(id response) {
        
        [TYShowMessage showPlaint:@"操作成功"];
    };
    
    //升级类型
    groupMangerTool.buyGoodType = VIPServiceType;
    
    groupMangerTool.targetVc = self.navigationController;
    
    groupMangerTool.workProListModel = self.proListModel.group_info;
    
    //    return [groupMangerTool overTimeTip];
    
    return NO;
    
    
}

#pragma mark - 班组、项目公共

#pragma mark - 签到
- (JGJChatListSignVc *)selSignVc{
    
    JGJChatListSignVc *signVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatListSignVc"];
    
    [self closeGroupFlag:signVc];
    
    return signVc;
}

#pragma mark - 通知
- (JGJChatListNoticeVc *)selNoticeVc{
    
    JGJChatListNoticeVc *noticeVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatListNoticeVc"];
    
    [self closeGroupFlag:noticeVc];
    
    return noticeVc;
}

#pragma mark - 质量
- (JGJQuaSafeHomeVc *)selQualityVc{
    
    JGJQuaSafeHomeVc *qualityVc = [JGJQuaSafeHomeVc new];
    
    JGJQualitySafeCommonModel *commonModel = [JGJQualitySafeCommonModel new];
    
    commonModel.type = JGJChatListQuality;
    
    commonModel.msg_type = @"quality";
    
    qualityVc.commonModel = commonModel;
    
    //区分质量安全任务存草稿
    commonModel.quaSafeCheckType = @"qualityType";
    
    qualityVc.workProListModel = self.proListModel.group_info;
    
    // 清除首页质量红点
    JGJIndexDataModel *indexModel = [JGJChatMsgDBManger getTheIndexModelInIndexTable];
    indexModel.unread_quality_count = @"0";
    [JGJChatMsgDBManger updateIndexModelToIndexTable:indexModel];
    
    // 清除聊聊列表对应的质量未读数
    JGJChatGroupListModel *originGroupModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:indexModel.group_id classType:indexModel.class_type];
    originGroupModel.unread_quality_count = @"0";
    [JGJChatMsgDBManger updateChatGroupListTableTheUnread_work_countWithGroupListModel:originGroupModel group_id:indexModel.group_id class_type:indexModel.class_type];
    
    
    return qualityVc;
}

#pragma mark - 安全
- (JGJQuaSafeHomeVc *)selSafeVc{
    
    JGJQuaSafeHomeVc *quaSafeHomeVc = [JGJQuaSafeHomeVc new];
    
    JGJQualitySafeCommonModel *commonModel = [JGJQualitySafeCommonModel new];
    
    commonModel.type = JGJChatListSafe;
    
    commonModel.msg_type = @"safe";
    
    //    chatRootRequestModel.msg_type = @"safe";
    
    //区分质量安全任务存草稿
    commonModel.quaSafeCheckType = @"safeType";
    
    quaSafeHomeVc.commonModel = commonModel;
    
    quaSafeHomeVc.workProListModel = self.proListModel.group_info;
    
    JGJIndexDataModel *indexModel = [JGJChatMsgDBManger getTheIndexModelInIndexTable];
    indexModel.unread_safe_count = @"0";
    [JGJChatMsgDBManger updateIndexModelToIndexTable:indexModel];
    
    
    // 清除聊聊列表对应的质量未读数
    JGJChatGroupListModel *originGroupModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:indexModel.group_id classType:indexModel.class_type];
    originGroupModel.unread_safe_count = @"0";
    [JGJChatMsgDBManger updateChatGroupListTableTheUnread_work_countWithGroupListModel:originGroupModel group_id:indexModel.group_id class_type:indexModel.class_type];
    return quaSafeHomeVc;
}

#pragma mark - 班组内容

#pragma mark - 选择代理记工
- (JGJMorePeopleViewController *)selAgencyRecordVc {
    
    JGJMyWorkCircleProListModel *workProListModel = self.proListModel.group_info;
    
    JgjRecordlistModel *listModel = [JgjRecordlistModel new];
    
    JGJMorePeopleViewController *morePepleRecordVc = [[JGJMorePeopleViewController alloc]init];
    
    morePepleRecordVc.isAgentMonitor = YES;
    
    morePepleRecordVc.agency_uid = workProListModel.agency_group_user.uid;
    
    morePepleRecordVc.WorkCircleProListModel = workProListModel;
    
    listModel.group_id = workProListModel.group_id;
    listModel.members_num = workProListModel.members_num;
    listModel.pro_id   = workProListModel.pro_id;
    listModel.pro_name = workProListModel.pro_name;
    listModel.group_name = workProListModel.group_name;
    listModel.all_pro_name = workProListModel.all_pro_name;
    morePepleRecordVc.recordSelectPro = listModel;
    morePepleRecordVc.isMinGroup = YES;
    
    return morePepleRecordVc;
}

#pragma mark - 代理流水
- (JGJRecordWorkpointsVc *)selAgencyPointVc {
    
    TYLog(@"--------代理流水");
    JGJRecordWorkpointsVc *recordWorkpointsVc = [[UIStoryboard storyboardWithName:@"JGJRecordWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJRecordWorkpointsVc"];
    
    recordWorkpointsVc.proListModel = self.proListModel.group_info;
    
    return recordWorkpointsVc;
}

#pragma mark - 代理对账
- (JGJSurePoorbillViewController *)selAencyCheckRecordVc {
    
    JGJMyWorkCircleProListModel *workProListModel = self.proListModel.group_info;
    
    JGJSurePoorbillViewController *poorBillVC = [[UIStoryboard storyboardWithName:@"JGJSurePoorbillVC" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJSurePoorbillVC"];
    
    poorBillVC.agency_uid = workProListModel.agency_group_user.uid;
    
    poorBillVC.group_id = workProListModel.group_id;
    
    return poorBillVC;
}

#pragma mark - 选择记工
- (UIViewController *)selRecordVcWithProTypeModel:(JGJWorkCircleMiddleInfoModel *)proTypeModel isBorrow:(BOOL)isBorrow {
    
    JGJMyWorkCircleProListModel *workProListModel = self.proListModel.group_info;
    
    UIViewController *nextVc = nil;
    
    if ([workProListModel.myself_group isEqualToString:@"1"]) {
        
        if (JLGisLeaderBool) {
            
            if (isBorrow) {
                
                nextVc = [self selBorrowVc];
                
            }else {
                
                //点击记账
                nextVc = [self handleClickedMulRecordListType:proTypeModel];
            }
            //            //点击记账
            //            nextVc = [self handleClickedMulRecordListType:proTypeModel];
            
        }else {
            
            JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
            
            desModel.popDetail = @"你当前是【工人】\n如需对自己的班组批量记工，请切换成【班组长】身份。";
            
            desModel.leftTilte = @"不切换";
            
            desModel.rightTilte = @"切换成【班组长】";
            
            desModel.changeContents = @[@"【班组长】", @"【工人】"];
            desModel.lineSapcing = 5;
            desModel.changeContentColor = AppFont000000Color;
            desModel.messageFont = [UIFont systemFontOfSize:AppFont30Size];
            JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
            alertView.contentViewHeight.constant = 140;
            alertView.messageLable.textAlignment = NSTextAlignmentLeft;
            alertView.backgroundColor = [AppFont000000Color colorWithAlphaComponent:0.75];
            __weak typeof(self) weakSelf = self;
            
            alertView.onOkBlock = ^{
                
                [weakSelf changeRoleWithType:2];
            };
            
            return nil;
        }
        
    }else {
        
        if (JLGisLeaderBool) {
            
            JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
            
            desModel.popDetail = @"你当前是【班组长】\n如需在加入的班组中记工，请切换成【工人】身份。";
            
            desModel.leftTilte = @"不切换";
            
            desModel.rightTilte = @"切换成【工人】";
            
            desModel.changeContents = @[@"【班组长】", @"【工人】"];
            desModel.lineSapcing = 5;
            desModel.changeContentColor = AppFont000000Color;
            desModel.messageFont = [UIFont systemFontOfSize:AppFont30Size];
            
            JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
            alertView.contentViewHeight.constant = 140;
            alertView.messageLable.textAlignment = NSTextAlignmentLeft;
            alertView.backgroundColor = [AppFont000000Color colorWithAlphaComponent:0.75];
            __weak typeof(self) weakSelf = self;
            
            alertView.onOkBlock = ^{
                
                
                [weakSelf changeRoleWithType:1];
            };
            
            return nil;
        }else {
            
            if (isBorrow) {
                
                nextVc = [self selBorrowVc];
                
            }else {
                
                //点击记账
                nextVc = [self handleClickedMulRecordListType:proTypeModel];
            }
            
        }
        
    }
    
    return nextVc;
}



- (UIViewController *)normalGroupProTypeModel:(JGJWorkCircleMiddleInfoModel *)proTypeModel chatRootRequestModel:(JGJChatRootRequestModel *)chatRootRequestModel {
    
    UIViewController *nextVc = nil;
    
    switch (proTypeModel.cellType) {
            
        case 0: {
            
            nextVc = [self selRecordVcWithProTypeModel:proTypeModel isBorrow:NO];
            
            if (!nextVc) {
                
                return nil;
            }
        }
            
            break;
            
        case 1:{
            
            nextVc = [self selRecordVcWithProTypeModel:proTypeModel isBorrow:YES];
            
            if (!nextVc) {
                
                return nil;
            }
        }
            break;
            
        case 2:{ //出勤公示
            
            nextVc = [self selRecordListVc];
            
        }
            
            break;
            
        case 3:{
            
            JGJChatListSignVc *signVc = [self selSignVc];
            
            chatRootRequestModel.msg_type = @"signIn";
            
            nextVc = signVc;
            
        }
            
            break;
            
            
        case 4:{
            
            JGJChatListNoticeVc *noticeVc = [self selNoticeVc];
            
            chatRootRequestModel.msg_type = @"notice";
            
            nextVc = noticeVc;
        }
            
            break;
            
        case 5:{
            
            JGJQuaSafeHomeVc *qualityVc = [self selQualityVc];
            
            chatRootRequestModel.msg_type = @"quality";
            
            nextVc = qualityVc;
        }
            
            break;
            
        case 6:{
            
            JGJQuaSafeHomeVc *quaSafeHomeVc = [self selSafeVc];
            
            chatRootRequestModel.msg_type = @"safe";
            
            nextVc = quaSafeHomeVc;
            
        }
            
            break;
            
        case 7:{
            
            JGJChatListLogVc *logVc = [self selLogVc];
            
            chatRootRequestModel.msg_type = @"log";
            
            nextVc = logVc;
            
        }
            
            break;
            
        case 8:{
            
            nextVc = [self handleCheckAllMember];
        }
            
            break;
            
        case 9:{
            
            nextVc = [self selSettingVc];
            
        }
            
            break;
            
        default:
            
            break;
    }
    
    return nextVc;
}

#pragma mark - 借支结算
- (UIViewController *)selBorrowVc {
    
    JGJMyWorkCircleProListModel *workProListModel = self.proListModel.group_info;
    
    UIViewController *vc = [UIViewController new];
    JYSlideSegmentController *slideSegmentVC = [[JYSlideSegmentController alloc] init];
    slideSegmentVC.is_Home_ComeIn = YES;
    slideSegmentVC.workProListModel = workProListModel;
    slideSegmentVC.segmentType = JYSlideSegmentBorrowAndCloseCountType;
    slideSegmentVC.title = @"记工记账";
    vc = slideSegmentVC;
    
    return vc;
    
}

- (UIViewController *)createrSetAgencyGroupProTypeModel:(JGJWorkCircleMiddleInfoModel *)proTypeModel chatRootRequestModel:(JGJChatRootRequestModel *)chatRootRequestModel {
    
    UIViewController *nextVc = nil;
    
    switch (proTypeModel.cellType) {
            
        case 0: {
            
            nextVc = [self selRecordVcWithProTypeModel:proTypeModel isBorrow:NO];
            
            if (!nextVc) {
                
                return nil;
            }
        }
            
            break;
            
        case 1:{
            
            nextVc = [self selRecordVcWithProTypeModel:proTypeModel isBorrow:YES];
            
            if (!nextVc) {
                
                return nil;
            }
        }
            break;
            
        case 2:{ //记工变更
            
            TYLog(@"-------------记工变更");
            
            nextVc = [self selRecordChangeVc];
            
        }
            
            break;
            
        case 3:{ //出勤公示
            
            nextVc = [self selRecordListVc];
            
        }
            
            break;
            
        case 4:{
            
            JGJChatListSignVc *signVc = [self selSignVc];
            
            chatRootRequestModel.msg_type = @"signIn";
            
            nextVc = signVc;
            
        }
            
            break;
            
            
        case 5:{
            
            JGJChatListNoticeVc *noticeVc = [self selNoticeVc];
            
            chatRootRequestModel.msg_type = @"notice";
            
            nextVc = noticeVc;
        }
            
            break;
            
        case 6:{
            
            JGJQuaSafeHomeVc *qualityVc = [self selQualityVc];
            
            chatRootRequestModel.msg_type = @"quality";
            
            nextVc = qualityVc;
        }
            
            break;
            
        case 7:{
            
            JGJQuaSafeHomeVc *quaSafeHomeVc = [self selSafeVc];
            
            chatRootRequestModel.msg_type = @"safe";
            
            nextVc = quaSafeHomeVc;
            
        }
            
            break;
            
        case 8:{
            
            JGJChatListLogVc *logVc = [self selLogVc];
            
            chatRootRequestModel.msg_type = @"log";
            
            nextVc = logVc;
            
        }
            
            break;
            
        case 9:{
            
            nextVc = [self handleCheckAllMember];
        }
            
            break;
            
        case 10:{
            
            nextVc = [self selSettingVc];
            
        }
            
            break;
            
        default:
            
            break;
    }
    
    return nextVc;
}


#pragma mark - 我是代理班组长
- (UIViewController *)normalAgencyGroupProTypeModel:(JGJWorkCircleMiddleInfoModel *)proTypeModel chatRootRequestModel:(JGJChatRootRequestModel *)chatRootRequestModel {
    
    UIViewController *nextVc = nil;
    
    switch (proTypeModel.cellType) {
            
        case 0:{ //代理记工
            
            nextVc = [self selAgencyRecordVc];
        }
            
            break;
            
        case 1:{ //代理流水
            
            TYLog(@"--------代理流水");
            nextVc = [self selAgencyPointVc];
            
        }
            
            break;
            
        case 2:{ //代理对账
            
            TYLog(@"--------代理对账");
            
            nextVc = [self selAencyCheckRecordVc];
            
        }
            
            break;
            
        case 3:{ //记工变更
            
            TYLog(@"-------------记工变更");
            
            nextVc = [self selRecordChangeVc];
            
        }
            
            break;
            
        case 4: {
            
            nextVc = [self selRecordVcWithProTypeModel:proTypeModel isBorrow:NO];
            
            if (!nextVc) {
                
                return nil;
            }
        }
            
            break;
            
        case 5:{ //借支结算
            
            nextVc = [self selRecordVcWithProTypeModel:proTypeModel isBorrow:YES];
            
            if (!nextVc) {
                
                return nil;
            }
            
        }
            break;
            
        case 6:{ //出勤公示
            
            nextVc = [self selRecordListVc];
            
        }
            
            break;
            
        case 7:{
            
            JGJChatListSignVc *signVc = [self selSignVc];
            
            chatRootRequestModel.msg_type = @"signIn";
            
            nextVc = signVc;
            
        }
            
            break;
            
            
        case 8:{
            
            JGJChatListNoticeVc *noticeVc = [self selNoticeVc];
            
            chatRootRequestModel.msg_type = @"notice";
            
            nextVc = noticeVc;
            
        }
            
            break;
            
        case 9:{
            
            JGJQuaSafeHomeVc *qualityVc = [self selQualityVc];
            
            chatRootRequestModel.msg_type = @"quality";
            
            nextVc = qualityVc;
        }
            
            break;
            
        case 10:{
            
            JGJQuaSafeHomeVc *quaSafeHomeVc = [self selSafeVc];
            
            chatRootRequestModel.msg_type = @"safe";
            
            nextVc = quaSafeHomeVc;
            
        }
            
            break;
            
        case 11:{
            
            JGJChatListLogVc *logVc = [self selLogVc];
            
            chatRootRequestModel.msg_type = @"log";
            
            nextVc = logVc;
            
        }
            
            break;
            
        case 12:{
            
            nextVc = [self handleCheckAllMember];
        }
            
            break;
            
        case 13:{
            
            nextVc = [self selSettingVc];
            
        }
            
            break;
            
        default:
            
            break;
    }
    
    return nextVc;
}

#pragma mark - 选择记工变更
- (UIViewController *)selRecordChangeVc {
    
    JGJMyWorkCircleProListModel *workProListModel = self.proListModel.group_info;
    JGJRecordWorkpointsChangeViewController *recordChangeListVC = [[JGJRecordWorkpointsChangeViewController alloc] init];
    recordChangeListVC.group_id = workProListModel.group_id;
    recordChangeListVC.proListModel = self.proListModel;
    return recordChangeListVC;
}

#pragma mark - 出勤公示
- (UIViewController *)selRecordListVc {
    
    JGJIndexDataModel *indexModel = [JGJChatMsgDBManger getTheIndexModelInIndexTable];
    indexModel.unread_billRecord_count = @"0";
    [JGJChatMsgDBManger updateIndexModelToIndexTable:indexModel];
    
    // 清除聊聊列表对应的质量未读数
    JGJChatGroupListModel *originGroupModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:indexModel.group_id classType:indexModel.class_type];
    originGroupModel.unread_billRecord_count = @"0";
    [JGJChatMsgDBManger updateChatGroupListTableTheUnread_work_countWithGroupListModel:originGroupModel group_id:indexModel.group_id class_type:indexModel.class_type];
    
    JGJChatListRecordVc *recordVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatListRecordVc"];
    
    return recordVc;
}

#pragma mark - 班组设置
- (UIViewController *)selSettingVc{
    
    NSString *vcIdentifier = [self.proListModel.group_info.class_type isEqualToString:@"group"] ? @"JGJTeamMangerVC" : @"JGJGroupMangerVC";
    
    UIViewController *mangerVC = [[UIStoryboard storyboardWithName:@"JGJTeamManger" bundle:nil] instantiateViewControllerWithIdentifier:vcIdentifier];
    
    [mangerVC setValue:self.proListModel.group_info forKey:@"workProListModel"];
    
    return mangerVC;
}

#pragma mark - 项目内容

#pragma mark - 检查
- (JGJQuaSafeCheckHomeVc *)selCheckVc{
    
    JGJQuaSafeCheckHomeVc *quaSafeCheckHomeVc = [JGJQuaSafeCheckHomeVc new];
    
    quaSafeCheckHomeVc.proListModel = self.proListModel.group_info;
    
    return quaSafeCheckHomeVc;
    
}

#pragma mark - 任务
- (JGJTaskRootVc *)selTaskVc{
    
    JGJQualitySafeCommonModel *commonModel = [JGJQualitySafeCommonModel new];
    
    JGJTaskRootVc *taskRootVc = [[JGJTaskRootVc alloc] init];
    
    taskRootVc.proListModel = self.proListModel.group_info;
    
    commonModel.msg_type = @"task";
    
    taskRootVc.commonModel = commonModel;
    
    return taskRootVc;
}

#pragma mark - 项目设置
- (void)selTeamSettingVc{
    
    
}

#pragma mark - 日志
- (JGJChatListLogVc *)selLogVc{
    
    JGJChatListLogVc *logVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatListLogVc"];
    logVc.cur_name = self.proListModel.group_info.cur_name;
    //    chatRootRequestModel.msg_type = @"log";
    
    return logVc;
}

#pragma mark - 云盘
- (JGJProicloudRootVc *)selCloudVc{
    
    JGJProicloudRootVc *cloudRootVc = [[UIStoryboard storyboardWithName:@"JGJProicloud" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJProicloudRootVc"];
    
    cloudRootVc.proListModel = self.proListModel.group_info;
    
    [self closeGroupFlag:cloudRootVc];
    
    
    return cloudRootVc;
}

#pragma mark - 官网
- (JGJWebAllSubViewController *)selOfficialWebc{
    
    JGJMyWorkCircleProListModel *workProListModel = self.proListModel.group_info;
    
    //项目微官网
    NSString *websiteStr = [NSString stringWithFormat:@"%@website?group_id=%@&class_type=%@&close=%@",JGJWebDiscoverURL, workProListModel.group_id, workProListModel.class_type, @(workProListModel.isClosedTeamVc)];
    
    JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:websiteStr];
    
    return webVc;
}

#pragma mark - 设备管理
- (JGJWebAllSubViewController *)selEquipmentWebVc{
    
    JGJMyWorkCircleProListModel *workProListModel = self.proListModel.group_info;
    
    //设备管理
    NSString *equipmentStr = [NSString stringWithFormat:@"%@equipment?group_id=%@&class_type=%@&close=%@",JGJWebDiscoverURL, workProListModel.group_id, workProListModel.class_type, @(workProListModel.isClosedTeamVc)];
    
    JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:equipmentStr];
    
    return webVc;
}

#pragma mark - 记工报表
- (JGJWebAllSubViewController *)selRecordStaWebc{
    
    JGJMyWorkCircleProListModel *workProListModel = self.proListModel.group_info;
    
    NSString *statisticsStr = [NSString stringWithFormat:@"%@statistical/charts?is_demo=%@&talk_view=1&team_id=%@",JGJWebDiscoverURL, workProListModel.is_not_source, workProListModel.group_id];
    
    JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:statisticsStr];
    
    return webVc;
}

- (BOOL)canDidSelectedListType:(JGJWorkCircleMiddleInfoModel *)proTypeModel {
    
    BOOL isCan = YES;
    
    JGJMyWorkCircleProListModel *workProListModel = self.proListModel.group_info;
    
    BOOL isTeam = [workProListModel.class_type isEqualToString:@"team"];
    
    //是班组情况
    if (!isTeam) {
        
        BOOL isSelAgencyType = (proTypeModel.cellType == 0 || proTypeModel.cellType == 1 || proTypeModel.cellType == 2 || proTypeModel.cellType == 3);
        
        JGJSynBillingModel *agency_group_user = workProListModel.agency_group_user;
        
        if (agency_group_user.is_expire && isSelAgencyType) {
            
            [JGJCustomAlertView customAlertViewShowWithMessage:@"代班时间已过期，请联系班组长为你延长代班时长"];
            
            isCan = NO;
            
        }else if (![NSString isEmpty:agency_group_user.uid] && !agency_group_user.is_start && isSelAgencyType) {
            
            NSString *msg = [NSString stringWithFormat:@"代班开始时间为%@，到期后再开始代班记工", agency_group_user.start_time];
            
            if ([NSString isEmpty:agency_group_user.start_time]) {
                
                msg = @"代班时间还未开始，请联系班组长";
                
            }
            
            [JGJCustomAlertView customAlertViewShowWithMessage:msg];
            
            isCan = NO;
        }
        
    }
    
    return isCan;
}

#pragma mark - 会议
- (JGJWebAllSubViewController *)selMeetingVc {
    
    JGJMyWorkCircleProListModel *workProListModel = self.proListModel.group_info;
    
    NSString *meetingStr = [NSString stringWithFormat:@"%@conference?group_id=%@&class_type=%@&close=%@&group_name=%@",JGJWebDiscoverURL, workProListModel.group_id, workProListModel.class_type, @(workProListModel.isClosedTeamVc), workProListModel.group_name];
    
    
    JGJIndexDataModel *indexModel = [JGJChatMsgDBManger getTheIndexModelInIndexTable];
    indexModel.unread_meeting_count = @"0";
    [JGJChatMsgDBManger updateIndexModelToIndexTable:indexModel];
    
    // 清除聊聊列表对应的质量未读数
    JGJChatGroupListModel *originGroupModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:indexModel.group_id classType:indexModel.class_type];
    originGroupModel.unread_meeting_count = @"0";
    [JGJChatMsgDBManger updateChatGroupListTableTheUnread_work_countWithGroupListModel:originGroupModel group_id:indexModel.group_id class_type:indexModel.class_type];
    
    JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:meetingStr];
    
    webVc.isHiddenTabbar = YES;
    
    return webVc;
}



#pragma mark - 审批
- (JGJWebAllSubViewController *)selApplyVc {
    
    JGJMyWorkCircleProListModel *workProListModel = self.proListModel.group_info;
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970]*1000;
    
    NSString *timeID = [NSString stringWithFormat:@"%.lf", time];
    
    NSString *applyStr = [NSString stringWithFormat:@"%@applyfor?group_id=%@&class_type=%@&close=%@&%@",JGJWebDiscoverURL, workProListModel.group_id, workProListModel.class_type, @(workProListModel.isClosedTeamVc),timeID];
    
    JGJIndexDataModel *indexModel = [JGJChatMsgDBManger getTheIndexModelInIndexTable];
    indexModel.unread_approval_count = @"0";
    [JGJChatMsgDBManger updateIndexModelToIndexTable:indexModel];
    
    // 清除聊聊列表对应的质量未读数
    JGJChatGroupListModel *originGroupModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:indexModel.group_id classType:indexModel.class_type];
    originGroupModel.unread_approval_count = @"0";
    [JGJChatMsgDBManger updateChatGroupListTableTheUnread_work_countWithGroupListModel:originGroupModel group_id:indexModel.group_id class_type:indexModel.class_type];
    
    JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:applyStr];
    
    return webVc;
}

#pragma mark - 知识库
- (JGJKnowRepoVc *)selRepoVc{
    
    JGJKnowRepoVc *knowBaseVc = [[UIStoryboard storyboardWithName:@"JGJKnowRepo" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJKnowRepoVc"];
    
    knowBaseVc.proListModel =  self.proListModel.group_info;
    
    //统计模块点击事件
    [MobClick event:@"click_repository_module"];
    
    [self closeGroupFlag:knowBaseVc];
    
    return knowBaseVc;
}

#pragma mark - 查看全部成员
- (UIViewController *)handleCheckAllMember {
    JGJCheckGroupChatAllMemberVc *allMemberVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJCheckGroupChatAllMemberVc"];
    
    JGJTeamInfoModel *teamInfo = [[JGJTeamInfoModel alloc] init];
    
    JGJMyWorkCircleProListModel *group_info = self.proListModel.group_info;
    
    teamInfo.agency_group_user = group_info.agency_group_user;
    
    teamInfo.class_type = group_info.class_type;
    
    teamInfo.group_id = group_info.group_id;
    
    teamInfo.is_admin = group_info.can_at_all;
    
    allMemberVc.teamInfo = teamInfo;
    
    allMemberVc.allMemberVcType = [group_info.class_type isEqualToString:@"group"] ? CheckAllMemberVcTeamMangerType : CheckAllMemberVcGroupMangerType;
    
    allMemberVc.workProListModel = group_info;
    
    JGJTeamMemberCommonModel *commonModel = [JGJTeamMemberCommonModel new];
    
    commonModel.memberType = JGJProMemberType;
    
    allMemberVc.commonModel = commonModel;
    
    allMemberVc.successBlock = ^(NSDictionary * response) {
        
        [JGJChatGetOffLineMsgInfo http_getChatIndexList];
        
        __weak typeof(self) weakSelf = self;
        
        [JGJChatGetOffLineMsgInfo shareManager].getIndexListSuccess = ^(JGJMyWorkCircleProListModel *proListModel) {
            
            
            JGJChatGroupListModel *chatGroupModel = [[JGJChatGroupListModel alloc] init];
            
            chatGroupModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:proListModel.group_info.group_id classType:proListModel.group_info.class_type];
            
            JGJIndexDataModel *indexModel = [JGJChatMsgDBManger getTheIndexModelInIndexTable];
            
            chatGroupModel.members_num = indexModel.group_info.members_num;
            
            //这里没更新到
            
            chatGroupModel.local_head_pic = [indexModel.group_info.members_head_pic mj_JSONString];
            
            chatGroupModel.group_name = weakSelf.proListModel.group_info.group_name;
            
            [JGJChatMsgDBManger updateChatGroupListTableWithJGJChatMsgListModel:chatGroupModel];
            
        };
        
    };
    
    return allMemberVc;
}

-(BOOL)checkIsRealName{
    SEL checkIsRealName = NSSelectorFromString(@"checkIsRealName");
    IMP imp = [self.navigationController methodForSelector:checkIsRealName];
    BOOL (*func)(id, SEL) = (void *)imp;
    if (!func(self.navigationController, checkIsRealName)) {
        return NO;
    }else{
        return YES;
    }
}

@end
