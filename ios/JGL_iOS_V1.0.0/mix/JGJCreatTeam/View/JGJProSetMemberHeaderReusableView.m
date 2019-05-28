//
//  JGJProSetMemberHeaderReusableView.m
//  JGJCompany
//
//  Created by yj on 2017/8/8.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJProSetMemberHeaderReusableView.h"

@interface JGJProSetMemberHeaderReusableView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UIButton *upgradeButton;
@property (weak, nonatomic) IBOutlet UIImageView *nextImageView;

@end

@implementation JGJProSetMemberHeaderReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLable.textColor = AppFont333333Color;

    [self.upgradeButton setTitleColor:AppFontE44343DColor forState:UIControlStateNormal];
}

- (void)setTeamInfo:(JGJTeamInfoModel *)teamInfo {

    _teamInfo = teamInfo;
    
    NSString *maxNum = [NSString stringWithFormat:@"%@", @(teamInfo.is_senior ? teamInfo.buyer_person : 5)];
    
    self.titleLable.text = [NSString stringWithFormat:@"成员(%@/%@)", teamInfo.members_num, maxNum];
    
    teamInfo.cur_member_num = teamInfo.members_num.integerValue;
    
    //升级显示按钮和图片
    BOOL isHidden = teamInfo.buyer_person >= 500;
    
    self.upgradeButton.hidden = isHidden;
    
    self.nextImageView.hidden = isHidden;
}


- (IBAction)upgradeButtonPressed:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(proSetMemberHeaderReusableView:)]) {
        
        [self.delegate proSetMemberHeaderReusableView:self];
    }
    
}


@end
