//
//  JGJGroupChatSelectedMemberCell.h
//  mix
//
//  Created by yj on 16/12/22.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomView.h"

typedef void(^ClickUnRegesterWithModel)(JGJSynBillingModel *model);

@interface JGJGroupChatSelectedMemberCell : UITableViewCell
@property (weak, nonatomic) IBOutlet LineView *lineView;
@property (nonatomic, strong) JGJSynBillingModel *groupChatMemberModel;
//控制器类型 选择人员单聊 和选择人员群聊
@property (nonatomic, assign) JGJChatType chatType;
+ (CGFloat)chatSelectedMemberCellHeight;
//聊聊搜索的的值根据当前搜索改变颜色
@property (nonatomic, copy) NSString *searchValue;
//添加人员、和创建群聊排除群人员
@property (nonatomic, assign)JGJContactedAddressBookVcType contactedAddressBookVcType;

//是否移动不是平台标识
@property (nonatomic, assign) BOOL isMoveActiveButton;

@property (nonatomic, copy) ClickUnRegesterWithModel clickUnRegesterWithModel;


@end
