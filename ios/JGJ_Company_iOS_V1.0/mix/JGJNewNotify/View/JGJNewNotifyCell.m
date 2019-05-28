//
//  JGJNewNotifyCell.m
//  mix
//
//  Created by yj on 16/8/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJNewNotifyCell.h"
#import "TYAvatarGroupImageView.h"
#import "UIButton+JGJUIButton.h"
#import "UILabel+GNUtil.h"
#import "JGJNewNotifyTool.h"
#import "NSDate+Extend.h"
#import "NSString+Extend.h"
#import "JGJHeadView.h"
#import "JGJAvatarView.h"
#define RefuseButtonW 40
#define SynButtonW 56

@interface JGJNewNotifyCell ()
@property (weak, nonatomic) IBOutlet JGJAvatarView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *detailLable;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UIButton *synBillingButton;
@property (weak, nonatomic) IBOutlet UIButton *refuseButton;
@property (weak, nonatomic) IBOutlet UIButton *delButton;
@property (weak, nonatomic) IBOutlet UIImageView *notifyTypeFlagImageView;
@property (weak, nonatomic) IBOutlet UILabel *accounterFlag;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *refuseButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *synButtonWidth;

@property (weak, nonatomic) IBOutlet UIButton *joinProButton;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *joinProButtonH;

@end

@implementation JGJNewNotifyCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    [self.headImageView.layer setLayerCornerRadius:JGJCornerRadius];
    self.timeLable.textColor = AppFontccccccColor;
    self.titleLable.textColor = AppFont333333Color;
    self.detailLable.textColor = AppFont999999Color;
    [self.delButton setEnlargeEdgeWithTop:30.0 right:30.0  bottom:30.0  left:30.0];
    [self.synBillingButton.layer setLayerBorderWithColor:AppFontd7252cColor width:0.5 radius:2.5];
    [self.refuseButton.layer setLayerBorderWithColor:AppFont666666Color width:0.5 radius:2.5];
    [self.accounterFlag.layer setLayerCornerRadius:2.0];
    self.detailLable.preferredMaxLayoutWidth = TYIS_IPHONE_5_OR_LESS ? 122 : 177;
    [self.joinProButton.layer setLayerBorderWithColor:AppFont666666Color width:0.5 radius:2.5];
}

- (void)setNotifyModel:(JGJNewNotifyModel *)notifyModel {
    _notifyModel = notifyModel;
    self.titleLable.text = notifyModel.title;
    
    self.timeLable.text = [NSDate showDateWithTimeStamp:notifyModel.date?:@""];
    
    [self.synBillingButton setTitleColor:AppFontd7252cColor forState:UIControlStateNormal];
    
    [self.refuseButton setTitleColor:AppFont333333Color forState:UIControlStateNormal];

    //    设置初始值
    self.delButton.hidden = NO;
    self.notifyTypeFlagImageView.hidden = YES;
    self.accounterFlag.hidden = YES;
    [self hiddenAllButton]; //初始隐藏
    [self.synBillingButton.layer setLayerBorderWithColor:AppFontd7252cColor width:0.5 radius:2.5];
    [self.refuseButton.layer setLayerBorderWithColor:AppFont666666Color width:0.5 radius:2.5];
    [self handleNotifyHeadImageView:notifyModel];
    [self handleNotifyTypeAction:notifyModel];
    
    //处理进入按钮的显示和隐藏2.3.0
    [self joinButtonStatusWithNotifyModel:notifyModel];
}

//RemoveGroupMemberType,
//RemoveTeamMemberType,
//CloseGroupType,
//CloseTeamType,
//JoinGroupType,
//JoinTeamType,
//ReopenGroupType,
//ReopenTeamType,
//MergeTeamType,
//SplitTeamType,
//SyncProjectType
//newBilling

#pragma mark - 设置头像
- (void)handleNotifyHeadImageView:(JGJNewNotifyModel *)notifyModel {
    if (notifyModel.members_head_pic.count > 0) {
        if (![NSString isEmpty:notifyModel.team_id]) {
            
            [self.headImageView getRectImgView:notifyModel.members_head_pic];

        } else {
            [self.headImageView getRectImgView:notifyModel.members_head_pic];

        }
    }
}

#pragma mark - 处理通知类型
- (void)handleNotifyTypeAction:(JGJNewNotifyModel *)notifyModel {
    NSString *synButtonTitle = nil;
    NSString *mergeStr = nil;//合并后的数据
    NSArray *textArray = nil;
    switch (notifyModel.notifyType) {
//         处理加入班组
//        case JoinGroupType:{
//            synButtonTitle = @"加入班组";
//            mergeStr = [NSString stringWithFormat:@"%@ 将你加入 班组: %@", notifyModel.user_name, notifyModel.group_name];
//            textArray = @[notifyModel.user_name,@"班组:",notifyModel.group_name];
//        }
//            break;
            
        case JoinTeamType: {
            synButtonTitle = @"加入项目组";
            mergeStr = [NSString stringWithFormat:@"%@ 将你加入 项目组: %@", notifyModel.user_name, notifyModel.team_name];
            textArray = @[notifyModel.user_name, @"项目组:", notifyModel.team_name];
        }
            break;
            
//       处理同步项目 按钮事件 未做处理同步账单和拒绝按钮均显示 ，隐藏删除按钮，拒绝成功隐藏拒绝按钮，显示删除按钮，同步按钮变灰
        case SyncProjectType:{
            synButtonTitle = @"同步项目";
            [self showAllButton]; //初始状态 同步、拒绝均显示
            self.delButton.hidden = YES;
            if (notifyModel.isRefused) {
                self.refuseButton.hidden = YES;
                self.refuseButtonWidth.constant = RefuseButtonW;
                self.delButton.hidden = NO;
                self.synBillingButton.hidden = NO;
                self.notifyTypeFlagImageView.hidden = NO;
                [self.synBillingButton.layer setLayerBorderWithColor:AppFontccccccColor width:0.5 radius:2.5];
                [self.synBillingButton setTitleColor:AppFont999999Color forState:UIControlStateNormal];
                self.notifyTypeFlagImageView.image = [UIImage imageNamed:@"yjj_icon"];
            }
            
            if (notifyModel.isSuccessSyn) {
                self.notifyTypeFlagImageView.image = [UIImage imageNamed:@"ytb_icon"];
                self.notifyTypeFlagImageView.hidden = NO;
                self.synBillingButton.hidden = YES;
                self.synButtonWidth.constant = 0;
                self.refuseButton.hidden = YES;
                self.refuseButtonWidth.constant = RefuseButtonW;
                self.delButton.hidden = NO;
            }
            mergeStr = [NSString stringWithFormat:@"%@ 要求你同步项目情况", notifyModel.user_name];
            textArray = @[notifyModel.user_name];
        }
            break;
//       其余类型待特殊处理
        case RemoveGroupMemberType: {
            mergeStr = [NSString stringWithFormat:@"你被 %@ 移除 班组: %@", notifyModel.user_name, notifyModel.group_name];
            textArray = @[notifyModel.user_name, @"班组:", notifyModel.group_name];
        }
            break;
        case RemoveTeamMemberType:{
            mergeStr = [NSString stringWithFormat:@"你被 %@ 移除 项目组: %@", notifyModel.user_name, notifyModel.team_name];
            textArray = @[notifyModel.user_name, @"项目组:", notifyModel.team_name];
        }
            break;
        case CloseGroupType:{
            mergeStr = [NSString stringWithFormat:@"班组: %@ 被%@关闭", notifyModel.group_name, notifyModel.user_name];
            textArray = @[@"班组:",notifyModel.group_name, notifyModel.user_name];
        }
            break;
        case CloseTeamType:{
            mergeStr = [NSString stringWithFormat:@"项目组: %@ 被%@关闭", notifyModel.team_name, notifyModel.user_name];
            textArray = @[@"项目组:", notifyModel.team_name, notifyModel.user_name];
        }
            break;
        case ReopenGroupType:{
            mergeStr = [NSString stringWithFormat:@"班组: %@ 被 %@ 重新打开", notifyModel.group_name, notifyModel.user_name];
            textArray = @[@"班组:", notifyModel.group_name,notifyModel.user_name];
        }
            break;
        case ReopenTeamType:{
            mergeStr = [NSString stringWithFormat:@"项目组: %@ 被 %@ 重新打开", notifyModel.team_name, notifyModel.user_name];
            textArray = @[@"项目组:", notifyModel.team_name,notifyModel.user_name];
        }
            break;
        case MergeTeamType:{
            mergeStr = [NSString stringWithFormat:@"项目组: %@ 被 %@ 合并为%@", notifyModel.merge_befor, notifyModel.user_name, notifyModel.merge_after];
            textArray = @[@"项目组:", notifyModel.merge_befor,notifyModel.user_name,notifyModel.merge_after];
        }
            break;
        case SplitTeamType:{
            mergeStr = [NSString stringWithFormat:@"项目组: %@ 被 %@ 拆分为%@", notifyModel.split_befor, notifyModel.user_name, notifyModel.split_after];
            textArray = @[@"项目组:", notifyModel.split_befor,notifyModel.user_name,notifyModel.split_after];
        }
            break;
        case RepulseSyncType:{
            synButtonTitle = @"同步项目被拒绝";
            mergeStr = [NSString stringWithFormat:@"%@ 拒绝同步项目情况", notifyModel.user_name];
            textArray = @[notifyModel.user_name];
        }
            break;
        case SyncCreateTeamNoticeType: {
            self.accounterFlag.hidden = NO;
            mergeStr = [NSString stringWithFormat:@"%@ 对你同步了项目数据 系统为你自动创建了项目组: %@", notifyModel.user_name, notifyModel.team_name];
             textArray = @[notifyModel.user_name, @"项目组:",notifyModel.team_name];
        }
            break;
        default:
            break;
    }
    [self.synBillingButton setTitle:synButtonTitle forState:UIControlStateNormal];
    self.detailLable.text = mergeStr;
    notifyModel.mergeStr = mergeStr; //加入班组详情页使用
    [self.detailLable markattributedTextArray:textArray color:AppFont333333Color font:self.detailLable.font isGetAllText:YES];
}

#pragma mark - 处理拒绝按钮事件
- (IBAction)handleRefuseButtonPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(handleJGJNewNotifyCellNotifyModel:buttonType:)]) {
        [self.delegate handleJGJNewNotifyCellNotifyModel:self.notifyModel buttonType:NotifyCellRefuseButtonType];
    }
}

#pragma mark - 处理删除按钮事件
- (IBAction)handleDelButtonPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(handleJGJNewNotifyCellNotifyModel:buttonType:)]) {
        [self.delegate handleJGJNewNotifyCellNotifyModel:self.notifyModel buttonType:NotifyCellDeleteButtonType];
    }
}

#pragma mark - 处理同步账单和和加入班组事件(按钮复用用类型区分)
- (IBAction)handleSynBillingAndJoinTeamButtonPressed:(UIButton *)sender {
    NotifyCellButtonType buttonType = NotifyCellSyncButtonType;
    switch (self.notifyModel.notifyType) {
        case SyncProjectType:{
            buttonType = NotifyCellSyncButtonType;
        }
            break;
//        case NewBillingType:{
//            buttonType = NotifyCellJoinTeamButtonType;
//        }
//            break;
        default:
            break;
    }
    if ([self.delegate respondsToSelector:@selector(handleJGJNewNotifyCellNotifyModel:buttonType:)]) {
        [self.delegate handleJGJNewNotifyCellNotifyModel:self.notifyModel buttonType:buttonType];
    }
}

/*
加入班组/项目组提示消息的操作：
 消息下方显示操作按钮【进入】，点击进入时，判断：
 如果我还在该班组/项目组中，则返回首页，且将首页的项目自动切换为消息中的项目或班组，并气泡提示：“首页项目已切换为 XXXX”，XXXX为项目名称 或 项目-班组名称。
 如果我已不在该班组/项目组中，则气泡提示：“无法进入已退出的班组/项目组”
 
 关闭班组/项目组提示消息的操作：
 
 消息下方显示操作按钮【进入】，点击进入时，判断：
 
 如果我还在该班组/项目组中，则返回首页，且将首页的项目自动切换为消息中的项目或班组，并气泡提示：“首页项目已切换为 XXXX”，XXXX为项目名称 或 项目-班组名称。
 
 如果我已不在该班组/项目组中，则气泡提示：“无法进入已退出的班组/项目组”
 
 退出班组/项目组提示消息的操作：无操作按钮，无点击效果

 注：以上提及的操作不包括删除消息操作（除特殊消息外，几乎所有消息都可以删除）。
 
*/

#pragma mark - 进入按钮显示和隐藏(班组、项目组加入和关闭的时候才显示其余状态隐藏)
- (void)joinButtonStatusWithNotifyModel:(JGJNewNotifyModel *)notifyModel {
    
    //    CloseGroupType,   //关闭班组通知
    //    CloseTeamType, //关闭项目组通知
    //    JoinGroupType,  //加入班组
    //    JoinTeamType, //加入项目组组
    
    self.joinProButton.hidden = YES;
    
    self.joinProButton.userInteractionEnabled = NO;
    
    self.joinProButtonH.constant = 0;
    
    switch (notifyModel.notifyType) {
        
//        case CloseGroupType:
//        case CloseTeamType:
        case JoinGroupType:
        case JoinTeamType:{
            
            self.joinProButton.hidden = NO;
            
            self.joinProButton.userInteractionEnabled = YES;
            
            self.joinProButtonH.constant = 21;
        }
            
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 加入项目按钮按下,切换项目
- (IBAction)joinProButtonPressed:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(handleJGJNewNotifyCellNotifyModel:buttonType:)]) {
        [self.delegate handleJGJNewNotifyCellNotifyModel:self.notifyModel buttonType:NotifyCellChangeProButtonType];
    }
    
}

#pragma mark - 隐藏同步拒绝按钮
- (void)hiddenAllButton {
    self.synButtonWidth.constant = 0;
    self.refuseButtonWidth.constant = RefuseButtonW;
    self.synBillingButton.hidden = YES;
    self.refuseButton.hidden = YES;
}

- (void)showAllButton {
    self.synButtonWidth.constant = SynButtonW;
    self.refuseButtonWidth.constant = RefuseButtonW;
    self.synBillingButton.hidden = NO;
    self.refuseButton.hidden = NO;
}

@end
