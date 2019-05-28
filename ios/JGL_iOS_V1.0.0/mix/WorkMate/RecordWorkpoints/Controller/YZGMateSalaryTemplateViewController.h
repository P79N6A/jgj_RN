//
//  YZGMateSalaryTemplateViewController.h
//  mix
//
//  Created by Tony on 16/3/7.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGGetBillModel.h"

@interface YZGMateSalaryTemplateViewController : UIViewController
@property (nonatomic,strong) YZGGetBillModel *yzgGetBillModel;//保存传入的数据，并且该数据是上一个界面的数据

@property (nonatomic,assign) BOOL superViewIsGroup;//上个界面是不是组合界面，YES:是，NO，不是
@property (nonatomic,assign) BOOL morepeple;//多人记账界面跳转

@end
