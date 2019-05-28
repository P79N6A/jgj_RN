//
//  JGJNewMarkBillProjectModel.h
//  mix
//
//  Created by Tony on 2018/6/4.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJNewMarkBillProjectModel : NSObject

@property (nonatomic, strong) NSString *pro_id;// 项目id
@property (nonatomic, strong) NSString *pro_name;// 项目名称
@property (nonatomic, assign) BOOL isEditeStating;// 是否在编辑状态
@property (nonatomic, copy) NSString *is_create_group;// 该项目是否创建了班组
@end
