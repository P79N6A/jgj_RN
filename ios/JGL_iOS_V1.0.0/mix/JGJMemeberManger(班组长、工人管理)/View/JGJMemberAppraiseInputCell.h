//
//  JGJMemberAppraiseInputCell.h
//  mix
//
//  Created by yj on 2018/4/19.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    
    JGJMemberAppraiseInputCellTextfieldResType, //输入框类型
    
    JGJMemberAppraiseInputCellButtonResType //按钮点击

} JGJMemberAppraiseInputCellResType;

@class JGJMemberAppraiseInputCell;

@protocol JGJMemberAppraiseInputCellDelegate <NSObject>

@optional

- (void)inputWithCell:(JGJMemberAppraiseInputCell *)cell inputCellResType:(JGJMemberAppraiseInputCellResType)inputCellResType;

@end

@interface JGJMemberAppraiseInputCell : UITableViewCell

@property (nonatomic, weak) id <JGJMemberAppraiseInputCellDelegate> delegate;

@end
