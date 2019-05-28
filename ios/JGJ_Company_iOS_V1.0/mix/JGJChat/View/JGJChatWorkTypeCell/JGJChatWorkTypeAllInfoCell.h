//
//  JGJChatWorkTypeAllInfoCell.h
//  mix
//
//  Created by yj on 17/2/16.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJChatListBaseCell.h"

typedef enum : NSUInteger {
    JGJChatWorkProDetailType, //进入项目详情
    JGJChatWorkPerInfoDetailType, //个人详情
    JGJChatMyIdcardType //立即认证类型

} JGJChatProSelelctedType;

@class JGJChatWorkTypeAllInfoCell;
@protocol JGJChatWorkTypeAllInfoCellDelegate <NSObject>
- (void)chatWorkTypeAllInfoCellWithCell:(JGJChatWorkTypeAllInfoCell *)cell didSelectedType:(JGJChatProSelelctedType)workTypeViewType;
@end

@interface JGJChatWorkTypeAllInfoCell : JGJChatListBaseCell
@property (nonatomic, strong) JGJChatMsgListModel *chatListModel;
@property (nonatomic, weak) id <JGJChatWorkTypeAllInfoCellDelegate> chatWorkTypeDelegate;


@end
