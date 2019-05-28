//
//  JLGWorkTypeTableViewCell.h
//  mix
//
//  Created by jizhi on 15/11/21.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLGRPBaseInfoModel.h"

@class JLGWorkTypeTableViewCell;
@protocol JLGWorkTypeTableViewCellDelegate <NSObject>
- (void)deleteWorkTypeCell:(NSUInteger )index;
- (void)selectedWorkType:(RPBaseClasses *)rpBaseClasses index:(NSInteger )index;

/**
 *  点击了换行的操作
 *
 *  @param cellIndex    当前cell的index
 *  @param selectedIndex 选中第几个，0表示选中输入人数，1白哦是输入报酬
 */
- (void)textReturnCell:(JLGWorkTypeTableViewCell *)cell CellIndex:(NSInteger )cellIndex selectedIndex:(NSInteger )selectedIndex;
@end

@interface JLGWorkTypeTableViewCell : UITableViewCell

@property (copy,nonatomic) NSString *workType;
@property (nonatomic , weak) id<JLGWorkTypeTableViewCellDelegate> delegate;
@property (nonatomic ,strong) RPBaseClasses *rpBaseClasses;

@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UITextField *personNumTF;
@end