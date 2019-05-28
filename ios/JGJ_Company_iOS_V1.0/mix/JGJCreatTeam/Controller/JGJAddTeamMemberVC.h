//
//  JGJAddTeamMemberVC.h
//  mix
//
//  Created by yj on 16/8/29.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HandleMembersBlock)(id);

typedef void(^skipToNextVc)(UIViewController *nextVc);
@protocol JGJAddTeamMemberDelegate <NSObject>
@optional
- (void)handleJGJGroupMemberSelectedTeamMembers:(NSMutableArray *)teamsMembers groupMemberMangeType:(JGJGroupMemberMangeType)groupMemberMangeType;
// 添加单个
- (void)handleJGJAddIndividualTeamMemberModel:(JGJSynBillingModel *)teamMemberModel;
@end
@interface JGJAddTeamMemberVC : UIViewController
@property (nonatomic, strong) JGJSynBillingCommonModel *synBillingCommonModel;
@property (nonatomic, strong) JGJTeamMemberCommonModel *commonModel;
@property (nonatomic, assign) JGJGroupMemberMangeType groupMemberMangeType;
@property (nonatomic, weak) id <JGJAddTeamMemberDelegate> delegate;
@property (nonatomic, strong) NSArray *currentTeamMembers;//当前已添加或者将要删除成员

//2.0.2点击有数据源用
@property (nonatomic, strong) JGJSourceSynProFirstModel *sourceSynProFirstModel;
@property (nonatomic, strong) NSArray *selelctedProIDs;//选中的项目id
@property (nonatomic, strong) JGJNewNotifyModel *notifyModel;
//2.0.3添加
@property (nonatomic, strong) JGJAddressBookSortContactsModel *sortContactsModel;//存储排序后信息

//记工报表添加数据来源人使用，返回显示头子
@property (nonatomic,copy) skipToNextVc skipToNextVc;

/**
 *  项目组信息
 */
@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;

//添加人员、和创建群聊排除群人员
@property (nonatomic, assign)JGJContactedAddressBookVcType contactedAddressBookVcType;

//最大可选人数
@property (nonatomic, assign) NSInteger maxMemberNum;

/**
 *  项目组详情信息
 */
@property (nonatomic, strong) JGJTeamInfoModel *teamInfo;

/**
 *  pop的vc
 */
@property (nonatomic, weak) UIViewController *targetVc;


@property (nonatomic, copy) HandleMembersBlock successBlock;

@end
