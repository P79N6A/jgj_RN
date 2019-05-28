//
//  JGJChatListRecordCell.h
//  mix
//
//  Created by Tony on 2016/8/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJChatListRecordModel.h"

@interface JGJChatListRecordCell : UITableViewCell
@property (nonatomic , strong) ChatListRecord_List *chatListRecordModel;

//工时和工切换
@property (nonatomic, assign) BOOL isShowWork;

//显示类型
@property (nonatomic, assign) NSInteger showType;

@end
