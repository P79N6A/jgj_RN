//
//  JGJLogputReasonCell.m
//  mix
//
//  Created by yj on 2018/6/6.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJLogputReasonCell.h"

@interface JGJLogputReasonCell ()

@property (weak, nonatomic) IBOutlet UIButton *selButton;

@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation JGJLogputReasonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = AppFontEBEBEBColor;
}

- (void)setDesModel:(JGJLogoutReasonModel *)desModel {
    
    _desModel = desModel;
    
    self.title.text = desModel.name;
    
    self.selButton.selected = desModel.isSel;
    
}

+(CGFloat)cellHeight {
    
    return 50.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
