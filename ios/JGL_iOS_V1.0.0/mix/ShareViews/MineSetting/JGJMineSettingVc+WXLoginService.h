//
//  JGJMineSettingVc+WXLoginService.h
//  mix
//
//  Created by yj on 2018/9/10.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJMineSettingVc.h"

@interface JGJMineSettingVc (WXLoginService)

//获取微信登录状态
- (void)requestWxLogionStatus;

//处理绑定微信
- (void)handleBindWX;

@end
