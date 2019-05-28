//
//  YZGWageMoreDetailModel.h
//  mix
//
//  Created by Tony on 16/3/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYModel.h"

@class WageMoreDetailList;
@interface YZGWageMoreDetailModel : TYModel

@property (nonatomic, copy) NSString *month_total_txt;

@property (nonatomic, copy) NSString *month_txt;

@property (nonatomic, strong) NSArray<WageMoreDetailList *> *list;

@property (nonatomic, assign) NSInteger m_total;

@end

@interface WageMoreDetailList : TYModel

@property (nonatomic, assign) NSInteger total_poor;

@property (nonatomic, copy) NSString *pname;

@property (nonatomic, assign) NSInteger uid;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger pid;

@property (nonatomic, assign) CGFloat t_total;

@property (nonatomic, assign) CGFloat t_poor;

@end

