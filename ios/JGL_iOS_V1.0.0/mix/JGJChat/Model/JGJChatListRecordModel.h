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

@property (nonatomic, copy) NSString *date_turn;//农历

@property (nonatomic, strong) NSArray<ChatListRecord_List *> *list;

//人员数量
@property (nonatomic, copy) NSString *mem_cnt;
@end

@interface ChatListRecord_List : NSObject

@property (nonatomic, copy) NSString *manhour;

@property (nonatomic, copy) NSString *working_hours;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *overtime;

@property (nonatomic, copy) NSString *overtime_hours;

@property (nonatomic, assign) BOOL is_rest;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, assign) BOOL is_agency;

@end

