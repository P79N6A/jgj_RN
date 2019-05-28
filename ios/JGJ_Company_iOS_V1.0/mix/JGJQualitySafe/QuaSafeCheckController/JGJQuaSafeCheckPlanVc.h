//
//  JGJQuaSafeCheckPlanVc.h
//  JGJCompany
//
//  Created by yj on 2017/7/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJQuaSafeCheckPlanVc : UIViewController

//区分质量和安全检查区分
@property (strong, nonatomic) JGJQualitySafeCommonModel *commonModel;

@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

@property (nonatomic, strong) JGJQuaSafeCheckListModel *listModel;

@end
