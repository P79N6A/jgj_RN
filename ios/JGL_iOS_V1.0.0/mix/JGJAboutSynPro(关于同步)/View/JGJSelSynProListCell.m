//
//  JGJSelSynProListCell.m
//  mix
//
//  Created by yj on 2018/4/16.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJSelSynProListCell.h"

#import "UILabel+GNUtil.h"

@interface JGJSelSynProListCell ()

@property (weak, nonatomic) IBOutlet UILabel *proName;

@property (weak, nonatomic) IBOutlet UIButton *selProButton;

@end

@implementation JGJSelSynProListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.proName.textColor = AppFont333333Color;
    
    self.proName.font = [UIFont systemFontOfSize:AppFont30Size];
    
}

- (void)setProlistModel:(JGJSelSynProListModel *)prolistModel {
    
    _prolistModel = prolistModel;
    
    self.proName.text = prolistModel.pro_name;
    
    self.selProButton.selected = prolistModel.isSel;
    
    [self.proName markText:self.searchValue withColor:AppFontEB4E4EColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
