//
//  JGJWorkTplHaveDiffAlertView.h
//  mix
//
//  Created by Tony on 2018/12/17.
//  Copyright © 2018 JiZhi. All rights reserved.
//  陈超 v3.4.2 工资模板差异弹窗

#import <UIKit/UIKit.h>
#import "CommonModel.h"
#import "JGJMarkBillCommonHeaderView.h"
typedef void(^CancleBlock)(void);
typedef void(^AgreeBlock)(void);
@interface JGJWorkTplHaveDiffAlertView : UIView

@property (nonatomic, copy) CancleBlock cancle;
@property (nonatomic, copy) AgreeBlock agree;

@property (assign ,nonatomic) JGJMarkSelectBtnType markSlectBtnType;
@property (nonatomic, strong) JGJGetWorkTplByUidModel *difTplBill;

- (void)show;
@end
