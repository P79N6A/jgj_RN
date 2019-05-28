//
//  JGJChatListRecordModel.h
//  mix
//
//  Created by Tony on 2016/9/1.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYModel.h"

@class ChatListRecord_List;
@interface JGJChatListRecordModel : TYModel

@property (nonatomic, copy) NSString *date;

@property (nonatomic, strong) NSArray<ChatListRecord_List *> *list;

@end

@interface ChatListRecord_List : NSObject

@property (nonatomic, copy) NSString *manhour;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *overtime;

@end

