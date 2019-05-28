//
//  JGJQRecordViewController.h
//  mix
//
//  Created by Tony on 2017/2/28.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLGDatePickerView.h"
#import "YZGGetBillModel.h"
#import "YZGAddContactsTableViewCell.h"
typedef void(^JGJMarkBillQueryproBlock)(void);

@interface JGJQRecordViewController : UIViewController
@property (strong, nonatomic) IBOutlet UICollectionView *RecordCollectionView;
@property (nonatomic ,strong) UISegmentedControl *segmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segment;
//默认时间
@property (nonatomic,strong) NSDate *selectedDate;
@property (nonatomic,strong) JLGDatePickerView *jlgDatePickerView;
@property (nonatomic,strong) YZGGetBillModel *yzgGetBillModel;

@property (nonatomic,strong) NSMutableArray *addForemandataArray;

@property (nonatomic,strong) YZGAddForemanModel *addForemanModel;

@property (nonatomic,strong) NSMutableDictionary *parametersDic;

@property (nonatomic,strong) NSMutableArray *imagesArray;
//班组传进来的数据
@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;
//填写单位和数量
@property (nonatomic,strong) JGJFilloutNumModel *fillOutModel;

/**
 *  判断是不是从聊天界面进入记账
 */
@property (nonatomic,assign) BOOL ChatType;
/**
 *  该不该初始化薪资模板
 */
@property (nonatomic,assign) BOOL getTpl;
/**
 *  是不是应该记录首次进入进入记账的状态
 */
@property (nonatomic,assign) BOOL firstRecod;
/**
 *  判断是不是从记多人界面进入
 */
@property (nonatomic,assign) BOOL recordMore;
/**
 *  判断是不是从记账首页进入
 */
@property (nonatomic,assign) BOOL Mainrecord;
/**
 *  1表示工人，2表示班组长/工头，0表示没有设置，直接用当前的身份
 */
@property (nonatomic,assign) NSInteger roleType;

/*
*
* 遮罩
*
*/


//刷新数据

- (void)ModifySalaryTemplateData;
/**
 *  查询项目
 *
 *  @param queryproBlock 查询完项目以后的操作
 */
-(void)querypro:(JGJMarkBillQueryproBlock )queryproBlock;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstance;

@end
