//
//  JGJSynAddressBookVC.h
//  mix
//
//  Created by celion on 16/5/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YZGAddContactsHUBView.h"

typedef enum : NSUInteger {
    AddressBookAddSynModelButton = 1, //同步账单点击按钮
    AddressBookAddWorkerButton //记工记账的模型进入通信录点击添加按钮弹出的类型
} AddressBookAddButtonType;

typedef void(^AddSynContactsBlock)(JGJSynBillingModel *);
@interface JGJSynAddressBookVC : UIViewController
@property (strong, nonatomic) NSMutableArray *synBillingModels;//存储同步账单管理的人员
@property (strong, nonatomic) NSMutableArray *selelctedModels;//存储已选中的数据和当前的人员作比较
@property (copy, nonatomic) AddSynContactsBlock addSynModelBlock;//返回添加的同步联系人
@property (nonatomic, strong) JGJSynBillingCommonModel *synBillingCommonModel;
@property (assign, nonatomic) AddressBookAddButtonType addressBookAddButtonType;//点击添加按钮类型
@property (strong, nonatomic) NSMutableArray *dataArray;

/**
 *  聊天界面传入的model,如果有就是聊天
 */
@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;

//3.2.0添加同步类型
@property (nonatomic, assign) YZGAddContactsHUBViewType hubViewType;

@property (nonatomic, copy) NSString *contractor_type; //1，//承包 2:分包

@end
