//
//  YZGRecordWorkpointsWaterModel.h
//  mix
//
//  Created by celion on 16/2/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Accounts_Type;

@interface YZGRecordWorkpointsWaterModel : NSObject

@property (nonatomic, assign) CGFloat total_expend;

@property (nonatomic, assign) CGFloat total_income;

@property (nonatomic, strong) NSMutableArray *workday;

@property (nonatomic, assign) CGFloat total;

@end

@interface WorkdayModel : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) CGFloat amounts;

@property (nonatomic, assign) NSInteger fuid;

@property (nonatomic, strong) Accounts_Type *accounts_type;

@property (nonatomic, assign) NSInteger date;

@property (nonatomic,copy) NSString *date_turn;

@property (nonatomic, assign) NSInteger wuid;

@property (nonatomic, copy) NSString *manhour;

@property (nonatomic, copy) NSString *overtime;

@property (nonatomic, assign) NSInteger role;

@property (nonatomic, copy) NSString *pro_name;

@property (nonatomic, assign) BOOL amounts_diff;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *sub_pro_name;

@end

@interface Accounts_Type : NSObject

@property (nonatomic, copy) NSString *txt;

@property (nonatomic, assign) NSInteger code;

@end

