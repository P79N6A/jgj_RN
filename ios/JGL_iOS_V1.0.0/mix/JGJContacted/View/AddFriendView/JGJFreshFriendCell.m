//
//  JGJFreshFriendCell.m
//  mix
//
//  Created by yj on 17/2/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJFreshFriendCell.h"
#import "UIButton+JGJUIButton.h"
#import "NSString+Extend.h"
#import "JSBadgeView.h"
@interface JGJFreshFriendCell ()
@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UIView *contentFreshFriendView;
@property (weak, nonatomic) IBOutlet UIButton *freshFriendButton;
@property (weak, nonatomic) IBOutlet UIView *redFlagView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (strong, nonatomic) JSBadgeView *badgeView ;
@end

@implementation JGJFreshFriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.redFlagView.hidden = YES;
    [self.freshFriendButton.layer setLayerCornerRadius:JGJHeadCornerRadius];
    [self.redFlagView.layer setLayerCornerRadius:TYGetViewH(self.redFlagView) / 2.0];
    self.titleLable.textColor = AppFont333333Color;
    self.titleLable.font = [UIFont boldSystemFontOfSize:AppFont30Size];
    self.badgeView.badgeStrokeWidth = 0.5;
    self.freshFriendButton.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
    self.redFlagView.backgroundColor = AppFontd7252cColor;
}

- (void)setFreshFriendModel:(JGJSynBillingModel *)freshFriendModel {
    _freshFriendModel = freshFriendModel;
//    new-friend
    self.contentFreshFriendView.hidden = YES;
    self.badgeView.hidden = YES;
    BOOL isHidden = [NSString isEmpty:_freshFriendModel.head_pic];
    self.titleLable.text = _freshFriendModel.name;
    if ([freshFriendModel.head_pic isEqualToString:@"new_friend_icon"]) {
        [self.headButton setImage:[UIImage imageNamed:freshFriendModel.head_pic] forState:UIControlStateNormal];
    }else {
        [self.freshFriendButton setMemberPicButtonWithHeadPicStr:_freshFriendModel.head_pic memberName:_freshFriendModel.real_name memberPicBackColor:_freshFriendModel.modelBackGroundColor];
        self.freshFriendButton.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
        self.contentFreshFriendView.hidden = isHidden;
        self.badgeView.hidden = isHidden;
        self.titleLable.text = @"新朋友";
        
    }
    NSInteger members = [freshFriendModel.members_num intValue];
    self.redFlagView.hidden = members == 0;
    
//    self.badgeView.badgeText = freshFriendModel.members_num;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//- (JSBadgeView *)badgeView {
//    if (!_badgeView) {
//        _badgeView = [[JSBadgeView alloc] initWithParentView:self.redFlagView alignment:JSBadgeViewAlignmentTopRight];
//        _badgeView.badgeBackgroundColor = TYColorHex(0xef272f);
//        _badgeView.badgeTextFont = [UIFont systemFontOfSize:AppFont24Size];
//        _badgeView.badgeStrokeColor = [UIColor redColor];
//    }
//    return _badgeView;
//}
@end
