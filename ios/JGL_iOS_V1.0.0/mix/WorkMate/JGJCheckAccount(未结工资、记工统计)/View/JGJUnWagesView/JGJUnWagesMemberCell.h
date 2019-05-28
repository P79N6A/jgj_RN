//
//  JGJUnWagesMemberCell.h
//  mix
//
//  Created by yj on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    JGJUnWagesMemberCellSelButtonType, //选中
    
    JGJUnWagesMemberCellSettleButtonType,//结算

} JGJUnWagesMemberCellButtonType;

@class JGJUnWagesMemberCell;

@protocol JGJUnWagesMemberCellDelegate <NSObject>

@optional

- (void)unWagesMemberCellWithCell:(JGJUnWagesMemberCell *)cell buttonType:(JGJUnWagesMemberCellButtonType)buttonType;

@end

@interface JGJUnWagesMemberCell : UITableViewCell

@property (strong, nonatomic) JGJRecordUnWageListModel *listModel;

@property (nonatomic, assign) BOOL isScreenShowLine;

//是否是批量结算
@property (nonatomic, assign) BOOL isBatch;

@property (nonatomic, weak) id <JGJUnWagesMemberCellDelegate> delegate;

@end
