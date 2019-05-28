//
//  JGJWorkingListNormalTypeCell.m
//  mix
//
//  Created by Tony on 2018/8/24.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJWorkingListNormalTypeCell.h"
#import "JGJCusYyLable.h"
#import "JGJChatCheckView.h"
@interface JGJWorkingListNormalTypeCell ()

@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet JGJChatCheckView *lookDetailView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailViewHeight;
@property (weak, nonatomic) IBOutlet JGJCusYyLable *workingTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workingTitleHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workingContentHeight;

@end
@implementation JGJWorkingListNormalTypeCell

- (void)awakeFromNib {
    
    _workingTitle.textColor = AppFontF8853FColor;
    _workingTitle.font = FONT(AppFont32Size);
    
    [super awakeFromNib];
    
}

- (void)subClassSetWithModel:(JGJChatMsgListModel *)jgjChatListModel{

    _content.attributedText = jgjChatListModel.htmlStr;
    _content.numberOfLines = 0;
    _content.font = FONT(AppFont32Size);
    _workingTitle.text = jgjChatListModel.title;
    _content.userInteractionEnabled = NO;
    
    
    CGFloat height =  [_content.attributedText boundingRectWithSize:CGSizeMake(TYGetUIScreenWidth - 70 - 78, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height + 10;
    
    _workingContentHeight.constant = height;
    if (jgjChatListModel.chatListType == JGJChatListIntegralType) {// 积分推送
        
        _workingTitle.textColor = AppFont3db1f3Color;
        
    }else {
        
        _workingTitle.textColor = AppFontF8853FColor;
        
    }
    
    if (jgjChatListModel.chatListType == JGJChatListRemoveType || jgjChatListModel.chatListType == JGJChatListCloseType ||  jgjChatListModel.chatListType == JGJChatListDismissGroupType) {
        
        _detailViewHeight.constant = 0;
        _lookDetailView.hidden = YES;
        
    }else {
        
        _detailViewHeight.constant = 25;
        _lookDetailView.hidden = NO;
        
        if (jgjChatListModel.chatListType == JGJChatListOssType) {
            
            _lookDetailView.title = @"立即申请";
            
        }else if (jgjChatListModel.chatListType == JGJChatListIntegralType || jgjChatListModel.chatListType == JGJChatListEvaluateType || jgjChatListModel.chatListType == JGJChatListJoinType || jgjChatListModel.chatListType == JGJChatListSwitchgroupType || jgjChatListModel.chatListType == JGJChatListReopenType) {
            
            _lookDetailView.title = @"查看详情";
            
        }else if (jgjChatListModel.chatListType == JGJChatListFriendType) {
            
            _lookDetailView.title = @"加他为好友";
            
        }else {
            
            _workingTitle.hidden = YES;
            _workingTitleHeight.constant = 0;
            
            if (jgjChatListModel.chatListType == JGJChatListApproveType || jgjChatListModel.chatListType == JGJChatListMeeting) {
                
                
            }else {
                
                if ([jgjChatListModel.status isEqualToString:@"4"]) {
                    
                    _detailViewHeight.constant = 0;
                    _lookDetailView.hidden = YES;
                }
            }
            
            
        }
    }
    _workingTitle.hidden = NO;
    _workingTitleHeight.constant = 25;
    // 设置标题
    [self setWorkingTitleColorWithChatListType:jgjChatListModel.chatListType];

}

- (void)setWorkingTitleColorWithChatListType:(JGJChatListType)chatListType {
    
    if (chatListType == JGJChatListQuality) {
        
        _workingTitle.textColor = AppFontF59019Color;
        _workingTitle.text = @"质量";
    }else if (chatListType == JGJChatListSafe) {
        
        _workingTitle.textColor = AppFont5771FFColor;
        _workingTitle.text = @"安全";
    }else if (chatListType == JGJChatListNotice) {
        
        _workingTitle.textColor = AppFont21B9D0Color;
        _workingTitle.text = @"通知";
    }else if (chatListType == JGJChatListMeeting) {
        
        _workingTitle.textColor = AppFont21B9D0Color;
        _workingTitle.text = @"会议";
    }else if (chatListType == JGJChatListLog) {
        
        _workingTitle.textColor = AppFontF59019Color;
        _workingTitle.text = @"日志";
    }else if (chatListType == JGJChatListTaskType) {
        
        _workingTitle.textColor = AppFont21B9D0Color;
        _workingTitle.text = @"任务";
    }else if (chatListType == JGJChatListApproveType) {
        
        _workingTitle.textColor = AppFontF59019Color;
        _workingTitle.text = @"审批";
    }else if (chatListType == JGJChatListInspectType) {
        
        _workingTitle.textColor = AppFontF96061Color;
        _workingTitle.text = @"检查";
    }else if (chatListType == JGJChatListOssType) {
        
        _workingTitle.textColor = AppFont24B3C8Color;
    }else if (chatListType == JGJChatListFriendType) {
        
        _workingTitle.text = @"好友注册通知";
    }else if (chatListType == JGJChatListWorkGroupChatType) {
        
        _workingTitle.text = @"加入工种群的通知";
    }else if (chatListType == JGJChatListLocalGroupChatType) {
        
        _workingTitle.text = @"快速加群的通知";
    }
}
//去除标签的方法
- (NSString *)getNormalStringFilterHTMLString:(NSString *)htmlStr{
    
    NSString *normalStr = htmlStr.copy;
    //判断字符串是否有效
    if (!normalStr || normalStr.length == 0 || [normalStr isEqual:[NSNull null]]) return nil;
    
    //过滤正常标签
    NSRegularExpression *regularExpression=[NSRegularExpression regularExpressionWithPattern:@"<[^>]*>" options:NSRegularExpressionCaseInsensitive error:nil];
    normalStr = [regularExpression stringByReplacingMatchesInString:normalStr options:NSMatchingReportProgress range:NSMakeRange(0, normalStr.length) withTemplate:@""];
    
    return normalStr;
}

@end
