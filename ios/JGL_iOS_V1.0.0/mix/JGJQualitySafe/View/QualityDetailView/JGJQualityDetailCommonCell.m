//
//  JGJQualityDetailCommonCell.m
//  JGJCompany
//
//  Created by yj on 2017/6/12.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQualityDetailCommonCell.h"

#import "UILabel+GNUtil.h"

#import "NSString+Extend.h"

@interface JGJQualityDetailCommonCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UILabel *detailLable;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightArrowW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightArrowH;

@property (weak, nonatomic) IBOutlet UIImageView *nextImageView;


@end

@implementation JGJQualityDetailCommonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLable.textColor = AppFont333333Color;
    
    self.detailLable.textColor = AppFont333333Color;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapTilte:)];
    
    tap.numberOfTapsRequired = 1;
    
    [self.titleLable addGestureRecognizer:tap];
    
    self.titleLable.userInteractionEnabled = YES;
}

- (void)setCommonModel:(JGJCreatTeamModel *)commonModel {

    _commonModel = commonModel;
    
    self.titleLable.text  = commonModel.title;
    
    self.detailLable.text = commonModel.detailTitle;
    
    if (commonModel.isHiddenArrow) {
        
        self.rightArrowH.constant = 0;
        
        self.rightArrowW.constant = 0;
        
        self.nextImageView.hidden = YES;
        
        self.detailLable.textColor = AppFont999999Color;
        
    }else {
    
        self.rightArrowH.constant = 15;
        
        self.rightArrowW.constant = 9;
        
        self.nextImageView.hidden = NO;
        
        self.detailLable.textColor = AppFont999999Color;
        
    }
    
    UIColor *changeColor = AppFont333333Color;
    
    if (commonModel.changeColor) {
        
        changeColor = commonModel.changeColor;
    }
    
    if (![NSString isEmpty:commonModel.changeStr]) {
        
        [self.titleLable markText:commonModel.changeStr withColor:changeColor];
    }
    
    [self hiddenAllSubView:commonModel];
}

- (void)hiddenAllSubView:(JGJCreatTeamModel *)commonModel  {

    self.titleLable.hidden = commonModel.isHiddenSubView;
    
    self.detailLable.hidden = commonModel.isHiddenSubView;
    
    self.nextImageView.hidden = commonModel.isHiddenSubView || commonModel.isHiddenArrow;

}

#pragma mark -
- (void)handleTapTilte:(UITapGestureRecognizer *)tap {

    if ([self.delegate respondsToSelector:@selector(qualityDetailCommonCell:)]) {
        
        [self.delegate qualityDetailCommonCell:self];
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
