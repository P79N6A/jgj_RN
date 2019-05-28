//
//  JGJNewMarkBillBottomBaseView.h
//  mix
//
//  Created by Tony on 2018/5/22.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum: NSUInteger{

    JGJRemaingAmountType,//未结工资

    JGJMarkBillJobForemanType,// 班组长

    JGJMarkBillWorkerManagement,// 工人管理

    JGJMarkBillWaterType,//记工流水

    JGJMarkBillTotalType,//记工统计

    JGJMarkBillSynchronizationType,//同步记工

    JGJMarkBillSynchronizationTypeToMe,//同步给我的记工
    JGJMarkBillGoToAccountCheckingType,// 我要对账
    JGJMarkBillRecommendToOtherType,// 推荐给他人
    JGJMarkBillSettingUpType,// 记工设置
    JGJMarkBillExplainType,// 记工说明
    JGJShowWarkDayType,// 晒工天
    
    
}JGJMainMarkBillType;

typedef void(^didSelectMarkBillBlock)(JGJMainMarkBillType mainMarkBillType);
@interface JGJNewMarkBillBottomBaseView : UIView

@property (copy, nonatomic) didSelectMarkBillBlock didSelectMarkBillBlock;
@property (strong, nonatomic)  JGJRecordMonthBillModel *model;
//0.上班按工天、加班按小时 1.按工天, 2. 按小时
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *wait_confirm_num;

// 更新选择类型

- (void)updateAccountSelType;
@end
