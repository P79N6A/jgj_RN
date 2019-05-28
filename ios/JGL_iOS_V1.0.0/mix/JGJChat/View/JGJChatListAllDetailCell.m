//
//  JGJChatListAllDetailCell.m
//  mix
//
//  Created by Tony on 2016/11/29.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatListAllDetailCell.h"
#import "NSDate+Extend.h"

#define kChatListAllDetailCellH 1.0

@interface JGJChatListAllDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;

@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelConstraintT;
@end

@implementation JGJChatListAllDetailCell
- (void)subClassInit{
    [super subClassInit];
    
    self.contentLabel.numberOfLines = 0;
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)subClassSetWithModel:(JGJChatMsgListModel *)jgjChatListModel{
    [super subClassSetWithModel:jgjChatListModel];

    self.nameLabel.text = jgjChatListModel.user_name;
    
    if ([NSString isEmpty:jgjChatListModel.msg_text]) {
        self.contentLabelConstraintT.constant = 0;
    }else{
        self.contentLabelConstraintH.constant = [self getTitleSizeHeigt:jgjChatListModel.msg_text];
    }

    NSString *noticeStr = @"";
    switch (self.jgjChatListModel.chatListType) {
        case JGJChatListNotice:
            noticeStr = @"通知";
            break;
        case JGJChatListSafe:
            noticeStr = @"安全";
            break;
        case JGJChatListLog:
            noticeStr = @"施工日志";
            break;
        case JGJChatListQuality:
            noticeStr = @"质量";
            break;
        default:
            break;
    }
    self.noticeLabel.text = noticeStr;
    
    self.bottomLabel.text = [NSString stringWithFormat:@"来自:%@",self.jgjChatListModel.from_group_name?:self.jgjChatListModel.group_name];
    
    self.dateLabel.text = [self getDisplayDate];
}

- (NSString *)getDisplayDate{
    NSString *date = self.jgjChatListModel.date;
    NSDate *converntDate = [NSDate dateFromString:date withDateFormat:chatMsgTimeFormat];
    
    NSString *displayDate = @"";
    
    NSString *detailDate = [NSDate stringFromDate:converntDate format:@"yyyy年MM月dd日 HH:mm"];
    if ([converntDate isToday]) {
        displayDate = [NSString stringWithFormat:@"今日 %@",[detailDate substringWithRange:NSMakeRange(5, 12)]];
    }else if([converntDate isThisYear]){
        displayDate = [detailDate substringWithRange:NSMakeRange(5, 12)];
    }else{
        displayDate = detailDate;
    }
    return displayDate;
    
}

- (CGFloat )getTitleSizeHeigt:(NSString *)msg_text{
    NSDictionary *attrs = @{NSFontAttributeName : self.contentLabel.font};
    CGSize maxSize = CGSizeMake(TYGetUIScreenWidth - 24.0, MAXFLOAT);
    CGSize titleSize = [msg_text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
    return titleSize.height + kChatListAllDetailCellH;
}
@end
