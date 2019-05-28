//
//  YZGGetBillMoneyTableViewCell.h
//  mix
//
//  Created by Tony on 16/3/4.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYTextField.h"
#import "YZGGetBillModel.h"
#import "YZGMateWorkitemsModel.h"


@class YZGGetBillMoneyTableViewCell;
@protocol YZGGetBillMoneyTableViewCellDelegate <NSObject>
@optional
- (void)GetBillMoneyReturn:(YZGGetBillMoneyTableViewCell *)cell;
- (void)GetBillMoneyBeginEditing:(YZGGetBillMoneyTableViewCell *)cell;
- (void)GetBillMoneyEndEditing:(YZGGetBillMoneyTableViewCell *)cell detailStr:(NSString *)detailStr;
- (void)GetBillMoneyChangeCharacters:(YZGGetBillMoneyTableViewCell *)cell detailStr:(NSString *)detailStr;
- (void)GetBillSelectedDate:(YZGGetBillMoneyTableViewCell *)cell;
- (void)tapBillMoneyLable;

@end

@interface YZGGetBillMoneyTableViewCell : UITableViewCell
@property (nonatomic , weak) id<YZGGetBillMoneyTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet LengthLimitTextField *billMoneyTF;
//是否需要在viewDidLoad里面从服务器获取数据,YES:不需要,就是发布项目;NO,需要,就是修改项目
@property (nonatomic,assign ) BOOL notGetBillDidLoad;
@property (strong, nonatomic) IBOutlet UIImageView *pushImageView;//推送进入显示图标

@property (nonatomic,strong) YZGGetBillModel *yzgGetBillModel;

/**
 *  将date转换为对应的字符串
 *
 *  @param date 需要转换的date
 *
 *  @return 转换完以后的字符串
 */
- (NSString *)getWeekDaysString:(NSDate *)date;

///**
// *  设置帮助的文本
// *
// *  @param helperLabelText 具体内容
// */
//-(void)setHelperLabelText:(NSString *)helperLabelText;

/**
 *  设置moneyTF是否可用
 *
 *  @param enabel 是否可用,YES:可用,NO:不可用
 */
- (void)setMoneyTFEnabel:(BOOL )enabel;

/**
 *  设置数据,金额显示的是红色
 *
 *  @param title 标题
 *  @param time  时间
 *  @param money 金额
 */
- (void)setTitle:(NSString *)title setTime:(NSString *)time setRedMoney:(NSString *)money;

/**
 *  设置数据,金额显示的是蓝色
 *
 *  @param title 标题
 *  @param time  时间
 *  @param money 金额
 */
- (void)setTitle:(NSString *)title setTime:(NSString *)time setBlueMoney:(NSString *)money;
@end
