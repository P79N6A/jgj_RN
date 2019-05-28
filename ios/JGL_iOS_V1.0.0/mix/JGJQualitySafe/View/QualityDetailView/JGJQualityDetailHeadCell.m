//
//  JGJQualityDetailHeadCell.m
//  mix
//
//  Created by yj on 2017/6/8.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQualityDetailHeadCell.h"

#import "UIButton+JGJUIButton.h"

#import "NSString+Extend.h"

@interface JGJQualityDetailHeadCell ()

@property (weak, nonatomic) IBOutlet UIButton *headButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) IBOutlet UIButton *statusButton;

@property (weak, nonatomic) IBOutlet UIImageView *alertFlagView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bellImageTrail;

@end

@implementation JGJQualityDetailHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.headButton.layer setLayerCornerRadius:2.5];
    
    self.nameLable.textColor = AppFont4990e2Color;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNameSkipPerVc)];
    
    tap.numberOfTapsRequired = 1;
    
    self.nameLable.userInteractionEnabled = YES;
    
    [self.nameLable addGestureRecognizer:tap];
    
}

- (void)setQualityDetailModel:(JGJQualityDetailModel *)qualityDetailModel {

    _qualityDetailModel  = qualityDetailModel;
    
    self.nameLable.text = qualityDetailModel.real_name;
    
    UIColor *headColor = [NSString modelBackGroundColor:_qualityDetailModel.real_name];

    [self.headButton setMemberPicButtonWithHeadPicStr:qualityDetailModel.head_pic memberName:qualityDetailModel.real_name memberPicBackColor:headColor];
    
    self.headButton.titleLabel.font = [UIFont systemFontOfSize:AppFont32Size];

    [self setStatusButtonInfo:_qualityDetailModel];
    
}

- (void)setStatusButtonInfo:(JGJQualityDetailModel *)qualityDetailModel {
    
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
//    UIColor *statusColor = TYColorHex(0xF9A00F);
    NSString *buttonTitle = @"";
    
    CGFloat normalStatusTrail = 10;
    
    CGFloat handleStatusTrail = -10;
    
    CGFloat trail = normalStatusTrail;
    
    UIColor *statuColor = AppFont999999Color;
    
    NSString *statusImageStr = @"";
    
    self.bellImageTrail.constant = 0;
    
    if ([qualityDetailModel.show_bell isEqualToString:@"1"]) {
        
        statuColor = AppFontEB4E4EColor; //红
        
        statusImageStr = @"quality_modify_red";
        
    }else if ([qualityDetailModel.show_bell isEqualToString:@"2"]) {
        
        statuColor = TYColorHex(0xf9a00f); //黄
        
        statusImageStr = @"quality_modify_yellow";
        
    }else if ([qualityDetailModel.show_bell isEqualToString:@"3"]) {
        
        statuColor = TYColorHex(0x83c76e); //绿
        
        statusImageStr = @"quality_modify_green";
    }
    
    
    //1 待整改 2 待复查
    if ([qualityDetailModel.statu isEqualToString:@"1"]) {
        
        if ([myUid isEqualToString:qualityDetailModel.principal_uid]) {
            
            buttonTitle = @"待整改";
            
            [self.statusButton setImage:[UIImage imageNamed:statusImageStr] forState:UIControlStateNormal];
            
            self.statusButton.imageEdgeInsets = UIEdgeInsetsMake(0, 65, 0, 0);
            
            self.statusButton.titleEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
            
            self.statusButtonType = JGJQualityDetailModifyCompleteStatusButtonType;
            
            _qualityDetailModel.statusButtonType = JGJQualityDetailModifyCompleteStatusButtonType;
//            statusColor = AppFontF9A00FColor;
            
            [self.statusButton.layer setLayerBorderWithColor:statuColor width:0.5 radius:2.5];
            self.bellImageTrail.constant = 10;
            trail = handleStatusTrail;
        }else {
            
            buttonTitle = @"待整改";
            
//            statusColor = AppFontF9A00FColor;
            
            trail = normalStatusTrail;
        }
        
    }else if ([qualityDetailModel.statu isEqualToString:@"2"]) {
        
        if ([myUid isEqualToString:qualityDetailModel.uid] || [qualityDetailModel.is_admin isEqualToString:@"1"] || [qualityDetailModel.is_creater isEqualToString:@"1"]) {
            
            buttonTitle = @"待复查";
            
            [self.statusButton setImage:[UIImage imageNamed:statusImageStr] forState:UIControlStateNormal];
            
            self.statusButton.imageEdgeInsets = UIEdgeInsetsMake(0, 65, 0, 0);
            
            self.statusButton.titleEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
            
            _qualityDetailModel.statusButtonType = JGJQualityDetailReviewResultStatusButtonType;
            
            self.statusButtonType = JGJQualityDetailReviewResultStatusButtonType;
//            statusColor = AppFont5998F6Color;
            
            [self.statusButton.layer setLayerBorderWithColor:statuColor width:0.5 radius:2.5];
            self.bellImageTrail.constant = 10;
            trail = handleStatusTrail;
        }else {
            
            buttonTitle = @"待复查";
            
//            statusColor = AppFont5998F6Color;
            
            trail = normalStatusTrail;
        }
        
    }else {
        
        buttonTitle = @"已完结";
        
//        statusColor = AppFont83C76EColor;
        
        trail = normalStatusTrail;
        
    }
    
    
    [self.statusButton mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(self).mas_offset(trail);
    }];
    
    [self.statusButton setTitle:buttonTitle forState:UIControlStateNormal];
    
    [self.statusButton setTitleColor:statuColor forState:UIControlStateNormal];
    
    [self alertImageViewWithQualityDetailModel:qualityDetailModel];
}

- (void)alertImageViewWithQualityDetailModel:(JGJQualityDetailModel *)qualityDetailModel {
    
    NSString *show_bell = @"";
    
    self.alertFlagView.hidden = NO;
    
    if ([qualityDetailModel.show_bell isEqualToString:@"1"]) {
        
        show_bell = @"tip_red_icon";
        
    }else if ([qualityDetailModel.show_bell isEqualToString:@"2"]) {
        
        show_bell = @"tip_yellow_icon";
        
    }else if ([qualityDetailModel.show_bell isEqualToString:@"3"]) {
        
        show_bell = @"tip_green_icon";
        
    }else {
        
        self.alertFlagView.hidden = YES;
    }
    
    self.alertFlagView.image = [UIImage imageNamed:show_bell];
    
}

- (void)tapNameSkipPerVc {

    if ([self.delegate respondsToSelector:@selector(qualityDetailHeadCell:didSelectedHeadButtonType:)]) {
        
        [self.delegate qualityDetailHeadCell:self didSelectedHeadButtonType:JGJQualityDetailHeadStatusButtonType];
    }
    
}

- (IBAction)handleButtonPressed:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(qualityDetailHeadCell:didSelectedHeadButtonType:)]) {
        
        [self.delegate qualityDetailHeadCell:self didSelectedHeadButtonType:JGJQualityDetailHeadStatusButtonType];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)handleStatusButtonPressed:(UIButton *)sender {
    
    if (self.qualityDetailHeadStatusBlock) {
        
        self.qualityDetailHeadStatusBlock(self);
    }
    
}


@end
