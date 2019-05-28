//
//  JGJMineSettingVc.h
//  mix
//
//  Created by jizhi on 16/6/1.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MineSettingVcBackBlock)();

@interface JGJMineSettingVc : UITableViewController

@property (nonatomic, strong) MyWorkZone *myWorkZone;

@property (strong, nonatomic) JGJLoginUserInfoRequest *request; //登录请求

@property (strong, nonatomic) JGJLoginUserInfoModel *userInfo;

@property (strong, nonatomic, readonly) JGJMineInfoFirstModel *mineInfoFirstModel;

@property (copy, nonatomic) MineSettingVcBackBlock mineSettingVcBackBlock;

@end
