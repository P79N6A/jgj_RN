//
//  JGJTaskSelMemberCell.m
//  JGJCompany
//
//  Created by yj on 2017/6/6.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJTaskSelMemberCell.h"

#import "UIButton+JGJUIButton.h"

#import "UILabel+GNUtil.h"

@interface JGJTaskSelMemberCell ()
@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UIButton *selectedMemeberButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unActiveTrail;

@end

@implementation JGJTaskSelMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.headButton.layer setLayerCornerRadius:JGJHeadCornerRadius];
    [self.selectedMemeberButton setTitleColor:AppFont999999Color forState:UIControlStateSelected];
    self.lineView.backgroundColor = AppFontf1f1f1Color;
    
    self.nameLable.textColor = AppFont333333Color;

}

- (void)setContactModel:(JGJSynBillingModel *)contactModel {
    
    _contactModel = contactModel;
    
    self.nameLable.text = contactModel.name;
    
    self.unActiveTrail.constant = self.isOffset ? 25 : 12;
    
    [self.headButton setTitle:@"" forState:UIControlStateNormal];
    if (contactModel.isAddModel) {
        
        [self.headButton setBackgroundImage:[UIImage imageNamed:contactModel.head_pic] forState:UIControlStateNormal];
        
    }else {
    
        [self.headButton setMemberPicButtonWithHeadPicStr:contactModel.head_pic memberName:contactModel.name memberPicBackColor:contactModel.modelBackGroundColor];
        
    }
    
    [self.selectedMemeberButton setTitle:@"" forState:UIControlStateNormal];
    
    [self.selectedMemeberButton setImage:nil forState:UIControlStateNormal];
    
    if ([contactModel.is_active isEqualToString:@"0"] && !contactModel.isAddModel) {
        
        [self.selectedMemeberButton setImage:[UIImage imageNamed:@"member_noActive"] forState:UIControlStateNormal];
        
    }else if ([contactModel.is_active isEqualToString:@"1"] && !contactModel.isSelected) {
        
        [self.selectedMemeberButton setImage:nil forState:UIControlStateNormal];
        
    }else if ([contactModel.is_active isEqualToString:@"1"] && contactModel.isSelected) {
        
        [self.selectedMemeberButton setImage:[UIImage imageNamed:@"proType_selected"] forState:UIControlStateNormal];
    }
    
    if ([NSString isEmpty:self.searchValue]) {
        
        self.nameLable.textColor = AppFont333333Color;
        
    }else {
        
        [self.nameLable markText:self.searchValue withColor:AppFontEB4E4EColor];
    }
    
}

@end
