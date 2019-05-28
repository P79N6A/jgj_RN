//
//  JGJCommonDesCell.m
//  mix
//
//  Created by yj on 2018/3/21.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJCommonDesCell.h"

@implementation JGJCommonDesCellModel

@end

@interface JGJCommonDesCell ()

@property (weak, nonatomic) IBOutlet UILabel *desLable;

@end

@implementation JGJCommonDesCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.desLable.backgroundColor = AppFontFEF1E1Color;

    self.desLable.textColor = AppFontFF6600Color;
    
    self.contentView.backgroundColor = AppFontFEF1E1Color;
    
    self.desLable.textAlignment = NSTextAlignmentLeft;
}

- (void)setDesModel:(JGJCommonDesCellModel *)desModel {
    
    _desModel = desModel;
    
    self.desLable.text = _desModel.title;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
