//
//  JGJLogoutRemindDesCell.m
//  mix
//
//  Created by yj on 2018/1/10.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJLogoutRemindDesCell.h"

@interface JGJLogoutRemindDesCell ()

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *des;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remindFlagH;

@end

@implementation JGJLogoutRemindDesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //    self.title.textColor = AppFontF18215Color;
    //
    //    self.des.textColor = AppFontF18215Color;
    //
    //    self.des.preferredMaxLayoutWidth = TYGetUIScreenWidth - 48;
    //
    self.remindFlagH.constant = (TYGetUIScreenWidth - 30) * 0.405;
}

- (void)setDesModel:(JGJLogoutItemDesModel *)desModel {
    
    _desModel = desModel;
    
    self.title.text = desModel.title;
    
    self.des.text = desModel.desInfo;
    
    self.remindFlagH.constant = desModel.desH;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

