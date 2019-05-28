//
//  JGJPersonWageListModel.h
//  mix
//
//  Created by Tony on 2016/7/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYModel.h"

@class PersonWageListList,PersonWageListListList;
@interface JGJPersonWageListModel : TYModel

@property (nonatomic, assign) CGFloat total_manhour;

@property (nonatomic, assign) CGFloat total_overtime;

@property (nonatomic, assign) CGFloat total_expend;

@property (nonatomic, assign) CGFloat total_income;

@property (nonatomic, assign) CGFloat total;
@property (nonatomic, assign) CGFloat total_balance;
@property (nonatomic, strong) NSString *class_type;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSArray<PersonWageListList *> *list;

@end

@interface PersonWageListList : NSObject

@property (nonatomic, assign) NSInteger year;

@property (nonatomic, strong) NSArray<PersonWageListListList *> *list;

@end

@interface PersonWageListListList : NSObject
/**
 *  月份
 */
@property (nonatomic, copy) NSString *month;
/**
 *  结算
 */
@property (nonatomic, assign) CGFloat total_balance;

/**
 *  差账比数
 */
@property (nonatomic, assign) NSInteger t_poor;

/**
 *  应收总和
 */
@property (nonatomic, assign) CGFloat total_income;

/**
 *  借支总和
 */
@property (nonatomic, assign) CGFloat total_expend;

/**
 *  余额
 */
@property (nonatomic, assign) CGFloat total;

/**
 *  上班总工时
 */
@property (nonatomic, assign) CGFloat total_manhour;

/**
 *  加班总工时
 */
@property (nonatomic, assign) CGFloat total_overtime;

/**
 *  所有账单里面最大的工时
 */
@property (nonatomic, assign) CGFloat total_maxManhour;
@end

