//
//  JGJMemManDetailMemCell.m
//  mix
//
//  Created by yj on 2018/4/18.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJMemManDetailMemCell.h"

#import "UIButton+JGJUIButton.h"

@interface JGJMemManDetailMemCell ()

@property (weak, nonatomic) IBOutlet UIButton *headButton;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *tel;


@property (weak, nonatomic) IBOutlet UIButton *editNameButton;

@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameCenterY;


@end

@implementation JGJMemManDetailMemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.headButton.layer setLayerCornerRadius:2.5];
    
    [self.editNameButton.layer setLayerBorderWithColor:AppFontEB4E4EColor width:0.5 radius:3];
    
    [self.editNameButton setTitleColor:AppFontEB4E4EColor forState:UIControlStateNormal];
    
    self.name.textColor = AppFont333333Color;
    
    self.textLabel.textColor = AppFont999999Color;
    
//    self.bottomLineView.backgroundColor = AppFontf1f1f1Color;
}

- (void)setMemberModel:(JGJSynBillingModel *)memberModel {
    
    _memberModel = memberModel;
    
    [self.headButton setMemberPicButtonWithHeadPicStr:memberModel.head_pic memberName:memberModel.name memberPicBackColor:memberModel.modelBackGroundColor membertelephone:memberModel.telephone?:@""];
    
    self.name.text = memberModel.name;
    
    self.tel.text = memberModel.telephone;
    
    self.nameCenterY.constant = memberModel.is_not_telph ? 0 : -12;
    
    self.tel.hidden = memberModel.is_not_telph;
    
    NSString *myuid = [TYUserDefaults objectForKey:JLGUserUid];
    
    self.editNameButton.hidden = [myuid isEqualToString:memberModel.uid];
    
}

- (IBAction)editNameButtonPresssed:(UIButton *)sender {
    
    if (self.memManDetailMemCellBlock) {
        
        self.memManDetailMemCellBlock(self.memberModel, JGJMemManDetailMemEditInfoBtntype);
    }
    
}

- (IBAction)headBtnPressed:(UIButton *)sender {
    
    if (self.memManDetailMemCellBlock) {
        
        self.memManDetailMemCellBlock(self.memberModel, JGJMemManDetailMemHeadBtntype);
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
