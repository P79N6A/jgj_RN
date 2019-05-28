//
//  JGJGroupChatDetailInfoAddMemberVc.h
//  mix
//
//  Created by yj on 16/12/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJContactedAddressBookBaseVc.h"

@interface JGJGroupChatDetailInfoAddMemberVc : JGJContactedAddressBookBaseVc

//创建群聊请求
- (void)handleCreatGroupChatRequest;

#pragma mark - 获取临时好友
- (void)loadGetTemporaryFriendList;
@end
