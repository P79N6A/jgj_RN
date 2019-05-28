//
//  JGJGroupMangerTool.h
//  JGJCompany
//
//  Created by yj on 2017/8/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JGJSureOrderListViewController.h"


typedef void(^JGJServiceOverTimeRequestBlock)(id);

@interface JGJServiceOverTimeRequest : NSObject

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *class_type;

@property (nonatomic, copy) NSString *server_type;

+ (void)serviceOverTimeRequest:(JGJServiceOverTimeRequest *)request requestBlock:(JGJServiceOverTimeRequestBlock)requestBlock;

@end

typedef void(^GroupMangerToolBlock)(id);

@interface JGJGroupMangerTool : NSObject

/**
 *  项目组信息
 */
@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;

/**
 *  项目组详情信息
 */
@property (nonatomic, strong) JGJTeamInfoModel *teamInfo;

/**
 *  当前Vc
 */
@property (nonatomic, strong) UINavigationController *targetVc;

/**
 *  是否弹框
 */
@property (nonatomic, assign, readonly) BOOL isPopView;

/**
 *  降级成功回调
 */
@property (nonatomic, copy) GroupMangerToolBlock groupMangerToolBlock;

/**
 *  是否是主页弹出云盘过期弹框
 */
-(BOOL)overTimeTip;

/**
 *  云盘过期提示
 */

- (BOOL)overCloudTip;

@property (nonatomic, assign) BuyGoodType buyGoodType;

@end
