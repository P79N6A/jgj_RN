//
//  JGJContractorSubentryModel.h
//  mix
//
//  Created by Tony on 2019/2/13.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJContractorSubentryModel : NSObject

@property (nonatomic, copy) NSString *subentryName;// 分项名称
@property (nonatomic, assign) CGFloat subentryUnitePrice;// 分项单价
@property (nonatomic, assign) CGFloat subentryAccount;// 分项数量
@property (nonatomic, assign) double subentryMoney;// 分项包工工钱
@property (nonatomic, copy) NSString *units;//分项包工单位
@property (nonatomic, copy) NSString *tpl_id;// 包工模板id

@end
