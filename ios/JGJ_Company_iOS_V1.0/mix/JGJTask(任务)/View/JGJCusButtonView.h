//
//  JGJCusButtonView.h
//  mix
//
//  Created by yj on 2017/5/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJTaskModel.h"

typedef enum : NSUInteger {
    
    JGJCusWaitButtonType,
    
    JGJCusCompleteButtonType,
    
    JGJCusMyCommitButtonType,
    
    JGJCusMyPrinButtonType
    
} JGJCusButtonViewType;

typedef void(^JGJCusButtonViewBlock)(JGJCusButtonViewType);

@interface JGJCusButtonView : UIView

@property (nonatomic, copy) JGJCusButtonViewBlock cusButtonViewBlock;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;

@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (nonatomic, strong) JGJTaskListModel *taskListModel; //任务列表模型

+ (JGJCusButtonView *)cusButtonView;

@end
