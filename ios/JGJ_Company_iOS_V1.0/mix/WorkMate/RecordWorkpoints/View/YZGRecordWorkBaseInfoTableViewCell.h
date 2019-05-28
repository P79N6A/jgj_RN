//
//  YZGRecordWorkBaseInfoTableViewCell.h
//  mix
//
//  Created by Tony on 16/3/4.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJUITableViewCell.h"
#import "TYTextField.h"
@class YZGRecordWorkBaseInfoTableViewCell;

@protocol YZGRecordWorkBaseInfoTableViewCellDelegate <NSObject>
@optional
- (void)RecordWorkBaseInfoShouldChange:(YZGRecordWorkBaseInfoTableViewCell *)cell;
- (void)RecordWorkBaseInfoReturn:(YZGRecordWorkBaseInfoTableViewCell *)cell;
- (void)RecordWorkBaseInfoBeginEditing:(YZGRecordWorkBaseInfoTableViewCell *)cell;
- (BOOL)RecordWorkBaseInfoShouldBeginEditing:(YZGRecordWorkBaseInfoTableViewCell *)cell;
- (void)RecordWorkBaseInfoEndEditing:(YZGRecordWorkBaseInfoTableViewCell *)cell detailStr:(NSString *)detailStr;
@end

@interface YZGRecordWorkBaseInfoTableViewCell : JGJUITableViewCell
@property (nonatomic , weak) id<YZGRecordWorkBaseInfoTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet LengthLimitTextField *detailTF;

@property (nonatomic,strong) NSIndexPath *indexPath;
/**
 *  设置detail是否只能输入数字
 *
 *  @param isOnlyNum YES:只能输入数字,NO:没有限制
 */
- (void)setDetailIsOnlyNum:(BOOL )isOnlyNum;

/**
 *  3.25设置数字带有小数点
 */
- (void)setDetailIsOnlyDecimalPad;
/**
 *  设置detailTF是否可用，默认不可用
 *
 *  @param enabled YES:可用  NO:不可用
 */
- (void)setDetailTFEnable:(BOOL )enabled;

/**
 *  设置detail的文字
 *
 *  @param detail 文字内容
 */
- (void)setDetail:(NSString *)detail;

/**
 *  获取detail的文字
 *
 *  @param detail 文字内容
 */
- (NSString *)getDetail;

/**
 *  设置文字颜色
 *
 *  @param detailColor 文字颜色
 */
- (void)setDetailColor:(UIColor *)detailColor;

/**
 *  设置detailTF的默认文字
 *
 *  @param placeholder 默认的文字
 */
- (void)setDetailTFPlaceholder:(NSString *)placeholder;

/**
 *  设置标题和内容
 *
 *  @param title  标题
 *  @param detail 内容
 */
- (void)setTitle:(NSString *)title setDetail:(NSString *)detail;

/**
 *  设置标题和内容的颜色
 *
 *  @param titleColor  标题颜色
 *  @param detailColor 内容颜色
 */
- (void)setTitleColor:(UIColor *)titleColor setDetailColor:(UIColor *)detailColor;

/**
 *  设置标题和内容的左右间距
 *
 *  @param leftValue  标题距左的间距
 *  @param rightValue 内容距右的间距
 */
- (void)setTitleLeft:(NSInteger )leftValue setDetailTFRight:(NSInteger )rightValue;

/**
 *  设置最小面的线间距
 *
 *  @param leftValue  线距左的间距
 *  @param rightValue 线距右的间距
 */
- (void)setBottomLineLeft:(NSInteger )leftValue setBottomLineRight:(NSInteger )rightValue;

//键盘类型为 UIKeyboardTypeDecimalPad且保留一位小数
- (void)saveDataPoint:(NSInteger)numPoint;
@end
