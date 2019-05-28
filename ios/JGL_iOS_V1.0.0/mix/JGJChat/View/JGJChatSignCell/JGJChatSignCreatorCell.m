//
//  JGJChatSignCreatorCell.m
//  JGJCompany
//
//  Created by Tony on 16/9/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatSignCreatorCell.h"
#import "CustomView.h"
#import "UILabel+GNUtil.h"
#import "UIImageView+WebCache.h"
#import "NSString+Extend.h"

#import "UIButton+JGJUIButton.h"

@interface JGJChatSignCreatorCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet LineView *lineView;

@property (weak, nonatomic) IBOutlet UIImageView *signImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelConstraintT;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recordWorkImageConstraintT;
@property (strong, nonatomic) UIButton *headButton;
@end

@implementation JGJChatSignCreatorCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.signImage.hidden = YES;
//    [self.avatarImage.layer setLayerCornerRadiusWithRatio:0.5];
    self.avatarImage.layer.cornerRadius = 5;
    self.avatarImage.layer.masksToBounds = YES;
    self.addressLabel.textColor = AppFont999999Color;
    
    self.headButton = [UIButton new];
    [self.avatarImage addSubview:self.headButton];
    [self.headButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(self.avatarImage);
    }];
}

- (void)setChatSign_Sign_List:(ChatSign_Sign_List *)chatSign_Sign_List{
    _chatSign_Sign_List = chatSign_Sign_List;
    
    self.signImage.hidden = YES;
    
    UIColor *backGroundColor = [NSString modelBackGroundColor:_chatSign_Sign_List.sign_user_info.real_name];
    
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    
    if ([myUid isEqualToString:_chatSign_Sign_List.sign_user_info.uid]) {
        
        backGroundColor = [NSString modelBackGroundColor:_chatSign_Sign_List.sign_user_info.real_name];
        
        [self.headButton setMemberPicButtonWithHeadPicStr:_chatSign_Sign_List.sign_user_info.head_pic memberName:_chatSign_Sign_List.sign_user_info.real_name memberPicBackColor:backGroundColor];
        
    }else {
        
        [self.headButton setMemberPicButtonWithHeadPicStr:_chatSign_Sign_List.sign_user_info.head_pic memberName:_chatSign_Sign_List.sign_user_info.real_name memberPicBackColor:backGroundColor];
    }
    
    self.headButton.titleLabel.font = [UIFont systemFontOfSize:AppFont30Size];
    
    self.nameLabel.text = _chatSign_Sign_List.sign_user_info.real_name?:@" ";
    
    if ([myUid isEqualToString:_chatSign_Sign_List.sign_user_info.uid]) {
        
        self.nameLabel.text = @"我";
    }
    
    self.addressLabel.text = _chatSign_Sign_List.sign_addr;
    
    self.timeLabel.text = _chatSign_Sign_List.sign_time;
    
}

- (void)setChatSignModel:(JGJChatSignModel *)chatSignModel{
    
    _chatSignModel = chatSignModel;
    
    [self setIsHiddenLineView:YES];
    
    UIColor *backGroundColor = [NSString modelBackGroundColor:chatSignModel.user_info.real_name];
    
    [self.headButton setMemberPicButtonWithHeadPicStr:chatSignModel.user_info.head_pic?:@"" memberName:chatSignModel.user_info.real_name?:@"" memberPicBackColor:backGroundColor];
    
    self.headButton.titleLabel.font = [UIFont systemFontOfSize:AppFont30Size];
    
    NSString *nameExtStr = @"";
    
    NSMutableAttributedString *attrStr;

    //箭头和时间的图标
    UIView *firstView = [self.contentView viewWithTag:101];
    
    UIView *secondView = [self.contentView viewWithTag:102];
    
    CGFloat fontPointSize = self.nameLabel.font.pointSize;
    //设置签到的描述
    if ([chatSignModel.today_sign_record_num integerValue] == 0) {
        self.signImage.hidden = NO;
        nameExtStr = @"今日未签到";
        
        nameExtStr = [NSString stringWithFormat:@"我 %@",nameExtStr];
        attrStr = [[NSMutableAttributedString alloc] initWithString:nameExtStr];
        
        NSRange allRange = NSMakeRange(0, attrStr.length);
        [attrStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontPointSize]} range:allRange];
        [attrStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:fontPointSize]} range:NSMakeRange(0, 1)];
    }else{
        self.signImage.hidden = YES;
        
        attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"我 今日签到%@次",chatSignModel.today_sign_record_num]];
        
        NSRange allRange = NSMakeRange(0, attrStr.length);
        [attrStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontPointSize]} range:allRange];
        
        [attrStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:fontPointSize]} range:NSMakeRange(0, 1)];
        
        [attrStr addAttributes:@{NSForegroundColorAttributeName:TYColorHex(0x83c76e),NSFontAttributeName:[UIFont boldSystemFontOfSize:fontPointSize]} range:NSMakeRange(6, chatSignModel.today_sign_record_num.length)];
    }
    
    self.nameLabel.attributedText = attrStr;
    self.addressLabel.text = _chatSignModel.sign_addr;
    self.timeLabel.text = _chatSignModel.sign_time;
    
    BOOL is_sign = [chatSignModel.today_sign_record_num integerValue] > 0;
    
    chatSignModel.had_sign = is_sign;
    
    firstView.hidden = !is_sign;
    
    secondView.hidden = !is_sign;
    
    self.nameLabelConstraintT.constant = firstView.hidden?30:22;
    self.recordWorkImageConstraintT.constant = firstView.hidden?-5:10;
}

- (void)setIsHiddenLineView:(BOOL)isHiddenLineView{
    self.lineView.hidden = isHiddenLineView;
}
@end
