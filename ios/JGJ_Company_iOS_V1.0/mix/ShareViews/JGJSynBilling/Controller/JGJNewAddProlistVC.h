//
//  JGJNewAddProlistVC.h
//  mix
//
//  Created by celion on 16/5/24.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JGJNewAddProlistBlock)(NSArray *);

typedef void(^JGJSynProListSuccessBlock)(id);

@interface JGJNewAddProlistVC : UIViewController

@property (nonatomic, strong)  JGJSynBillingModel *synBillingModel;

@property (nonatomic, copy) JGJNewAddProlistBlock addProlistBlock;

@property (strong, nonatomic) NSArray *dataSource;

//工作消息同步项目成功回调
@property (copy, nonatomic) JGJSynProListSuccessBlock synProListSuccessBlock;

@property (nonatomic, assign) BOOL isWorkVCComeIn;// v3.4 是否从工作消息跳进去
@end
