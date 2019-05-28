//
//  JGJModifyInfoVc.h
//  mix
//
//  Created by yj on 2018/6/11.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJAddAccountMemberInfoVc.h"

#import "JGJAccountComDesModel.h"

#import "JGJMemberMangerModel.h"

typedef void(^JGJModifyInfoBlock)(JGJCommonInfoDesModel *desModel);

@interface JGJModifyInfoVc : JGJAddAccountMemberInfoVc

@property (nonatomic, copy) JGJModifyInfoBlock modifyInfoBlock;

@property (nonatomic, strong) JGJSynBillingModel *memberModel;

@property (nonatomic, strong) JGJMemberMangerModel *mangerModel;
@end
