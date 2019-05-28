//
//  JGJLogoutItemDesCell.m
//  mix
//
//  Created by yj on 2018/1/10.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJLogoutItemDesCell.h"

@interface JGJLogoutItemDesCell ()

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *desInfo;

@end

@implementation JGJLogoutItemDesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.title.textColor = AppFontEB4E4EColor;
    
    self.desInfo.textColor = AppFont333333Color;
    
    self.desInfo.preferredMaxLayoutWidth = TYGetUIScreenWidth - 39;
    
//    self.desInfo.backgroundColor = AppFontEB4E4EColor;
}

- (void)setDesModel:(JGJLogoutItemDesModel *)desModel {
    
    _desModel = desModel;
    
    self.title.text = desModel.title;
    
    self.desInfo.text = desModel.desInfo;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
