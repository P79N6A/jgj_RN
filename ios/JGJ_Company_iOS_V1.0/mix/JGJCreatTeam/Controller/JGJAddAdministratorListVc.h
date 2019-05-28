//
//  JGJAddAdministratorListVc.h
//  JGJCompany
//
//  Created by yj on 16/11/29.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    JGJAddAtMemberType = 1, //选择@人员
    JGJAddAdminMember //选择管理员
} JGJAddAdminVcType;

@class JGJAddAdministratorListVc;
@protocol JGJAddAdministratorListVcDelegate <NSObject>

@optional
- (void)addAdminList:(JGJAddAdministratorListVc *)addAdminListVc didSelectedMember:(JGJSynBillingModel *)member;
@end
@interface JGJAddAdministratorListVc : UIViewController
/**
 *  项目组信息
 */
@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;
/**
 *  控制器类型 管理员、@人员
 */
@property (nonatomic, assign) JGJAddAdminVcType addMemberVcType;
@property (nonatomic, weak) id <JGJAddAdministratorListVcDelegate> delegate;
@end
