//
//  JGJAddFriendSendMsgRemarkCell.h
//  mix
//
//  Created by YJ on 17/2/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomView.h"
@interface JGJAddFriendSendMsgRemarkCell : UITableViewCell
@property (nonatomic, strong) JGJAddFriendSendMsgModel *sendMsgModel;
@property (weak, nonatomic) IBOutlet LineView *lineView;

@end
