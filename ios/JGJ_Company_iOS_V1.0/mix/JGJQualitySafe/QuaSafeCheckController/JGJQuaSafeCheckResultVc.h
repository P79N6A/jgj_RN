//
//  JGJQuaSafeCheckResultVc.h
//  JGJCompany
//
//  Created by yj on 2017/7/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JLGAddProExperienceViewController.h"

@interface JGJQuaSafeCheckResultVc : JLGAddProExperienceViewController

//2.3.4
@property (nonatomic, strong) JGJInspectPlanProInfoDotListModel *dotListModel;

@property (nonatomic, strong) JGJInspectPlanProInfoModel *proInfoModel;

@property (nonatomic, assign) JGJCheckModifyResultViewButtontype buttonType;

@end
