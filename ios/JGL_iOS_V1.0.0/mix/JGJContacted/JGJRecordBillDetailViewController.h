//
//  JGJRecordBillDetailViewController.h
//  mix
//
//  Created by Tony on 2017/9/24.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGMateWorkitemsModel.h"
@interface JGJRecordBillDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstance;


@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) MateWorkitemsItems *mateWorkitemsItems;

@property (nonatomic,assign) BOOL sendMsgType;

@property (nonatomic,assign) BOOL JGJisMateBool;

@property (nonatomic,assign) BOOL isChat;
/*
 *已经记过帐弹框跳转到详情界面然后删除返回
 */
@property (nonatomic,assign) BOOL showViewBool;

@property (nonatomic, assign) BOOL is_currentSureBill_come_in;

@end
