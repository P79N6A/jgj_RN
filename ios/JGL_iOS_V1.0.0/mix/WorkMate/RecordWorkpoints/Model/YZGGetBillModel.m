//
//  YZGGetBillModel.m
//  mix
//
//  Created by Tony on 16/3/4.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGGetBillModel.h"
#import "NSDate+Extend.h"
#import "YZGMateWorkitemsModel.h"

@implementation YZGGetBillModel
@synthesize dataArr = _dataArr;
- (instancetype)init
{
    self = [super init];
    if (self) {
        //初始化设置为-1，可以和0进行区分
        self.accounts_type = [[MateWorkitemsAccounts_Type alloc] init];
        self.accounts_type.code = -1;
        self.set_tpl = [[GetBillSet_Tpl alloc] init];
        self.set_tpl.s_tpl = -1;
        self.set_tpl.w_h_tpl = -1;
        self.set_tpl.o_h_tpl = -1;
        self.un_salary_tpl = @"0";
        self.balance_amount = @"0.00";
//        self.subsidy_amount = @"0.00";
//        self.reward_amount = @"0.00";
//        self.penalty_amount = @"0.00";
        self.deduct_amount = @"0.00";
        self.settlementAmount = @"0.00";
        self.remainingAmount = @"0.00";
    }
    return self;
}
-(void)setStart_time:(NSString *)start_time{
    _start_time = start_time;
    
    self.startDate = [NSDate dateFromString:start_time withDateFormat:@"yyyyMMdd"];
    self.start_timeString = [NSDate stringFromDate:self.startDate format:@"yyyy-MM-dd"];
}

- (void)setEnd_time:(NSString *)end_time{
    _end_time = end_time;
    
    self.endDate = [NSDate dateFromString:end_time withDateFormat:@"yyyyMMdd"];
    self.end_timeString = [NSDate stringFromDate:self.endDate format:@"yyyy-MM-dd"];
}

- (void)setSet_tpl:(GetBillSet_Tpl *)set_tpl{
    _set_tpl = set_tpl;
    
    //显示的字
    NSInteger w_h_tpl = set_tpl.w_h_tpl;
    NSInteger o_h_tpl = set_tpl.o_h_tpl;
//    NSInteger s_tpl = set_tpl.s_tpl;

    CGFloat manhour = self.manhour != -1 && self.manhour != 0?self.manhour:w_h_tpl;
    CGFloat overtime = self.overtime != -1 && self.overtime != 0?self.overtime:0;
    
    if (manhour != 0) {//上班时长
        self.manhourTimeStr = [NSString stringWithFormat:@"%@小时%@",@(manhour),((manhour == w_h_tpl) ? @"(一个工)" :(manhour == w_h_tpl / 2.0 ? @"\n(半个工)" : @""))];
//修改0显示休息(2.0.3-yj)
        if (self.manhour == 0) {
            self.manhourTimeStr = @"休息";
        }
    }
    
    if (overtime != 0) {//加班时长
        self.overhourTimeStr = [NSString stringWithFormat:@"%@小时%@",@(overtime),((overtime == o_h_tpl) ? @"(一个工)" :(overtime == o_h_tpl / 2.0 ? @"\n(半个工)" : @""))];
    }else {
        if (w_h_tpl != 0) {//s_tpl != 0 1.4.5去掉这个判断，主要是不需要工资了
            self.overhourTimeStr = @"无加班";
            self.overtime = 0;
        }else{
            self.overhourTimeStr = @"";
        }
    }
}

- (void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    TYLog(@"dataArr = %@",dataArr);
}


- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (NSMutableArray *)dataNameArr
{
    if (!_dataNameArr) {
        _dataNameArr = [[NSMutableArray alloc] init];
    }
    return _dataNameArr;
}

@end

@implementation GetBillSet_Tpl

- (id)mutableCopyWithZone:(NSZone *)zone {
    GetBillSet_Tpl *mutableCopy = [[GetBillSet_Tpl allocWithZone:zone] init];
    mutableCopy.s_tpl = _s_tpl;
    mutableCopy.w_h_tpl = _w_h_tpl;
    mutableCopy.o_h_tpl = _o_h_tpl;
    return mutableCopy;
}
@end

@implementation GetBill_UnitQuanTpl

- (id)mutableCopyWithZone:(NSZone *)zone {
    
    GetBill_UnitQuanTpl *mutableCopy = [[GetBill_UnitQuanTpl allocWithZone:zone] init];
    mutableCopy.s_tpl = _s_tpl;
    mutableCopy.w_h_tpl = _w_h_tpl;
    mutableCopy.o_h_tpl = _o_h_tpl;
    return mutableCopy;
}
@end

@implementation Recorder_infoModel

@end
