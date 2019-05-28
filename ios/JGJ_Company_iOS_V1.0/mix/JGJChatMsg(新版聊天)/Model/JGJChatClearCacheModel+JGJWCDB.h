//
//  JGJChatClearCacheModel+JGJWCDB.h
//  mix
//
//  Created by yj on 2018/8/27.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJChatGroupListModel.h"

#import <WCDB/WCDB.h>

@interface JGJChatClearCacheModel (JGJWCDB)<WCTTableCoding>

WCDB_PROPERTY(primary_key);

WCDB_PROPERTY(group_id);

WCDB_PROPERTY(class_type);

WCDB_PROPERTY(msg_id);

WCDB_PROPERTY(user_unique);

@end
