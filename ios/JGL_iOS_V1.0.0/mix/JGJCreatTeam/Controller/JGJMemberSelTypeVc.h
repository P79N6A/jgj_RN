//
//  JGJMemberSelTypeVc.h
//  mix
//
//  Created by yj on 2017/9/28.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJMemberSelTypeVc : UIViewController

//添加人员、和创建群聊排除群人员
@property (nonatomic, assign)JGJContactedAddressBookVcType contactedAddressBookVcType;

/**
 *  班组信息
 */
@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;

/**
 *  项目组详情信息
 */
@property (nonatomic, strong) JGJTeamInfoModel *teamInfo;

/**
 *  当前已添加或者将要删除成员
 */
@property (nonatomic, strong) NSArray *currentTeamMembers;

/**
 *  区分班组、项目组成员
 */
@property (nonatomic, strong) JGJTeamMemberCommonModel *commonModel;

@property (nonatomic, weak) UIViewController *targetVc;
@end
