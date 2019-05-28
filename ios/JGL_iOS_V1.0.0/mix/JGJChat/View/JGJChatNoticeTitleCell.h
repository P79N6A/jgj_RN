//
//  JGJChatNoticeTitleCell.h
//  mix
//
//  Created by Tony on 2016/11/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJChatListType.h"

@interface JGJChatNoticeTitleCell : UITableViewCell

- (void)setChatListType:(JGJChatListType )chatListType proName:(NSString *)proNameStr;

- (void)setChatListType:(JGJChatListType )chatListType workProListModel:(JGJMyWorkCircleProListModel *)workProListModel;
@end
