//
//  JGJGroupChatSelectedMemberCell.m
//  mix
//
//  Created by yj on 16/12/22.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJGroupChatSelectedMemberCell.h"
#import "UIButton+JGJUIButton.h"
#import "NSString+Extend.h"
#import "UILabel+GNUtil.h"
@interface JGJGroupChatSelectedMemberCell ()
@property (weak, nonatomic  ) IBOutlet UIButton           *showHeadPicBtn;
@property (weak, nonatomic  ) IBOutlet UILabel            *name;
@property (weak, nonatomic  ) IBOutlet UILabel            *telphone;
@property (weak, nonatomic  ) IBOutlet UIButton           *multiSelectedButon;
@property (weak, nonatomic) IBOutlet UIButton *activeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *multiSelectedButtonW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activeButtonTrail;

@property (weak, nonatomic) IBOutlet UILabel *activeDes;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activeDesTrail;


@end
@implementation JGJGroupChatSelectedMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.showHeadPicBtn.layer setLayerCornerRadius:JGJHeadCornerRadius];
    [self.showHeadPicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.showHeadPicBtn.titleLabel.font = [UIFont systemFontOfSize:AppFont46Size];
    self.name.textColor = AppFont333333Color;
    self.name.font = [UIFont systemFontOfSize:AppFont30Size];
    self.telphone.textColor = AppFont666666Color;
    self.telphone.font = [UIFont systemFontOfSize:AppFont30Size];
    [self.multiSelectedButon setImage:PNGIMAGE(@"MultiSelected") forState:UIControlStateSelected];
    [self.multiSelectedButon setImage:[UIImage imageNamed:@"EllipseIcon"] forState:UIControlStateNormal];
    
    self.activeDes.textColor = AppFont999999Color;
    
}

+ (CGFloat)chatSelectedMemberCellHeight {
    return 67;
}

- (void)setGroupChatMemberModel:(JGJSynBillingModel *)groupChatMemberModel {
    _groupChatMemberModel = groupChatMemberModel;
    self.name.text = _groupChatMemberModel.real_name;
    self.telphone.text = _groupChatMemberModel.telephone;
    [self.showHeadPicBtn setMemberPicButtonWithHeadPicStr:_groupChatMemberModel.head_pic memberName:_groupChatMemberModel.name memberPicBackColor:_groupChatMemberModel.modelBackGroundColor];
    
//是否是平台用户标记
    
    [self.activeButton setTitle:@"" forState:UIControlStateNormal];
    
    BOOL isUnActive = [_groupChatMemberModel.is_active isEqualToString:@"0"];
    
    if (isUnActive) {
        [self.activeButton setImage:[UIImage imageNamed:@"member_noActive"] forState:UIControlStateNormal];
    }else {
        [self.activeButton setImage:nil forState:UIControlStateNormal];
    }
    self.multiSelectedButtonW.constant = self.chatType == JGJSingleChatType ? 12 : 40;
    self.multiSelectedButon.hidden = self.chatType == JGJSingleChatType;
    if (![NSString isEmpty:self.searchValue]) {
        [self.name markattributedTextArray:@[self.searchValue] color:AppFontEF272FColor font:self.name.font isGetAllText:YES];
        [self.telphone markattributedTextArray:@[self.searchValue] color:AppFontEF272FColor font:self.telphone.font isGetAllText:YES];
    }
    
    //已存在灰色勾勾，并且不能选中
    
    UIImage *image = [UIImage imageNamed:@"EllipseIcon"];
    
    if (groupChatMemberModel.is_exist) {
        
        image = [UIImage imageNamed:@"OldSelected"];
                
        self.activeDes.text = @"已添加";
        
        self.activeDes.hidden = NO;
        
        self.activeDesTrail.constant = -37;
        
    }else {
        
        image = _groupChatMemberModel.isSelected ? [UIImage imageNamed:@"MultiSelected"] : [UIImage imageNamed:@"EllipseIcon"];
        
        self.activeDes.hidden = YES;
        
        self.activeDesTrail.constant = 0;
    }
    
    [self.multiSelectedButon setImage:image forState:UIControlStateNormal];
    
}

- (void)setIsMoveActiveButton:(BOOL)isMoveActiveButton {
    
    _isMoveActiveButton = isMoveActiveButton;
    
    //2.3.2
    
    CGFloat trailing = _isMoveActiveButton ? 30 : 12;
    
    self.activeButtonTrail.constant = trailing;
    
    [self layoutIfNeeded];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickUnRegesterBtn:(UIButton *)sender {
    
    if (_clickUnRegesterWithModel) {
        
        _clickUnRegesterWithModel(self.groupChatMemberModel);
    }
}

@end
