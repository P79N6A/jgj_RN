//
//  JGJQualityLocalLevelCell.m
//  mix
//
//  Created by yj on 2017/6/8.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQualityLocalLevelCell.h"

#import "NSString+Extend.h"

#import "UILabel+GNUtil.h"

@implementation JGJQualityLocalModel


@end


@interface JGJQualityLocalLevelCell ()

@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;

@property (weak, nonatomic) IBOutlet UILabel *desLable;

@property (weak, nonatomic) IBOutlet UIImageView *arrowRightImageView;

@end

@implementation JGJQualityLocalLevelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.desLable.textColor = AppFont333333Color;
}

- (void)setLocalInfoModel:(JGJQualityLocalModel *)localInfoModel {

    _localInfoModel = localInfoModel;
    
    self.flagImageView.image = [UIImage imageNamed:localInfoModel.flagIcon];
    
    self.desLable.text = localInfoModel.desTitle;
    
    if (![NSString isEmpty:localInfoModel.changeColorStr]) {
        
        [self.desLable markText:localInfoModel.changeColorStr withColor:localInfoModel.changeColor];
        
    }
    
    CGFloat flagImageViewWH = 0;
    
    CGFloat left = 0;
    
    if ([NSString isEmpty:localInfoModel.flagIcon]) {
        
        flagImageViewWH = 0;
        
        left = -4;
        
    }else {
        
        flagImageViewWH = 14;
        
        left = 10;
    }
    
    [self.flagImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.height.mas_equalTo(flagImageViewWH);
        
        make.left.mas_equalTo(left);
        
    }];

    self.arrowRightImageView.hidden = localInfoModel.isHiddenArrowRightImageView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
