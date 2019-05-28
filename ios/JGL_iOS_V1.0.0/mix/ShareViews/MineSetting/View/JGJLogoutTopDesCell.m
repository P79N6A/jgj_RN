//
//  JGJLogoutTopDesCell.m
//  mix
//
//  Created by yj on 2018/1/10.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJLogoutTopDesCell.h"

@interface JGJLogoutTopDesCell ()


@property (weak, nonatomic) IBOutlet UILabel *desLable;

@end

@implementation JGJLogoutTopDesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.desLable.textColor = AppFont999999Color;
}

- (void)setDesModel:(JGJLogoutItemDesModel *)desModel {
    
    _desModel = desModel;
    
    self.desLable.text = desModel.desInfo;
    
    self.desLable.textColor = desModel.desInfoColor ? AppFont333333Color : AppFont999999Color;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
