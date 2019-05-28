//
//  YZGWageBestDetailModel.h
//  mix
//
//  Created by Tony on 16/3/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYModel.h"
#import "YZGMateWorkitemsModel.h"

@class WageBestDetailPro_List,WageBestDetailWorkday,MateWorkitemsAccounts_Type;
@interface YZGWageBestDetailModel : TYModel

@property (nonatomic, assign) NSInteger m_total;

@property (nonatomic, copy) NSString *month_total_txt;

@property (nonatomic, copy) NSString *month_txt;

@property (nonatomic, strong) NSArray<WageBestDetailWorkday *> *workday;

@property (nonatomic, strong) NSArray<WageBestDetailPro_List *> *pro_list;

@end
@interface WageBestDetailPro_List : TYModel

@property (nonatomic, assign) NSInteger pid;

@property (nonatomic, copy) NSString *pro_name;

@end

@interface WageBestDetailWorkday : TYModel

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *date_txt;

@property (nonatomic, assign) NSInteger uid;

@property (nonatomic, copy) NSString *date_turn;

@property (nonatomic, assign) CGFloat amounts;

@property (nonatomic, strong) MateWorkitemsAccounts_Type *accounts_type;

@property (nonatomic, copy) NSString *manhour;

@property (nonatomic, copy) NSString *overtime;

@property (nonatomic, assign) NSInteger pid;

@property (nonatomic, copy) NSString *sub_pro_name;

@property (nonatomic, assign) NSInteger amounts_diff;

@property (nonatomic, assign) NSInteger modify_marking;
@end




