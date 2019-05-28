//
//  JGJProFilterCell.m
//  mix
//
//  Created by yj on 2018/1/3.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJProFilterCell.h"

@interface JGJProFilterCell ()


@property (weak, nonatomic) IBOutlet UILabel *proNameLable;

@property (weak, nonatomic) IBOutlet UIImageView *selFlagImageView;


@end

@implementation JGJProFilterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selFlagImageView.hidden = YES;
    
    self.proNameLable.textColor = AppFont333333Color;
}

- (void)setProModel:(JGJRecordWorkPointFilterModel *)proModel {
    
    _proModel = proModel;
    
    self.proNameLable.text = proModel.name;
    
    self.selFlagImageView.hidden = !proModel.isSel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
