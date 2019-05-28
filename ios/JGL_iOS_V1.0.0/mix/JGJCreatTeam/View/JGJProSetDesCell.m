//
//  JGJProSetDesCell.m
//  JGJCompany
//
//  Created by yj on 2017/8/8.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJProSetDesCell.h"

#import "NSString+Extend.h"

#import "UILabel+GNUtil.h"

@implementation JGJProSetDesCellModel


@end


@interface JGJProSetDesCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UIButton *pronameButton;

@property (weak, nonatomic) IBOutlet LineView *topLineView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pronameButtonTrail;

@end

@implementation JGJProSetDesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.topLineView.hidden = YES;
    
    self.titleLable.textColor = AppFont333333Color;
    
    [self.pronameButton setTitleColor:AppFontEB4E4EColor forState:UIControlStateNormal];
}

- (void)setDesModel:(JGJProSetDesCellModel *)desModel {

    _desModel = desModel;
    
    self.titleLable.text = desModel.title;
    
    if (![NSString isEmpty:desModel.detailTitle]) {
        
        desModel.detailTitle = [desModel.detailTitle stringByReplacingOccurrencesOfString:@"续订" withString:@"续期"];
    }
    
    [self.pronameButton setTitle:desModel.detailTitle forState:UIControlStateNormal];
    
    self.topLineView.hidden = !desModel.isShowTopLineView;
    
    self.bottomLineView.hidden = desModel.isShowTopLineView;
    
    if (desModel.isHiddenImageView) {
        
        self.rightImageView.hidden = YES;
        
        self.pronameButtonTrail.constant = -8;
        
    }else {
        
        self.rightImageView.hidden = NO;
        
        self.pronameButtonTrail.constant = 6;
    }
    
    if (![NSString isEmpty:desModel.flagImageStr]) {
        
        [self.pronameButton setImage:[UIImage imageNamed:desModel.flagImageStr] forState:UIControlStateNormal];
        
    }else {
        
        [self.pronameButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    
    if (desModel.detailTitleColor) {
        
        [self.pronameButton setTitleColor:desModel.detailTitleColor forState:UIControlStateNormal];
    }
    
    NSString *subStr = nil;
    
    NSRange range = [desModel.title rangeOfString:@"(剩余"];
    
    if (range.location != NSNotFound) {
        
        subStr = [desModel.title substringFromIndex:range.location];
    }
    
    if ([desModel.title rangeOfString:@"已过期"].location != NSNotFound) {
        
        [self.titleLable markText:@"已过期" withFont:[UIFont systemFontOfSize:AppFont26Size] color:AppFontEB4E4EColor];
        
    }else if (![NSString isEmpty:subStr]) {
        
        [self.titleLable markText:subStr withFont:[UIFont systemFontOfSize:AppFont26Size] color:AppFont999999Color];
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
