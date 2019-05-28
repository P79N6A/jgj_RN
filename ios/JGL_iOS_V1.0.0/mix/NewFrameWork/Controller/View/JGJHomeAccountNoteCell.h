//
//  JGJHomeAccountNoteCell.h
//  mix
//
//  Created by yj on 2018/4/27.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    JGJHomeNoteButtonType, //笔记本按钮
    
    JGJHomeAccountButtonType //记账按钮

} JGJHomeAccountNoteCellButtonType;

typedef void(^JGJHomeAccountNoteCellBlock)(JGJHomeAccountNoteCellButtonType buttonType);

@interface JGJHomeAccountNoteCell : UITableViewCell

@property (nonatomic, copy) JGJHomeAccountNoteCellBlock cellBlock;

@end
