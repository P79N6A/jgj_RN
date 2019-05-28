//
//  JGJPerInfoHeadCell.m
//  mix
//
//  Created by yj on 16/12/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJPerInfoHeadCell.h"
#import "UIButton+JGJUIButton.h"
#import "NSString+Extend.h"
/** 竖直方向间距 */
static CGFloat const verticalInset = 6.0;

@interface JGJPerInfoHeadCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) IBOutlet UILabel *telephoneLable;

@property (weak, nonatomic) IBOutlet UILabel *nicknameLable;

@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;

@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nickNameLabelTopMargin;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *telephoneLabelTopMargin;

@end

@implementation JGJPerInfoHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLable.textColor = AppFont000000Color;
    self.nameLable.font = [UIFont systemFontOfSize:AppFont40Size];
    
    self.nicknameLable.textColor = AppFont666666Color;
    self.nicknameLable.font = [UIFont systemFontOfSize:AppFont30Size];
    self.nickNameLabelTopMargin.constant = verticalInset;
    
    
    self.telephoneLable.textColor = AppFont666666Color;
    self.telephoneLable.font = [UIFont systemFontOfSize:AppFont30Size];
    self.telephoneLabelTopMargin.constant = verticalInset;
    
    self.messageLabel.textColor = AppFont666666Color;
    self.messageLabel.font = [UIFont systemFontOfSize:AppFont28Size];
    self.messageLabel.numberOfLines = 0;
    
    self.messageView.backgroundColor = AppFontf7f7f7Color;
    self.messageView.layer.borderColor = AppFontdbdbdbColor.CGColor;
    self.messageView.layer.borderWidth = 1.0;
    self.messageView.layer.cornerRadius = 3.0;
    self.messageView.clipsToBounds = YES;
    
    [self.headPic.layer setLayerCornerRadius:JGJHeadCornerRadius];
    
    self.bottomView.backgroundColor = AppFontf1f1f1Color;
    
}

- (void)setPerInfoModel:(JGJChatPerInfoModel *)perInfoModel {
    _perInfoModel = perInfoModel;
    // 设置头像
    JGJSynBillingModel *infoModel = [JGJSynBillingModel new];
    infoModel.real_name = perInfoModel.real_name;
    infoModel.head_pic = perInfoModel.head_pic;
    [self.headPic setMemberPicButtonWithHeadPicStr:infoModel.head_pic memberName:infoModel.real_name memberPicBackColor:infoModel.modelBackGroundColor membertelephone:perInfoModel.telephone];
    // 名字
    self.nameLable.text = _perInfoModel.real_name;
    
    // 昵称
    if ([NSString isEmpty:perInfoModel.nick_name]) {
        self.nicknameLable.text = nil;
        self.nickNameLabelTopMargin.constant = 0;
    } else {
        self.nicknameLable.text = [NSString stringWithFormat:@"昵称: %@",perInfoModel.nick_name];
        self.nickNameLabelTopMargin.constant = verticalInset;
    }
    self.nicknameLable.hidden = [NSString isEmpty:_perInfoModel.nick_name];
    
    // 电话
    if ([NSString isEmpty:perInfoModel.telephone]) {
        self.telephoneLable.text = nil;
        self.telephoneLabelTopMargin.constant = 0;
    }else{
        self.telephoneLable.text = [NSString stringWithFormat:@"手机号码: %@",perInfoModel.telephone];
        self.telephoneLabelTopMargin.constant = verticalInset;
    }
    
    
    NSString *genderImageStr = perInfoModel.gender == 2 ? @"woman" : @"man";
    self.genderImageView.hidden = NO;
    if ([NSString isEmpty:perInfoModel.real_name] || _perInfoModel.gender == 0) {
        self.genderImageView.hidden = YES;
    }
    
    self.genderImageView.image = [UIImage imageNamed:genderImageStr];
    
    self.messageView.hidden = !(perInfoModel.status == JGJFriendListUnAddMsgType && ![NSString isEmpty:perInfoModel.message]);
    
    if (!self.messageView.hidden) {
        self.messageLabel.text = perInfoModel.message;
        NSString *name = [NSString isEmpty:perInfoModel.comment_name] ? perInfoModel.real_name : perInfoModel.comment_name;
        self.messageLabel.text = [NSString stringWithFormat:@"%@：%@",name,perInfoModel.message];
    }
    
    
    
}

- (IBAction)handleHeadButtonPressedAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(perInfoHeadWithCell:perInfoModel:)]) {
        [self.delegate perInfoHeadWithCell:self perInfoModel:self.perInfoModel];
    }
}

+ (CGFloat)headHeightWithMessage:(NSString *)message status:(JGJFriendListMsgType)status
{
    CGFloat height = 65 + 20 * 2 + 15;
    if (status == JGJFriendListUnAddMsgType && ![NSString isEmpty:message]) {
        CGFloat maxWidth = TYGetUIScreenWidth - 15 * 2 - 15 * 2;
        CGFloat messageH = [NSString getContentHeightWithString:message maxWidth:maxWidth font:AppFont28Size lineSpace:0];
        height = height + messageH + 15 * 2 + 20;
    }
    return height;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
