//
//  JGJCreatProAddMemberVC.h
//  JGJCompany
//
//  Created by yj on 16/9/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJCreatProAddMemberVC : UIViewController
//JGJCreatProAddMemberVC使用
@property (nonatomic, strong) NSMutableArray *teamMemberModels;//存储班组成员模型数组
@property (strong, nonatomic) JGJCreatProDecModel *proDecModel;
@property (nonatomic, strong) JGJTeamMemberCommonModel *commonModel;//存储添加人员个数等信息
@property (nonatomic, assign) JGJGroupMemberMangeType groupMemberMangeType;//添加成员和发送通知
@property (nonatomic, strong) JGJCreatDiscussTeamRequest *discussTeamRequest;//项目组
@property (nonatomic, strong) JGJNewNotifyModel *notifyModel;
@property (nonatomic, strong, readonly) NSMutableArray *confirmSourceMembers;//有源的来源人
- (void)handleJGJGroupMemberSelectedTeamMembers:(NSMutableArray *)teamsMembers groupMemberMangeType:(JGJGroupMemberMangeType)groupMemberMangeType;
//2.0.2点击有数据源用
@property (nonatomic, strong) JGJSourceSynProFirstModel *sourceSynProFirstModel;
/**
 * 排序后的联系人模型
 */
@property (nonatomic, strong) JGJAddressBookSortContactsModel *sortContactsModel;//存储排序后信息

/**
*
* 子类使用
*/
@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;
@end
