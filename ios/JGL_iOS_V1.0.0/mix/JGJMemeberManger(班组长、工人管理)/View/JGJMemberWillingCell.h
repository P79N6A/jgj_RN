//
//  JGJMemberWillingCell.h
//  mix
//
//  Created by yj on 2018/4/19.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    JGJMemberUnWillingType, //不愿意
    
    JGJMemberWillingType //愿意

} JGJMemberWillingButtonType;

@class JGJMemberWillingCell;

@protocol JGJMemberWillingCellDelegate <NSObject>

@optional

- (void)memberWillingCell:(JGJMemberWillingCell *)cell buttonType:(JGJMemberWillingButtonType)buttonType;

@end

@interface JGJMemberWillingCell : UITableViewCell

@property (nonatomic, weak) id <JGJMemberWillingCellDelegate> delegate;

@end
