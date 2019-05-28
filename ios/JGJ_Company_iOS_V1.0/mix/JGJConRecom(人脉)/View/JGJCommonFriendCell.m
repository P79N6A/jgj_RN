//
//  JGJCommonFriendCell.m
//  mix
//
//  Created by Json on 2019/4/16.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJCommonFriendCell.h"
#import "UIButton+JGJUIButton.h"

@interface JGJCommonFriendCell ()
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sourceLabelTopMargin;

@end

@implementation JGJCommonFriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.avatarButton.layer.cornerRadius = JGJCornerRadius;
    self.avatarButton.clipsToBounds = YES;
    self.avatarButton.userInteractionEnabled = NO;
    
    self.nameLabel.font = [UIFont systemFontOfSize:AppFont30Size];
    self.nameLabel.textColor = AppFont333333Color;
    
    self.sourceLabel.font = [UIFont systemFontOfSize:AppFont24Size];
    self.sourceLabel.textColor = AppFont666666Color;
    
    self.lineView.backgroundColor = AppFontdbdbdbColor;
    
}

- (void)setComFriend:(JGJSynBillingModel *)comFriend
{
    _comFriend = comFriend;
    
    [self.avatarButton setMemberPicButtonWithHeadPicStr:comFriend.head_pic?:@"" memberName:comFriend.name?:@"" memberPicBackColor:comFriend.modelBackGroundColor membertelephone:comFriend.telephone?:@""];
    self.avatarButton.titleLabel.font = [UIFont systemFontOfSize:AppFont26Size];
    self.nameLabel.text = comFriend.name;
    if ([NSString isEmpty:comFriend.addFrom]) {
        self.sourceLabel.text = nil;
        self.sourceLabelTopMargin.constant = 0;
    } else {
        self.sourceLabel.text = [NSString stringWithFormat:@"来源: %@",comFriend.addFrom];
        self.sourceLabelTopMargin.constant = 5.0;
    }

}



@end
