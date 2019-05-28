//
//  JGJMergeProCell.m
//  JGJCompany
//
//  Created by yj on 16/9/24.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJMergeProCell.h"
#import "TYAvatarGroupImageView.h"
#import "JSBadgeView.h"
#import "NSString+Extend.h"
@interface JGJMergeProCell ()
@property (weak, nonatomic) IBOutlet UIButton *multipleButton;
@property (weak, nonatomic) IBOutlet TYAvatarGroupImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *teamName;
@property (weak, nonatomic) IBOutlet UILabel *memberLable;
@property (weak, nonatomic) IBOutlet UILabel *sourceMemberLable;
@property (weak, nonatomic) IBOutlet UIView *contentBadageView;
@property (strong, nonatomic) JSBadgeView *badgeView ;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@end

@implementation JGJMergeProCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

+ (CGFloat)mergeProCellHeight {
    return 90;
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"Cell";
    JGJMergeProCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JGJMergeProCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setMergeProModel:(JGJMergeSplitProModel *)mergeProModel {
    _mergeProModel = mergeProModel;
    //最大数是13
    if (_mergeProModel.team_name.length > 13) {
        self.teamName.text = [_mergeProModel.team_name substringWithRange:NSMakeRange(0, 13)];
    }else{
        self.teamName.text = _mergeProModel.team_name;
    }

    self.memberLable.text = [NSString stringWithFormat:@"成员:(共%@人)", _mergeProModel.members_num];
    self.sourceMemberLable.text = [NSString stringWithFormat:@"数据来源:%@", _mergeProModel.source_members_num];
    [self.avatarImageView getCircleImgView:_mergeProModel.members_head_pic];
    NSString *buttonImageStr = _mergeProModel.isSelected  ? @"MultiSelected" : @"EllipseIcon";
    [self.multipleButton setImage:[UIImage imageNamed:buttonImageStr] forState:UIControlStateNormal];
    self.contentBadageView.hidden = [_mergeProModel.unread_msg_count isEqualToString:@"0"];
    self.badgeView.badgeText = _mergeProModel.unread_msg_count;
    self.lineView.hidden = [NSString isEmpty:_mergeProModel.source_members_num];
    self.sourceMemberLable.hidden = [NSString isEmpty:_mergeProModel.source_members_num];
    self.memberLable.hidden = [NSString isEmpty:_mergeProModel.members_num];
}

- (JSBadgeView *)badgeView {
    if (!_badgeView) {
        _badgeView = [[JSBadgeView alloc] initWithParentView:self.contentBadageView alignment:JSBadgeViewAlignmentTopRight];
        _badgeView.badgeBackgroundColor = TYColorHex(0xef272f);
    }
    return _badgeView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    NSString *buttonImageStr = self.mergeProModel.isSelected ? @"MultiSelected" : @"EllipseIcon";
//    [self.multipleButton setImage:[UIImage imageNamed:buttonImageStr] forState:UIControlStateNormal];
//    self.mergeProModel.isSelected = !self.mergeProModel.isSelected;
}

@end
