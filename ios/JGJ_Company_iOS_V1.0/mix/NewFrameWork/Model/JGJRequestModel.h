//
//  JGJRequestModel.h
//  mix
//
//  Created by yj on 16/8/29.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJRequestModel : NSObject
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *client_type;
@property (nonatomic, copy) NSString *ctrl;
@end

#pragma mark - 创建班组请求模型
@interface JGJCreatTeamRequest : JGJRequestModel
@property (nonatomic, copy) NSString *group_name;
@property (nonatomic, copy) NSString *city_code;
@property (nonatomic, copy) NSString *pro_id;
@property (nonatomic, strong) NSArray *group_members;
@end

@interface JGJGroupMembersRequestModel : NSObject
@property (nonatomic, copy) NSString *real_name;
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, copy) NSString *is_demand;

@property (nonatomic, copy) NSString *uid;

//关联的项目
@property (nonatomic, copy) NSString *source_pro_id;
@end

#pragma mark - 班组成员加入
@interface JGJAddGroupMemberRequestModel : JGJRequestModel
@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, strong) NSArray *group_members; //存储JGJGroupMembersRequestModel
@property (nonatomic, copy) NSString *is_qr_code;
@property (nonatomic, copy) NSString *inviter_uid;
@property (nonatomic, copy) NSString *qr_code_create_time;
@property (nonatomic, strong) NSArray *team_members; //存储项目组项目成员
@property (nonatomic, strong) NSArray *source_members; //存储数据来源人
@property (nonatomic, copy) NSString *team_id;
//1.0.2添加
@property (nonatomic, copy) NSString *source_pro_id;
//2.1.0
@property (nonatomic, copy) NSString *class_type; //groupChat群聊，不传默认是group
@end

#pragma mark - 修改班组信息
@interface JGJModifyTeamInfoRequestModel : JGJRequestModel
@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, copy) NSString *group_name;
@property (nonatomic, copy) NSString *city_code;
@property (nonatomic, copy) NSString *city_name; //城市名字，项目使用2.2.3
@property (nonatomic, copy) NSString *team_name;
@property (nonatomic, copy) NSString *team_id;
@property (nonatomic, copy) NSString *pro_id; //项目组需要传项目id
@property (nonatomic, copy) NSString *team_comment; //项目组需要传项目id
@property (nonatomic, copy) NSString *nickname; //昵称
//1.1.0添加
@property (nonatomic, copy) NSString *is_not_disturbed; //设置消息是否免打扰
@property (nonatomic, copy) NSString *class_type; //班组：group；项目：team；群聊：groupChat
@end

#pragma mark - 移除成员模型
@interface JGJRemoveGroupMemberRequestModel : JGJRequestModel
@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, copy) NSString *team_id;
@property (nonatomic, copy) NSString *uid;

//1.1.0添加
@property (nonatomic, copy) NSString *class_type; //班组group,群聊groupChat
@end
//1.0企业版添加
#pragma mark - 创建项目组请求模型
@interface JGJCreatDiscussTeamRequest : JGJRequestModel
@property (nonatomic, copy) NSString *pro_name;

@property (nonatomic, strong) NSArray *team_members;
@property (nonatomic, strong) NSArray *source_members;
@property (nonatomic, strong) NSArray *confirm_source_members; //有源的数据来源人
@property (nonatomic, copy) NSString *source_pro_id; //创建项目组时选中的数据源,多个用逗号隔开，如 2,3,4
@property (nonatomic, copy) NSString *is_demand; //是否要求同步新项目

//3.4创建项目的名字

@property (nonatomic, copy) NSString *group_name;

@property (nonatomic, copy) NSString *msg_id;//通过同步消息创建项目组

@end

@interface JGJTeamGroupInfoDetailRequest : JGJRequestModel
@property (nonatomic, copy) NSString *team_id; //项目组使用
@property (nonatomic, copy) NSString *group_id; //班组使用
@property (nonatomic, copy) NSString *pro_id; //班组使用
//1.1.0添加
@property (nonatomic, copy) NSString *class_type; //详情类型 班组：group；项目：team；群聊：groupChat
@end

@interface JGJMergeProRequestModel : JGJRequestModel
@property (nonatomic, copy) NSString *pro_name;//合并后的项目名称
@property (nonatomic, copy) NSString *merge_before_name;//合并前的多个项目名称
@property (nonatomic, copy) NSString *team_ids;//要合并项目组的id,至少2个id,用逗号隔开
@end

#pragma mark - 是否是成员
@interface JGJCheckIsMemberRequest : JGJRequestModel
@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, copy) NSString *team_id;
@end

@interface JGJSingleListRequest : JGJRequestModel
@property (nonatomic, copy) NSString *class_type;
@property (nonatomic, copy) NSString *cur_group_id; //添加人员排除当前群的人员
@property (nonatomic, copy) NSString *cur_class_type;
@end

@interface JGJLoginUserInfoRequest : JGJRequestModel

@property (nonatomic, copy) NSString *telph;

@property (nonatomic, copy) NSString *vcode; //添加人员排除当前群的人员

@property (nonatomic, copy) NSString *os;

@property (nonatomic, copy) NSString *role;

@property (nonatomic, copy) NSString *wechatid; //微信unionid

@property (nonatomic, copy) NSString *api; //接口

//(1:在线修改 0：登录修改)
@property (nonatomic, copy) NSString *online; //是否是在线绑定

@end

@interface JGJLogoutReasonRequestModel : NSObject

@property (nonatomic, copy) NSString *vcode;

//填写的原因，与code至少要传一个
@property (nonatomic, copy) NSString *code;

//选择的原因
@property (nonatomic, copy) NSString *reason;

@end


