//
//  JGJFilterAccountMemberCell.m
//  mix
//
//  Created by yj on 2018/1/3.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJFilterAccountMemberCell.h"

#import "UIButton+JGJUIButton.h"

@interface JGJFilterAccountMemberCell ()

@property (weak, nonatomic) IBOutlet UIButton *headButton;

@property (weak, nonatomic) IBOutlet UIImageView *selFlagImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@end

@implementation JGJFilterAccountMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.headButton.layer setLayerCornerRadius:JGJCornerRadius];
    
    self.selFlagImageView.hidden = YES;
}

- (void)setMemberModel:(JGJSynBillingModel *)memberModel {
    
    _memberModel = memberModel;
    
    [self.headButton setMemberPicButtonWithHeadPicStr:memberModel.head_pic?:@"" memberName:memberModel.name?:@"" memberPicBackColor:memberModel.modelBackGroundColor membertelephone:memberModel.telephone?:@""];
    
    self.headButton.titleLabel.font = [UIFont systemFontOfSize:AppFont26Size];
    
    self.nameLable.text = memberModel.name;
    
    self.selFlagImageView.hidden = !memberModel.isSelected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
