//
//  JGJCheckStaPopViewCell.m
//  mix
//
//  Created by yj on 2018/6/5.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJCheckStaPopViewCell.h"

#import "UILabel+GNUtil.h"

@interface JGJCheckStaPopViewCell()

@property (weak, nonatomic) IBOutlet UILabel *firTitle;

@property (weak, nonatomic) IBOutlet UILabel *firDes;


@property (weak, nonatomic) IBOutlet UILabel *secTitle;

@property (weak, nonatomic) IBOutlet UILabel *secDes;

@property (weak, nonatomic) IBOutlet UILabel *typeTitle;

@property (weak, nonatomic) IBOutlet UILabel *money;

//包工记账 借支 计算
@property (weak, nonatomic) IBOutlet UILabel *otherTitle;

@property (weak, nonatomic) IBOutlet UIImageView *dotLineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeTitleTrail;


@end

@implementation JGJCheckStaPopViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.firTitle.textColor = AppFont333333Color;
    
    self.firDes.textColor = AppFont333333Color;
    
    self.secTitle.textColor = AppFont333333Color;
    
    self.secDes.textColor = AppFont333333Color;
    
    self.typeTitle.textColor = AppFont333333Color;
    
    self.money.textColor = AppFontEB4E4EColor;
    
    UIFont *titleFont = [UIFont boldSystemFontOfSize:AppFont24Size];
    
    self.firDes.font = titleFont;
    
    self.secDes.font = titleFont;
    
    self.typeTitle.font = [UIFont systemFontOfSize:AppFont24Size];;
    
    self.money.font = [UIFont boldSystemFontOfSize:AppFont28Size];
    
    self.otherTitle.textColor = AppFont333333Color;
    
    self.otherTitle.font = titleFont;
    
    self.firTitle.font = titleFont;
    
    self.secTitle.font = titleFont;
    
    self.dotLineView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDesInfoModel:(JGJCheckStaPopViewCellModel *)desInfoModel {
    
    _desInfoModel = desInfoModel;
    
    self.typeTitle.text = desInfoModel.typeTitle;
    
    self.money.text = desInfoModel.money;
    
    //1、2点工、包工考勤
    
    if (desInfoModel.otherType == 1 ||  desInfoModel.otherType == 2) {
        
        [self setwork_typeWithDesInfoModel:desInfoModel];
        
    }else {
        
        [self setOtherTypeWithDesInfoModel:desInfoModel];
        
    }
    
    //隐藏对应标签
    
    BOOL isHidden = desInfoModel.otherType == 1 ||  desInfoModel.otherType == 2;
    
    //包工记账、借支、结算显示
    
    [self isHiddenTitle:!isHidden];
    
    //设置钱的颜色
    
    [self setMoneyFontWithDesInfoModel:desInfoModel];
    
}

- (void)setMoneyFontWithDesInfoModel:(JGJCheckStaPopViewCellModel *)desInfoModel {
    
    self.money.font = [UIFont boldSystemFontOfSize:AppFont28Size];
    
    self.money.textColor = desInfoModel.firChangeColor;
    
}

#pragma mark - 点工、包工考勤
- (void)setwork_typeWithDesInfoModel:(JGJCheckStaPopViewCellModel *)desInfoModel {
    
    self.firTitle.text = desInfoModel.firTitle;
    
    self.firDes.text = desInfoModel.firDes;
    
    self.secTitle.text = desInfoModel.secTitle;
    
    self.secDes.text = desInfoModel.secDes;
    
    UIFont *font = [UIFont boldSystemFontOfSize:AppFont28Size];
    
    if (desInfoModel.firChangeColor && ![NSString isEmpty:desInfoModel.firChangeStr]) {
        
//        [self.firDes markText:desInfoModel.firChangeStr withFont:font color:desInfoModel.firChangeColor];
        
        [self.firDes markText:desInfoModel.firChangeStr withColor:desInfoModel.firChangeColor];
    }
    
    if (desInfoModel.secChangeColor && ![NSString isEmpty:desInfoModel.secChangeStr]) {
        
//        [self.secDes markText:desInfoModel.secChangeStr withFont:font color:desInfoModel.secChangeColor];
        
        [self.secDes markText:desInfoModel.secChangeStr withColor:desInfoModel.secChangeColor];
        
    }
}

#pragma mark - 借支、结算、包工记账
- (void)setOtherTypeWithDesInfoModel:(JGJCheckStaPopViewCellModel *)desInfoModel {
    
    UIFont *font = [UIFont boldSystemFontOfSize:AppFont24Size];
    
    self.otherTitle.text = desInfoModel.firDes;
    
    if (desInfoModel.firChangeColor && ![NSString isEmpty:desInfoModel.firChangeStr]) {
        
        [self.otherTitle markText:desInfoModel.firChangeStr withColor:desInfoModel.firChangeColor];
    }
    
}

- (void)isHiddenTitle:(BOOL)isHidden {
    
    self.firTitle.hidden = isHidden;
    
    self.firDes.hidden = isHidden;
    
    self.secTitle.hidden = isHidden;
    
    self.secDes.hidden = isHidden;
    
    self.otherTitle.hidden = !isHidden;
    
}

+ (CGFloat)JGJCheckStaPopViewCellHeight {
    
    return 51;
}

@end
