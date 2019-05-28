//
//  JGJCheckStaListCell.m
//  mix
//
//  Created by yj on 2018/6/4.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJCheckStaListCell.h"

@implementation JGJCheckStaListCellModel


@end

@interface JGJCheckStaListCell ()

@property (weak, nonatomic) IBOutlet UIView *topLineView;

@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@property (weak, nonatomic) IBOutlet UILabel *titleLablel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLineH;

@property (weak, nonatomic) IBOutlet UIImageView *nextImageView;

@end

@implementation JGJCheckStaListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLablel.textColor = AppFontLight333333Color;
    
//    self.topLineView.backgroundColor = AppFontEBEBEBColor;
//    
//    self.bottomLineView.backgroundColor = AppFontEBEBEBColor;
}

- (void)setDesInfoModel:(JGJCheckStaListCellModel *)desInfoModel {
    
    _desInfoModel = desInfoModel;
    
    self.titleLablel.text = desInfoModel.title;
    
    self.bottomLineH.constant = desInfoModel.bottomLineHeight;
    
    self.topLineH.constant = desInfoModel.topLineHeight;
    
    if (desInfoModel.bottomLineColor) {
        
        self.bottomLineView.backgroundColor = desInfoModel.bottomLineColor;
    }
    
    if (desInfoModel.topLineColor) {
        
        self.topLineView.backgroundColor = desInfoModel.topLineColor;
    }
    
    if (![NSString isEmpty:desInfoModel.nextImageStr]) {
        
        self.nextImageView.image = [UIImage imageNamed:desInfoModel.nextImageStr];
        
    }
}

+(CGFloat)cellHeight {
    
    return 33;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
