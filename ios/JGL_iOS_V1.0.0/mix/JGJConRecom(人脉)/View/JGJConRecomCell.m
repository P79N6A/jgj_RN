//
//  JGJConRecomCell.m
//  mix
//
//  Created by yj on 2018/1/17.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJConRecomCell.h"

#import "UIButton+JGJUIButton.h"

#import "UILabel+GNUtil.h"

@interface JGJConRecomCell ()

@property (weak, nonatomic) IBOutlet UIButton *headButton;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *comment;

@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;

//认证按钮
@property (weak, nonatomic) IBOutlet UIButton *authFlagBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *authBtnW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *authTrail;

//实名按钮

@property (weak, nonatomic) IBOutlet UIButton *vertifyBtn;

@property (weak, nonatomic) IBOutlet UILabel *signature;


@end

@implementation JGJConRecomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.addFriendButton.layer setLayerBorderWithColor:AppFontEB4E4EColor width:0.5 radius:14];

    self.name.textColor = AppFont333333Color;
    
    self.comment.textColor = AppFont999999Color;
    
    [self.headButton.layer setLayerCornerRadius:JGJHeadCornerRadius];
    
    self.name.font = [UIFont boldSystemFontOfSize:AppFont30Size];
    
    self.signature.textColor = AppFont666666Color;
    
    self.signature.font = [UIFont systemFontOfSize:AppFont24Size];
    
    self.comment.font = [UIFont systemFontOfSize:AppFont24Size];
    
}

-(void)setFriendlyModel:(JGJSynBillingModel *)friendlyModel {
    
    _friendlyModel = friendlyModel;
    
    self.name.textColor = AppFont333333Color;
    
    self.name.text = friendlyModel.real_name;
    
    [self.headButton setMemberPicButtonWithHeadPicStr:friendlyModel.head_pic memberName:friendlyModel.real_name memberPicBackColor:friendlyModel.modelBackGroundColor membertelephone:friendlyModel.telephone];
    
    NSString *title = @"好友";
    
    NSString *imageStr = @"add_conRecom_icon";
    
    if (friendlyModel.isSelected) {
        
        title = @"已发送";
        
        imageStr = nil;
        
    }
    
    self.comment.text = friendlyModel.comment?:@"";
    
    self.signature.text = friendlyModel.signature?:@"";
    
    [self.addFriendButton setTitle:title forState:UIControlStateNormal];
    
    [self.addFriendButton setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    
    [self handleVertifyAndAuthWithFriendlyModel:friendlyModel];
}

- (void)handleVertifyAndAuthWithFriendlyModel:(JGJSynBillingModel *)friendlyModel {
    
    self.vertifyBtn.hidden = YES;
    
    self.authFlagBtn.hidden = YES;
    
//    friendlyModel.verified = 3;
//
//    friendlyModel.auth_type = 1;
    
    //    "verified": "3",//3已实名
    
    //    "auth_type": "1",//认证类型,0为都未认证,1为已工人认证,2为班组认证
    
    BOOL is_verified = friendlyModel.verified == 3;
    
    BOOL is_auth_type = friendlyModel.auth_type == 1 || friendlyModel.auth_type == 2;
    
    self.authBtnW.constant = 45;
    
    self.authTrail.constant = 10;
    
    if (is_verified && is_auth_type) {
        
        self.vertifyBtn.hidden = NO;
        
        self.authFlagBtn.hidden = NO;
        
    }else if (is_verified && !is_auth_type) {
        
        self.vertifyBtn.hidden = NO;
        
        self.authFlagBtn.hidden = YES;
        
        self.authBtnW.constant = 0;
        
        self.authTrail.constant = 0;
        
    }else if (!is_verified && is_auth_type) {
        
        self.vertifyBtn.hidden = YES;
        
        self.authFlagBtn.hidden = NO;
        
    }else if (!is_verified && !is_auth_type) {
        
        self.vertifyBtn.hidden = YES;
        
        self.authFlagBtn.hidden = YES;
    }
    
}

- (IBAction)addFriendButtonPressed:(UIButton *)sender {
    
    if (self.conRecomCellBlock) {
        
        self.conRecomCellBlock(self.friendlyModel,JGJConRecomCellAddFriendBtnType);
        
    }
}

- (IBAction)vertifyBtnPressed:(UIButton *)sender {
    
    if (self.conRecomCellBlock) {
        
        self.conRecomCellBlock(self.friendlyModel,JGJConRecomCellVertifyBtnType);
        
    }
    
}

- (IBAction)authBtnPressed:(UIButton *)sender {
    
    if (self.conRecomCellBlock) {
        
        self.conRecomCellBlock(self.friendlyModel,JGJConRecomCellAuthBtnType);
        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
