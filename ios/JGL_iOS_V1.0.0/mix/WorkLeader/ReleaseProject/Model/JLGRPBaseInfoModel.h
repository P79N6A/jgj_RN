//
//  JLGRPBaseInfoModel.h
//  mix
//
//  Created by jizhi on 15/12/2.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "TYModel.h"

@class Protype,Region,RPBaseClasses;
@interface JLGRPBaseInfoModel : TYModel

@property (nonatomic ,assign) NSInteger money;
@property (nonatomic, strong) Protype *protype;

@property (nonatomic, copy) NSString *proaddress;

@property (nonatomic, strong) NSMutableArray<RPBaseClasses *> *classes;

@property (nonatomic, copy) NSString *proname;

@property (nonatomic, assign) NSInteger timelimit;

@property (nonatomic, copy) NSString *protitle;

@property (nonatomic, copy) NSString *prolocation;

@property (nonatomic, strong) NSArray<NSString *> *welfares;

@property (nonatomic, assign) NSInteger cooperate_type;

@property (nonatomic, strong) Region *region;

@property (nonatomic, assign) NSInteger valid_date;

@property (nonatomic, assign) NSInteger prepay;

@property (nonatomic, assign) NSInteger pid;

@property (nonatomic, copy) NSString *prodescrip;

@property (nonatomic, assign) NSInteger find_role;

@property (nonatomic, assign) NSInteger total_area;

@property (nonatomic, copy) NSString *regionName;//显示的城市

@property (nonatomic, copy) NSString *worktypeName;//取出所有workType拼接的数据
@end

@interface Protype : TYModel

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger code;

@end

@interface Region : TYModel

@property (nonatomic, strong) NSArray<NSString *> *name;

@property (nonatomic, assign) NSInteger code;

@end

@interface RPBaseClasses : TYModel

@property (nonatomic, copy) NSString *balanceway;

@property (nonatomic, copy) NSString *money;

@property (nonatomic, assign) NSInteger worklevel;

@property (nonatomic, assign) NSInteger cooperate_range;

@property (nonatomic, copy) NSString *person_count;

@property (nonatomic, copy) NSString *worktype;

@property (nonatomic, copy) NSString *worktypeName;

@end

