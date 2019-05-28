//
//  JGJComTitleDesCell.m
//  mix
//
//  Created by yj on 2018/4/16.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJComTitleDesCell.h"

#import "JGJCustomLable.h"

#import "CustomView.h"

#import "UILabel+GNUtil.h"

#import "NSDate+Extend.h"

@interface JGJComTitleDesCell ()

@property (weak, nonatomic) IBOutlet JGJCustomLable *title;

@property (weak, nonatomic) IBOutlet JGJCustomLable *des;

@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;

@property (weak, nonatomic) IBOutlet LineView *topLineView;

@property (weak, nonatomic) IBOutlet LineView *bottomLineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *desTrail;

@end

@implementation JGJComTitleDesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.title.textColor = AppFont333333Color;
    
    self.des.textColor = AppFont999999Color;
    
    self.title.textAlignment = NSTextAlignmentLeft;
}

- (void)setInfoModel:(JGJComTitleDesInfoModel *)infoModel {
    
    _infoModel = infoModel;
    
    self.title.text = infoModel.title;
    
    self.des.text = infoModel.des;
    
    if (self.is_show_lunar && ![NSString isEmpty:infoModel.des]) {
        
        NSString *lunarTime = [NSDate convertChineseDateWithDate:infoModel.des];
        
        self.des.text = [NSString stringWithFormat:@"%@(%@)",infoModel.des, lunarTime];
    }
    
    if (infoModel.desColor) {
        
        self.des.textColor = infoModel.desColor;
    }
    
    if (infoModel.titleColor) {
        
        self.title.textColor = infoModel.titleColor;
    }
    
    if (infoModel.font) {
        
        self.title.font = infoModel.font;
    }
    
    if (infoModel.textInsets.top > 0 || infoModel.textInsets.left > 0 || infoModel.textInsets.bottom > 0 || infoModel.textInsets.right > 0) {
        
        self.title.textInsets = infoModel.textInsets;
        
        self.des.textInsets = infoModel.textInsets;
    }
    
    self.topLineView.hidden = infoModel.isHiddenTopLine;
    
    self.bottomLineView.hidden = infoModel.isHiddenBottomLine;
        
    self.rightArrow.hidden = infoModel.isHiddenArrow;
    
    if (![NSString isFloatZero:infoModel.desTrail]) {
        
        self.desTrail.constant = infoModel.desTrail;
        
    }else {
        
        self.desTrail.constant = 30;
    }
    
    self.title.textColor = AppFont333333Color;
    
    if ([self.title.text containsString:@"\n"]) {

        NSRange range = [self.title.text rangeOfString:@"\n"];
        
        NSString *des = [self.title.text substringFromIndex:range.location + 1];
        
        if (![NSString isEmpty:des]) {
            
              [self.title markLineText:des withLineFont:[UIFont systemFontOfSize:AppFont24Size] withColor:AppFont666666Color lineSpace:1];
        }
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
