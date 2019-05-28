//
//  JGJUnWagesShortWorkVc.h
//  mix
//
//  Created by yj on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BatchModifyTinySuccessBlock)();

@interface JGJUnWagesShortWorkVc : UIViewController

//记账人的id，自己的id不需要传
@property (nonatomic, copy) NSString *uid;

@property (nonatomic, assign) BOOL isMarkBillGoIn;// 是否从记单人界面进入

//批量修改点工成功
@property (nonatomic, copy) BatchModifyTinySuccessBlock modifyTinySuccessBlock;
@end
