//
//  JGJAddFriendSendMsgCell.h
//  mix
//
//  Created by YJ on 17/2/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGJAddFriendSendMsgCell;
@protocol JGJAddFriendSendMsgCellDelegate <NSObject>

- (void)textViewCell:(JGJAddFriendSendMsgCell *)cell didChangeText:(NSString *)inputText;

@end

@interface JGJAddFriendSendMsgCell : UITableViewCell
@property (nonatomic,weak) id <JGJAddFriendSendMsgCellDelegate>delegate;
@property (strong, nonatomic) NSString *inputMsg;
@end
