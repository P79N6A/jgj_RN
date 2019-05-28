//
//  JGJSetAgentMonitorController.h
//  mix
//
//  Created by Tony on 2018/7/17.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SetAgentMonSuccessBlock)(JGJSynBillingModel *agency_group_user);

@interface JGJSetAgentMonitorController : UIViewController

@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

//3.3.3代理人信息
@property (nonatomic, strong) JGJSynBillingModel *agency_group_user;

@property (nonatomic, copy) SetAgentMonSuccessBlock setAgentMonSuccessBlock;

@end
