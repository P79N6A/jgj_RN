//
//  JGJCheckGroupChatAllMemberVc.h
//  mix
//
//  Created by yj on 16/12/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HandleMembersSuccessBlock)(id);

typedef enum : NSUInteger {
    CheckAllMemberVcDefaultType = 0,
    
    CheckAllMemberVcGroupMangerType, //项目管理进入

} CheckGroupChatAllMemberVcType;

@interface JGJCheckGroupChatAllMemberVc : UIViewController
@property (nonatomic, strong) NSMutableArray *memberModels;
/**
 *  群聊信息
 */
@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;

/**
 *  项目设置查看
 */
@property (nonatomic, strong) JGJTeamInfoModel *teamInfo;

/**
 *  前一个页面类型
 */
@property (nonatomic, assign) CheckGroupChatAllMemberVcType allMemberVcType;


/**
 *  排序后的模型2.3.0
 */
@property (nonatomic, strong) JGJAddressBookSortContactsModel *sortContactsModel;

/**
 *  添加人员需要的模型2.3.0
 */
@property (nonatomic, strong) JGJTeamMemberCommonModel *commonModel;

/**
 *  人员添加删除成功回调，修改数据库数据
 */
@property (nonatomic, strong) HandleMembersSuccessBlock successBlock;

@end
