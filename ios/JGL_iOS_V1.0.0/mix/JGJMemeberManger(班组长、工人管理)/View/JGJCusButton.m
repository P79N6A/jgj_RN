//
//  JGJCusButton.m
//  mix
//
//  Created by yj on 2018/4/20.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJCusButton.h"

@implementation JGJCusButtonModel


@end

@implementation JGJCusButton

-(void)setTagModel:(JGJMemberImpressTagViewModel *)tagModel {
    
    _tagModel = tagModel;
    
    if (tagModel.tagViewType == JGJMemberImpressComselTagViewType || tagModel.tagViewType == JGJMemberImpressRemarkselTagViewType || tagModel.tagViewType == JGJMemberImpressAgencyselTagViewType) {
        
        [self comSelTagViewWithTagModel:tagModel];
        
    }else {
        
        [self impressSelTagViewWithTagModel:tagModel];
    }
    
}

- (void)comSelTagViewWithTagModel:(JGJMemberImpressTagViewModel *)tagModel {
    
    UIColor *layerCor = tagModel.selected ? AppFontEB4E4EColor : AppFontF5F5F5Color;
    
    UIColor *textColor = AppFont333333Color;
    
    UIColor *backColor = AppFontF5F5F5Color;
    
    self.titleLabel.font = [UIFont systemFontOfSize:AppFont28Size];
    
    if (tagModel.selected) {
        
        layerCor = AppFontF5A6A6Color;
        
        textColor = AppFontEB4E4EColor;
        
        backColor = AppFontFDEDEDColor;
    }
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.backgroundColor = backColor;
    
    [self setTitleColor:textColor forState:UIControlStateNormal];
    
    [self.layer setLayerBorderWithColor:layerCor width:0.5 radius:self.height / 2.0];
        
    [self setTitle:tagModel.tag_name forState:UIControlStateNormal];
    
    [self setImage:[UIImage imageNamed:@"markBillSelectPro"] forState:UIControlStateSelected];
    
    [self setTitle:tagModel.tag_name forState:UIControlStateNormal];
    
    if (tagModel.selected) {
        
        self.imageEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 0);
        
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
        
    }else {
        
        self.imageEdgeInsets = UIEdgeInsetsZero;
        
        self.titleEdgeInsets = UIEdgeInsetsZero;
    }
    
}

#pragma mark - 印象标签选择
- (void)impressSelTagViewWithTagModel:(JGJMemberImpressTagViewModel *)tagModel {
    
    UIColor *cor = tagModel.selected ? AppFontEB4E4EColor : AppFont999999Color;
    
    [self setTitleColor:cor forState:UIControlStateNormal];
    
    [self.layer setLayerBorderWithColor:cor width:0.5 radius:self.height / 2.0];
    
    self.layer.masksToBounds = YES;
    
    [self setImage:[UIImage imageNamed:@"appraise_sel_icon"] forState:UIControlStateSelected];
    
    [self setTitle:tagModel.tag_name forState:UIControlStateNormal];
    
    CGFloat titleW = self.titleLabel.bounds.size.width;
    
    if ([NSString isFloatZero:titleW]) {
        
        titleW = tagModel.tagNameW;
    }
    
    CGFloat imageW = 14;
    
    CGFloat interval = 8.0;
    
    if (tagModel.selected) {
        
        self.imageEdgeInsets = UIEdgeInsetsMake(0,titleW + interval + imageW, 0, 0);
        
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageW + interval + 15), 0, 0);
        
    }else {
        
        self.imageEdgeInsets = UIEdgeInsetsZero;
        
        self.titleEdgeInsets = UIEdgeInsetsZero;
    }
}

@end
