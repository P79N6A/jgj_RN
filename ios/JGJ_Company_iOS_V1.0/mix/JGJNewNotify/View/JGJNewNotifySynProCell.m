//
//  JGJNewNotifySynProCell.m
//  JGJCompany
//
//  Created by yj on 16/11/9.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJNewNotifySynProCell.h"
#import "TYAvatarGroupImageView.h"
#import "UIButton+JGJUIButton.h"
#import "UILabel+GNUtil.h"
#import "JGJNewNotifyTool.h"
#import "NSDate+Extend.h"
#import "NSString+Extend.h"
#import "JGJAvatarView.h"

@interface JGJNewNotifySynProCell ()
@property (weak, nonatomic) IBOutlet JGJAvatarView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *detailLable;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UIButton *delButton;
@property (weak, nonatomic) IBOutlet UILabel *accounterFlag;
@property (weak, nonatomic) IBOutlet UIButton *creatTeamButton;
@property (weak, nonatomic) IBOutlet UIButton *joinExistTeamButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *creatTeamButtonBottomDistance;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *delButtonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *creatTeamButtonTrail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *joinExistTeamButtonW;

@end

@implementation JGJNewNotifySynProCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.headImageView.layer setLayerCornerRadius:JGJHeadCornerRadius];
    self.timeLable.textColor = AppFontccccccColor;
    self.titleLable.textColor = AppFont333333Color;
    self.detailLable.textColor = AppFont999999Color;
    [self.delButton setEnlargeEdgeWithTop:30.0 right:30.0  bottom:30.0  left:30.0];
    [self.creatTeamButton.layer setLayerBorderWithColor:AppFont666666Color width:0.5 radius:2.5];
    [self.joinExistTeamButton.layer setLayerBorderWithColor:AppFont666666Color width:0.5 radius:2.5];
    [self.joinExistTeamButton setTitleColor:AppFont333333Color forState:UIControlStateNormal];
    [self.creatTeamButton setTitleColor:AppFont333333Color forState:UIControlStateNormal];
    [self.accounterFlag.layer setLayerCornerRadius:2.0];
    self.detailLable.preferredMaxLayoutWidth = TYIS_IPHONE_5_OR_LESS ? 122 : 177;
}

- (void)setNotifyModel:(JGJNewNotifyModel *)notifyModel {
    _notifyModel = notifyModel;
    self.titleLable.text = notifyModel.title;
    NSString *dateString = [NSDate dateTimesTampToString:notifyModel.date format:@"YYYY-MM-dd"];
    NSDate *date = [NSDate dateFromString:dateString withDateFormat:@"YYYY-MM-dd"];
    if (date.isToday) {
        dateString = [NSDate dateTimesTampToString:notifyModel.date format:@"HH:mm"];
    }
    self.timeLable.text = dateString;
    [self handleNotifyHeadImageView:notifyModel];
    [self handleNotifyButton:notifyModel];
    
}

#pragma mark - 按钮操作成功会后，情况
- (void)handleNotifyButton:(JGJNewNotifyModel *)notifyModel {
    NSString *mergeStr = nil;
    NSArray *textArray = nil;
    self.accounterFlag.hidden = YES;
    NSUInteger nameLength = 14;
    self.joinExistTeamButton.hidden = NO;
    self.delButton.enabled = YES;
    self.delButtonHeight.constant = 50;
    self.delButton.hidden = NO;
    NSString *proName = nil;
    if (![NSString isEmpty:notifyModel.pro_name] && notifyModel.pro_name.length > nameLength) {
        proName = [NSString stringWithFormat:@"%@%@", [notifyModel.pro_name substringToIndex:nameLength],@"..."];
    }else {
        proName = notifyModel.pro_name;
    }
    if (notifyModel.iSNotifySynCreatTeam) {
        self.accounterFlag.hidden = NO;
        self.delButton.enabled = NO;
        self.delButtonHeight.constant = 50;
        self.creatTeamButton.hidden = YES;
        self.joinExistTeamButton.hidden = YES;
        self.creatTeamButtonBottomDistance.constant = 0;
        self.titleLable.text = @"新创建项目组";
        mergeStr = [NSString stringWithFormat:@"你 已将 %@ 等项目新建为 %@, 项目组名: %@", proName, notifyModel.team_name, notifyModel.team_name];
        textArray = @[@"你", proName, notifyModel.team_name ,@"项目组名:",notifyModel.team_name];
        self.detailLable.text = mergeStr;
    } else if (notifyModel.iSNotifyJoinExistTeam) {
        self.accounterFlag.hidden = YES;
        self.delButton.enabled = YES;
        self.delButtonHeight.constant = 50;
        self.creatTeamButton.hidden = YES;
        self.joinExistTeamButton.hidden = YES;
        self.creatTeamButtonBottomDistance.constant = 0;
        self.titleLable.text = @"加入现有项目组";
        mergeStr = [NSString stringWithFormat:@"你 已将 %@ 等项目加入 %@", proName, notifyModel.team_comment];
        textArray = @[@"你", proName, notifyModel.team_comment?:@""];
        self.detailLable.text = mergeStr;
    }else {
        self.delButton.hidden = YES;
        self.delButtonHeight.constant = 0;
        NSString *mergeStr = [NSString stringWithFormat:@"%@ 将 %@ 等项目同步给你", notifyModel.user_name, proName];
        textArray = @[notifyModel.user_name?:@"", proName];
        self.detailLable.text = mergeStr;
        self.creatTeamButtonBottomDistance.constant = 15.0;
        if (!notifyModel.isExistMyCreatTeam) {
            self.creatTeamButtonTrail.constant = 20;
            self.joinExistTeamButton.hidden = YES;
            self.creatTeamButton.hidden = NO;
        }else {
            self.creatTeamButton.hidden = NO;
            self.joinExistTeamButton.hidden = NO;
            self.creatTeamButtonTrail.constant = 130;
        }
    }
    [self.detailLable markattributedTextArray:textArray color:AppFont333333Color font:self.detailLable.font isGetAllText:YES];
}

- (IBAction)handleButtonPressedAction:(UIButton *)sender {
    JGJNewNotifySynProCellButtonType buttonType = sender.tag - 100;
    if ([self.delegate respondsToSelector:@selector(handleNewNotifySynProCellNotifyModel:buttonType:)]) {
        [self.delegate handleNewNotifySynProCellNotifyModel:self.notifyModel buttonType:buttonType];
    }
}

#pragma mark - 设置头像
- (void)handleNotifyHeadImageView:(JGJNewNotifyModel *)notifyModel {
     [self.headImageView getRectImgView:notifyModel.members_head_pic];
}
@end
