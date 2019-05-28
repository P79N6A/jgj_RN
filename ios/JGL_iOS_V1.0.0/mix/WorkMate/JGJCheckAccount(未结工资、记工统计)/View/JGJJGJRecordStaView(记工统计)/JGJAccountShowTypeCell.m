//
//  JGJAccountShowTypeCell.m
//  mix
//
//  Created by yj on 2018/6/5.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJAccountShowTypeCell.h"

@interface JGJAccountShowTypeCell ()

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;

@end

@implementation JGJAccountShowTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.title.textColor = AppFont333333Color;
}

- (void)setShowTypeModel:(JGJAccountShowTypeModel *)showTypeModel {
    
    _showTypeModel = showTypeModel;
    
    self.title.text = showTypeModel.title;
    
    self.flagImageView.hidden = !showTypeModel.isSel;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
