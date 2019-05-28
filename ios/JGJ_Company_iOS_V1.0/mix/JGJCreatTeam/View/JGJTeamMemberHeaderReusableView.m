//
//  JGJTeamMemberHeaderReusableView.m
//  mix
//
//  Created by yj on 16/8/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJTeamMemberHeaderReusableView.h"
#import "JGJCustomAlertView.h"
#import "UILabel+GNUtil.h"
#import "JGJShareProDesView.h"
@interface JGJTeamMemberHeaderReusableView ()
@property (weak, nonatomic) IBOutlet UILabel *teamMemberTypeLable;
@property (weak, nonatomic) IBOutlet UILabel *teamMemberNumberLable;
@property (weak, nonatomic) IBOutlet UIButton *sourceMemberDesButton;
@property (weak, nonatomic) IBOutlet UIView *desLineView;
@property (weak, nonatomic) IBOutlet LineView *lineView;
@end

@implementation JGJTeamMemberHeaderReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.teamMemberNumberLable.textColor = AppFont999999Color;
    self.teamMemberTypeLable.textColor = AppFont333333Color;
    NSRange attributedRange = NSMakeRange(0, self.sourceMemberDesButton.titleLabel.text.length);
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self.sourceMemberDesButton.titleLabel.text];
    
    [attributedStr addAttribute:NSStrokeColorAttributeName value:self.sourceMemberDesButton.titleLabel.tintColor range:attributedRange];
    
    [self.sourceMemberDesButton setAttributedTitle:attributedStr forState:UIControlStateNormal];
    
    self.sourceMemberDesButton.imageEdgeInsets = UIEdgeInsetsMake(2.0, 0, 0, 0);
}

- (void)setCommonModel:(JGJTeamMemberCommonModel *)commonModel {
    _commonModel = commonModel;
    self.lineView.hidden = _commonModel.teamControllerType == JGJAddProSourceMemberControllerType || _commonModel.teamControllerType == JGJAddProNormalMemberControllerType;
    
//    创建项目添加项目成员和数据来源人不现显示人数
    BOOL isHidden = _commonModel.teamControllerType == JGJAddProNormalMemberControllerType || _commonModel.teamControllerType == JGJAddProSourceMemberControllerType;
    self.teamMemberNumberLable.hidden = isHidden;
    self.sourceMemberDesButton.hidden = isHidden;
    self.teamMemberNumberLable.font = !_commonModel.headerTitleFont ? [UIFont systemFontOfSize:AppFont30Size] : commonModel.headerTitleFont;
    
//        数据来人员是在JGJAddProSourceMemberControllerType时不显示
    if (commonModel.memberType == JGJProSourceMemberType && commonModel.teamControllerType != JGJAddProSourceMemberControllerType) { //数据来源人的数量显示在左边
        self.sourceMemberDesButton.hidden = NO;
        NSString *countMember = [NSString stringWithFormat:@"(%@)", @(commonModel.count)];
        self.teamMemberTypeLable.text = [NSString stringWithFormat:@"%@ %@", commonModel.headerTitle, countMember];
    } else {
        self.teamMemberNumberLable.text = [NSString stringWithFormat:@"%@人", @(commonModel.count)];
        self.sourceMemberDesButton.hidden = YES;
        self.teamMemberTypeLable.text = commonModel.headerTitle;
    }
    
//    发版前改的需求
    if (commonModel.teamControllerType ==JGJAddProSourceMemberControllerType) {
        
        self.sourceMemberDesButton.hidden = NO;
    }
    
    BOOL isChangeColor = commonModel.teamControllerType == JGJAddProSourceMemberControllerType || commonModel.teamControllerType == JGJAddProNormalMemberControllerType;
    
    if (isChangeColor) {
        
        self.teamMemberTypeLable.textColor = AppFont666666Color;
    }
    
    self.desLineView.hidden = self.sourceMemberDesButton.hidden;
}

- (IBAction)handleSourceMemberDesButtonAction:(UIButton *)sender {
    if (self.commonModel.teamControllerType == JGJAddProSourceMemberControllerType) {
        JGJShareProDesModel *proDesModel = [[JGJShareProDesModel alloc] init];
        proDesModel.popTitle = @"什么是数据来源人?";
        proDesModel.popDetail = @"1.项目管理端用户想要清楚项目用工情况，则要求项目各班组长下载“吉工家”app对工人进行日常记工\n2.记工后自动形成统计数据，项目负责人可以要求将数据向上同步给他。此时，数据来源人就是“记工的各班组长”\n3.“项目上级管理人员”又可以要求“项目下级管理人员”继续将班组长同步的数据向上同步给他，此时，数据来源人是“项目下级管理人员”\n4.所有项目成员会自动加入合并后的项目中\n5.所谓数据来源人，始终是下一级数据来源人，则你的数据是谁同步给你，他就是你的数据来源人";
        proDesModel.contentViewHeight = 405.0;
        JGJShareProDesView *proDesView = [JGJShareProDesView shareProDesViewWithProDesModel:proDesModel];
        proDesView.popDetailLable.font = [UIFont boldSystemFontOfSize:AppFont26Size];
    } else {
       JGJCustomAlertView *alertView = [JGJCustomAlertView customAlertViewShowWithTitle:@"什么是数据来源人?" message:@"1.数据来源人是指向你同步项目数据、班组数据的人\n2.你可以要求你的下级、班组长将记工统计和项目其他信息同步给你" titleColor:AppFont333333Color messageColor:AppFont666666Color];
      alertView.containViewHeight.constant = 200.0;
    }
}

@end
