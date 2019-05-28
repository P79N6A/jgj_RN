//
//  JGJSignRequestModel.h
//  mix
//
//  Created by yj on 2018/8/20.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJSignRequestModel : NSObject

@property (nonatomic, assign) NSInteger pg;

@property (nonatomic, assign) NSInteger pagesize;

@property (nonatomic, copy) NSString *group_id; //班组id

@property (nonatomic, copy) NSString *class_type; //班组类型

@property (nonatomic, copy) NSString *uid;

@end
