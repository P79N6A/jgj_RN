//
//  JGJReadInfoCell.h
//  mix
//
//  Created by Tony on 2016/9/2.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJChatMsgListModel.h"

@interface JGJReadInfoCell : UITableViewCell

@property (nonatomic, strong) ChatMsgList_Read_User_List *readedInfo;

@end
