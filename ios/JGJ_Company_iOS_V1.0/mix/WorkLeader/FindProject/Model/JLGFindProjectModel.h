//
//  JLGFindProjectModel.h
//  mix
//
//  Created by jizhi on 15/11/30.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "TYModel.h"


@class Classes,Cooperate_Type,Worklevel,Worktype, FindResultModel;
@interface JLGFindProjectModel : TYModel

@property (nonatomic, copy) NSString *protitle;

@property (nonatomic, assign) NSInteger prepay;

@property (nonatomic, assign) NSInteger friendcount;

@property (nonatomic, assign) NSInteger ctime;

//@property (nonatomic, copy) NSArray<Classes *> *classes; //2.1.2-yj和H5交互删除
@property (nonatomic, strong) Classes *classes;

@property (nonatomic, copy) NSString *timelimit;

@property (nonatomic, copy) NSString *ctime_txt;

@property (nonatomic, copy) NSString *prodescrip;

@property (nonatomic, strong) NSArray<NSNumber *> *prolocation;

@property (nonatomic, assign) NSInteger pid;

@property (nonatomic, assign) NSInteger is_reply;

@property (nonatomic, assign) NSInteger is_call;

@property (nonatomic, assign) NSInteger is_full;

@property (nonatomic, copy) NSString *proaddress;

@property (nonatomic, copy) NSString *regionname;

@property (nonatomic, copy) NSString *fmname;

@property (nonatomic,copy) NSDictionary *share;

@property (nonatomic,copy) NSArray *welfare;

@property (nonatomic,assign) NSInteger review_cnt;

@property (nonatomic,copy) NSArray *findresult;

@property (nonatomic,copy) NSString *enroll_time_txt;

@property (nonatomic,copy) NSString *proname;

@property (nonatomic,assign) NSInteger telph;

@property (nonatomic,copy) NSString *create_time_txt;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic,copy) NSString *total_area;

@property (nonatomic,assign) NSInteger firstitem;

@property (nonatomic, assign) CGFloat strViewH;//类型View的高度

@property (nonatomic, assign) CGFloat maxWidth;//换行最大宽度

@property (nonatomic, strong) NSAttributedString *attributedStr;//计算出的富文本

@property (nonatomic, strong) NSArray <FindResultModel *> *contact_info;//存储联系人模型

/**计算福利的换行高度*/
@property (nonatomic, assign) CGFloat welfareMaxWidth;
@property (nonatomic, assign) CGFloat welfareHeight;

@property (nonatomic, assign) NSInteger role_type; //工人/工头
@end

@interface Classes : NSObject

@property (nonatomic, copy) NSString *total_scale;//总规模

@property (nonatomic, copy) NSString *balanceway;

//开始时间
@property (nonatomic, copy) NSString *work_begin;

@property (nonatomic, copy) NSString *contractor;

//金额的最小范围
@property (nonatomic, copy) NSString *money;

//金额的最大范围
@property (nonatomic, copy) NSString *max_money;

@property (nonatomic, copy) NSString *unitMoney;

@property (nonatomic, strong) Worklevel *worklevel;

@property (nonatomic, strong) Cooperate_Type *cooperate_type;

@property (nonatomic, strong) Worktype *worktype;

@property (nonatomic,assign) NSInteger person_count;

@end

@interface Cooperate_Type : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger code;

@end

@interface Worklevel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger code;

@end

@interface Worktype : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger code;

@end

@interface Type_list : NSObject

@property (nonatomic, copy) NSString *type_name;

@property (nonatomic, assign) NSInteger type_id;

@end
