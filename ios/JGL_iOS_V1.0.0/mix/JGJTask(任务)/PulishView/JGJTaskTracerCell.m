//
//  JGJTaskTracerCell.m
//  JGJCompany
//
//  Created by yj on 2017/6/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJTaskTracerCell.h"

#import "UIButton+JGJUIButton.h"

#import "NSString+Extend.h"

#import "UILabel+GNUtil.h"

@interface JGJTaskTracerCell ()
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;

@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) IBOutlet UIButton *headButton;

@property (weak, nonatomic) IBOutlet UIButton *flagButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flagButtonTrail;

@end

@implementation JGJTaskTracerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLable.textColor = AppFont333333Color;
    self.nameLable.font = [UIFont boldSystemFontOfSize:AppFont30Size];
    [self.headButton.layer setLayerCornerRadius:JGJHeadCornerRadius];

}

- (void)setContactModel:(JGJSynBillingModel *)contactModel {
    
    _contactModel = contactModel;
    
    if ([contactModel.is_active isEqualToString:@"0"]) {
        
        [self.flagButton setImage:[UIImage imageNamed:@"member_noActive"] forState:UIControlStateNormal];
        
    }else {
    
        [self.flagButton setImage:nil forState:UIControlStateNormal];
    }
    
    if (contactModel.isAddModel) {
        
        self.headButton.backgroundColor = [UIColor whiteColor];
        
        [self.headButton setBackgroundImage:[UIImage imageNamed:contactModel.head_pic] forState:UIControlStateNormal];
        
        [self.headButton setTitle:@"" forState:UIControlStateNormal];
        
        [self.headButton setImage:nil forState:UIControlStateNormal];
        
    }else {
        
        [self.headButton setImage:nil forState:UIControlStateNormal];
        
        [self.headButton setMemberPicButtonWithHeadPicStr:contactModel.head_pic memberName:contactModel.real_name memberPicBackColor:contactModel.modelBackGroundColor membertelephone:contactModel.telephone];
        
        self.headButton.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
    }
    
    self.nameLable.text = contactModel.name;
    
    self.selectedBtn.selected = _contactModel.isSelected;

    if (![NSString isEmpty:self.searchValue]) {
        
        [self.nameLable markText:self.searchValue withColor:AppFontEB4E4EColor];
        
    }else {
        
        self.nameLable.textColor = AppFont333333Color;
    }
    
}

- (void)setIsOffset:(BOOL)isOffset {
    
    _isOffset = isOffset;
    
    self.flagButtonTrail.constant = isOffset ? 24 : 12;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
