//
//  JGJSetAdministratorVc.h
//  JGJCompany
//
//  Created by yj on 16/11/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJSetAdministratorVc : UIViewController
/**
 *  项目信息
 */
@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;
/**
 *  项目组信息
 */
@property (nonatomic, strong) JGJTeamInfoModel *teamInfo;
@end
