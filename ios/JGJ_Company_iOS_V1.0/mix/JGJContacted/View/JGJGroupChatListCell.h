//
//  JGJGroupChatListCell.h
//  mix
//
//  Created by YJ on 16/12/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomView.h"
@interface JGJGroupChatListCell : UITableViewCell
@property (nonatomic, strong) JGJMyWorkCircleProListModel *groupListModel;
@property (weak, nonatomic) IBOutlet LineView *lineView;
//聊聊搜索的的值根据当前搜索改变颜色
@property (nonatomic, copy) NSString *searchValue;
+ (CGFloat)JGJGroupChatListCellHeight;
//当前类型从项目选择 不显示数量
@property (nonatomic, assign) JGJGroupChatListVcType groupChatListVcType;

//控制器类型 选择人员单聊 和选择人员群聊
@property (nonatomic, assign) JGJChatType chatType;
@end
