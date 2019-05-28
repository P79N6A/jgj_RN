//
//  JGJMarkBillBaseVc.h
//  mix
//
//  Created by 任涛 on 16/6/6.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "UIPhotoViewController.h"

#import "TYFMDB.h"
#import "NSDate+Extend.h"
#import "TYShowMessage.h"
#import "JLGPickerView.h"
#import "SMCustomSegment.h"
#import "KeyboardManager.h"
#import "YZGGetBillModel.h"
#import "SMCustomSegment.h"
#import "JLGDatePickerView.h"
#import "YZGMateWorkitemsModel.h"
#import "JGJOtherInfoViewController.h"
#import "YZGAudioAndPicTableViewCell.h"
#import "YZGGetBillMoneyTableViewCell.h"
#import "YZGRecordWorkBaseInfoTableViewCell.h"
#import "YZGRecordWorkInputInfoTableViewCell.h"

static const NSInteger MarkBillDefaultManhour = -1;//默认的上班时间，因为工作时间有休息的状态，所以默认情况下，状态为-1，需要判断
static const NSInteger MarkBillDefaultOverhour = -1;//默认的加班时间，因为工作时间有无加班的状态，所以默认情况下，状态为-1，需要判断
//使用IQKeyBoardManager
#define UseIQKeyBoardManager YES

//保存数据的文件
#define JGJMarkDayBaseInfoFile [TYUserDocumentPaths stringByAppendingString:@"/JGJMarkDayBaseInfo.jgj"]

@class JGJMarkBillBaseVc,YZGAddForemanModel;

typedef void(^JGJMarkBillQueryproBlock)(void);

typedef enum : NSUInteger {
    MarkBillTypeNewBill = 0,//新的记账
    MarkBillTypeEdit,//编辑记账
    MarkBillTypeChat//从聊天界面进来的记账
} MarkBillType;
@protocol JGJMarkBillBaseVcDelegate <NSObject>
@optional
- (void)MateGetBillPush:(JGJMarkBillBaseVc *)mateGetBillVc ByVc:(UIViewController *)Vc;
- (void)MateGetBillPresentView:(UIViewController *)Vc getBillVc:(JGJMarkBillBaseVc *)mateGetBillVc;
- (void)MateGetBillPopView:(UIViewController *)Vc getBillVc:(JGJMarkBillBaseVc *)mateGetBillVc;
@end

@interface JGJMarkBillBaseVc : UIPhotoViewController
<
    UITableViewDelegate,
    UITableViewDataSource,
    JLGDatePickerViewDelegate,
    YZGGetBillMoneyTableViewCellDelegate,
    YZGRecordWorkBaseInfoTableViewCellDelegate
>
@property (nonatomic , weak) id<JGJMarkBillBaseVcDelegate> delegate;

@property (nonatomic,strong) YZGAddForemanModel *addForemanModel;
@property (nonatomic,strong) NSMutableArray *addForemandataArray;
@property (nonatomic,assign) BOOL isNeedRecordAgain;//是否需要再记账
@property (nonatomic,strong) NSDate *selectedDate;
@property (nonatomic,strong) JLGPickerView *jlgPickerView;
@property (nonatomic,strong) NSMutableArray *cellDataArray;
@property (nonatomic,strong) NSMutableArray *deleteImgsArray;
@property (nonatomic,strong) NSMutableDictionary *parametersDic;
@property (nonatomic,assign) BOOL disappear;//YES,消失,NO:没有消失
@property (nonatomic,assign) MarkBillType markBillType;
@property (nonatomic,strong) JLGDatePickerView *jlgDatePickerView;
@property (nonatomic,strong) YZGAudioAndPicTableViewCell *audioCell;
@property (nonatomic,copy)   NSString *identityString;//标识身份的字符串
@property (nonatomic,strong) NSIndexPath *proNameIndexPath;//所在项目的indexPath
@property (nonatomic,strong) NSIndexPath *noteIndexPath;//备注的indexPath
@property (nonatomic,strong) NSIndexPath *startTimeIndexPath;//开工的indexPath
@property (nonatomic,strong) NSIndexPath *endTimeIndexPath;//完工的indexPath
@property (nonatomic,strong) NSMutableDictionary *oldYOffsetDic;//记录上一次的偏移值

@property (strong, nonatomic)  UITableView *tableView;
@property (strong, nonatomic)  NSLayoutConstraint *bottomViewBottomH;

//上级界面传进来的model
@property (nonatomic,strong) MateWorkitemsItems *mateWorkitemsItems;
//本界面使用的model
@property (nonatomic,strong) YZGGetBillModel *yzgGetBillModel;
/*
 *2.3.0添加记账新需求用于区分是不是修改了记账信息后点击保存
 */
@property (nonatomic,strong) YZGGetBillModel *oldBillyzgGetBillModel;

//记录记账类型
@property (nonatomic,assign) NSInteger accountTypeCode;
//记账的id
@property (nonatomic,copy) NSString *record_id;
//当前身份
@property (nonatomic,assign) BOOL JGJisMateBool;
//是不是推送进来的
@property (nonatomic,assign) BOOL sendMsgType;

@property (nonatomic,assign) BOOL deleteImage;


#warning 因为markBillType为MarkBillTypeEidt的时候界面不好修改，所以增加这个字段，也是用于聊天的判断，主要用于接口调用的判断
@property (nonatomic,assign) BOOL isChat;

/**
 *  聊天界面传入的model
 */
@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;

/**
 *  根据类型获取控制器
 */
+ (instancetype)getSubVc:(MateWorkitemsItems *)mateWorkitemsItems;

- (void)dataInit;
- (void)cellDataInit;

/**
 *  获取正常账单
 */
- (void)JLGHttpRequest;

/**
 *  查询薪资模板
 */
- (void)JLGHttpRequest_QueryTpl;

/**
 *  登录第一次以后显示的使用说明
 */
- (void)firstShowUseIntroductions:(SMCustomSegment *)segmentView;


/**
 *  转换城项目需要的时间格式
 *
 *  @param date 传入的时间
 *
 *  @return 返回的字符串
 */
- (NSString *)getWeekDaysString:(NSDate *)date;
    
/**
 *  使用说明
 */
- (void)UseIntroductionsDisPlay:(CGFloat )yOffest;

- (void)UseIntroductionsDisPlay:(CGFloat )yOffest segMentView:(SMCustomSegment *)segmentView;


/**
 *  跳转到备注界面
 */
- (void)goToOtherInfoVc;

/**
 *  错误提示信息
 *
 *  @return
 */
- (BOOL )showErrorMessage;

/**
 *  保存数据到服务器
 */
- (void)saveDataToServer;

/**
 *  提交数据到服务器，用于子类重写
 *
 *  @param parametersDic 参数Dic
 *  @param dataArray     需要上传的数据数组
 *  @param dataNameArray 需要上传的数据名字的数组
 */
- (void)ModifyRelase:(NSDictionary *)parametersDic dataArray:(NSArray *)dataArray dataNameArray:(NSArray *)dataNameArray;

/**
 *  修改了金额的设置
 */
- (void)ModifySalaryTemplateData;

/**
 *  弹出项目名称
 */
- (void)showProjectPickerByIndexPath:(NSIndexPath *)indexPath;

/**
 *  点工点击cell的配置
 *
 *  @param indexPath indexPath
 */
- (void)dayWorkDidSelectIndexPath:(NSIndexPath *)indexPath;

/**
 *  包工点击cell的配置
 *
 *  @param indexPath indexPath
 */
- (void)contractWorkDidSelectIndexPath:(NSIndexPath *)indexPath;

/**
 *  借支点击cell的配置
 *
 *  @param indexPath indexPath
 */
- (void)borrowingWorkDidSelectIndexPath:(NSIndexPath *)indexPath;

#if TYKeyboardObserver
/**
 *  根据系统键盘Y的偏移量执行时间为duration的动画
 *
 *  @param yOffset  Y的偏移量
 *  @param duration 动画时间
 */
- (void)MarkBillKeyboradChangeYOffset:(CGFloat )yOffset duration:(double) duration;
#endif

/**
 *  增加项目
 *
 *  @param proName 增加的项目:@{@"pid":@"",@"pro_name":@""};
 */
- (void)addProNameByName:(NSDictionary *)proNameDic;

/**
 *  刷新备注信息
 */
- (void )RefreshOtherInfo;

/**
 *  获取对应的cell,给子类重写
 *
 *  @param cell      传入的cell
 *  @param tableView 传入的tableView
 *  @param indexPath 传入的indexPath
 *
 *  @return 返回的cell
 */
- (UITableViewCell *)getCell:(UITableViewCell *)cell tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;


/**
 *  配置点工的nextCell
 */
- (YZGRecordWorkNextVcTableViewCell *)configDayNextVcCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

/**
 *  配置包工的nextCell
 */
- (YZGRecordWorkNextVcTableViewCell *)configContractNextVcCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

/**
 *  配置借支的nextCell
 */
- (YZGRecordWorkNextVcTableViewCell *)configBorrowingNextVcCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

/**
 *  配置Money Cell
 */
- (YZGGetBillMoneyTableViewCell *)configureMoneyCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

/**
 *  配置next Cell
 */
- (YZGRecordWorkNextVcTableViewCell *)configureNextVcCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

/**
 *  获取项目名的indexPath,用于子类重写
 */
- (NSIndexPath *)getProNameIndexPath;

/**
 *  是否需要进入新增项目
 */
- (BOOL)isAddNewProName:(NSIndexPath *)indexPath;

/**
 *  在编辑状态下保存数据
 */
- (void)saveDataTOServerInEidt;

/**
 *  择时间控件弹出
 *
 *  @param indexPath 对应的indexPath
 */
- (void)showDatePickerByIndexPath:(NSIndexPath *)indexPath;

/**
 *  获取总金额
 *
 *  @return
 */
- (CGFloat)getSalary;

/**
 *  增加键盘监控
 */
- (void)addKeyBoardObserver;

/**
 *  移除键盘监控
 */
- (void)removeKeyBoardObserver;

/**
 *  查询项目
 *
 *  @param queryproBlock 查询完项目以后的操作
 */
-(void)querypro:(JGJMarkBillQueryproBlock )queryproBlock;


/**
 * 如果删除的项目是选中的项目，清除状态
 *
 *  @param pid 删除的pid
 */
-(void)deleteSelectProByPid:(NSInteger )pid;


/**
 * 设置姓名的颜色
 *
 */
- (UIColor *)setNameColorBy:(NSString *)detailStr defaultStr:(NSString *)defaultStr;

- (void)hiddenRecordWorkPointGuideView;
@end
