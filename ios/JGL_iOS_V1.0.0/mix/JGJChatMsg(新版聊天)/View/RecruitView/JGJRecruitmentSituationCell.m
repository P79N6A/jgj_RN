//
//  JGJRecruitmentSituationCell.m
//  mix
//
//  Created by ccclear on 2019/4/17.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJRecruitmentSituationCell.h"
#import "UILabel+GNUtil.h"
#import "NSString+Extend.h"

@interface JGJRecruitmentSituationCell ()

@property (weak, nonatomic) IBOutlet UILabel *situationTitle;// 招工情况标题

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *situationTitleConstraintH;

@property (weak, nonatomic) IBOutlet UILabel *todayTelAccount;// 今日拨打电话次数

@property (weak, nonatomic) IBOutlet UIView *detailInfoBack;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailInfoBackConstraintH;


@property (weak, nonatomic) IBOutlet UILabel *projectName;// 项目信息
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *projectTitleConstraintH;
@property (weak, nonatomic) IBOutlet UILabel *projectTitle;

@property (weak, nonatomic) IBOutlet UILabel *lookedAccount;// 被查看次数
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lookedAccountConstraintH;

@property (weak, nonatomic) IBOutlet UILabel *telAccount;// 拨打电话次数
@property (weak, nonatomic) IBOutlet UIView *inspectInfoView;// 查看详情

@property (weak, nonatomic) IBOutlet UILabel *systemInfo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *systemInfoConstraintH;

@end
@implementation JGJRecruitmentSituationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _detailInfoBack.clipsToBounds = YES;
    _detailInfoBack.layer.cornerRadius = 2;
    
    _inspectInfoView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInspectInfoView)];
    [_inspectInfoView addGestureRecognizer:tapGes];
}

- (void)tapInspectInfoView {
    
    if ([self.delegate respondsToSelector:@selector(tapRecruitmentSituationCellWithJumpUrl:)]) {
        
        [self.delegate tapRecruitmentSituationCellWithJumpUrl:self.jgjChatListModel.extend.msg_content.jump_url];
    }
}

- (void)subClassSetWithModel:(JGJChatMsgListModel *)jgjChatListModel {
    
    _situationTitle.text = jgjChatListModel.title;
    
    CGFloat situationTitleConstraintH = [NSString stringWithYYContentWidth:TYGetUIScreenWidth - 70 - 78 font:16 lineSpace:5 content:_situationTitle.text];
    _situationTitleConstraintH.constant = situationTitleConstraintH;
    
    NSMutableArray *changeColorArr = [[NSMutableArray alloc] init];
    NSString *colorStr;
    for (NSDictionary *dic in jgjChatListModel.extend.content) {
        
        [changeColorArr addObject:dic[@"field"] ? : @""];
        colorStr = dic[@"color"] ? : @"0X000000";
    }
    
    [_situationTitle markattributedTextArray:changeColorArr color:TYColorHex([colorStr integerValue]) font:[UIFont boldSystemFontOfSize:16]];
    
    // 项目名称
    if ([NSString isEmpty:jgjChatListModel.extend.msg_content.pro_name]) {
        
        _projectName.hidden = YES;
        _projectTitle.hidden = YES;
        _projectTitleConstraintH.constant = 0;
        _detailInfoBackConstraintH.constant = 79 - 13 - 10;
        _lookedAccountConstraintH.constant = 0;
    }else {
        
        _lookedAccountConstraintH.constant = 10;
        _detailInfoBackConstraintH.constant = 79;
        _projectTitleConstraintH.constant = 13;
        _projectTitle.hidden = NO;
        _projectName.hidden = NO;
        _projectName.text = jgjChatListModel.extend.msg_content.pro_name;
    }
    
    // 今日拨打次数
    _todayTelAccount.text = [NSString stringWithFormat:@"%ld",jgjChatListModel.extend.msg_content.today_num];
    // 累计查看次数
    _lookedAccount.text = [NSString stringWithFormat:@"%ld次",jgjChatListModel.extend.msg_content.view_count];
    // 累计拨打数
    _telAccount.text = [NSString stringWithFormat:@"%ld次",jgjChatListModel.extend.msg_content.all_num];
    // 系统提示
    if ([NSString isEmpty:jgjChatListModel.extend.msg_content.system_msg]) {
        
        _systemInfo.hidden = YES;
        _systemInfoConstraintH.constant = 0;
        
    }else {
        
        _systemInfo.hidden = NO;
        _systemInfo.text = [NSString stringWithFormat:@"系统提示:%@",jgjChatListModel.extend.msg_content.system_msg];
        CGFloat systemInfoConstraintH = [NSString stringWithYYContentWidth:TYGetUIScreenWidth - 70 - 78 font:13 lineSpace:5 content:_systemInfo.text];
        _systemInfoConstraintH.constant = systemInfoConstraintH;
        
    }
    
}

@end
