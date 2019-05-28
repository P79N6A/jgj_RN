//
//  JGJComRemarkCell.m
//  mix
//
//  Created by yj on 2018/7/16.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJComRemarkCell.h"

@interface JGJComRemarkCell()

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *detailTitle;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UILabel *titleType;

@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *desLable;


@end

@implementation JGJComRemarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.topView.backgroundColor = AppFontf1f1f1Color;
    
    self.title.textColor = AppFontEB4E4EColor;
    
    self.detailTitle.textColor = AppFontEB4E4EColor;
}

- (void)setTeamModel:(JGJCreatTeamModel *)teamModel {
    
    _teamModel = teamModel;
    
    self.title.text = teamModel.title;
    
    self.detailTitle.text = teamModel.detailTitle;
    
    BOOL isCenter = [NSString isEmpty:teamModel.detailTitle] || self.isAgency;
    
    [self.title mas_updateConstraints:^(MASConstraintMaker *make) {

        make.centerY.mas_equalTo(self).mas_offset(isCenter ? 5 : -3);
        
    }];
    
    //代班长只显示时间
    
    self.desLable.text = @"可帮你记工记账及管理班组成员";
    
    if (self.isAgency) {
        
        self.title.text = teamModel.detailTitle;
        
        self.titleType.text = @"代班时间";

        [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(self).mas_offset(-12);
            
        }];
        
        self.desLable.text = @"你可帮班组长管理班组及记工";
    }
    
    self.rightImageView.hidden = self.isAgency;
    
    self.detailTitle.hidden = self.isAgency;
    
}

+(CGFloat)cellHeight {
    
    return 65;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
