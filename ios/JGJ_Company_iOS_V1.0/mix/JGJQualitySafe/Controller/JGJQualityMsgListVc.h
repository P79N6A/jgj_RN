//
//  JGJQualityMsgListVc.h
//  JGJCompany
//
//  Created by yj on 2017/6/7.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJChatListBaseVc.h"

@interface JGJQualityMsgListVc : JGJChatListBaseVc

@property (strong, nonatomic) JGJMyWorkCircleProListModel *proListModel;

//区分质量和安全
@property (strong, nonatomic) JGJQualitySafeCommonModel *commonModel;
@end
