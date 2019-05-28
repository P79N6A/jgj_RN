//
//  YZGMateShowpoorModel.h
//  mix
//
//  Created by Tony on 16/2/29.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYModel.h"

@class MateWorkitemsAccounts_Type,Prompt;
@interface YZGMateShowpoorModel : TYModel
@property (nonatomic,strong) MateWorkitemsAccounts_Type *accounts_type;

#pragma mark - 所有情况都有的
@property (nonatomic, assign) NSInteger id;//本条记账的id

@property (nonatomic, assign) NSInteger main_role;//我的角色 1是工人,2是班组长/工头
@property (nonatomic, assign) NSInteger
is_del;//是否已经删除

@property (nonatomic, copy) NSString *main_name;//我的姓名
@property (nonatomic, assign) BOOL main_del;//我的姓名
@property (nonatomic, assign) BOOL second_del;
@property (nonatomic, strong) NSString *main_line;
@property (nonatomic, strong) NSString *second_line;

@property (nonatomic, copy) NSString * main_set_amount;//我的记账总额

@property (nonatomic, copy) NSString * describe;//记账描述

@property (nonatomic, assign) NSInteger second_role;//对方角色 1是工人,2是班组长/工头
@property (nonatomic, assign) NSInteger is_rest;//是不是休息
@property (nonatomic, assign) NSInteger show_lines;//是不是休息

@property (nonatomic, copy) NSString *second_name;//对方姓名
@property (nonatomic, copy) NSString *del_diff_right;//对方姓名
@property (nonatomic, copy) NSString *del_diff_left;//对方姓名
@property (nonatomic, copy) NSString *date;//时间
@property (nonatomic, copy) NSString *second_manhour_hours;//对方 正常工时(工为单位)
@property (nonatomic, copy) NSString *second_overtime_hours;//对方 加班工时(工为单位)

@property (nonatomic,copy) NSString *second_set_amount;//对方记账总额

@property (nonatomic, strong) Prompt *prompt;
#pragma mark - 点工
@property (nonatomic, assign) NSInteger main_hour_type;// 1代表按小时显示加班 0代表按工天显示加班
@property (nonatomic, assign) CGFloat main_o_s_tpl;// 每小时加班工资


@property (nonatomic, copy) NSString *main_manhour;//我的记账正常时长（当记账为点工时返回）

@property (nonatomic, copy) NSString *main_overtime;//我的记账加班时长（当记账为点工时返回）
@property (nonatomic, copy) NSString *main_overtime_hours;///当前用户 加班工时模板

@property (nonatomic, copy) NSString *second_manhour;//对方记账正常时长（当记账为点工时返回）

@property (nonatomic, copy) NSString *second_overtime;//对方记账加班时长（当记账为点工时返回）

#pragma mark - 包工
@property (nonatomic, copy) NSString *main_set_unitprice;//我的记账单价（当记账为包工时返回）

@property (nonatomic,copy) NSString *main_set_quantities;

@property (nonatomic, copy) NSString *second_set_unitprice;

@property (nonatomic, copy) NSString *second_set_quantities;

@property (nonatomic, copy) NSString *main_balance_amount;

@property (nonatomic, copy) NSString *main_deduct_amount;

@property (nonatomic, copy) NSString *main_pay_amount;

@property (nonatomic, copy) NSString *main_penalty_amount;

@property (nonatomic, copy) NSString *main_reward_amount;

@property (nonatomic, copy) NSString *main_subsidy_amount;

@property (nonatomic, copy) NSString *second_balance_amount;

@property (nonatomic, copy) NSString *second_deduct_amount;

@property (nonatomic, copy) NSString *second_pay_amount;

@property (nonatomic, copy) NSString *second_penalty_amount;

@property (nonatomic, copy) NSString *second_reward_amount;

@property (nonatomic, copy) NSString *second_subsidy_amount;

@property (nonatomic, assign) NSInteger second_hour_type;// 1代表按小时显示加班 0代表按工天显示加班
@property (nonatomic, assign) CGFloat second_o_s_tpl;// 每小时加班工资



@property (nonatomic,copy) NSString *main_s_tpl;//我的记账模板金额

@property (nonatomic,copy) NSString *main_w_h_tpl;//我的记账模板正常工作时长

@property (nonatomic, copy) NSString *main_o_h_tpl;//我的记账模板加班工作时长

@property (nonatomic, copy) NSString *second_s_tpl;//对方记账模板金额

@property (nonatomic, copy) NSString *second_w_h_tpl;//对方记账模板正常工作时长

@property (nonatomic, copy) NSString *second_o_h_tpl;//对方记账模板加班工作时长

@property (nonatomic, assign) BOOL del_diff_tag;//2.1.2删除之后形成的差账显示--

@property (nonatomic, assign) NSInteger create_by_role;//2.1.2删除之后形成的差账显示--

//改变颜色的名字
@property (nonatomic, copy) NSString *second_name_mark;

@end

@interface Prompt:TYModel
@property (nonatomic, copy) NSString *msg;//提示的语言

/**
 *  是否有差账 0 :没有 2:需要自己确认 3:需要对方确认
 */
@property (nonatomic, assign) NSInteger modify_marking;
@end
