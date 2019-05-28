//
//  JGJQuaSafeAboutMeCell.m
//  JGJCompany
//
//  Created by yj on 2017/11/20.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQuaSafeAboutMeCell.h"

#define ContentViewH  TYIS_IPHONE_5 ? 82 : 95

@interface JGJQuaSafeAboutMeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;

@property (weak, nonatomic) IBOutlet UILabel *typeTitle;

@property (weak, nonatomic) IBOutlet UIView *msgFlagView;

@property (weak, nonatomic) IBOutlet UIView *containView;


@property (weak, nonatomic) IBOutlet UIView *shadowView;

@end

@implementation JGJQuaSafeAboutMeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.typeTitle.textColor = AppFont333333Color;
    
    self.typeTitle.font = [UIFont systemFontOfSize:AppFont34Size];
    
    [self.msgFlagView.layer setLayerCornerRadius:JGJRedFlagWH / 2.0];
    
    self.msgFlagView.backgroundColor = AppFontF40F40Color;
    
    self.contentView.backgroundColor = AppFontf1f1f1Color;
    
    self.containView.backgroundColor = [UIColor whiteColor];
    
    self.shadowView.backgroundColor = AppFontf1f1f1Color;
    
    [self.shadowView.layer setLayerShadowWithColor:AppFontE6E6E6Color offset:CGSizeMake(0, 5) opacity:0.9 radius:6];
    
    [self.containView.layer setLayerCornerRadius:3.0];
}

- (void)setTypeModel:(JGJQuaSafeHomeModel *)typeModel {
    
    _typeModel = typeModel;
    
    self.typeTitle.text = typeModel.title;
    
    self.typeImageView.image  = [UIImage imageNamed:typeModel.icon];
    
    self.msgFlagView.hidden = [typeModel.unReadMsgCount isEqualToString:@"0"] || [NSString isEmpty: typeModel.unReadMsgCount];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)JGJQuaSafeAboutMeCellHeight {
    
    return TYIS_IPHONE_5 ? 82 : 95;
}

@end
