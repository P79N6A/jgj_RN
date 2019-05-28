//
//  JGJAddFriendSendMsgVc.h
//  mix
//
//  Created by YJ on 17/2/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JGJAddFriendSendMsgSuccessBlock)(id);

@interface JGJAddFriendSendMsgVc : UIViewController

@property (nonatomic, strong) JGJChatPerInfoModel *perInfoModel;

@property (nonatomic, copy) JGJAddFriendSendMsgSuccessBlock sendMsgSuccessBlock;


@end
