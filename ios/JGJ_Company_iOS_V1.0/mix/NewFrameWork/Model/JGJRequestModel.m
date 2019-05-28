//
//  JGJRequestModel.m
//  mix
//
//  Created by yj on 16/8/29.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJRequestModel.h"

@implementation JGJRequestModel

@end

@implementation JGJCreatTeamRequest
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"group_members" : @"JGJGroupMembersRequestModel"};
}
@end

@implementation JGJGroupMembersRequestModel

@end

@implementation JGJAddGroupMemberRequestModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"group_members" : @"JGJGroupMembersRequestModel"};
}
@end

@implementation JGJModifyTeamInfoRequestModel

@end

@implementation JGJRemoveGroupMemberRequestModel

@end

@implementation JGJCreatDiscussTeamRequest
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"team_members" : @"JGJGroupMembersRequestModel",
             @"source_members" : @"JGJGroupMembersRequestModel"
             };
}
@end

@implementation JGJTeamGroupInfoDetailRequest

@end

@implementation JGJMergeProRequestModel

@end

@implementation JGJCheckIsMemberRequest

@end

@implementation JGJSingleListRequest

@end

@implementation JGJLoginUserInfoRequest

@end

@implementation JGJLogoutReasonRequestModel

@end

