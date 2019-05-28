//
//  JGJContactedAddressBookCell.m
//  mix
//
//  Created by yj on 16/12/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJContactedAddressBookCell.h"
#import "NSString+Extend.h"
#import "UIButton+WebCache.h"
#import "UIButton+JGJUIButton.h"
@interface JGJContactedAddressBookCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectedButtonW;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet UIButton *headButton;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;


@end
@implementation JGJContactedAddressBookCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLable.textColor = AppFont333333Color;
    self.nameLable.font = [UIFont boldSystemFontOfSize:AppFont30Size];
    [self.headButton.layer setLayerCornerRadius:JGJHeadCornerRadius];
    
    [self.addBtn setTitleColor:AppFont666666Color forState:UIControlStateNormal];
}

- (void)setContactModel:(JGJSynBillingModel *)contactModel {
    
    _contactModel = contactModel;
    
    if ([NSString isEmpty:contactModel.head_pic]) {
        if (![NSString isEmpty:contactModel.name]) {
            [self.headButton setMemberPicButtonWithHeadPicStr:contactModel.head_pic memberName:contactModel.name memberPicBackColor:contactModel.modelBackGroundColor membertelephone:contactModel.telph];
        }
    }else if (self.addressBookCellType == JGJContactedAddressBookFirstSectionCellCustomHeadPicType){
//        [self.headButton setImage:[UIImage imageNamed:contactModel.head_pic] forState:UIControlStateNormal];
    }else {
        
        [self.headButton setMemberPicButtonWithHeadPicStr:contactModel.head_pic memberName:contactModel.name memberPicBackColor:contactModel.modelBackGroundColor membertelephone:contactModel.telph];

    }

    self.nameLable.text = contactModel.name;
    
    self.selectedButton.selected = _contactModel.isSelected;
    
    [self.addBtn setTitle:@"" forState:UIControlStateNormal];
    
    UIImage *image = [UIImage imageNamed:@"EllipseIcon"];
    
    if (contactModel.is_exist) {
        
        image = [UIImage imageNamed:@"OldSelected"];
        
        [self.addBtn setTitle:@"已添加" forState:UIControlStateNormal];
        
    }else {
        
        image = contactModel.isSelected ? [UIImage imageNamed:@"MultiSelected"] : [UIImage imageNamed:@"EllipseIcon"];
        
    }
    
    [self.selectedButton setImage:image forState:UIControlStateNormal];
    
    self.selectedButtonW.constant = self.addressBookCellType == JGJContactedAddressBookCellSelectedMembersType ? 40 :0;
    
    self.headButton.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
}

- (void)setHeadModel:(JGJSynBillingModel *)headModel {
    _headModel = headModel;
//    [self.headButton setImage:[UIImage imageNamed:headModel.head_pic] forState:UIControlStateNormal];
//    self.nameLable.text = headModel.name;
//    self.selectedButton.selected = _contactModel.isSelected;
//    self.selectedButtonW.constant = self.addressBookCellType == JGJContactedAddressBookCellSelectedMembersType ? 40 :0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)cellHeight {
    
    return 55.0;
}

@end
