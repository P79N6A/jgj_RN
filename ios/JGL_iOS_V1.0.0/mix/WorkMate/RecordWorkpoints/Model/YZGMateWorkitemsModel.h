//
//  YZGMateWorkitemsModel.h
//  mix
//
//  Created by Tony on 16/2/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYModel.h"

@class MateWorkitemsValues,MateWorkitemsItems,MateWorkitemsAccounts_Type;

@interface YZGMateWorkitemsModel : TYModel
<
    NSCopying,
    NSMutableCopying
>
@property (nonatomic, copy) NSArray<MateWorkitemsValues *> *values;

@end

@interface MateWorkitemsValues : TYModel

@property (nonatomic, copy) NSArray<MateWorkitemsItems *> *items;

@property (nonatomic, copy) NSString *pro_name;

@end

@interface MateWorkitemsItems : TYModel

@property (nonatomic, assign) NSInteger is_del;//是否移除,1是移除,0是不移除

@property (nonatomic, copy) NSString *overtime;

@property (nonatomic, assign) NSInteger uid;

@property (nonatomic, assign) NSInteger pid;

@property (nonatomic, assign) CGFloat amounts;

//1是工友，2是班组长/工头
@property (nonatomic, assign) NSInteger role;

/**
 *  是否有差账 0 :没有 1：有
 */
@property (nonatomic, assign) NSInteger amounts_diff;

/**
 *  是否有差账 0 :没有 2:需要自己确认 3:需要对方确认
 */
@property (nonatomic, assign) NSInteger modify_marking;

@property (nonatomic, copy) NSString *manhour;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) MateWorkitemsAccounts_Type *accounts_type;

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *record_id;

@property (nonatomic, copy) NSString *pro_name;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *date_turn;

@property (nonatomic, copy) NSString *create_by_role;

@property (nonatomic, copy) NSString *foreman_name;

@property (nonatomic, copy) NSString *fuid;

@property (nonatomic, copy) NSString *sub_pro_name;

@property (nonatomic, copy) NSString *worker_name;

@property (nonatomic, copy) NSString *wuid;

@property (nonatomic, assign) CGFloat is_rest;

@property (nonatomic, assign) CGFloat show_line;


@property (nonatomic, copy) NSString *manhour_text;//正常上班单位

@property (nonatomic, copy) NSString *overtime_text;//加班单位

@property (nonatomic, copy) NSString *unit;//单位

@property (nonatomic, copy) NSString *quantities;//数量

@property (nonatomic, copy) NSString *unitprice;//单价

//代理人uid自己
@property (nonatomic, copy) NSString *agency_uid;

//班组id
@property (nonatomic, copy) NSString *group_id;

@end

@interface MateWorkitemsAccounts_Type : TYModel

@property (nonatomic, copy) NSString *txt;

/**
 *  code:1:点工 2:包工 3:借支
 */
@property (nonatomic, assign) NSInteger code;

@end

