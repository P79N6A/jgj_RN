//
//  JGJGroupChatSelelctedMembersVc.h
//  mix
//
//  Created by yj on 16/12/22.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

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
 *  区分添加数据来源人 班组、项目组成员
 */
@property (nonatomic, strong) JGJTeamMemberCommonModel *commonModel;

@end
