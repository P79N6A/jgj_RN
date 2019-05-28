//
//  JGJSplitProCell.m
//  JGJCompany
//
//  Created by yj on 16/9/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJSplitProCell.h"
#import "TYAvatarGroupImageView.h"
#import "JSBadgeView.h"
#import "NSString+Extend.h"

@interface JGJSplitProCell ()
@property (weak, nonatomic) IBOutlet TYAvatarGroupImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *teamName;
@property (weak, nonatomic) IBOutlet UILabel *desDetailLable;
@property (weak, nonatomic) IBOutlet UIView *contentBadageView;
@property (strong, nonatomic) JSBadgeView *badgeView ;

@end

@implementation JGJSplitProCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"Cell";
    JGJSplitProCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JGJSplitProCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setSplitProModel:(JGJMergeSplitProModel *)splitProModel {
    _splitProModel = splitProModel;
    self.teamName.text = _splitProModel.team_name;
    
    self.desDetailLable.text = [NSString stringWithFormat:@"管理员: %@ (共%@人)", _splitProModel.creater_name, _splitProModel.members_num];
    self.desDetailLable.hidden = [NSString isEmpty:_splitProModel.members_num];
    [self.avatarImageView getCircleImgView:_splitProModel.members_head_pic];
    self.contentBadageView.hidden = [_splitProModel.unread_msg_count isEqualToString:@"0"];
    self.badgeView.badgeText = _splitProModel.unread_msg_count;
}

- (JSBadgeView *)badgeView {
    if (!_badgeView) {
        _badgeView = [[JSBadgeView alloc] initWithParentView:self.contentBadageView alignment:JSBadgeViewAlignmentTopRight];
        _badgeView.badgeBackgroundColor = TYColorHex(0xef272f);
    }
    return _badgeView;
}
@end
