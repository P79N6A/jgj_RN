//
//  YZGAddForemanAndMateViewController.h
//  mix
//
//  Created by Tony on 16/3/12.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGAddContactsTableViewCell.h"

@interface YZGAddForemanAndMateViewController : UIViewController
@property (nonatomic,strong) YZGAddForemanModel *addForemanModel;
@property (nonatomic,strong) NSMutableArray <YZGAddForemanModel *> *dataArray;

/**
 *  聊天界面传入的model,如果有就是聊天
 */
@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomDistance;

@property (nonatomic,strong) NSString *recordType;

@property (nonatomic,assign) BOOL modifySelect;//修改界面选择人

@end

