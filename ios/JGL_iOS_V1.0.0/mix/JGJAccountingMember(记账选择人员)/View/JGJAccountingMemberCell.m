//
//  JGJAccountingMemberCell.m
//  mix
//
//  Created by yj on 2017/10/10.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJAccountingMemberCell.h"

#import "NSString+Extend.h"

#import "UIButton+JGJUIButton.h"

#import "UILabel+GNUtil.h"

@interface JGJAccountingMemberCell ()

@property (weak, nonatomic) IBOutlet UIButton *delButton;

//子类使用 JGJSelSynMemberCell
@property (weak, nonatomic) IBOutlet UIButton *headButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) IBOutlet UILabel *desLable;

@property (assign, nonatomic) JGJAccountingMemberButtonType buttonType;

@end
@implementation JGJAccountingMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.delButton.layer setLayerBorderWithColor:AppFont999999Color width:0.5 radius:2.5];
    
    [self.delButton setTitleColor:AppFont999999Color forState:UIControlStateNormal];
    
    [self.headButton.layer setLayerCornerRadius:JGJHeadCornerRadius];
    
    self.headButton.userInteractionEnabled = NO;
    
    self.nameLable.textColor = AppFont333333Color;
    
    self.nameLable.font = [UIFont boldSystemFontOfSize:AppFont30Size];
    
    self.desLable.textColor = AppFont333333Color;
    
    self.desLable.font = [UIFont systemFontOfSize:AppFont24Size];
    
    self.delButton.titleLabel.font = [UIFont systemFontOfSize:AppFont22Size];
    
}

- (void)setAccountMember:(JGJSynBillingModel *)accountMember {
    
    _accountMember = accountMember;
    
    [self.headButton setMemberPicButtonWithHeadPicStr:accountMember.head_pic memberName:accountMember.name memberPicBackColor:accountMember.modelBackGroundColor membertelephone:accountMember.telph];
    
    self.headButton.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
    
    self.nameLable.text = accountMember.name;
    
    self.desLable.text = accountMember.telph;
    
    if (accountMember.is_not_telph) {
        
        [self setHiddenMemberTel];
    }
    
    self.desLable.hidden = accountMember.is_not_telph;
    
    if (![NSString isEmpty:self.searchValue]) {
        
        [self.nameLable markText:self.searchValue withColor:AppFontEB4E4EColor];
        
        [self.desLable markText:self.searchValue withColor:AppFontEB4E4EColor];
    }
    
}

- (void)setWorkerManger:(JGJSynBillingModel *)workerManger {
    
    _workerManger = workerManger;
    
    [self.headButton setMemberPicButtonWithHeadPicStr:workerManger.head_pic memberName:workerManger.name memberPicBackColor:workerManger.modelBackGroundColor membertelephone:workerManger.telph];
    
    self.headButton.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
    
    self.nameLable.text = workerManger.name;
    
    if (![NSString isEmpty:workerManger.proname]) {
        
        NSString *des = [NSString stringWithFormat:@"你在%@为他干活", workerManger.proname];
        
        if (!JLGisMateBool) {
            
            des = [NSString stringWithFormat:@"他在%@干活", workerManger.proname];
            
        }
        
        self.desLable.text = des;
        
        [self.desLable markText:workerManger.proname withColor:AppFontEB4E4EColor];
        
    }else {
        
        [self setHiddenMemberTel];
    }
    
    //能对账的时候显示对账按钮删除的时候
    if (workerManger.is_check_accounts && !_isShowDelButton) {
       
        [self.delButton setTitle:@"跟他对账" forState:UIControlStateNormal];
        
        self.buttonType = JGJAccountingMemberAccountCheckType;
        
        self.delButton.hidden = NO;
        
    }
    
    if (![NSString isEmpty:self.searchValue]) {
        
        [self.nameLable markText:self.searchValue withColor:AppFontEB4E4EColor];
        
        [self.desLable markText:self.searchValue withColor:AppFontEB4E4EColor];
    }
    
}

- (void)setIsShowDelButton:(BOOL)isShowDelButton {
    
    _isShowDelButton = isShowDelButton;
    
    self.delButton.hidden = !_isShowDelButton;
    
    [self.delButton setImage:nil forState:UIControlStateNormal];
    
    [self.delButton.layer setLayerBorderWithColor:AppFont333333Color width:0.5 radius:2.5];
    
    if (_isShowDelButton) {
        
        [self.delButton setTitle:@"删除" forState:UIControlStateNormal];
        
    }else if (self.accountMember.isSelected) {
        
        [self.delButton setImage:[UIImage imageNamed:@"RecordWorkpoints_AddFmNoContactsSelected"] forState:UIControlStateNormal];
        
        [self.delButton setTitle:@"已选中" forState:UIControlStateNormal];
        
        [self.delButton.layer setLayerBorderWithColor:AppFont333333Color width:0 radius:0];
        
        self.delButton.hidden = NO;
    }
    
}

- (IBAction)delButtonPressed:(UIButton *)sender {
    
    JGJSynBillingModel *memberModel = self.accountMember;
    
    if (!self.accountMember) {
        
        memberModel = self.workerManger;
    }
    
    if (self.accountingMemberDelButtonPressedBlock && self.isShowDelButton) {
        
        self.accountingMemberDelButtonPressedBlock(memberModel);
        
    }else {
        
        if (_buttonType == JGJAccountingMemberAccountCheckType) {
            
            if (self.checkAccountButtonPressedBlock) {
                
                self.checkAccountButtonPressedBlock(self);
            }
        }
    }
    
}

- (void)setIsHiddenName:(BOOL)isHiddenName {
    
    _isHiddenName = isHiddenName;
    
    if (_isHiddenName) {
        
        [self setHiddenMemberTel];
    }
    
}

#pragma mark - 隐藏姓名子类使用
- (void)setHiddenMemberTel {
    
    self.desLable.hidden = YES;
    
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerY.mas_equalTo(self.headButton);

    }];
    
    [self layoutIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
