//
//  YZGShowpoorModel.h
//  mix
//
//  Created by Tony on 16/2/29.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYModel.h"

@interface YZGShowpoorModel : TYModel

@property (nonatomic, assign) NSInteger second_role;

@property (nonatomic, assign) NSInteger main_set_amount;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger main_role;

@property (nonatomic, copy) NSString *second_name;

@property (nonatomic, assign) NSInteger second_set_amount;

@property (nonatomic, assign) NSInteger main_overtime;

@property (nonatomic, copy) NSString *main_name;

@property (nonatomic, assign) NSInteger second_manhour;

@property (nonatomic, assign) NSInteger second_overtime;

@property (nonatomic, assign) NSInteger main_manhour;

@end
