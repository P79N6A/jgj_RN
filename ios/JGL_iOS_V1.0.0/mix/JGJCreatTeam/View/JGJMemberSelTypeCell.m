//
//  JGJMemberSelTypeCell.m
//  mix
//
//  Created by yj on 2017/9/28.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJMemberSelTypeCell.h"


@implementation JGJMemberSelTypeModel

@end

@interface JGJMemberSelTypeCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UIView *toplineView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrawImageView;

@end

@implementation JGJMemberSelTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLable.textColor = AppFont333333Color;
    
    self.titleLable.font = [UIFont boldSystemFontOfSize:AppFont30Size];
    
    self.toplineView.backgroundColor = AppFontf1f1f1Color;
}

- (void)setSelTypeModel:(JGJMemberSelTypeModel *)selTypeModel {
    
    _selTypeModel = selTypeModel;
    
    self.titleLable.text = _selTypeModel.title;
    
    self.iconImageView.image = [UIImage imageNamed:_selTypeModel.icon];
    
    self.rightArrawImageView.hidden = [NSString isEmpty:_selTypeModel.title];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
