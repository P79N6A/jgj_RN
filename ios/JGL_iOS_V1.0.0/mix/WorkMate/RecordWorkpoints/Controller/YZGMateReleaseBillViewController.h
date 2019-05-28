//
//  YZGMateReleaseBillViewController.h
//  mix
//
//  Created by Tony on 16/3/1.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJMarkBillBaseVc.h"

@class YZGAddForemanModel;
@interface YZGMateReleaseBillViewController : UIViewController

/**
 *  聊天界面传入的model
 */
@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;

@property (nonatomic,strong) NSDate *selectedDate;

/**
 *  1表示工人，2表示班组长/工头，0表示没有设置，直接用当前的身份
 */
@property (nonatomic,assign) NSInteger roleType;
@property (nonatomic,strong) YZGAddForemanModel *addForemanModel;
@property (nonatomic,strong) NSMutableArray *addForemandataArray;

/**
 *  获取子Vc
 *
 *  @return 返回子Vc
 */
- (UIViewController *)getSubViewController;

- (void)ModifySalaryTemplateData;

/**
 *  刷新备注信息
 */
- (void )RefreshOtherInfo;

/**
 *  查询项目
 *
 *  @param queryproBlock 查询完项目以后的操作
 */
- (void)querypro:(JGJMarkBillQueryproBlock )queryproBlock;

/**
 * 如果删除的项目是选中的项目，清除状态
 *
 *  @param pid 删除的pid
 */
-(void)deleteSelectProByPid:(NSInteger )pid;
@end
