//
//  YZGGetBillModel.h
//  mix
//
//  Created by Tony on 16/3/4.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYModel.h"
#import "YZGMateWorkitemsModel.h"

@class GetBillSet_Tpl;
@class GetBill_UnitQuanTpl;
@class Recorder_infoModel;
@interface YZGGetBillModel : TYModel

@property (nonatomic, assign) BOOL is_not_telph; //是否有电话号码
//自己加的，保存记账类型，1是点工，2是包工，3是借支 4结算
@property (nonatomic, strong) MateWorkitemsAccounts_Type *accounts_type;

@property (nonatomic, strong) NSMutableArray *dataArr;//提交的语音文件
@property (nonatomic, strong) NSMutableArray *dataNameArr;//提交的语音文件名字
@property (nonatomic, copy) NSString *be_booked_user_name;//被记账人的名字

@property (nonatomic, copy) NSString *id;//被记账人的名字
@property (nonatomic, copy) NSString *record_id;
//通用的
@property (nonatomic, copy) NSString *notes_voice;//音频的路径

@property (nonatomic, copy) NSString *notes_voice_amr;//amr的路径
@property (nonatomic, copy) NSString *all_pro_name;//项目组名称

@property (nonatomic, assign) NSInteger voice_length;//音频的长度
@property (nonatomic, copy) NSString *del_diff_tag;//是否被删除的账单
@property (nonatomic, assign) BOOL isRest;//是否休息
@property (nonatomic, assign) BOOL isOverWork;//是否加班
@property (nonatomic, assign) BOOL isEditeTpl;//是否是编辑薪资模板

@property (nonatomic, assign) NSInteger uid;

@property (nonatomic, copy) NSString *proname;
@property (nonatomic, assign) float totalMoney;//工资总额

@property (nonatomic, assign) double  salary;
@property (nonatomic, assign) CGFloat pay_amount;// 本次实收/实付金额
@property (nonatomic, assign) BOOL editerecord;//是否编辑过记账人

@property (nonatomic, assign) NSInteger role;//1、工人,2、班组长/工头

@property (nonatomic, copy) NSString *notes_txt;

@property (nonatomic, assign) NSInteger pid;

@property (nonatomic, strong) NSArray<NSString *> *notes_img;
@property (nonatomic, copy) NSString *units;//包工单位

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *head_pic;
//判断是不是推送进来的
@property (nonatomic, copy) NSString *sendType;
//判断显示那个查账图标
@property (nonatomic, copy) NSString *modify_marking;
@property (nonatomic, copy) NSString *p_s_time;
@property (nonatomic, copy) NSString *p_e_time;

//点工/包工考勤
@property (nonatomic, assign) CGFloat manhour;

@property (nonatomic, assign) CGFloat overtime;

@property (nonatomic, copy)   NSString  *manhourTimeStr; //时间显示

@property (nonatomic, copy)   NSString  *overhourTimeStr; //时间显示

@property (nonatomic, copy)   NSString  *foreman_name; //工头名称
@property (nonatomic, copy)   NSString  *fuid; //工头uid

@property (nonatomic, copy)   NSString  *worker_name; //工人名称
@property (nonatomic, copy)   NSString  *wuid; //工人uid

@property (nonatomic, copy)   NSString  *working_hours; //上班工时

@property (nonatomic, copy)   NSString  *overtime_hours; //加班工时

@property (nonatomic, assign)   CGFloat  amounts; //收入

@property (nonatomic, strong) GetBillSet_Tpl *set_tpl;

//包工独有的
@property (nonatomic, assign) NSInteger contractor_type;// 包工记账类型 1 承包  2 分包
@property (nonatomic, assign) CGFloat unitprice;

@property (nonatomic, assign) CGFloat quantities;

@property (nonatomic, copy) NSString *sub_proname;
@property (nonatomic, copy) NSString *tpl_id;
@property (nonatomic, copy) NSString *sub_pro_name;

@property (nonatomic, copy) NSString *deleteImageURL;

@property (nonatomic, copy) NSString *start_time;

@property (nonatomic, copy) NSString *end_time;

@property (nonatomic, copy) NSString *start_timeString;

@property (nonatomic, copy) NSString *end_timeString;

@property (nonatomic, strong) NSDate *startDate;

@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, copy) NSString *phone_num;

@property (nonatomic, copy) NSString *browNum;//添加借支金额

@property (nonatomic, copy) NSString *totalNum;//结算金额
//结算
@property (nonatomic, copy) NSString *balance_amount;//未结算金额

@property (nonatomic, copy) NSString *un_salary_tpl;//还有多少笔笔点工的工资模板中未设置金额

@property (nonatomic, copy) NSString *subsidy_amount;//补贴工资

@property (nonatomic, copy) NSString *reward_amount;//    奖金工资

@property (nonatomic, copy) NSString *penalty_amount;//   惩罚工资

@property (nonatomic, copy) NSString *deduct_amount;//   抹零工资

@property (nonatomic, copy) NSString *totalCalculation;//  补贴，奖金，罚款总额

@property (nonatomic, copy) NSString *settlementAmount;//  本次结算金额

@property (nonatomic, copy) NSString *remainingAmount;//  剩余未结金额

@property (nonatomic, copy) NSString *salary_desc;//

@property (nonatomic, copy) NSString *bill_num;//

@property (nonatomic, copy) NSString *bill_desc;//

@property (nonatomic, strong) GetBill_UnitQuanTpl *unit_quan_tpl;

@property (nonatomic, strong) Recorder_infoModel *recorder_info;// 记录人信息



@end

@interface GetBillSet_Tpl : TYModel
<
    NSMutableCopying
>
@property (nonatomic, assign) double s_tpl;// 一个工的薪资

@property (nonatomic, assign) CGFloat w_h_tpl;// 上班标准时间

@property (nonatomic, assign) CGFloat o_h_tpl;// 加班标准时间

@property (nonatomic, assign) CGFloat o_s_tpl;// 每小时加班好多钱

@property (nonatomic, assign) NSInteger hour_type;// 1 代表加班按小时 0代表加班按工天

@end

@interface GetBill_UnitQuanTpl: CommonModel

@property (nonatomic, assign) double s_tpl;// 薪资
@property (nonatomic, assign) CGFloat w_h_tpl;// 上班时间标准
@property (nonatomic, assign) CGFloat o_h_tpl;// 加班时间标准

@end

@interface Recorder_infoModel: CommonModel

@property (nonatomic, strong) NSString *real_name;// 记录人名字
@property (nonatomic, strong) NSString *record_time;// 记录人时间
@property (nonatomic, strong) NSString *uid;// 记录人uid

@end

