//
//  JGJSelectedConversationCell.h
//  mix
//
//  Created by Json on 2019/3/26.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGJChatGroupListModel;
@interface JGJSelectedConversationCell : UITableViewCell
@property (nonatomic, assign, getter=isEdited) BOOL edited;
@property (nonatomic, copy) NSString *searchKeyword;
@property (nonatomic, strong) JGJChatGroupListModel *conversation;
@end
