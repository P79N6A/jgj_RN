//
//  JGJWorkCircleProGroupCell.m
//  mix
//
//  Created by yj on 16/8/16.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJWorkCircleProGroupCell.h"
#import "TYAvatarGroupImageView.h"
#import "JSBadgeView.h"
#import "UIView+GNUtil.h"
#import "UILabel+GNUtil.h"
#import "NSString+Extend.h"
#import "NSDate+Extend.h"
#import "JGJHeadView.h"
#import "JGJAvatarView.h"
#define MaxGroupNameWidth 120.0
@interface JGJWorkCircleProGroupCell ()
@property (weak, nonatomic) IBOutlet JGJAvatarView *avatarGroupImageView;
@property (weak, nonatomic) IBOutlet UIView *contentBadageView;
@property (weak, nonatomic) IBOutlet UILabel *groupName;
@property (weak, nonatomic) IBOutlet UIImageView *groupFlagImageView;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UIView *containView;
@property (strong, nonatomic) JSBadgeView *badgeView ;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *examImageViewW;
@property (weak, nonatomic) IBOutlet UIImageView *disturbFlagImageView;
@property (weak, nonatomic) IBOutlet UIView *disturbMsgFlagView;
@property (weak, nonatomic) IBOutlet UIView *contentDisturbView;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@end

@implementation JGJWorkCircleProGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.groupName.font = [UIFont systemFontOfSize:AppFont34Size];
    self.message.font = [UIFont systemFontOfSize:AppFont28Size];
    self.groupName.textColor = AppFont333333Color;
    self.message.textColor = AppFont999999Color;
    self.badgeView.badgeStrokeWidth = 0.5;
    [self.disturbMsgFlagView.layer setLayerCornerRadius:TYGetViewH(self.disturbMsgFlagView) / 2.0];
    self.contentDisturbView.backgroundColor = [UIColor clearColor];
    self.disturbMsgFlagView.backgroundColor = TYColorHex(0xFF0000);
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"Cell";
    JGJWorkCircleProGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JGJWorkCircleProGroupCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setProListModel:(JGJMyWorkCircleProListModel *)proListModel {
    _proListModel = proListModel;
    
    [self.avatarGroupImageView getRectImgView:proListModel.members_head_pic];
    self.groupFlagImageView.hidden = ![proListModel.myself_group isEqualToString:@"1"];
    self.examImageViewW.constant = proListModel.workCircleProType == WorkCircleExampleProType ? 50 : 0;
    self.badgeView.badgeText = proListModel.unread_msg_count;
    self.badgeView.hidden = [proListModel.unread_msg_count isEqualToString:@"0"];
    self.groupName.text = TYIS_IPHONE_5 ? proListModel.group_name : proListModel.all_pro_name;
    CGFloat groupNameWidth = [self.groupName contentSizeFixWithWidth:TYGetUIScreenWidth].width;
    NSString *mergeName = @"";
    if (![NSString isEmpty:proListModel.at_message]) {
        mergeName = [NSString stringWithFormat:@"%@ %@", proListModel.at_message,proListModel.msg_text];
    }else {
        mergeName = proListModel.msg_text;
    }
    
    TYLog(@"mergeName ===== %@", mergeName);
    
    TYLog(@"proListModel.msg_text ===== %@", proListModel.msg_text);
    
    self.message.text = mergeName;
    if (![NSString isEmpty:proListModel.at_message]) {
        [self.message markText:proListModel.at_message withColor:AppFontd7252cColor];
    }
    
    if (groupNameWidth > MaxGroupNameWidth && TYIS_IPHONE_5_OR_LESS && self.groupName.text.length >=7) {
        self.groupName.text = [self.groupName.text substringToIndex:7];
        self.groupName.text = [self.groupName.text stringByAppendingFormat:@"%@(%@)", @"...", proListModel.members_num];
    } else {
        self.groupName.text = [self.groupName.text stringByAppendingFormat:@"(%@)", proListModel.members_num];
    }
    
    //置顶颜色改变
    if (_proListModel.is_sticked) {
        self.containView.backgroundColor = AppFontF5F6FCColor;
    }else {
        self.containView.backgroundColor = [UIColor whiteColor];
    }
    
    //设置未读数
    [self handleUnReadedMsgWithProListModel:proListModel];
    //设置时间
    if (proListModel.workCircleProType == WorkCircleExampleProType) {
        if (TYIS_IPHONE_5) {
            self.timeLable.text = @"8:05";
        }else {
            self.timeLable.text = @"08:05";
        }
    }else {
        [self showDateProListModel:proListModel];
    }
    
    self.groupFlagImageView.hidden = YES; //2.1.2去掉我是班组和项目标记
}

#pragma mark - 设置时间
- (void)showDateProListModel:(JGJMyWorkCircleProListModel *)proListModel {
    self.timeLable.text = [NSDate showDateWithTimeStamp:proListModel.send_time];
}

#pragma mark - 处理未读数
- (void)handleUnReadedMsgWithProListModel:(JGJMyWorkCircleProListModel *)proListModel {
    BOOL isUnReadedMsg = ![proListModel.unread_msg_count isEqualToString:@"0"];
    self.badgeView.hidden = NO;
    self.contentBadageView.hidden = NO;
    if (proListModel.is_no_disturbed && !isUnReadedMsg) {
        self.disturbFlagImageView.hidden = NO;
        self.contentBadageView.hidden = YES;
        self.disturbMsgFlagView.hidden = YES;
        self.badgeView.hidden = YES;
    }else if (proListModel.is_no_disturbed && isUnReadedMsg) {
        self.disturbFlagImageView.hidden = NO;
        self.disturbMsgFlagView.hidden = NO;
        self.contentBadageView.hidden = YES;
    }else if (!proListModel.is_no_disturbed && isUnReadedMsg) {
        self.disturbFlagImageView.hidden = YES;
        self.disturbMsgFlagView.hidden = YES;
        self.contentBadageView.hidden = NO;
    }else if (!proListModel.is_no_disturbed && !isUnReadedMsg) {
        self.disturbFlagImageView.hidden = YES;
        self.disturbMsgFlagView.hidden = YES;
        self.contentBadageView.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
//    self.containView.backgroundColor =  highlighted ? TYColorHex(0xe3e3ec) : TYColorHex(0xf5f6fc);
}

- (JSBadgeView *)badgeView {
    if (!_badgeView) {
        _badgeView = [[JSBadgeView alloc] initWithParentView:self.contentBadageView alignment:JSBadgeViewAlignmentTopRight];
        _badgeView.badgeBackgroundColor = TYColorHex(0xef272f);
        _badgeView.badgeTextFont = [UIFont systemFontOfSize:AppFont24Size];
        _badgeView.badgeStrokeColor = [UIColor redColor];
    }
    return _badgeView;
}

@end
