//
//  JGJMemberMangerAppraiseVc.h
//  mix
//
//  Created by yj on 2018/4/19.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MemberMangerAppraiseSuccessBlock)();

@interface JGJMemberMangerAppraiseVc : UIViewController

@property (nonatomic, strong) JGJSynBillingModel *memberModel;

@property (nonatomic, copy) MemberMangerAppraiseSuccessBlock successBlock;

@property (nonatomic, assign) BOOL isMemberManagerInfoVCComeIn;// 是否是从工人/班组长信息进入


@end
