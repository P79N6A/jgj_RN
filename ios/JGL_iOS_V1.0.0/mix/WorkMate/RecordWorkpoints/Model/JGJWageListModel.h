//
//  JGJWageListModel.h
//  mix
//
//  Created by Tony on 2016/7/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYModel.h"

@interface JGJWageListModel : TYModel
@property (nonatomic, assign) CGFloat total_manhour;

@property (nonatomic, assign) CGFloat total_overtime;

@property (nonatomic, assign) NSInteger cur_uid;

@property (nonatomic, assign) NSInteger target_id;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) CGFloat total;
@property (nonatomic, copy) NSString *class_type;

@end
