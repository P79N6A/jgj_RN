//
//  JGJMemberWorkInfoCell.m
//  mix
//
//  Created by yj on 2018/4/19.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJMemberWorkInfoCell.h"

#import "UILabel+GNUtil.h"

@implementation JGJMemberWorkInfoModel

@end

@interface JGJMemberWorkInfoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewType;

@property (weak, nonatomic) IBOutlet UILabel *typeDes;

@end

@implementation JGJMemberWorkInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.typeDes.textColor = AppFont333333Color;
    
    self.typeDes.font = [UIFont systemFontOfSize:AppFont28Size];
    
}

- (void)setInfoModel:(JGJMemberWorkInfoModel *)infoModel {
    
    _infoModel = infoModel;
    
    self.imageViewType.image = [UIImage imageNamed:infoModel.imageStr];
    
    self.typeDes.text = infoModel.typeDes;
    
    if (![NSString isEmpty:infoModel.changeColorStr]) {
        
        [self.typeDes markText:infoModel.changeColorStr withColor:AppFontEB4E4EColor];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
