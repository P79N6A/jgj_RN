//
//  JGJSubentryListModel.h
//  mix
//
//  Created by Tony on 2019/2/19.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJSubentryListModel : NSObject

@property (nonatomic, copy) NSString *tpl_id;// 模板id
@property (nonatomic, copy) NSString *sub_pro_name;//分项目名称
@property (nonatomic, copy) NSString *units;//包工数量单位名称
@property (nonatomic, copy) NSString *set_unitprice;//单价

@end
