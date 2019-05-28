//
//  JGJRecordBillDetailBottomView.h
//  mix
//
//  Created by Tony on 2018/6/5.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ModifyBill)(void);
typedef void(^DeleteBill)(void);
@interface JGJRecordBillDetailBottomView : UIView

@property (nonatomic, copy) ModifyBill modifyBill;
@property (nonatomic, copy) DeleteBill deleteBill;
@property (nonatomic, strong) UIView *topLine;

@end
