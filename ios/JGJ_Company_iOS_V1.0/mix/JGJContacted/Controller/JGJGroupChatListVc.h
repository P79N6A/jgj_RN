//
//  JGJGroupChatListVc.h
//  mix
//
//  Created by YJ on 16/12/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJGroupChatListVc : UIViewController
@property (nonatomic, assign) JGJGroupChatListVcType groupChatListVcType;
//控制器类型 选择人员单聊 和选择人员群聊
@property (nonatomic, assign) JGJChatType chatType;

//添加人员、和创建群聊排除群人员
@property (nonatomic, assign)JGJContactedAddressBookVcType contactedAddressBookVcType;

/**
 *  群聊信息
 */
@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;

/**
 *  项目、群模型数组
 */
@property (nonatomic, strong) NSArray *groupChatList;

/**
 *  项目组详情信息添加人数升级条件2.3.0
 */
@property (nonatomic, strong) JGJTeamInfoModel *teamInfo;

/**
 *  区分添加数据来源人 班组、项目组成员
 */
@property (nonatomic, strong) JGJTeamMemberCommonModel *commonModel;
@end
