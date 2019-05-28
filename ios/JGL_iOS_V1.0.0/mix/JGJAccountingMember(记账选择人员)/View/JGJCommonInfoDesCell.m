//
//  JGJCommonInfoDesCell.m
//  mix
//
//  Created by yj on 2017/10/10.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCommonInfoDesCell.h"

@interface JGJCommonInfoDesCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UILabel *des;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameCenterY;

@property (weak, nonatomic) IBOutlet UIImageView *nextImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leading;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailing;

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;


@end

@implementation JGJCommonInfoDesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    self.lineView.backgroundColor = AppFontf1f1f1Color;
    
    self.des.textColor = AppFont999999Color;
    
    self.titleLable.textColor = AppFont333333Color;
    
    self.titleLable.font = [UIFont boldSystemFontOfSize:AppFont30Size];
}

- (void)setInfoDesModel:(JGJCommonInfoDesModel *)infoDesModel {
    
    _infoDesModel = infoDesModel;
    
    self.titleLable.text = infoDesModel.title;
    
    self.des.text = infoDesModel.des?:@"";
    
    self.nameCenterY.constant =  [NSString isEmpty:infoDesModel.des] ? 0 : -8;

    self.leading.constant = infoDesModel.leading;
    
    self.trailing.constant = infoDesModel.trailing;
    
    self.typeImageView.image = [UIImage imageNamed:infoDesModel.imageStr];
    
    self.nextImageView.hidden = [NSString isEmpty:infoDesModel.title];
}

+ (CGFloat)JGJCommonInfoDesCellHeight {

    return 60;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
