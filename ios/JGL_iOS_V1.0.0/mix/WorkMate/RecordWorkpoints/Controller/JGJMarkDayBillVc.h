//
//  JGJMarkDayBillVc.h
//  mix
//
//  Created by 任涛 on 16/6/6.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJMarkBillBaseVc.h"

@interface JGJMarkDayBillVc : JGJMarkBillBaseVc
/**
 *  跳转到工资模板界面
 */
- (void)showSalaryTemplateVc;

/**
 *  弹出上班时间选择
 */
- (void)showManHourPicker:(NSIndexPath *)indexPath;

/**
 *  弹出加班时间选择
 */
- (void)showOverHourPicker:(NSIndexPath *)indexPath;
@end
