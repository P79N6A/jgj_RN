//
//  YZGRecordWorkpointTool.h
//  mix
//
//  Created by Tony on 16/3/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZGRecordWorkpointTool : NSObject
/**
 *  设置富文本
 *
 *  @param label  需要进行设置的label
 *  @param manHour  上面需要显示的string
 *  @param overHour 下面需要显示的string
 *
 *  @return 计算出的富文本
 */
+ (void )setLabel:(UILabel *)label topString:(NSString *)topString bottomString:(NSString *)bottomString;

/**
 *  获取点工的富文本
 *
 *  @param label  需要进行设置的label
 *  @param manHour  正常工作时间
 *  @param overHour 加班时间
 *
 *  @return 计算出的富文本
 */
+ (void )setLabel:(UILabel *)label manHour:(NSString *)manHour overhour:(NSString *)overHour;

/**
 *  传入价格，设置颜色和金额
 *
 *  @param label   需要设置的label
 *  @param amounts 需要计算的金额,如果是小数，获取的值是这样的"￥-abc"
 */
+ (void)setLabel:(UILabel *)label amount:(CGFloat )amounts;

/**
 *  传入价格，设置颜色和金额
 *
 *  @param label   需要设置的label
 *  @param amounts 需要计算的金额,如果是小数，获取的值是这样的"-￥abc"
 */
+ (void)setFabsLabel:(UILabel *)label amount:(CGFloat )amounts;

/**
 *  获取V1.4默认的提示的cell
 *
 *  @param tableView 传入的tableView
 *
 *  @return 返回的cell 高度30比较合适
 */
+ (UITableViewCell *)getJGJTipCell:(UITableView *)tableView;
@end
