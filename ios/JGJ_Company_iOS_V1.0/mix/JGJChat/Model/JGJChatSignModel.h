//
//  JGJChatSignModel.h
//  JGJCompany
//
//  Created by Tony on 16/9/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYModel.h"

typedef NS_ENUM(NSUInteger, JGJChatSignVcType) {
    
    JGJChatSignVcUseType = 1, //默认使用签到
    
    JGJChatSignVcCheckType  //查看类型
};

@class ChatSign_List,ChatSign_Sign_List,ChatSign_MyUserInfo;
@interface JGJChatSignModel : TYModel

@property (nonatomic, copy) NSString *sign_addr;

@property (nonatomic, copy) NSString *sign_time;

@property (nonatomic, copy) NSString *today_sign_record_num;

@property (nonatomic, copy) NSString *today_sign_member_num;

@property (nonatomic, assign) NSInteger is_creater;

@property (nonatomic, copy) NSString *s_date;

@property (nonatomic, strong) NSMutableArray<ChatSign_List *> *list;

//我自己的签到情况
@property (nonatomic, strong) ChatSign_MyUserInfo *user_info;

@property (nonatomic, assign) BOOL had_sign;

@end

@interface ChatSign_List : NSObject

@property (nonatomic, strong) NSMutableArray<ChatSign_Sign_List *> *sign_list;

@property (nonatomic, copy) NSString *sign_date_str;

@property (nonatomic, copy) NSString *sign_date;

@property (nonatomic, copy) NSString *sign_date_num;

@property (nonatomic, copy) NSString *is_today;


@end

@interface ChatSign_Sign_List : NSObject

@property (nonatomic, copy) NSString *sign_addr;

@property (nonatomic, copy) NSString *sign_time;

@property (nonatomic, copy) NSString *sign_id;

@property (nonatomic, copy) NSString *real_name;

@property (nonatomic, copy) NSString *group_user_name;

@property (nonatomic, copy) NSString *head_pic;

@property (nonatomic, copy) NSString *mber_id;

@property (nonatomic, strong) ChatSign_MyUserInfo *sign_user_info;

@end


@interface ChatSign_MyUserInfo : NSObject

@property (nonatomic, copy) NSString *telphone;

@property (nonatomic, copy) NSString *real_name;

@property (nonatomic, copy) NSString *head_pic;

@property (nonatomic, copy) NSString *uid;
@end
