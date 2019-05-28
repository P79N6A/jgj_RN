//
//  JGJMemberDesCell.m
//  mix
//
//  Created by yj on 2018/12/13.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJMemberDesCell.h"

#import "JGJShareProDesView.h"

#import "JGJCustomAlertView.h"

@interface JGJMemberDesCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UIButton *desBtn;

@property (weak, nonatomic) IBOutlet UILabel *desLable;


@property (weak, nonatomic) IBOutlet UIView *redLineView;

@end

@implementation JGJMemberDesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.desLable.hidden = YES;
}

- (void)setCommonModel:(JGJTeamMemberCommonModel *)commonModel {
    
    _commonModel = commonModel;
    
}

- (IBAction)desBtnPressed:(UIButton *)sender {
    
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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
