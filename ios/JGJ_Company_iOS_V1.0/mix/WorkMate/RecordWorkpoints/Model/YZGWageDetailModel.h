//
//  YZGWageDetailModel.h
//  mix
//
//  Created by Tony on 16/3/17.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYModel.h"

typedef NS_ENUM(NSUInteger, WageDetailFilterType) {
    WageDetailFilterPeople = 1,//人
    WageDetailFilterProject = 2//项目
};

@class WageDetailValues,WageDetailList;
@interface YZGWageDetailModel : TYModel

@property (nonatomic, assign) NSInteger unwindNum;//第几个是展开的,主要起记录作用
@property (nonatomic, strong) NSArray<WageDetailValues *> *values;
@property (nonatomic, assign) CGFloat maxTotalValue;
@end
@interface WageDetailValues : TYModel

@property (nonatomic, assign) NSInteger year;

@property (nonatomic, assign) NSInteger month;

@property (nonatomic, assign) NSInteger cur_uid;

@property (nonatomic, strong) NSArray<WageDetailList *> *list;

@property (nonatomic, assign) CGFloat m_total_expend;

@property (nonatomic, assign) CGFloat m_total_income;

@property (nonatomic, assign) CGFloat m_total;

@property (nonatomic, assign) BOOL isSelected;
@end

@interface WageDetailList : TYModel

@property (nonatomic, assign) NSInteger t_poor;

@property (nonatomic, assign) CGFloat t_total;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger pid;

@property (nonatomic, assign) NSInteger uid;
@end

