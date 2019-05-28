//
//  JGJChatGroupListModel.m
//  mix
//
//  Created by Tony on 2018/8/14.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJChatGroupListModel.h"
#import <WCDB/WCDB.h>
@interface JGJChatGroupListModel ()<WCTTableCoding>

@end
@implementation JGJChatGroupListModel

- (NSString *)user_id {
    
    _user_id = [TYUserDefaults objectForKey:JLGUserUid]?:@"";
    
    return _user_id;
}

- (BOOL)isAutoIncrement {
    
    return YES;
}

#pragma mark - 定义绑定到数据库表的类
WCDB_IMPLEMENTATION(JGJChatGroupListModel)

//#pragma mark - 定义需要绑定到数据库表的字段
WCDB_SYNTHESIZE(JGJChatGroupListModel, primary_key)
WCDB_SYNTHESIZE(JGJChatGroupListModel, user_id)
WCDB_SYNTHESIZE(JGJChatGroupListModel, group_id)
WCDB_SYNTHESIZE(JGJChatGroupListModel, pro_id)
WCDB_SYNTHESIZE(JGJChatGroupListModel, class_type)
WCDB_SYNTHESIZE(JGJChatGroupListModel, group_name)
WCDB_SYNTHESIZE(JGJChatGroupListModel, server_head_pic)
WCDB_SYNTHESIZE(JGJChatGroupListModel, local_head_pic)
WCDB_SYNTHESIZE(JGJChatGroupListModel, creater_uid)
WCDB_SYNTHESIZE(JGJChatGroupListModel, create_time)
WCDB_SYNTHESIZE(JGJChatGroupListModel, members_num)
WCDB_SYNTHESIZE(JGJChatGroupListModel, chat_unread_msg_count)
WCDB_SYNTHESIZE(JGJChatGroupListModel, last_send_uid)
WCDB_SYNTHESIZE(JGJChatGroupListModel, last_send_name)
WCDB_SYNTHESIZE(JGJChatGroupListModel, last_msg_type)
WCDB_SYNTHESIZE(JGJChatGroupListModel, last_msg_content)
WCDB_SYNTHESIZE(JGJChatGroupListModel, last_msg_send_time)
WCDB_SYNTHESIZE(JGJChatGroupListModel, sys_msg_type)
WCDB_SYNTHESIZE(JGJChatGroupListModel, agency_group_uid)
WCDB_SYNTHESIZE(JGJChatGroupListModel, is_no_disturbed)
WCDB_SYNTHESIZE(JGJChatGroupListModel, modified_time)
WCDB_SYNTHESIZE(JGJChatGroupListModel, max_readed_msg_id)
WCDB_SYNTHESIZE(JGJChatGroupListModel, max_asked_msg_id)
WCDB_SYNTHESIZE(JGJChatGroupListModel, at_message)
WCDB_SYNTHESIZE(JGJChatGroupListModel, is_top)
WCDB_SYNTHESIZE(JGJChatGroupListModel, all_pro_name)
WCDB_SYNTHESIZE(JGJChatGroupListModel, can_at_all)
WCDB_SYNTHESIZE(JGJChatGroupListModel, is_closed)
WCDB_SYNTHESIZE(JGJChatGroupListModel, is_sticked)
WCDB_SYNTHESIZE(JGJChatGroupListModel, is_delete)
WCDB_SYNTHESIZE(JGJChatGroupListModel, close_time)
WCDB_SYNTHESIZE(JGJChatGroupListModel, list_sort_time)
WCDB_SYNTHESIZE(JGJChatGroupListModel, unread_quality_count)
WCDB_SYNTHESIZE(JGJChatGroupListModel, unread_safe_count)
WCDB_SYNTHESIZE(JGJChatGroupListModel, unread_inspect_count)
WCDB_SYNTHESIZE(JGJChatGroupListModel, unread_task_count)
WCDB_SYNTHESIZE(JGJChatGroupListModel, unread_notice_count)
WCDB_SYNTHESIZE(JGJChatGroupListModel, unread_sign_count)
WCDB_SYNTHESIZE(JGJChatGroupListModel, unread_meeting_count)
WCDB_SYNTHESIZE(JGJChatGroupListModel, unread_approval_count)
WCDB_SYNTHESIZE(JGJChatGroupListModel, unread_log_count)
WCDB_SYNTHESIZE(JGJChatGroupListModel, unread_billRecord_count)
WCDB_SYNTHESIZE(JGJChatGroupListModel, unread_weath_count)

WCDB_SYNTHESIZE(JGJChatGroupListModel, msg_text)
WCDB_SYNTHESIZE(JGJChatGroupListModel, title)

WCDB_SYNTHESIZE(JGJChatGroupListModel, recruitMsgTitle)
WCDB_SYNTHESIZE(JGJChatGroupListModel, linkMsgTitle)
WCDB_SYNTHESIZE(JGJChatGroupListModel, linkMsgContent)

//3.4.2yj添加扩展字段

WCDB_SYNTHESIZE(JGJChatGroupListModel, extent_type)

//3.4.2当前是群聊使用(招工找活关键词防骗提示yj),是昨天或者是空的信息就显示。

WCDB_SYNTHESIZE(JGJChatGroupListModel, extent_msg)

//#pragma mark - 设置主键
WCDB_PRIMARY_AUTO_INCREMENT(JGJChatGroupListModel, primary_key)

//#pragma mark - 设置索引
WCDB_INDEX(JGJChatGroupListModel, "_index", group_id)
WCDB_INDEX(JGJChatGroupListModel, "_index", class_type)

- (CGFloat)checkProCellHeight {
    
    if (_checkProCellHeight > 0) {
        
        return _checkProCellHeight;
    }
    
    BOOL isUnReadedMsg = ![self.chat_unread_msg_count isEqualToString:@"0"] ;
    
    BOOL is_readed_msg = !isUnReadedMsg || [NSString isEmpty:self.chat_unread_msg_count];
    
    NSString *user_id = [TYUserDefaults objectForKey:JLGUserUid];
    
    BOOL isMySelfGroup = [self.creater_uid isEqualToString:user_id];
    
    CGFloat leftPadding = 57;
    
    CGFloat groupdesW = 100; //我创建的
    
    CGFloat unreadMsgW = 18; //未读标记
    
    CGFloat groupdestrail = 10; //我创建的尾部距离
    
    CGFloat maxW = TYGetUIScreenWidth - leftPadding - groupdestrail;
    
    if (isMySelfGroup && is_readed_msg) {
        
        maxW = TYGetUIScreenWidth - groupdesW - leftPadding - groupdestrail * 2;
        
    }else if (isMySelfGroup && !is_readed_msg) {
        
        maxW = TYGetUIScreenWidth - groupdesW - leftPadding - groupdestrail * 2;
        
    }else if (!isMySelfGroup && !is_readed_msg) {
        
        maxW = TYGetUIScreenWidth - leftPadding - groupdestrail * 2;
        
    }else if (!isMySelfGroup && is_readed_msg) {
        
        maxW = TYGetUIScreenWidth - leftPadding - unreadMsgW - groupdestrail * 2;
        
    }
    
    //    NSString *myGroupFlagStr = isMySelfGroup ?@"(我创建的)" : @"";
    
    //    NSString *proName = [NSString stringWithFormat:@"%@ %@", self.group_name, myGroupFlagStr];
    
    NSString *proName = self.group_name;
    
    if (!self.isCheckClosedPro) {
        
        _checkProCellHeight = [NSString stringWithContentWidth:maxW content:proName font:AppFont30Size lineSpace:1] + 31.5;
        
    }else {
        
        _checkProCellHeight = [NSString stringWithContentWidth:maxW content:proName font:AppFont30Size lineSpace:1] + 45;
        
        if (_checkProCellHeight < 20.0) {
            
            _checkProCellHeight = 85.0;
            
        }
        
        //没有关闭时间减去文字高度
        if ([NSString isEmpty:self.close_time]) {
            
            _checkProCellHeight -= 15;
            
        }else if (self.close_time.length < 5) {
            
            _checkProCellHeight -= 15;
        }
    }
    
    return _checkProCellHeight;
}

- (NSAttributedString *)last_msg_html_content {
    
    NSString * htmlString = self.last_msg_content ? :@"";
    
    if ([NSString isEmpty:self.last_msg_content]) {
        
        htmlString = @"";
    }
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    return attrStr;
}
@end


