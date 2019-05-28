//
//  JGJContactedListCell.m
//  mix
//
//  Created by YJ on 16/12/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJContactedListCell.h"
#import "TYAvatarGroupImageView.h"
#import "UILabel+GNUtil.h"
#import "NSString+Extend.h"
#import "NSDate+Extend.h"
#import "JGJHeadView.h"
#import "UIButton+JGJUIButton.h"
#import "JGJAvatarView.h"

#import "UIButton+JGJUIButton.h"

#import "JGJCommonButton.h"
#import "RKNotificationHub.h"

#define MaxGroupNameWidth 120.0

static CGFloat avatarWH = 50;
static CGFloat badgeH = 18.0;

@interface JGJContactedListCell ()
{
    
    RKNotificationHub *_barHub;
}
@property (weak, nonatomic) IBOutlet JGJAvatarView *avatarGroupImageView;
@property (weak, nonatomic) IBOutlet UIView *contentBadageView;
@property (weak, nonatomic) IBOutlet UILabel *groupName;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (nonatomic, strong) UILabel *unReadMsgLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UIImageView *disturbFlagImageView;
@property (weak, nonatomic) IBOutlet UIView *disturbMsgFlagView;
@property (weak, nonatomic) IBOutlet UIView *contentDisturbView;

@property (weak, nonatomic) IBOutlet JGJCommonButton *goHomeButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goHomeButtonW;



@end
@implementation JGJContactedListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.groupName.font =  [UIFont systemFontOfSize:TYIS_IPHONE_6P ? 17 : 16];
    self.message.font =  [UIFont systemFontOfSize:TYIS_IPHONE_6P ? 14 : 14];
    self.groupName.textColor = [UIColor blackColor];
    self.message.textColor = AppFont999999Color;
    
    [self.disturbMsgFlagView.layer setLayerCornerRadius:TYGetViewH(self.disturbMsgFlagView) / 2.0];
    self.contentDisturbView.backgroundColor = [UIColor clearColor];
    
    self.disturbMsgFlagView.backgroundColor = TYColorHex(0XFF0000);
    
    [self.goHomeButton.layer setLayerBorderWithColor:AppFont999999Color width:1 radius:2.0];
    
    [self.goHomeButton setEnlargeEdgeWithTop:10 right:0 bottom:10 left:0];
    
    [self.goHomeButton setTitleColor:AppFont333333Color forState:UIControlStateNormal];
    
    [self.contentView addSubview:self.unReadMsgLabel];
    
//    [self.goHomeButton setBackgroundColor:AppFontE6E6E6Color forState:UIControlStateHighlighted];
}

// 配置cell高亮状态
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    [super setHighlighted:highlighted animated:animated];
    
//    self.containView.backgroundColor = highlighted ? AppFontE6E6E6Color : [UIColor whiteColor];
    
}



- (void)setProListModel:(JGJMyWorkCircleProListModel *)proListModel {
    
    _proListModel = proListModel;
}


- (void)setGroupModel:(JGJChatGroupListModel *)groupModel {
    
    _groupModel = groupModel;
    
    // 设置名字 消息之类的
    [self handleProNameWithGroupListModel:_groupModel];
    
    // 处理未读数
    [self handleUnReadedMsgWithGroupListModel:_groupModel];
    
    // 设置时间
    self.timeLable.text = [NSDate chatShowDateWithTimeStamp:_groupModel.last_msg_send_time];
    
    // 设置去首页按钮
    [self setGoHomeButtonWithGroupListModel:_groupModel];
    
}
#pragma mark - 处理项目名字头像显示

- (void)handleProNameWithGroupListModel:(JGJChatGroupListModel *)groupModel {
    
    // 聊聊名字
    self.groupName.text = groupModel.group_name;
    
    // 头像
    if ([groupModel.class_type isEqualToString:@"work"]) {
        
        [self.avatarGroupImageView getRectImgView:nil];
        [self.avatarGroupImageView setImage:IMAGE(@"working_inner_type")];
        
    }else if ([groupModel.class_type isEqualToString:@"activity"]) {
        
        [self.avatarGroupImageView getRectImgView:nil];
        [self.avatarGroupImageView setImage:IMAGE(@"messagetype_activity")];
        
    }else if ([groupModel.class_type isEqualToString:@"recruit"]) {
        
        [self.avatarGroupImageView getRectImgView:nil];
        [self.avatarGroupImageView setImage:IMAGE(@"messagetype_recruit")];
        
    }else if ([groupModel.class_type isEqualToString:@"newFriends"]) {
        
        [self.avatarGroupImageView getRectImgView:nil];
        [self.avatarGroupImageView setImage:IMAGE(@"contactListNewFriend")];
        
    }else {
        
        [self.avatarGroupImageView setImage:nil];
        [self.avatarGroupImageView getRectImgView:[groupModel.local_head_pic mj_JSONObject]];
//        TYLog(@"7777777===%@===>===>%@",groupModel.group_name,groupModel.local_head_pic);
    }
    
    
    // 消息
    if ([groupModel.class_type isEqualToString:@"work"]) {
        
        if ([NSString isEmpty:groupModel.title] && ![NSString isEmpty:groupModel.last_msg_html_content.string]) {
            
            self.message.text = [groupModel.last_msg_html_content string];
            
        }else {
            
            self.message.text = groupModel.title;
        }
        self.message.textColor = AppFont999999Color;
        
    }else {
        
        self.message.text = [self dealMessageContentWithGroupLisyModel:groupModel];
        self.message.textColor = AppFont999999Color;
    }
    [self.message markText:groupModel.at_message withColor:AppFontEB4E4EColor];
    
    // 未读数
    NSUInteger unread_msg_count = [groupModel.chat_unread_msg_count integerValue];
    if (unread_msg_count > 99) {
        
        groupModel.chat_unread_msg_count = @"99+";
    }
    
    self.unReadMsgLabel.text = groupModel.chat_unread_msg_count;
    
    CGFloat badgeY = ([[self class] JGJContactedListCellHeight] - avatarWH) * 0.5 - (badgeH / 3.0);
    
    if (unread_msg_count > 9) {
        
        self.unReadMsgLabel.frame = CGRectMake(41 + 5, badgeY, 28, badgeH);
    }else {
        
        self.unReadMsgLabel.frame = CGRectMake(41 + 10, badgeY, badgeH, badgeH);
    }
    
    //成员数
    NSString *memberNumstr = [NSString stringWithFormat:@"(%@)",groupModel.members_num];
    if ([groupModel.class_type isEqualToString:@"singleChat"] || [groupModel.class_type isEqualToString:@"work"] || [groupModel.class_type isEqualToString:@"activity"] || [groupModel.class_type isEqualToString:@"recruit"] || [groupModel.class_type isEqualToString:@"newFriends"]) {
        
        memberNumstr = @"";
    }
    
    NSString *dateString = [NSDate dateTimesTampToString:groupModel.last_msg_send_time format:@"yyyy-MM-dd"];
    
    NSDate *date = [NSDate dateFromString:dateString withDateFormat:@"yyyy-MM-dd"];
    
    NSInteger maxLenth = 6;
    
    NSInteger maxIphone6Lenth = 8;
    
    NSInteger maxIphonePlusLenth = 11;
    
    NSInteger index = maxLenth;
    
    if (TYIS_IPHONE_5_OR_LESS && self.groupName.text.length > maxLenth) {
        
        index = maxLenth;
        
        if (!date.isThisYear) {
            
            index = maxLenth;
        }
        
        self.groupName.text = [self.groupName.text substringToIndex:index];
        
        self.groupName.text = [self.groupName.text stringByAppendingFormat:@"%@%@", @"...", memberNumstr];
        
    } else {
        
        if ((TYIS_IPHONE_6 || TYIST_IPHONE_X) && self.groupName.text.length > maxIphone6Lenth) {
            
            index = maxIphone6Lenth;
            
            if (!date.isThisYear) {
                
                index = maxIphone6Lenth;
            }
            
            self.groupName.text = [self.groupName.text substringToIndex:index];
            
            self.groupName.text = [self.groupName.text stringByAppendingFormat:@"%@%@", @"...", memberNumstr];
            
        }else {
            
            if (TYIS_IPHONE_6P && self.groupName.text.length >= maxIphonePlusLenth) {
                
                index = maxIphonePlusLenth;
                
                if (!date.isThisYear) {
                    
                    index = maxIphonePlusLenth;
                }
                
                self.groupName.text = [self.groupName.text substringToIndex:index];
                
                self.groupName.text = [self.groupName.text stringByAppendingFormat:@"%@%@", @"...", memberNumstr];
                
            }else {
                
                self.groupName.text = [self.groupName.text stringByAppendingFormat:@"%@", memberNumstr];
            }
            
        }
        
    }
    
    [self.groupName markText:self.searchValue withColor:AppFontEB4E4EColor];
    //置顶颜色改变
    if (groupModel.is_top) {
        self.containView.backgroundColor = AppFontF5F6FCColor;
    }else {
        self.containView.backgroundColor = [UIColor whiteColor];
    }
}

#pragma mark - 处理未读数
- (void)handleUnReadedMsgWithGroupListModel:(JGJChatGroupListModel *)groupListModel {
    // 有未读数为 -> YES  没有未读数为 -> NO
    BOOL isUnReadedMsg = ![groupListModel.chat_unread_msg_count ? : @"0" isEqualToString:@"0"];
    self.contentBadageView.hidden = NO;
    if (groupListModel.is_no_disturbed && !isUnReadedMsg) {
        
        self.disturbFlagImageView.hidden = NO;
        self.contentBadageView.hidden = YES;
        self.disturbMsgFlagView.hidden = YES;
        self.unReadMsgLabel.hidden = YES;
        
    }else if (groupListModel.is_no_disturbed && isUnReadedMsg) {
        
        self.disturbFlagImageView.hidden = NO;
        self.disturbMsgFlagView.hidden = NO;
        self.unReadMsgLabel.hidden = YES;
        
    }else if (!groupListModel.is_no_disturbed && isUnReadedMsg) {
        
        self.disturbFlagImageView.hidden = YES;
        self.disturbMsgFlagView.hidden = YES;
        self.unReadMsgLabel.hidden = NO;
        
    }else if (!groupListModel.is_no_disturbed && !isUnReadedMsg) {
        
        self.disturbFlagImageView.hidden = YES;
        self.disturbMsgFlagView.hidden = YES;
        self.unReadMsgLabel.hidden = YES;
        
    }
}


- (UILabel *)unReadMsgLabel {
    
    if (!_unReadMsgLabel) {
        
        CGFloat badgeY = ([[self class] JGJContactedListCellHeight] - avatarWH) * 0.5 - (badgeH / 3.0);

        _unReadMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(41 + 10, badgeY, badgeH, badgeH)];
        _unReadMsgLabel.backgroundColor = AppFontEB4E4EColor;
        _unReadMsgLabel.font = [UIFont systemFontOfSize:AppFont24Size];
        _unReadMsgLabel.textColor = [UIColor whiteColor];
        _unReadMsgLabel.textAlignment = NSTextAlignmentCenter;
        _unReadMsgLabel.clipsToBounds = YES;
        _unReadMsgLabel.layer.cornerRadius = 9;
        _unReadMsgLabel.hidden = YES;
    }
    return _unReadMsgLabel;
}

- (IBAction)goHomeButtonPressed:(UIButton *)sender {
    
    if (self.contactedListCellBlock) {
        
        self.contactedListCellBlock(self.groupModel);
    }
    
}

- (void)setGoHomeButtonWithGroupListModel:(JGJChatGroupListModel *)groupListModel {
    
    self.goHomeButton.hidden = YES;
    
    self.goHomeButtonW.constant = CGFLOAT_MIN;
    
    if ([groupListModel.class_type isEqualToString:@"group"] || [groupListModel.class_type isEqualToString:@"team"]) {
        
        self.goHomeButton.hidden = NO;
        
        self.goHomeButtonW.constant = 73;
        
        NSString *buttonTitle = [groupListModel.class_type isEqualToString:@"group"] ? @"去该班组首页" : @"去该项目首页";
        
        [self.goHomeButton setTitle:buttonTitle forState:UIControlStateNormal];
        
    }
}

+ (CGFloat)JGJContactedListCellHeight {
    
    return TYIS_IPHONE_6P ? 78 : 68;
}


- (NSString *)dealMessageContentWithGroupLisyModel:(JGJChatGroupListModel *)model {
    
    if ([model.class_type isEqualToString:@"activity"]) {
        
        if (![NSString isEmpty:model.title]) {
            
            return model.title;
        }else {
            
            return model.last_msg_content;
        }
        
        if (![model.last_msg_type isEqualToString:@"present_integral"] && ![model.last_msg_type isEqualToString:@"activity"]) {
            
            return @"当前版本暂不支持查看此消息，请升级为最新版本查看";
        }
    }else if ([model.class_type isEqualToString:@"recruit"]) {
        
        if (![NSString isEmpty:model.title]) {
            
            return model.title;
            
        }else {
            
            return model.last_msg_content;
        }
        
        if (![model.last_msg_type isEqualToString:@"authpass"] && ![model.last_msg_type isEqualToString:@"authfail"] && ![model.last_msg_type isEqualToString:@"authexpired"] && ![model.last_msg_type isEqualToString:@"authdue"] && ![model.last_msg_type isEqualToString:@"workremind"] && ![model.last_msg_type isEqualToString:@"feedback"]) {
            
            return @"当前版本暂不支持查看此消息，请升级为最新版本查看";
        }
        
        
    }else if ([model.class_type isEqualToString:@"newFriends"]) {// 新的好友
        
        return model.last_msg_content;
        
    }
    else {// 普通消息
        
        if ([model.last_msg_type isEqualToString:@"text"]) {// 文本消息
            
            // 当前消息是自己发的
            if ([model.last_send_uid isEqualToString:[TYUserDefaults objectForKey:JLGUserUid]]) {
                
                return [NSString stringWithFormat:@"我:%@",model.last_msg_content];
                
            }else {
                
                // 判断是否被@
                if (model.at_message.length > 0 && ![model.at_message isEqualToString:@"0"]) {
                    
                    return [NSString stringWithFormat:@"%@%@:%@",model.at_message,model.last_send_name,model.last_msg_content];
                    
                }else {
                    
                    return [NSString stringWithFormat:@"%@:%@",model.last_send_name,model.last_msg_content];
                }
                
                
            }
            
        }else if ([model.last_msg_type isEqualToString:@"voice"]) {
            
            // 当前消息是自己发的
            if ([model.last_send_uid isEqualToString:[TYUserDefaults objectForKey:JLGUserUid]]) {
                
                return @"我:[语音]";
                
            }else {
                
                return [NSString stringWithFormat:@"%@:[语音]",model.last_send_name];
            }
        }else if ([model.last_msg_type isEqualToString:@"pic"]) {
            
            // 当前消息是自己发的
            if ([model.last_send_uid isEqualToString:[TYUserDefaults objectForKey:JLGUserUid]]) {
                
                return @"我:[图片]";
                
            }else {
                
                return [NSString stringWithFormat:@"%@:[图片]",model.last_send_name];
            }
        }else if ([model.last_msg_type isEqualToString:@"recall"]) {
            
            // 当前消息是自己发的
            if ([model.last_send_uid isEqualToString:[TYUserDefaults objectForKey:JLGUserUid]]) {
                
                return @"我:[撤回一条消息]";
                
            }else {
                
                return [NSString stringWithFormat:@"%@: [撤回一条消息]",model.last_send_name];
            }
        }else if ([model.last_msg_type isEqualToString:@"addGroupFriend"]) {
            
            return [NSString stringWithFormat:@"%@%@",model.last_send_name,model.last_msg_content];
            
        }else if ([model.last_msg_type isEqualToString:@"signIn"]) {
            
            if ([model.last_send_uid isEqualToString:[TYUserDefaults objectForKey:JLGUserUid]]) {
                
                return @"你已签到";
            }else {
                
                return [NSString stringWithFormat:@"%@已签到",model.last_send_name];
            }
        }else if ([model.last_msg_type isEqualToString:@"notice"]) {
            
            if ([model.last_send_uid isEqualToString:[TYUserDefaults objectForKey:JLGUserUid]]) {
                
                return @"我: 发了一条工作通知";
            }else {
                
                if (model.at_message.length > 0 && ![model.at_message isEqualToString:@"0"]) {
                    
                    return [NSString stringWithFormat:@"%@%@: 发了一条工作通知",model.at_message,model.last_send_name];
                    
                }else {
                    
                    return [NSString stringWithFormat:@"%@：发了一条工作通知",model.last_send_name];
                }
                
            }
        }else if ([model.last_msg_type isEqualToString:@"quality"]) {
            
            if ([model.last_send_uid isEqualToString:[TYUserDefaults objectForKey:JLGUserUid]]) {
                
                return @"我: 发布了一条质量";
            }else {
                
                if (model.at_message.length > 0 && ![model.at_message isEqualToString:@"0"]) {
                    
                    return [NSString stringWithFormat:@"%@%@：发布了一条质量",model.at_message,model.last_send_name];
                    
                }else {
                    
                    return [NSString stringWithFormat:@"%@：发布了一条质量",model.last_send_name];
                }
                
            }
        }else if ([model.last_msg_type isEqualToString:@"safe"]) {
            
            if ([model.last_send_uid isEqualToString:[TYUserDefaults objectForKey:JLGUserUid]]) {
                
                return @"我: 发布了一条安全";
            }else {
                
                if (model.at_message.length > 0 && ![model.at_message isEqualToString:@"0"]) {
                    
                    return [NSString stringWithFormat:@"%@%@：发布了一条安全",model.at_message,model.last_send_name];
                    
                }else {
                    
                    return [NSString stringWithFormat:@"%@：发布了一条安全",model.last_send_name];
                }
                
            }
        }else if ([model.last_msg_type isEqualToString:@"log"]) {
            
            if ([model.last_send_uid isEqualToString:[TYUserDefaults objectForKey:JLGUserUid]]) {
                
                return @"我: 提交了一条日志";
                
            }else {
                
                return [NSString stringWithFormat:@"%@: 提交了一条日志",model.last_send_name];
            }
        }else if ([model.last_msg_type isEqualToString:@"setadmin"]) {
            
            return [NSString stringWithFormat:@"%@",model.msg_text];
            
        }else if ([model.last_msg_type isEqualToString:@"agreeFriends"] || [model.last_msg_type isEqualToString:@"agreeFriendsNotice"]) {
            
            return [NSString stringWithFormat:@"%@",model.msg_text];
            
        }else if ([model.last_msg_type isEqualToString:@"approval"]) {
            
            return [NSString stringWithFormat:@"%@",model.msg_text];
            
        }else if ([model.last_msg_type isEqualToString:@"join"]) {
            
            if ([model.class_type isEqualToString:@"group"]) {
                
                return [NSString stringWithFormat:@"你被邀请加入该班组"];
                
            }else if ([model.class_type isEqualToString:@"team"]) {
                
                return [NSString stringWithFormat:@"你被邀请加入该项目组"];
            }
            
        }else if ([model.last_msg_type isEqualToString:@"memberjoin"] || [model.last_msg_type isEqualToString:@"delmember"] || [model.last_msg_type isEqualToString:@"upgradegroupchat"] || [model.last_msg_type isEqualToString:@"switchgroup"] || [model.last_msg_type isEqualToString:@"modifyname"]) {
            
            return model.msg_text;
            
        }else if ([model.last_msg_type isEqualToString:@"postcard"]) {

            if ([model.last_send_uid isEqualToString:[TYUserDefaults objectForKey:JLGUserUid]]) {
                
                return [NSString stringWithFormat:@"我: [找活名片]%@",model.last_send_name];
                
            }else {
                
                return [NSString stringWithFormat:@"%@: [找活名片]%@",model.last_send_name,model.last_send_name];
            }
            
            
        }else if ([model.last_msg_type isEqualToString:@"recruitment"]) {
            
            if ([model.last_send_uid isEqualToString:[TYUserDefaults objectForKey:JLGUserUid]]) {
                
                return [NSString stringWithFormat:@"我: [招工信息]%@",model.recruitMsgTitle];
                
            }else {
                
                return [NSString stringWithFormat:@"%@: [招工信息]%@",model.last_send_name,model.recruitMsgTitle];
            }
            
            
        }else if ([model.last_msg_type isEqualToString:@"link"]) {
            
            if (![NSString isEmpty:model.linkMsgTitle]) {
                
                if ([model.last_send_uid isEqualToString:[TYUserDefaults objectForKey:JLGUserUid]]) {
                    
                    return [NSString stringWithFormat:@"我: [链接]%@",model.linkMsgTitle];
                    
                }else {
                    
                    return [NSString stringWithFormat:@"%@: [链接]%@",model.last_send_name,model.linkMsgTitle];
                }
                
            }else {
                
                if (![NSString isEmpty:model.linkMsgContent]) {
                    
                    if ([model.last_send_uid isEqualToString:[TYUserDefaults objectForKey:JLGUserUid]]) {
                        
                        return [NSString stringWithFormat:@"我: [链接]%@",model.linkMsgContent];
                        
                    }else {
                        
                        return [NSString stringWithFormat:@"%@: [链接]%@",model.last_send_name,model.linkMsgContent];
                    }
                    
                }else {
                    
                    if ([model.last_send_uid isEqualToString:[TYUserDefaults objectForKey:JLGUserUid]]) {
                        
                        return [NSString stringWithFormat:@"我: [链接]"];
                        
                    }else {
                        
                        return [NSString stringWithFormat:@"%@: [链接]",model.last_send_name];
                    }
                    
                }
            }
        }
        
    }
    return nil;
}
@end
