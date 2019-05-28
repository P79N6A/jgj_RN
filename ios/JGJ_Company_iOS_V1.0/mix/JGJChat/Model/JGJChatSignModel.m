//
//  JGJChatSignModel.m
//  JGJCompany
//
//  Created by Tony on 16/9/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatSignModel.h"
#import "NSString+Extend.h"

@implementation JGJChatSignModel

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [ChatSign_List class],@"myuserinfo":[ChatSign_MyUserInfo class]};
}

@end


@implementation ChatSign_List

+ (NSDictionary *)objectClassInArray{
    return @{@"sign_list" : [ChatSign_Sign_List class]};
}

@end


@implementation ChatSign_Sign_List
- (NSString *)head_pic{
    if ([NSString isEmpty:_head_pic]) {
        _head_pic = @"";
    }
    
    return _head_pic;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"sign_id" : @"id"};
}

@end

@implementation ChatSign_MyUserInfo

- (NSString *)head_pic{
    if ([NSString isEmpty:_head_pic]) {
        _head_pic = @"";
    }
    
    return _head_pic;
}

@end



