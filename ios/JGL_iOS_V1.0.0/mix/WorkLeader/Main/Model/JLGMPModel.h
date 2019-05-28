//
//  JLGMPModel.h
//  mix
//
//  Created by jizhi on 15/12/7.
//  Copyright © 2015年 JiZhi. All rights reserved.
//


#import "JLGFindProjectModel.h"

@interface JLGMPModel :JLGFindProjectModel

@property (nonatomic, assign) NSInteger region;

@property (nonatomic, assign) NSInteger find_role;

@property (nonatomic, assign) NSInteger enroll_num;

@property (nonatomic, assign) NSInteger is_full;//0是已招满，1是未招满
@end



