//
//  BMDatePickerView.h
//  BMDeliverySpecialists
//
//  Created by 1 on 16/2/16.
//  Copyright © 2016年 BlueMoon. All rights reserved.
//

/**
 *******************************************************
 *  由于最近在项目中需要一个只有  年月的选择PickView 但是系统自带的 DatePickView 好像无法满足
 *  所以 自己随便弄了一下, kMIN_YEAR 为 最早可选的年份 不可大于 当前年份: 0 - 2016 均可,[大了小心BUG  O(∩_∩)O~... ]
 *  目前默认是最大可以选的时间为当前时间 (当前的 年 月)
 *  以后会优化一下,增加一个方法: 模仿系统的 DatePickView 封装
 
 低级的见解 或者可以交流 asiosldh@163.com 或者 QQ 872304636
 *******************************************************
 */

#import <UIKit/UIKit.h>

#define kMIN_YEAR  2001

typedef void(^SelectActionBlock)(NSString *selectYearMonthString);

@interface BMDatePickerView : UIView

/**
 *  确定按钮点击回调
 */
@property (copy, nonatomic) SelectActionBlock selectActionBlock;

/**
 *  常见时间选择控件 (只有 年 月)
 *
 *  @param selectActionBlock 选回调
 */
+ (instancetype)BMDatePickerViewCertainActionBlock:(SelectActionBlock)selectActionBlock;

/**
 *  显示
 */
- (void)show;

@end
