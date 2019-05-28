//
//  JGJGroupMangerTool.m
//  JGJCompany
//
//  Created by yj on 2017/8/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJGroupMangerTool.h"

#import "JGJCustomPopView.h"

#import "JGJCustomAlertView.h"

#import "JGJOverTimeview.h"

#define SenorTips @"免费版的使用人数不能超过5人，如需使用免费版，请进入[项目设置]模块中将成员人数降到≤5人。"

#define ChangeColorStr  @"[项目设置]"

@implementation JGJServiceOverTimeRequest

+ (void)serviceOverTimeRequest:(JGJServiceOverTimeRequest *)request requestBlock:(JGJServiceOverTimeRequestBlock)requestBlock {

    NSDictionary *parameters = [request mj_keyValues];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/order/applyServer" parameters:parameters success:^(id responseObject) {
        
        NSString *record = [NSString stringWithFormat:@"%@", responseObject[@"record_id"]];
        
        if ([record isEqualToString:@"0"]) {
            
             [TYShowMessage showPlaint:@"申请失败"];
            
        }else {
            
            [TYShowMessage showSuccess:@"申请成功"];
        }
        
        if (requestBlock) {
            
            requestBlock(responseObject);
        }
    
    } failure:^(NSError *error) {
        
        
    }];
}

@end

@interface JGJGroupMangerTool ()

/**
 *  是否弹框
 */
@property (nonatomic, assign) BOOL isPopView;

/**
 *  当前项目人数
 */
@property (nonatomic, assign) NSInteger curMemberCount;

@property (nonatomic, strong) JGJServiceOverTimeRequest *serviceOverTimeRequest;

@end

static JGJGroupMangerTool *_groupMangerTool;

@implementation JGJGroupMangerTool

- (instancetype)init {

    self  = [super init];
    
    if (self) {
        
        _groupMangerTool = self;
    }
    
    return self;

}

//#pragma mark - 全局取消黄金服务版(4个位置修改了，搜索这句话) 3.3.0修改
- (BOOL)isPopView {

    return NO;
    
//    return [_groupMangerTool handlePopViewWithTeamInfo:_groupMangerTool.teamInfo];
    
}

#pragma mark - 处理对应点的弹框

- (BOOL)handlePopViewWithTeamInfo:(JGJTeamInfoModel *)teamInfo {
    
    BOOL isGroupMangerVC = NO;
    
    for (UIViewController *vc in self.targetVc.viewControllers) {
        
        if ([vc isKindOfClass:NSClassFromString(@"JGJGroupMangerVC")]) {
            
            isGroupMangerVC = YES;
            
            break;
        }
        
    }
    
    //非项目(班组和群聊)设置不需要弹框。
    if (!isGroupMangerVC) {
        
        return NO;
    }
    
    BOOL isPopView = NO;
    
    JGJShareProDesModel *desModel = [JGJShareProDesModel new];
    
    JGJCustomPopView *popView = nil;
    
    if (teamInfo.cur_member_num >= 500 && !teamInfo.team_info.is_senior_expire) {
        
        [TYShowMessage showPlaint:@"项目成员人数不能超过500人"];
        
        return YES;
        
    } else if (teamInfo.team_info.is_senior_expire) {  //人数小于购买人数。当前过期。过期弹框. 人数大于购买人数。当前过期。过期弹框
        
        isPopView = YES;
        
        desModel.popTextAlignment = NSTextAlignmentLeft;
        
        desModel.title = teamInfo.team_group_info.team_all_comment?:@"";
        
        desModel.popDetail = @"使用的黄金服务版已过期，如需添加成员，请点击申请，我们的客服将尽快与你联系。";
        
        desModel.leftTilte = @"降级使用免费版";
        
        desModel.rightTilte = @"申请";
        
        desModel.lineSapcing = 5;
        
        desModel.messageBottom = 15;
        
        //        对项目创建者、管理员及最后一个为该项目订购服务的用户.具有降级权限
        desModel.isHiddenLeftButton = !teamInfo.team_info.is_degrade;
        
        popView = [JGJCustomPopView showWithMessage:desModel];
        
    }else if (teamInfo.isUpdatePer && !teamInfo.team_info.is_senior_expire) { //人数大于购买人数。当前未过期。升级人数弹框
        
        desModel.popTextAlignment = NSTextAlignmentLeft;
        
        desModel.popDetail = @"本项目成员人数已达上限，如需升级人数，请点击申请，我们的客服将尽快与你联系。";
        
        desModel.leftTilte = @"我再想想";
        
        desModel.rightTilte = @"申请";
        
        desModel.lineSapcing = 5;
        
        popView = [JGJCustomPopView showWithMessage:desModel];
        
        isPopView = YES;
        
    }
    
    __weak typeof(self) weakSelf  = self;
    
    popView.onOkBlock = ^{
        
        TYLog(@"要立即升级了");
        
        [weakSelf handleOrderVcWithBuyGoodType:VIPServiceType];
    };
    
    if (teamInfo.team_info.is_senior_expire) {
        
        popView.leftButtonBlock = ^{
            
            TYLog(@"要降级了");
            
            [weakSelf handleDegradeGroup];
        };
    }
    
    
    return isPopView;
}

#pragma mark - 进入购买页面
- (void)handleOrderVcWithBuyGoodType:(BuyGoodType)buyGoodType {
    
    self.serviceOverTimeRequest.server_type = @"3";
    
    [JGJServiceOverTimeRequest serviceOverTimeRequest:self.serviceOverTimeRequest requestBlock:^(id response) {
        
        
    }];
    
//    JGJSureOrderListViewController *SureOrderListVC = [[UIStoryboard storyboardWithName:@"JGJSureOrderListViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJSureOrderListVC"];
//    
//    SureOrderListVC.GoodsType = buyGoodType;
//    
//    JGJOrderListModel *orderListModel = [JGJOrderListModel new];
//    
//    orderListModel.group_id = self.workProListModel.group_id;
//    
//    orderListModel.class_type = self.workProListModel.class_type;
//    orderListModel.upgrade = YES;
//    SureOrderListVC.orderListModel = orderListModel;
//    
//    [self.targetVc pushViewController:SureOrderListVC animated:YES];
}

- (void)handleDegradeGroup {
    
    //    is_handle 1：高级版
    
    [self degradeGroupWithMemberNum:self.teamInfo.members_num.intValue];
    
}

- (void)degradeGroupWithMemberNum:(NSInteger)memberNum {

//    __weak typeof(self) weakSelf = self;
    //保证类型正确
    
//    CGFloat used_space = [[NSString stringWithFormat:@"%@", self.workProListModel.used_space] floatValue];
    
    CGFloat alertViewH = 180;
    //群聊升级人数 tip_update 大于5人 is_senior_expire 过期大于5人 is_cloud_expire云盘过期大于2G
    if (self.workProListModel.is_senior_expire || self.workProListModel.tip_update) {
        
        //人数大于5和云盘控件大于2G
        if (memberNum > 5) {
            
            NSString *tips = SenorTips;
            
            NSString *changeColorStr = ChangeColorStr;
            
            JGJCustomAlertView *alertView = [JGJCustomAlertView customAlertViewShowWithMessage:tips changeColorMsg:changeColorStr];
            
            alertView.containViewHeight.constant = alertViewH;

        }else {
        
            [self degradeGroupRequest];
        
        }
        
    }
    
}

- (void)degradeGroupRequest {
    
    NSString *is_handle = self.buyGoodType == CloudNumType ? @"2" : @"1";
    
    NSDictionary *parameters = @{@"group_id" : self.workProListModel.group_id?:@"",
                                 @"class_type" : self.workProListModel.class_type?:@"",
                                 @"is_handle" : is_handle};
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/cloud/degradeGroupHandle" parameters:parameters success:^(id responseObject) {
        
        if (self.groupMangerToolBlock) {
            
            self.groupMangerToolBlock(self);
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

#pragma mark - 是否是主页弹出云盘过期弹框
-(BOOL)overTimeTip
{
    BOOL isPopView = NO;
    
    NSString *tipStr = @"过期提示";
    
    NSString *contentStr = @"使用的黄金服务版已过期，如需继续使用黄金服务版，请点击申请，我们的客服将尽快与你联系。";
    
    if (self.workProListModel.is_senior_expire || self.workProListModel.tip_update) {
        
        isPopView = YES;
        
        if (self.workProListModel.tip_update) {
            
//            tipStr = @"付费提示";
            
            contentStr = @"项目人数已超过5人，如需使用黄金服务版，请点击申请，我们的客服将尽快与你联系";
            
        }
        
    }
    
    __weak typeof(self) weakSelf = self;
    
    if (isPopView) {
        
        JGJOverTimeModel *timeModel = [JGJOverTimeModel new];
        
        timeModel.tipStr = tipStr;
        
        timeModel.proNameStr = [NSString stringWithFormat:@"\"%@\"",self.workProListModel.group_name];
        
        timeModel.contentStr = contentStr;
        
        if (self.workProListModel.is_degrade) {
            
            timeModel.buttonArr = @[@"降级使用免费版",@"申请"];
            
            if (self.workProListModel.tip_update) {
                
                timeModel.buttonArr = @[@"使用免费版",@"申请"];
            }
            
        }else {
            
            timeModel.buttonArr = @[@"申请"];
        }
        
        
        [JGJOverTimeview showOverTimeViewWithModel:timeModel andClickCancelButton:^(NSString *buttonTitle) {
            
            //先弹人员再弹云盘框
            [weakSelf degradeGroupWithMemberNum:weakSelf.curMemberCount];
            
        } andClickOKButton:^(NSString *buttonTitle) {
            
            
            [weakSelf handleOrderVcWithBuyGoodType:VIPServiceType];
            
        }];
        
    }
    
    return isPopView;

}

#pragma mark - 云盘过期提示
- (BOOL)overCloudTip {

    BOOL isPopView = NO;
    
    int64_t cloud_disk = [NSString stringWithFormat:@"%@", self.workProListModel.cloud_disk].intValue;
    
    int64_t use_space = [NSString stringWithFormat:@"%@", self.workProListModel.used_space].intValue;
    
    TYWeakSelf(self);
    if (cloud_disk - use_space <= 0) {
        
        isPopView = YES;
        
        JGJShareProDesModel *desModel = [JGJShareProDesModel new];
        
        desModel.popTextAlignment = NSTextAlignmentLeft;

        desModel.changeContent = @"注意：如云盘已用空间大于总空间，则平台半年后将自动清除其中的资料。";
        
        desModel.contentViewHeight = 210.0;
        
        desModel.popDetail = [NSString stringWithFormat:@"%@\n%@", @"使用云盘剩余空间不足，如需扩容，请点击申请，我们的客服将尽快与你联系。", desModel.changeContent];
        
        desModel.leftTilte = @"我再想想";
        
        desModel.rightTilte = @"申请";
        
        desModel.lineSapcing = 3;
        
       JGJCustomPopView *popView = [JGJCustomPopView showWithMessage:desModel];
        
        popView.onOkBlock = ^{
          
            [weakself handleOrderVcWithBuyGoodType:CloudNumType];
        };
        
        
//        JGJOverTimeModel *timeModel = [JGJOverTimeModel new];
////        timeModel.tipStr = @"过期提示";
//        timeModel.proNameStr = @"";
//        timeModel.cloudType = YES;
//        timeModel.contentStr = @"云盘剩余空间不足，如需扩容，请点击申请，我们的客服将尽快与您联系";
//
//        timeModel.contentSubStr = @"注意：如云盘已用空间大于总空间，则平台半年后将自动清除其中的资料。";
//
//        timeModel.buttonArr = @[@"我再想想",@"申请"];
//
//        [JGJOverTimeview showOverTimeViewWithModel:timeModel andClickCancelButton:^(NSString *buttonTitle) {
//
//
//
//        } andClickOKButton:^(NSString *buttonTitle) {
//
//            [weakself handleOrderVcWithBuyGoodType:CloudNumType];
//
//        }];

    }
    
    return isPopView;

}

- (void)setWorkProListModel:(JGJMyWorkCircleProListModel *)workProListModel {

    _workProListModel = workProListModel;
    
    self.curMemberCount = _workProListModel.members_num.integerValue;

}

- (void)setTeamInfo:(JGJTeamInfoModel *)teamInfo {

    _teamInfo = teamInfo;
    
    self.curMemberCount = _teamInfo.cur_member_num;

}

- (JGJServiceOverTimeRequest *)serviceOverTimeRequest {
    
    if (!_serviceOverTimeRequest) {
        
        _serviceOverTimeRequest = [JGJServiceOverTimeRequest new];
        
        _serviceOverTimeRequest.group_id = self.workProListModel.group_id;
        
        _serviceOverTimeRequest.class_type = self.workProListModel.class_type;
        
    }
    
    return _serviceOverTimeRequest;
}

@end
