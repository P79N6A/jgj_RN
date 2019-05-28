//
//  JGJMineSettingVc.h
//  mix
//
//  Created by jizhi on 16/6/1.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JGJMineSettingVcBlock)(void);

@interface JGJMineSettingVc : UITableViewController

@property (nonatomic, copy) JGJMineSettingVcBlock mineSettingVcBlock;

@property (nonatomic, strong) MyWorkZone *myWorkZone;

@property (strong, nonatomic) JGJLoginUserInfoRequest *request; //登录请求

@property (strong, nonatomic) JGJLoginUserInfoModel *userInfo;

@property (strong, nonatomic, readonly) JGJMineInfoFirstModel *mineInfoFirstModel;

@end
