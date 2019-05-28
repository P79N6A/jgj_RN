//
//  JGJMemAppraiseMemInfoCell.m
//  mix
//
//  Created by yj on 2018/4/19.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJMemAppraiseMemInfoCell.h"

#import "UIButton+JGJUIButton.h"

@interface JGJMemAppraiseMemInfoCell ()

@property (weak, nonatomic) IBOutlet UIButton *headButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLable;


@end

@implementation JGJMemAppraiseMemInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLable.font = [UIFont boldSystemFontOfSize:AppFont30Size];
    
    self.nameLable.textColor = AppFont333333Color;
    
    [self.headButton.layer setLayerCornerRadius:2.5];
}

- (void)setMemberModel:(JGJSynBillingModel *)memberModel {
    
    _memberModel = memberModel;
    
    [self.headButton setMemberPicButtonWithHeadPicStr:memberModel.head_pic memberName:memberModel.name memberPicBackColor:memberModel.modelBackGroundColor membertelephone:memberModel.telephone];
    
    self.nameLable.text = memberModel.name;
    
    self.headButton.titleLabel.font = [UIFont systemFontOfSize:AppFont30Size];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
