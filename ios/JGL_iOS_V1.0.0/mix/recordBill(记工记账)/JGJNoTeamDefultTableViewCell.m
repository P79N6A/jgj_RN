//
//  JGJNoTeamDefultTableViewCell.m
//  mix
//
//  Created by Tony on 2017/9/26.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJNoTeamDefultTableViewCell.h"
#import "UILabel+GNUtil.h"
@implementation JGJNoTeamDefultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.createButton.layer.masksToBounds = YES;
    self.createButton.layer.cornerRadius = 5;
    
    self.userCaseBtn.clipsToBounds = YES;
    self.userCaseBtn.layer.cornerRadius = 5;
    self.userCaseBtn.layer.borderWidth = 1;
    self.userCaseBtn.layer.borderColor = AppFont666666Color.CGColor;
    
    [self.userCaseDetail markattributedTextArray:@[@"记工案例"] color:AppFontEB4E4EColor];
    
}

- (IBAction)clickCreateTeamButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(JGJNoTeamDefultTableViewClickCreateTeamButton)]) {
        
        [self.delegate JGJNoTeamDefultTableViewClickCreateTeamButton];
    }
}


- (IBAction)userCaseBtnClick:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(JGJNoTeamDefultTableViewClickUserCaseTeamButton)]) {
        
        [self.delegate JGJNoTeamDefultTableViewClickUserCaseTeamButton];
    }
}


@end
