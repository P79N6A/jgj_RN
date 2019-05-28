//
//  JGJQuaSafeCheckVc.h
//  JGJCompany
//
//  Created by yj on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJChatListBaseVc.h"

typedef void(^HandleTopViewFlagBlock)(JGJQuaSafeCheckModel *);

@interface JGJQuaSafeCheckVc : JGJChatListBaseVc

//区分质量和安全
@property (strong, nonatomic) JGJQualitySafeCommonModel *commonModel;

@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

@property (nonatomic, copy) HandleTopViewFlagBlock handleTopViewFlagBlock;

//刷新列表
- (void)freshTableView;

@end
