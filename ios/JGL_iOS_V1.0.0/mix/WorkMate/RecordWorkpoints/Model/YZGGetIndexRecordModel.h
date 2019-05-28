//
//  YZGGetIndexRecordModel.h
//  mix
//
//  Created by Tony on 16/3/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYModel.h"
#import "YZGMateWorkitemsModel.h"

@interface YZGGetIndexRecordModel : TYModel

@property (nonatomic, assign) CGFloat total_expend;

@property (nonatomic, assign) CGFloat total_income;

@property (nonatomic, strong) NSArray *workday;

@property (nonatomic, assign) CGFloat total;
@property (nonatomic, assign) CGFloat total_balance;

@property (nonatomic, strong) NSMutableArray *selectedArray;
@end

