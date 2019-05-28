//
//  JGJMemberAppraiseDetailVc.h
//  mix
//
//  Created by yj on 2018/6/9.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJMemberMangerModel.h"

@interface JGJMemberAppraiseDetailVc : UIViewController

@property (nonatomic, strong) JGJSynBillingModel *memberModel;

//工作消息查看评价详情，传入服务器给的角色

@property (nonatomic, copy) NSString *cur_role;
@property (nonatomic, assign) BOOL isMemberManagerInfoVCComeIn;// 是否是从工人/班组长信息进入
@end
