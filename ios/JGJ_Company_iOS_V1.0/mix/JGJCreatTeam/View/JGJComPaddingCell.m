//
//  JGJComPaddingCell.m
//  mix
//
//  Created by yj on 2018/6/7.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJComPaddingCell.h"

@interface JGJComPaddingCell ()

@property (weak, nonatomic) IBOutlet UIView *topLineView;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerY;

@end

@implementation JGJComPaddingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.topLineView.backgroundColor = AppFontf1f1f1Color;
    
    self.titleLable.textColor = AppFont333333Color;
}

- (void)setInfoDesModel:(JGJCommonInfoDesModel *)infoDesModel {
    
    _infoDesModel = infoDesModel;
    
    self.titleLable.text = infoDesModel.title;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeight {
    
    return 50;
}

@end
