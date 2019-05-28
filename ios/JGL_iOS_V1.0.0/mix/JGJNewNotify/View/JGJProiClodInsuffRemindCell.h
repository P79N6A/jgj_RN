//
//  JGJProiClodInsuffRemindCell.h
//  JGJCompany
//
//  Created by yj on 2017/8/7.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomView.h"

typedef enum : NSUInteger {
    
    ProiClodInsuffRemindCellDelButtonType = 1, //删除
    
    ProiClodInsuffRemindCellOrderButtonType, //续订按钮

    CheckDetailButtonType //查看详情
    
} ProiClodInsuffRemindCellButtonType;

@protocol JGJProiClodInsuffRemindCellDelegate <NSObject>
- (void)handleJGJProiClodInsuffRemindCellWithNotifyModel:(JGJNewNotifyModel *)notifyModel buttonType:(ProiClodInsuffRemindCellButtonType)buttonType;
@end

@interface JGJProiClodInsuffRemindCell : UITableViewCell

@property (nonatomic, strong) JGJNewNotifyModel *notifyModel;

@property (weak, nonatomic) IBOutlet LineView *lineView;

@property (weak, nonatomic) id <JGJProiClodInsuffRemindCellDelegate> delegate;

@end
