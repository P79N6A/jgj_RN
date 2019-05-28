//
//  JGJGroupChatSelelctedMembersVc.h
//  mix
//
//  Created by yj on 16/12/22.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JGJGroupChatSelelctedMembersVcBlock)(id);

//记账选择多人回调

typedef void(^JGJRecordSelelctedMembersVcBlock)(NSArray *members);

@interface JGJGroupChatSelelctedMembersVc : UIViewController
//群聊信息
@property (nonatomic, strong) JGJMyWorkCircleProListModel *groupListModel;
//控制器类型 选择人员单聊 和选择人员群聊
@property (nonatomic, assign) JGJChatType chatType;
//添加人员、和创建群聊排除群人员
@property (nonatomic, assign)JGJContactedAddressBookVcType contactedAddressBookVcType;

/**
 *  项目组详情信息
 */
@property (nonatomic, strong) JGJTeamInfoModel *teamInfo;

/**
 *  记账选择人员回调 2.3.2添加
 */
@property (nonatomic, strong) JGJGroupChatSelelctedMembersVcBlock selelctedMembersVcBlock;

/**
 *  记多人选择人员回调 3.5.2添加
 */
@property (nonatomic, strong) JGJRecordSelelctedMembersVcBlock recordSelMembersVcBlock;

/**
 *  区分添加数据来源人 班组、项目组成员
 */
@property (nonatomic, strong) JGJTeamMemberCommonModel *commonModel;

//是否是记多人选择成员

@property (nonatomic, assign) BOOL isRecordSelMembers;

//标题
@property (nonatomic, copy) NSString *titleDes;

@end
