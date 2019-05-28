//
//  JGJRecordModel.h
//  mix
//
//  Created by Tony on 2017/2/17.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JGJTplModel;
@class JGJChooseTplModel;
@class accounts_type;
@class JGGtypeModel;
@class accountsModel;
@class JGJeRecordFourBillDetailArrModel;
@class JGJMsgModel;
@class JGJAccountedMsgModel;
@class JGJAttendanceUnitQuanTplModel;
typedef enum:NSUInteger{
    
    JGJMorePeopleMakeLittleWorkType = 0,// 记点工考勤类型
    
    JGJMorePeopleMakeAttendanceType,// 记包工考勤类型
    
}JGJMorePeopleMakeType;

@interface JGJRecordModel : NSObject

@end
@interface JgjRecordlistModel : JGJRecordModel
@property (nonatomic ,copy)NSString *group_id;
@property (nonatomic ,copy)NSString *group_name;
@property (nonatomic ,copy)NSString *pro_id;
@property (nonatomic ,copy)NSString *pro_name;
@property (nonatomic ,copy)NSString *members_num;
@property (nonatomic ,copy)NSString *my_role_type;
@property (nonatomic ,copy)NSString *all_pro_name;
@property (nonatomic ,assign)BOOL isProSelected;

@property (nonatomic, strong) NSArray *members_head_pic;

@end


@interface JgjRecordMorePeoplelistModel : JGJRecordModel

@property (nonatomic ,copy)NSString *record_id;
@property (nonatomic ,copy)NSString *salary;
@property (nonatomic ,copy)NSString *is_salary;
@property (nonatomic ,copy)NSString *name;
@property (nonatomic ,copy)NSString *work_time;//上班时间
@property (nonatomic ,copy)NSString *over_time;//加班时间
@property (nonatomic ,copy)NSString *telph;
@property (nonatomic ,strong)JGJTplModel *tpl;
@property (nonatomic, strong) JGJChooseTplModel *choose_tpl;
@property (nonatomic ,copy)NSString *uid;
//@property (nonatomic ,strong)JGJMsgModel *msg;
@property (nonatomic, strong) JGJAccountedMsgModel *msg;
@property (nonatomic ,copy)NSString *head_pic;
// 当前选择为点工还是包工考勤
@property (nonatomic, assign) BOOL isLittleWorkOrContractorAttendance;
@property (nonatomic, assign) BOOL isSelected;// 一天记多人是否已选中工人
@property (nonatomic, assign) JGJMorePeopleMakeType makeType;
@property (nonatomic, strong) JGJAttendanceUnitQuanTplModel *unit_quan_tpl;
@property (nonatomic, copy) NSString *notes_text;
@property (nonatomic, copy) NSArray *notes_img;
@property (nonatomic, assign) BOOL is_double;
@property (nonatomic, assign) BOOL is_notes;

@end



@interface JGJFirstMorePeoplelistModel :JGJRecordModel
@property (nonatomic, assign) NSInteger last_accounts_type;// 最后一次记账类型
@property (nonatomic ,copy)NSString *account_num;
@property (nonatomic ,strong)NSMutableArray *list;
@end

@interface JGJTplModel : JGJRecordModel
<
NSMutableCopying
>
@property (nonatomic ,copy)NSString *o_h_tpl;
@property (nonatomic ,copy)NSString *s_tpl;
@property (nonatomic ,copy)NSString *w_h_tpl;
@property (nonatomic ,copy)NSString *is_diff;

@property (nonatomic, assign) CGFloat o_s_tpl;// 每小时加班好多钱

@property (nonatomic, assign) NSInteger hour_type;// 1 代表加班按小时 0代表加班按工天

@end

@interface JGJChooseTplModel : JGJRecordModel
<
NSMutableCopying
>
@property (nonatomic ,copy)NSString *choose_o_h_tpl;
@property (nonatomic ,copy)NSString *choose_w_h_tpl;

@end

// 用于判断一人记多天 已记工 记得是点工还是包工考勤
@interface JGJAccountedMsgModel : JGJRecordModel

@property (nonatomic ,copy)NSString *accounts_type;// 1代表点工  5代表包工考勤
@property (nonatomic ,copy)NSString *msg_text;// 记账信息  如果为nil则显示 记账时间 不为nil显示文本内容
@property (nonatomic ,copy)NSString *msg_type;

@end

//unit_quan_tpl
@interface JGJAttendanceUnitQuanTplModel : JGJRecordModel

@property (nonatomic ,copy)NSString *o_h_tpl;
@property (nonatomic ,copy)NSString *s_tpl;
@property (nonatomic ,copy)NSString *w_h_tpl;

@end
@interface JGJMsgModel : JGJRecordModel
<
NSMutableCopying
>
@property (nonatomic ,copy)NSString *msg_text;
@property (nonatomic ,copy)NSString *msg_type;

@end


@interface JGJMoneyListModel : JGJRecordModel

@property (nonatomic ,copy)NSString *normal_time;
@property (nonatomic ,copy)NSString *over_time;
@property (nonatomic ,copy)NSString *money_day;
@property (nonatomic ,copy)NSString *is_salary;
@property (nonatomic ,copy)NSString *recordID;
@property (nonatomic ,copy)NSString *telephone;
@property (nonatomic ,copy)NSString *Puid;
@property (nonatomic ,copy)NSString *real_name;
@property (nonatomic ,copy)NSString *workTime_tpl;
@property (nonatomic ,copy)NSString *overTime_tpl;

@end

@interface JGJAddProModel : JGJRecordModel
@property (nonatomic ,copy)NSString *exist;
@property (nonatomic ,copy)NSString *pid;
@property (nonatomic ,copy)NSString *pro_name;
@end
//用于记工流水三级页面
@interface JGJeRecordBillDetailModel : JGJRecordModel
@property (nonatomic ,copy)NSArray *list;
@property (nonatomic ,copy)NSString *total_month;
@property (nonatomic ,copy)NSString *total_month_txt;

//@property (nonatomic ,copy)NSString *name;
//@property (nonatomic ,copy)NSString *pid;
//@property (nonatomic ,copy)NSString *uid;
//@property (nonatomic ,copy)NSString *calss_type;
//@property (nonatomic ,copy)NSDictionary *accounts_type;
//@property (nonatomic ,copy)NSString *amounts;
//@property (nonatomic ,copy)NSString *manhour;
//@property (nonatomic ,copy)NSString *overtime;
//@property (nonatomic ,copy)NSString *total_month;
//@property (nonatomic ,copy)NSString *total_month_txt;

@end
@interface JGJeRecordBillDetailArrModel : JGJRecordModel
@property (nonatomic ,copy)NSString *name;
@property (nonatomic ,copy)NSString *pid;
@property (nonatomic ,copy)NSString *uid;
@property (nonatomic ,copy)NSString *class_type;
@property (nonatomic ,strong)accountsModel *accounts_type;
@property (nonatomic ,assign)CGFloat total;
@property (nonatomic ,copy)NSString *total_manhour;
@property (nonatomic ,copy)NSString *total_overtime;
@property (nonatomic ,copy)NSString *role;
@property (nonatomic ,copy)NSString *create_by_role;
@property (nonatomic ,copy)NSString *foreman_name;
//@property (nonatomic ,copy)NSString *name;
@property (nonatomic ,copy)NSString *pro_name;
@property (nonatomic ,copy)NSString *worker_name;
//@property (nonatomic ,assign)CGFloat accounts_type;
@end
@interface accountsModel : JGJRecordModel
<
NSMutableCopying
>
@property (nonatomic ,copy)NSString *code;
@property (nonatomic ,copy)NSString *txt;
@end
//记工流水四级页面
@interface JGJeRecordFourBillDetailModel : JGJRecordModel
@property (nonatomic ,copy)NSString *name;
@property (nonatomic ,copy)NSString *pro_name;
@property (nonatomic ,copy)NSString *total_month;
@property (nonatomic ,copy)NSString *total_manhour;
@property (nonatomic ,copy)NSString *total_over;
@property (nonatomic ,copy)NSString *total_month_txt;
@property (nonatomic ,copy)NSString *pid;
@property (nonatomic ,copy)NSString *uid;
@property (nonatomic ,copy)NSArray <JGJeRecordFourBillDetailArrModel *>*workday;
@end
@interface JGJeRecordFourBillDetailArrModel : JGJRecordModel
//@property (nonatomic ,strong)JGGtypeModel *accounts_type;
@property (nonatomic ,copy)NSString *total;
@property (nonatomic ,copy)NSString *date_turn;
@property (nonatomic ,copy)NSString *date_txt;
@property (nonatomic ,copy)NSString *del_diff_tag;
@property (nonatomic ,copy)NSString *id;
@property (nonatomic ,copy)NSString *total_manhour_txt;
@property (nonatomic ,copy)NSString *modify_marking;
@property (nonatomic ,copy)NSString *total_overtime_txt;
@property (nonatomic ,copy)NSString *role;
@property (nonatomic ,copy)NSString *create_by_role;
@property (nonatomic ,copy)NSString *foreman_name;
@property (nonatomic ,copy)NSString *name;
@property (nonatomic ,copy)NSString *pro_name;
@property (nonatomic ,copy)NSString *worker_name;
@property (nonatomic ,assign)CGFloat accounts_type;
@property (nonatomic ,assign)NSInteger amounts_diff;
@property (nonatomic ,copy)NSString *manhour;
@property (nonatomic ,copy)NSString *overtime;
@property (nonatomic ,copy)NSString *overtime_hours;
@property (nonatomic ,copy)NSString *working_hours;
@property (nonatomic ,copy)NSString *unit;
@property (nonatomic ,copy)NSString *proname;
@property (nonatomic ,copy)NSString *amounts;
@property (nonatomic ,assign)CGFloat is_rest;
@property (nonatomic ,assign)CGFloat show_line;

@property (nonatomic ,copy)NSString *unitprice;
@property (nonatomic ,copy)NSString *quantities;

@end
@interface JGGtypeModel : JGJRecordModel
<
NSMutableCopying
>
@property (nonatomic ,copy)NSString *code;
@property (nonatomic ,copy)NSString *txt;
@end
@interface JGJFilloutNumModel : CommonModel//
//@property (nonatomic, copy) NSArray *days;
//@property (nonatomic, copy) NSString *normal_work;
@property (nonatomic, copy) NSString *Num;//数量
@property (nonatomic, copy) NSString *priceNum;//单位

@end
