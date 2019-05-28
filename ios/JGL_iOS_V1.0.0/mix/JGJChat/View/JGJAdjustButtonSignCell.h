//
//  JGJAdjustButtonSignCell.h
//  JGJCompany
//
//  Created by yj on 2017/7/21.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    JGJRetryButtonSignType = 1,//重试按钮
    
    JGJAdjustButtonSignType //微调按钮

} JGJAdjustButtonSignCellButtonType;

@class JGJAdjustButtonSignCell;
typedef void(^HandleAdjustButtonSignCellBlock)(JGJAdjustButtonSignCell *);

@interface JGJAdjustButtonSignCell : UITableViewCell

@property (nonatomic, copy) HandleAdjustButtonSignCellBlock handleAdjustButtonSignCellBlock;

@property (weak, nonatomic) IBOutlet UIButton *adjustButton;

@property (weak, nonatomic) IBOutlet UIButton *retryLocalButton;


@property (nonatomic, assign) JGJAdjustButtonSignCellButtonType buttonSignType;

@end
