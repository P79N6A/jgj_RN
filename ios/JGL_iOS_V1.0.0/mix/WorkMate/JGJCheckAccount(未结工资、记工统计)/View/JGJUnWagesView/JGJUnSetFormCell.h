//
//  JGJUnSetFormCell.h
//  mix
//
//  Created by yj on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJUnSetFormCell;

@protocol JGJUnSetFormCellDelegate <NSObject>

@optional

//查看按钮按下
- (void)unSetFormCell:(JGJUnSetFormCell *)cell checkButton:(UIButton *)checkButton;

@end

@interface JGJUnSetFormCell : UITableViewCell

@property (weak, nonatomic) id <JGJUnSetFormCellDelegate> delegate;

@property (nonatomic, strong) JGJRecordUnWageModel *recordUnWageModel;

@end
