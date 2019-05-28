//
//  YZGWageMoreDetailViewTableViewCell.h
//  mix
//
//  Created by Tony on 16/3/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZGWageMoreDetailViewTableViewCell;
@protocol YZGWageMoreDetailViewTableViewCellDelegate <NSObject>
- (void)WageMoreDetailCellRightBtnClik:(YZGWageMoreDetailViewTableViewCell *)wageMoreDetailViewTableViewCell;
@end

@interface YZGWageMoreDetailViewTableViewCell : UITableViewCell
@property (nonatomic , weak) id<YZGWageMoreDetailViewTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *rightButton;

/**
 *  向上显示
 */
- (void)rigthImageTransFormUp;

/**
 *  恢复默认
 */
- (void)rigthImageTransFormReset;
- (void)setRightButtonText:(NSString *)buttonText;
- (void)setYearMonthText:(NSString *)yearMonthText money:(CGFloat )money;

@end
